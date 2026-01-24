# Relatório de Preparação AWS + Terraform

## Status: ⚠️ Parcialmente Concluído (Bloqueio de Permissão)

A estrutura de código (Terraform) foi criada com sucesso, mas a execução do provisionamento falhou devido a permissões insuficientes no perfil AWS fornecido.

### 1. Arquivos Criados
Foram gerados os seguintes arquivos de infraestrutura:

- **Bootstrap (State Remoto)**:
  - `infra/bootstrap/main.tf`: Define Bucket S3 (com versionamento/encriptação) e Tabela DynamoDB (Lock).
  - `infra/bootstrap/versions.tf`: Versões do Terraform/Provider.
  - `infra/bootstrap/outputs.tf`: Outputs para uso posterior.
  - `infra/bootstrap/variables.tf`: Variáveis flexíveis (Região, Profile).

- **Ambiente de Teste (Skeleton)**:
  - `infra/environments/test/backend.tf`: Configuração do backend S3 (apontando para o bucket planejado).
  - `infra/environments/test/main.tf`: Provider AWS e tags padrão.
  - `infra/environments/test/variables.tf`: Variáveis de ambiente.

### 2. Validação de Acesso AWS
- **Profile**: `hrclsfss`
- **Região**: `us-east-2`
- **Identity Confirmed**: Account `654654369899`
- **Erro Encontrado**: `AccessDenied` ao listar buckets S3 e criar recursos.

### 3. Ação Necessária (Correção de Permissões)
O usuário/role `hrclsfss` precisa das seguintes permissões mínimas para executar o bootstrap:

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "TerraformBootstrap",
            "Effect": "Allow",
            "Action": [
                "s3:ListAllMyBuckets",
                "s3:CreateBucket",
                "s3:GetBucketVersioning",
                "s3:PutBucketVersioning",
                "s3:GetBucketEncryption",
                "s3:PutBucketEncryption",
                "s3:GetBucketPublicAccessBlock",
                "s3:PutBucketPublicAccessBlock",
                "s3:GetBucketTagging",
                "s3:PutBucketTagging",
                "dynamodb:ListTables",
                "dynamodb:CreateTable",
                "dynamodb:DescribeTable",
                "dynamodb:TagResource"
            ],
            "Resource": "*"
        }
    ]
}
```

### 4. Como Validar (Após corrigir permissões)

1.  **Executar Bootstrap**:
    ```bash
    cd infra/bootstrap
    terraform init
    terraform apply -auto-approve
    ```

2.  **Validar Recursos**:
    ```bash
    aws --profile hrclsfss s3 ls | grep ezops-tfstate
    aws --profile hrclsfss dynamodb describe-table --table-name ezops-tflock
    ```

3.  **Inicializar Ambiente de Teste**:
    ```bash
    cd ../environments/test
    terraform init
    ```
    *Sucesso esperado*: "Terraform has been successfully initialized!"

### 5. Resumo para Validação (Cole no ChatGPT)

- **Bucket Name (Planejado)**: `ezops-tfstate-654654369899-us-east-2`
- **DynamoDB Table**: `ezops-tflock`
- **Região**: `us-east-2`
- **Profile**: `hrclsfss`
- **STS Identity**: `654654369899` (Auth confirmada, permissões pendentes)
- **Status Terraform**: Code generated. `apply` failed due to AccessDenied.
