# Project Timeline Checklist

Marco 1: Discovery & Analysis
- Mapeamento da estrutura do Monorepo (Apps + Infra)
- Identificação da stack Backend (Node/Express/Postgres) e Frontend (Vue 2)
- Análise de manifests Kubernetes (Staging/Production)
- Análise de workflows GitHub Actions
- Identificação de Tech Debt e relatórios de risco (Gaps de Auth e Infra)
- Diagnóstico de falhas de conexão de banco e loop de reinicialização

Marco 2: Backend Stabilization & Infrastructure
- Implementação de lógica de Migração Idempotente (Startup Service)
- Configuração de conexão SSL para PostgreSQL (RDS)
- Refatoração de Credenciais de Banco para Variáveis de Ambiente
- Correção de Configuração CORS (Credentials + Origin Reflection)
- Ajuste de Probes Liveness/Readiness no Kubernetes (Aumento de Timeouts)
- Criação de endpoint de Health Check implícito

Marco 3: Security Implementation (Authentication P0)
- Modelagem e criação da tabela Users no Schema
- Implementação de Hash de Senha (bcrypt) e Tokenização (JWT)
- Desenvolvimento do AuthService (Backend)
- Criação do Middleware de Autenticação (AuthMiddleware.js)
- Criação da Rota de Login (POST /login)
- Seed Inicial de Usuário Administrador
- Integração do Frontend com Lógica de Autenticação
- Validação de fluxo de login local

Marco 4: Content & Feature Expansion (News/Hello)
- Criação de lógica de filtro de posts por AuthorID
- Seeding de Conteúdo de Marketing (Posts Iniciais)
- Atualização de Posts para Suporte a HTML Rico e Imagens
- Implementação de rota de API padronizada ({ data: content })
- Criação da HelloPage.vue e Rota /hello
- Correção de Links no Menu (Dropdown)
- Redesign completo da NewsPage.vue (Layout Cards + CSS Scoped)
- Correção de Linter (ESLint) no código Vue

Marco 5: CI/CD & Deployment Optimization
- Correção de compatibilidade Windows no package.json (NODE_ENV)
- Sincronização de package-lock.json para Build na CI
- Configuração de Frontend Local para uso de API Remota (.env.local)
- Implementação de Estratégia de Cache Split no S3 (Assets vs HTML)
- Habilitação explícita de filenameHashing no vue.config.js
- Forçamento de ambiente de Produção no build de Staging
- Invalidação de Cache CloudFront e verificação de deploy

Marco 6: Quality, Security & Automated Validation
- Padronização de Linting (Backend Standard + Frontend Lint:fix)
- Refatoração de Testes de Integração para Testes Unitários Mockados (Jest/Supertest)
- Upgrade de Jest e Supertest para compatibilidade com Node 20 LTS
- Resolução de 100+ Vulnerabilidades de Segurança via npm updates e overrides (Axios, Express, pg-promise, etc)
- Atualização do Dockerfile (Backend) para Node 20-alpine e otimização `npm ci --only=production`
- Correção de Syntax e Plugins nos Workflows de CI (Kubeconform-binary)
- Ajuste de IAM OIDC Scope via Environment Context no GitHub Actions
- Validação Final 100% Green (Lint, Unit Tests, Security Audit, Docker Build, Infra Check)

Marco 7: Observability, Tracing & Post-Deploy Validation
- Implementação da Stack de Observabilidade (kube-prometheus-stack) no namespace `observability`
- Configuração de Alertas via Alertmanager com integração SMTP (Gmail) e validação de entrega
- Implementação de Monitoramento Sintético (Blackbox Exporter) com Probes para API, Frontend e Grafana
- Deploy e Configuração do Grafana Tempo para Rastreamento Distribuído (Distributed Tracing)
- Implementação de ServiceAccount IRSA (IAM Role for Service Accounts) para escrita do Tempo no Amazon S3
- Integração do Tempo com Prometheus via ServiceMonitor para coleta de métricas de ingestão
- Validação de Ingestão de Traces via OpenTelemetry Collector usando `telemetrygen`
- Automação de Pós-Deploy (GitHub Actions) com o workflow `Post-Deploy Smoke Test`:
- Validação automática de conectividade EKS e Rollout de componentes
- Teste de sanidade de métricas e acessibilidade de endpoints externos
- Geração de tráfego sintético e verificação de fluxo de telemetria
- Coleta automática de logs e eventos para troubleshooting preventivo