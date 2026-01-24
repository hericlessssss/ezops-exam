# EZOps DevOps Exam — Implementation Notes (Fase 1: Repositório + Execução Local)

## Contexto do exame
O objetivo do exame é demonstrar capacidade prática de DevOps na AWS, cobrindo:
- Containerização (Docker)
- Infraestrutura como código (Terraform com state remoto e lock)
- Deploy do backend em Kubernetes (EKS) ou ECS com ALB e DNS (Route53)
- Hosting do frontend em S3 + CloudFront
- CI/CD (ex.: GitHub Actions)

Nesta fase inicial, o foco foi **organizar o repositório** e **fazer o projeto rodar localmente**, entendendo como backend e frontend se conectam e quais ajustes eram necessários para dockerização.

---

## Estratégia de repositório (decisão)
### O que foi decidido
Adotei um **monorepo de entrega** (um único repositório GitHub) contendo:
- código do backend e frontend
- Dockerfiles e Docker Compose para execução local
- pastas reservadas para Infra e Kubernetes
- preparação para CI/CD

### Motivo
A instrução do exame pede que eu entregue um repositório GitHub com “todo o código que eu fiz”. Para reduzir risco na avaliação (clonar múltiplos repos, submodules, paths quebrados etc.), um monorepo facilita a reprodução e a leitura.

---

## Estrutura atual do projeto
Estrutura final do repositório (após organização):

- `.github/workflows/` (planejado)
- `apps/`
  - `backend/` (Node.js Express API)
  - `frontend/` (Vue.js SPA)
- `infra/` (planejado: Terraform)
- `k8s/` (planejado: manifests Kubernetes)
- `docs/`
  - `implementation-notes.md` (este documento)
- `README.md` (instruções de execução local)

---

## Ajuste de estrutura (problema: “pasta dentro de pasta”)
### Sintoma
Inicialmente o backend estava assim:
`apps/backend/rest-api-ezops-test/...`

Esse formato cria atrito para:
- `docker build` (não encontra `package.json` na raiz esperada)
- CI/CD (paths e `working-directory` confusos)
- facilidade do avaliador para entender/rodar

### Solução
Foi feito o “flatten” (achatamento), deixando o conteúdo do projeto diretamente em:
- `apps/backend/`
- `apps/frontend/`

Isso simplifica dockerização, Compose e pipelines.

---

## Varredura completa do repositório (Antigravity)
Para acelerar a análise e reduzir tentativa-e-erro, utilizei a IDE com IA (Antigravity) para:
- ler `package.json` e scripts
- identificar portas e comandos de start
- entender como o frontend chama o backend
- mapear variáveis de ambiente necessárias
- verificar dependência de banco de dados
- gerar arquivos para execução local com Docker

Resultado: configuração local completa (Dockerfiles + Compose + Makefile + README).

---

## Execução local via Docker (resultado final)

### Como rodar
Foram criados/ajustados arquivos para executar localmente com Docker Compose:
- `apps/backend/Dockerfile`
- `apps/frontend/Dockerfile`
- `docker-compose.yml` (na raiz)
- `Makefile` (`make up`, `make down`, `make logs`)
- atualização do `README.md` com instruções e checklist

Comando recomendado:
```bash
make up
# ou
docker-compose up --build -d
```

---

### Como o frontend se conecta ao backend (detalhe crítico)

**Comportamento encontrado:**
O frontend está _hardcoded_ para se conectar em `localhost:5000`.

**Decisão local (para funcionar sem refator):**
- O backend roda internamente no container na porta `3000`.
- No host, ele foi exposto como `5000` no `docker-compose.yml`.
- O frontend fica disponível no host em `8080`.

**Motivo:** Manter a execução local estável sem refatorar o frontend nesta fase. A limitação fica documentada e será tratada como melhoria futura.

### Banco de dados (PostgreSQL)

O backend tenta conectar no banco ao iniciar, então foi incluído um container Postgres no Compose.

**Variáveis padrão no ambiente local:**
- `DB_HOST=db`
- `DB_PORT=5432`
- `DB_USER=postgres`
- `DB_PASSWORD=postgres`
- `DB_NAME=blog`

Também foi incluído script de inicialização (ex.: `create.sql`) para preparar o banco para o backend.

### Ajustes realizados

#### 1) Backend
- **Correções no `package.json`**: Estava quebrado (faltava script de start e main incorreto). Ajustado para garantir execução correta.
- **Endpoint de Health**:
    - Adicionado `GET /health` no `server.js` (retorna 200 OK sem depender do banco).
    - Adicionado `HEALTHCHECK` no Dockerfile usando `wget` (compatível com Alpine).
    - Objetivo: Melhorar preparação para Kubernetes (EKS).

#### 3) Infraestrutura (Terraform)
- **VPC**: Módulo criado com subnets públicas/privadas e NAT Gateway (Single NAT para economia). Prefixos de nome padronizados (`test-chico-*`).
- **ECR**: Repositórios criados (`test-chico-backend`, `test-chico-frontend`) com Scan on Push e tags mutáveis (para facilitar laboratório).
- **EKS**: Cluster Kubernetes (v1.29) com Managed Node Group (Nodes `t3.medium` privados). IAM Roles configuradas para cluster e nodes.

#### 4) Frontend
- **Compatibilidade**: O frontend usa dependências antigas (`node-sass`), exigindo **Node 14**.
- **Docker**: Build multi-stage (`Node 14` → `Nginx`).
- **Observação**: Node 14 é EOL (End of Life). Documentado como melhoria futura.

### Validação (evidências)

#### Checklist local
- [x] **Frontend**: `http://localhost:8080` carrega a aplicação Vue.
- [x] **Backend**: `http://localhost:5000/posts` retorna JSON (ex.: `[]`).
- [x] **Health**: `http://localhost:5000/health` retorna `200 OK`.

#### Comandos úteis
```bash
docker ps
curl http://localhost:5000/health
curl http://localhost:5000/posts
```

**Evidência adicional:** Container do backend reportado como `healthy` (`docker ps`), validando o HEALTHCHECK.

### Decisões técnicas desta fase (trade-offs)

1.  **Node 14 no build**: Utilizado por compatibilidade com `node-sass` antigo. Prioridade: execução local rápida.
2.  **Hardcode do frontend**: Mantido mapeamento de portas (`3000` -> `5000`) para evitar refatoração prematura.

### Melhorias futuras (planejadas)

- [ ] **Migrar `node-sass` → `sass` (Dart Sass)**: Para suportar Node moderno.
- [ ] **Remover hardcode do frontend**: Trocar `localhost:5000` por env var (`VUE_APP_API_URL`).
- [ ] **Configuração de env vars**: Definir injeção de variáveis no deploy (CloudFront/S3).

---

## Status da Fase 1 (Concluída)

- [x] Monorepo organizado (`apps`, `infra`, `k8s`, `docs`).
- [x] Backend e Frontend rodando com Docker Compose.
- [x] Banco de dados inicializado.
- [x] README com instruções.
- [x] Healthcheck implementado.

## Próximos passos (Fase 2 — Exame na AWS)

1.  **Terraform**:
    - Backend remoto (S3) + Lock (DynamoDB).
    - Módulos e ambientes (dev/test).
2.  **Provisionar AWS**:
    - VPC, Subnets, ECR.
    - EKS + ALB Controller.
    - RDS (Postgres).
    - S3 + CloudFront (Frontend).
3.  **Deploy**:
    - Backend no EKS (ALB + DNS).
    - Frontend no S3 (CloudFront).
4.  **CI/CD**:
    - Pipelines de Build/Push/Deploy.