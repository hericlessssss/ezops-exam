# Visão geral da aplicação

Esta documentação fornece uma análise técnica detalhada da aplicação contida neste repositório, cobrindo arquitetura, componentes, configurações e infraestrutura.

## Objetivo do projeto

A aplicação demonstra um sistema web completo (Frontend + Backend + Banco de Dados) implantado em nuvem (AWS), servindo como cenário para o exame prático da EzOps. O foco não é a complexidade de negócio (é um CRUD simples de Blog), mas sim a demonstração de competências em DevOps: containerização, orquestração (Kubernetes), IaC (Terraform) e pipelines de CI/CD.

## Arquitetura em alto nível

A arquitetura segue o padrão **Single Page Application (SPA)** desacoplada:

*   **Frontend**: Aplicação Vue.js servida estaticamente (S3 + CloudFront).
*   **Backend**: API REST em Node.js/Express rodando em containers (EKS).
*   **Banco de Dados**: PostgreSQL gerenciado (AWS RDS).
*   **Comunicação**: O Frontend consome a API via HTTP/JSON.

## Frontend: o que é e como funciona

O Frontend é uma aplicação JavaScript baseada no framework **Vue.js 2**.
*   **Framework**: Vue.js v2.6.11
*   **Gerenciamento de Estado**: Vuex v3.3.0
*   **Roteamento**: Vue Router v3.1.6
*   **Cliente HTTP**: Axios

### Páginas e rotas do frontend
As rotas são definidas em `apps/frontend/src/router/routes.js`:

| Rota | Página (Componente) | Protegida? | Descrição |
| :--- | :--- | :--- | :--- |
| `/` | `Home` | Não | Página inicial. |
| `/news` | `NewsPage` | Não | Listagem de notícias. |
| `/profile` | `ProfilePage` | **Sim** | Área do usuário logado. |
| `/login` | `Login` | Não | Tela de autenticação. |
| `*` | `NotFound` | - | Página 404. |

### Funcionalidades do frontend
*   **Autenticação**: Login com JWT. O token é armazenado e enviado no header `Authorization: Bearer` (interceptador configurado em `apps/frontend/src/services/http.init.js`).
*   **Gestão de Posts**: Visualização e manipulação de postagens (CRUD via `posts.service.js`).
*   **Perfil**: Exibição de posts do usuário conectado.

## Backend: o que é e como funciona

O Backend é uma API JSON simples construída com **Node.js** e **Express**.
*   **Entrypoint**: `apps/backend/server/server.js`
*   **Porta**: 3000 (Hardcoded)
*   **Banco de Dados**: Conexão via biblioteca `pg-promise`.

### Principais endpoints da API
Definidos em `apps/backend/server/route/postsRoute.js` e `server.js`:

| Método | Endpoint | Descrição |
| :--- | :--- | :--- |
| `GET` | `/health` | Health Check (Retorna 200 OK). |
| `GET` | `/posts` | Lista todos os posts. |
| `POST` | `/posts` | Cria um novo post. |
| `PUT` | `/posts/:id` | Atualiza um post existente. |
| `DELETE` | `/posts/:id` | Remove um post. |

### Banco de dados e persistência
*   **Tecnologia**: PostgreSQL.
*   **Schema**: Utiliza um schema dedicado chamado `blog`.
*   **Tabelas**:
    *   `blog.post`: Armazena `id`, `title`, `content` e `date`.
*   **Migrations**: Existe um script SQL inicial em `apps/backend/database/create.sql`, mas **não há evidência** de um sistema de migração automática (ex: TypeORM migrations ou Knex). As tabelas devem ser criadas manualmente ou via script externo na inicialização.

## Integração frontend ↔ backend

O frontend se comunica com o backend através de chamadas HTTP (REST).
*   **Configuração de URL**: A URL base da API é definida pela variável de ambiente `VUE_APP_API_URL` no build do frontend.
*   **Comportamento**:
    *   Em desenvolvimento local (`.env`), aponta para `http://localhost:5000`.
    *   Em Staging (`.env.staging`), aponta para `https://api-ezops.gratianovem.com.br`.
    *   Em Produção (`.env.production`), aponta para `https://api.test-chico.exam.ezopscloud.tech`.

## Configurações por ambiente (dev/staging/prod)

### Staging (Ambiente `stg-chico`)
*   **Infraestrutura (Terraform)**:
    *   VPC Staging (`10.0.0.0/16`).
    *   Cluster EKS v1.29 (Node Group `t3.medium`).
    *   Banco RDS Postgres (`db.t3.micro`).
    *   Bucket S3 + CloudFront para o Frontend.
*   **Kubernetes**:
    *   Namespace: `stg-chico`.
    *   Deployment: 2 réplicas do backend.
    *   Ingress: ALB Exposto em `api-ezops.gratianovem.com.br` (HTTPS).

### Produção (`prod-chico` - Inferido)
*   Segue a mesma estrutura de módulos do Staging, mas com isolamento de VPC e novos recursos definidos em `infra/environments/production`.

## Dependências de infraestrutura (AWS/Kubernetes)

As principais dependências externas para o funcionamento do sistema são:
1.  **AWS EKS**: Para orquestração dos containers do Backend.
2.  **AWS RDS (PostgreSQL)**: Para persistência de dados.
3.  **AWS S3 & CloudFront**: Para hospedagem e entrega de conteúdo estático (Frontend).
4.  **AWS ECR**: Registro de imagens Docker (`backend` e `frontend` repositories).
5.  **AWS Load Balancer Controller**: Para provisionar o ALB via Ingress.

## Pontos críticos, limitações e riscos atuais

Durante a análise estática, foram identificados os seguintes pontos de atenção:

1.  **Secrets em Texto Plano**: O arquivo `k8s/staging/backend/secret.yaml` contém a senha do banco de dados (`postgres`) versionada no Git.
2.  **Configuração de Build do Frontend**: O workflow do GitHub Actions (`frontend-staging.yml`) executa `npm run build` sem especificar o modo. Por padrão, o Vue CLI usa o modo `production`, o que carrega o arquivo `.env.production` em vez do `.env.staging`. Isso fará o Frontend de Staging tentar conectar na API de Produção.
3.  **URLs e IPs Hardcoded**:
    *   O `k8s/staging/backend/configmap.yaml` contém o DNS do RDS hardcoded (`stg-chico-db...`). Se o RDS for recriado, isso quebrará.
    *   O `k8s/staging/backend/deployment.yaml` aponta para uma imagem específica no ECR (`563702590660...`). Isso torna o manifesto rígido e difícil de portar para outras contas AWS.
4.  **Ausência de Migrations Automáticas**: Não há comando no `package.json` ou no container startup para rodar o `create.sql`. O banco precisa ser "seedado" manualmente.
5.  **CORS**: Não foi encontrado middleware de CORS explícito no `server.js`. Isso pode causar bloqueios se o Frontend e Backend estiverem em domínios diferentes (o que é o caso: `app-ezops...` vs `api-ezops...`).

## Como validar que o comportamento está correto

Sem executar comandos, o fluxo esperado de validação seria:
1.  Acessar a URL do Frontend (`https://app-ezops...`).
2.  O navegador deve carregar a Home.
3.  Ao navegar para `/news`, o Frontend deve fazer um `GET /posts` para a API.
4.  Inspecionar a aba "Network" do navegador para garantir que a requisição vai para `https://api-ezops.gratianovem.com.br` (e não localhost ou prod).
5.  O backend deve responder 200 OK com JSON.

## Glossário rápido

*   **EKS**: Elastic Kubernetes Service.
*   **ALB**: Application Load Balancer.
*   **ECR**: Elastic Container Registry.
*   **Manifests**: Arquivos YAML que definem recursos do Kubernetes (Deployment, Service, Ingress).
*   **SPA**: Single Page Application.

---

## Evidências no código

Lista de arquivos chave utilizados para esta análise:

1.  `apps/frontend/package.json`: Definição de dependências e scripts do Vue.
2.  `apps/frontend/src/router/routes.js`: Mapeamento de rotas e proteção de páginas.
3.  `apps/frontend/src/services/http.init.js`: Configuração do Axios e Interceptors de Auth.
4.  `apps/frontend/.env.staging`: Variáveis de ambiente corretas para Staging.
5.  `.github/workflows/frontend-staging.yml`: Pipeline de CI/CD (com risco de build mode incorreto).
6.  `apps/backend/server/server.js`: Entrypoint da API e definição de rotas base.
7.  `apps/backend/server/route/postsRoute.js`: Implementação dos endpoints de Posts.
8.  `apps/backend/server/infra/database.js`: Configuração da conexão Postgres.
9.  `apps/backend/database/create.sql`: Schema do banco de dados.
10. `infra/environments/staging/main.tf`: Definição da infraestrutura AWS via Terraform.
11. `k8s/staging/backend/deployment.yaml`: Definição dos Pods do Backend.
12. `k8s/staging/backend/secret.yaml`: Exposição de credenciais (Risco).
13. `k8s/staging/backend/ingress.yaml`: Configuração de exposição externa da API.
