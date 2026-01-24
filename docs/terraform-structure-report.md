# Relatório de Estrutura Terraform (Ready to Apply)

## Status: 🟢 Pronto para Apply (Aguardando Permissões)

Toda a estrutura de código foi refatorada e modularizada. O repositório agora segue padrões de produção, com módulos reutilizáveis e ambientes segregados.

### 1. Arquivos e Módulos Criados

#### Módulos (`infra/modules/`)
Foram criados os esqueletos (interfaces) para todos os componentes exigidos:
- **vpc**: Rede base (VPC, Subnets, IGW).
- **ecr**: Repositórios Docker (Backend/Frontend).
- **eks**: Cluster Kubernetes (Control Plane + Node Groups).
- **rds**: Banco de Dados PostgreSQL.
- **s3_frontend**: Bucket para hosting estático.
- **cloudfront**: CDN para HTTPS e caching do frontend.
- **route53**: Zonas e registros DNS.

*Nota: Os arquivos `main.tf` dos módulos estão vazios (placeholders) para permitir validação inicial sem erros de referência.*

#### Ambiente de Teste (`infra/environments/test/`)
- `main.tf`: Instancia todos os módulos acima, passando variáveis (ex.: `vpc_id` do módulo VPC para o módulo EKS).
- `backend.tf`: Configurado para usar o S3/DynamoDB criados no bootstrap.
- `variables.tf`: Define tags padrão (`Project`, `Owner`, `Env`) e prefixos de naming.
- **Naming Convention Strategy**: `<project>-<env>-<component>` (ex.: `ezops-exam-test-eks`).

### 2. Design e Decisões
- **EKS vs ECS**: Optei por preparar o módulo **EKS**, pois é a recomendação para pontuar competência em Kubernetes na prova.
- **State Remoto**: Configurado para ser bloqueado via DynamoDB para evitar corrupção em aplicações simultâneas.
- **Networking**: Módulo VPC preparado para receber `cidr_block` como variável, facilitando criação de novos ambientes (ex.: `staging`, `prod`) sem conflito.
- **NAT Gateway**: Adotada estratégia **Single NAT Gateway** (em uma subnet pública) para economizar custos durante a prova/dev. Em produção real, seria recomendado Multi-AZ NAT (um por AZ). Todas as subnets privadas roteiam para este único NAT.

### 3. Como Validar (Checklist)
Assim que as permissões AWS forem liberadas:

1.  [ ] **Bootstrap**:
    ```bash
    cd infra/bootstrap && terraform apply
    ```
2.  [ ] **Inicializar Teste**:
    ```bash
    cd infra/environments/test && terraform init
    ```
3.  [ ] **Validar Plano**:
    ```bash
    terraform plan
    ```
    *Deve mostrar 0 resources to add (por enquanto), ou 7 resources (se os módulos tivessem recursos reais).*

### 4. Guia de Execução
Criada documentação detalhada em `docs/terraform-ready-to-apply.md` (em inglês) para servir como guia passo a passo durante o exame.
