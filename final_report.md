# Relatório Final de Encerramento: Infraestrutura EzOps Exam

Este documento formaliza a destruição da infraestrutura e o descomissionamento dos ambientes `Staging`, `Production` e `Test`, garantindo que não restem custos ativos e que as esteiras de CI/CD estejam inativadas.

## 1. Inventário Final de Destruição

A destruição foi realizada em dois perfis AWS distintos, seguindo a ordem de dependência dos recursos.

### Ambiente Staging (Perfil: `chico`)
*   **Região**: `us-east-2`
*   **Recursos Deletados**:
    *   Cluster EKS (`stg-chico-eks`) e Node Groups.
    *   Instância RDS Postgres (`stg-chico-db`).
    *   Load Balancers (ALBs) e Target Groups residuais.
    *   Repositórios ECR (`stg-chico-backend`).
    *   Buckets S3 de Frontend (limpeza de versões e deleção).
    *   Distribuição CloudFront.
*   **Status**: Infraestrutura crítica e cobrável 100% removida.

### Ambientes Production & Test (Perfil: `hrclsfss` / EZOps)
*   **Regiões**: `us-east-1` e `us-east-2`
*   **Recursos Deletados**:
    *   Cluster EKS (`test-chico-eks`) e Node Groups.
    *   VPC e Subnets (`test-chico-vpc`).
    *   Elastic IPs e NAT Gateways.
    *   Repositórios ECR (`test-chico-backend`, `test-chico-frontend`).
    *   Buckets S3 e CloudFront relacionados ao prefixo `test-chico`.
*   **Status**: Infraestrutura crítica e cobrável 100% removida.

---

## 2. Comandos e Ferramentas Utilizadas

A estratégia combinou **Terraform** para a destruição orquestrada e **AWS CLI (PowerShell)** para limpeza de recursos órfãos ou bloqueantes.

### Orquestração (Terraform)
```powershell
cd infra/environments/staging
terraform destroy -auto-approve

cd infra/environments/production
terraform destroy -auto-approve
```

### Limpeza Crítica (AWS CLI)
Para recursos que o Terraform não consegue gerenciar (ex: arquivos no S3, imagens no ECR ou ALBs dinâmicos):

*   **Esvaziar S3 (Versões)**: `aws s3api delete-object --bucket <name> --key <k> --version-id <v>`
*   **Forçar ECR**: `aws ecr delete-repository --repository-name <name> --force`
*   **Limpar Dependências de Rede**: `aws ec2 delete-network-interface --network-interface-id <id>`

---

## 3. Inativação da Esteira (GitHub Actions)

As pipelines de CI/CD em `.github/workflows/` foram inativadas para evitar qualquer tentativa acidental de conexão com a AWS ou o cluster.
*   **Ação**: Triggers (`on: [push, pull_request]`) foram comentados.
*   **Ação**: Nomes das workflows alterados para conter `(DISABLED)`.

---

## 4. Auditoria de Sobras (Custo Zero)

Restam nas contas apenas os seguintes itens de impacto zero:
1.  **Buckets de State**: Buckets S3 que armazenam o `.tfstate`. Não geram custo significativo e são úteis para histórico.
2.  **VPC Metadados**: Em alguns casos, a "casca" da VPC (sem NAT Gateway ou IPs) pode permanecer. Custo: **$0.00**.

---

**Projeto encerrado com sucesso. Obrigado pela confiança!**
