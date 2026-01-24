# Resumo para Validação no ChatGPT

Use este resumo para validar a solução de CI/CD (Auditorada e Corrigida).

## 1. Workflows Corrigidos e "Exam-Proof"
- **Backend (`.github/workflows/backend.yml`)**:
  - **Correção de Auth**: Lógica condicional robusta para usar OIDC (`secrets.AWS_ROLE_ARN`) OU Access Keys como fallback explícito.
  - **Deploy Seguro**:
    - Instalação explícita do `kubectl`.
    - Criação dinâmica de Secrets (`kubectl create secret generic`) usando GitHub Secrets (sem aplicar arquivo yaml inseguro).
    - Aplicação ordenada de manifests e atualização de imagem via `kubectl set image`.
  - **Tagging**: Mantido padrão `github.sha` + `latest`.

- **Frontend (`.github/workflows/frontend.yml`)**:
  - **Job Splitting**: Separado em `build` (CI) e `deploy`.
  - **Environment Safety**: Job `deploy` roda apenas na branch main e usa `environment: test`. PRs rodam apenas `build` sem travar por regras de ambiente.
  - **Sintaxe Segura**: Condicionais corrigidos para `${{ ... }}`.

## 2. Melhorias de Segurança
- **Segredos Isolados**: Credenciais COMPLETAS de banco (`DB_HOST`, `DB_NAME`, `DB_PORT`, `DB_USER`, `DB_PASSWORD`) injetadas via Pipeline.
- **Permissão EKS**: Documentado procedimento para autorizar a Role do GitHub no cluster (via `access-entry` ou `aws-auth`), evitando erros de *Forbidden*.
- **Least Privilege**: Workflow Frontend não tem acesso a chaves AWS em PRs.

## 3. Variáveis e Secrets Necessários
| Secret | Descrição |
| :--- | :--- |
| `AWS_ROLE_ARN` | OIDC Role (se vazio, usa keys). |
| `AWS_ACCESS_KEY_ID` | Fallback Key. |
| `AWS_SECRET_ACCESS_KEY` | Fallback Secret. |
| `DB_HOST` | Endpoint RDS. |
| `DB_NAME` | Nome DB. |
| `DB_PORT` | Porta DB. |
| `DB_USER` | Usuário DB. |
| `DB_PASSWORD` | Senha DB. |
| `S3_BUCKET_NAME` | Bucket do Frontend. |
| `CLOUDFRONT_DISTRIBUTION_ID` | ID do CloudFront. |

## 4. Como Validar
1. **PR Frontend**: Abrir PR alterando frontend -> Check deve passar apenas no build.
2. **Push Backend**: Commit no backend -> Build Docker -> Push ECR -> EKS Rollout.
3. **Rollout**: `kubectl rollout status` no log prova que o deploy "esperou" os pods ficarem saudáveis.

