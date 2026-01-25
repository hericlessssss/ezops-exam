# 📜 Diário Completo da Implementação (EzOps Exam)

Este documento consolidado detalha a jornada completa do projeto, desde o clone inicial até a entrega de um ambiente de Produção pronto para uso. Aqui explicamos **O Que**, **Como** e **Por Que** cada decisão técnica foi tomada.

---

## 1. 🔍 Descoberta e Setup Local
**Objetivo**: Entender a aplicação e garantir que ela rode fora do ambiente do desenvolvedor original.

### O Que Foi Feito:
*   **Análise de Código**: Identificamos um Frontend (Vue.js 2) e um Backend (Node.js/Express + Postgres).
*   **Dockerização**: Criamos `Dockerfile` para ambos e um `docker-compose.yml` para orquestração local.
*   **Correção de Dependências**: Substituímos o `node-sass` (depreciado e incompatível com Nodes recentes) pelo `sass` (Dart Sass).

**Por Que?**
Sem rodar localmente, não garantimos que a aplicação funciona. O uso de Docker elimina o "na minha máquina funciona", e o ajuste do SASS foi crítico pois as builds quebravam em ambientes modernos de CI.

---

## 2. 🏗️ Infraestrutura como Código (Terraform)
**Objetivo**: Criar uma fundação sólida, reprodutível e isolada na AWS.

### O Que Foi Feito:
*   **Arquitetura Modular**: Criamos módulos reutilizáveis (`vpc`, `eks`, `rds`, `ecr`, `s3_frontend`, `cloudfront`).
*   **Ambiente Staging (`stg-chico`)**:
    *   **VPC**: Rede isolada com subnets Públicas e Privadas.
    *   **EKS**: Cluster Kubernetes Gerenciado (v1.29) com Managed Node Groups.
    *   **RDS**: Banco Postgres em subnets privadas (segurança).
    *   **EC2 Utility**: Instância "Bastion/Debug" na subnet pública (requisito do exame).
*   **State Remoto**: Configurado backend S3 + DynamoDB para travar o estado e permitir trabalho em equipe.

**Por Que?**
Terraform permite versionar a infraestrutura. Separar em módulos facilita a futura criação de Produção. O uso de EKS e RDS retira a carga de gerenciar SO e Backups manualmente.

---

## 3. ⚙️ Kubernetes & Bootstrapping
**Objetivo**: Preparar o Cluster EKS para receber tráfego externo e aplicações.

### O Que Foi Feito:
*   **AWS Load Balancer Controller**:
    *   Instalado via Helm.
    *   Configurado IAM Role (IRSA) para permitir que o K8s crie Load Balancers na AWS.
*   **Correção de Subnets**: Adicionamos as tags `kubernetes.io/role/elb` (pública) e `internal-elb` (privada) na VPC para que o Controller encontre onde criar os ALBs.
*   **Manifestos**: Criamos Deployments, Services e Ingress para o Backend.

**Por Que?**
O Ingress nativo do K8s precisa de um "Controller" para falar com a AWS. O ALB Controller é o padrão moderno para expor serviços HTTP/HTTPS na AWS.

---

## 4. 🔄 CI/CD (GitHub Actions)
**Objetivo**: Automatizar o deploy com segurança (sem chaves fixas).

### O Que Foi Feito:
*   **OIDC Connect**: Configuramos o GitHub como um Identity Provider na AWS. Isso permite que a Action assuma uma Role sem precisarmos salvar Access Keys (que vazam fácil).
*   **Pipelines Separadas**:
    *   **Backend**: Build Docker -> Login ECR -> Push Image -> Update K8s Deployment (`kubectl set image`).
    *   **Frontend**: Build NPM -> Sync S3 Bucket -> Invalidate CloudFront Cache.
*   **Environment Handling**: O build injeta variáveis diferentes para Staging (`.env.staging`) e Produção.

**Por Que?**
Segurança (OIDC) e Agilidade. Cada commit na `main` atualiza o Staging automaticamente, permitindo feedback rápido.

---

## 5. 🛠️ Refatoração da Aplicação & Correções
**Objetivo**: Tornar a aplicação "Cloud Native" e corrigir dívidas técnicas.

### O Que Foi Feito:
*   **Variáveis de Ambiente**:
    *   Removemos hardcodes (`localhost:3000`) do código Vue.js.
    *   Implementamos `process.env.VUE_APP_API_URL` carregado via arquivos `.env`.
*   **Lint & Build Fixes**:
    *   Rodamos `eslint --fix` para satisfazer o padrão rigoroso do projeto.
    *   Corrigimos erro de lógica do Vue 2 (`v-for` sem `:key` no componente de Paginação).
    *   Ajustamos o carregamento de CSS global para evitar erros de compilação SASS.

**Por Que?**
Uma aplicação moderna precisa ser configurável (não se recompila código para mudar a URL da API) e o código quebrado impedia o deploy automático.

---

## 6. 🔐 HTTPS, DNS e Segurança (A Grande Vitória)
**Objetivo**: Entregar um site seguro (cadeado verde) e profissional.

### Backend (API)
*   **Certificado**: ACM Regional (`us-east-2`).
*   **Ingress**: Configuramos annotations para:
    *   Escutar na porta 443 (HTTPS).
    *   Forçar redirecionamento (HTTP -> HTTPS).
    *   Anexar o certificado gerenciado pela AWS.
*   **DNS**: Cloudflare aponta para o ALB.

### Frontend (CDN)
*   **Certificado**: ACM Global (`us-east-1` - requisito do CloudFront).
*   **CloudFront**:
    *   Adicionamos suporte a `aliases` (CNAMEs).
    *   Configuramos OAC (Origin Access Control) para que o Bucket S3 permaneça **Privado**, acessível apenas pelo CloudFront.
*   **DNS**: Cloudflare aponta para o CloudFront.

**Por Que?**
Segurança é não-negociável. Mixed Content (site HTTPS chamando API HTTP) é bloqueado por navegadores modernos. OAC no S3 previne vazamento de dados.

---

## 7. 🚀 Preparação para Produção (Handover)
**Objetivo**: Deixar tudo pronto para a conta da EZOps.

### O Que Foi Feito:
*   **Ambientes Segregados**: Criamos a pasta `infra/environments/production` independente de staging.
*   **Naming Convention**: Adotamos o prefixo `test-chico` exigido no exame.
*   **Organização Pró**:
    *   `runbooks/`: Manuais de operação.
    *   `checklists/`: Para garantir que nada foi esquecido.
    *   `reference/`: Documentação técnica.
*   **Workflows de Produção**: CI/CD configurado com aprovação (`environment: production`) e triggers manuais ou por Release.

---

## ✅ Conclusão
O repositório evoluiu de um código "local/legado" para uma arquitetura **Enterprise-Grade**:
1.  **Segura** (IAM Least Privilege, OIDC, HTTPS, S3 Privado).
2.  **Escalável** (EKS, ALB, CloudFront).
3.  **Automatizada** (Terraform, GitHub Actions).
4.  **Documentada** (Runbooks claros para operação).

Estamos prontos para o Deploy Final! 👊
