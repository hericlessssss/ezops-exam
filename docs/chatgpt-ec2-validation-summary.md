# Resumo para Validação no ChatGPT (EC2)

Use este resumo para validar a implementação do módulo EC2 utility.

## 1. Arquivos Criados/Alterados
- **Módulo**: `infra/modules/ec2/` (main.tf, variables.tf, outputs.tf).
- **Ambiente**: `infra/environments/test/main.tf` (instanciado) e `outputs.tf` (expostos).
- **Docs**: `docs/ec2.md`.

## 2. Decisões Técnicas
- **AMI**: `Amazon Linux 2023` (Moderno, seguro, lightweight).
- **Tipo**: `t3.micro` (Econômico, suficiente para utility/debug).
- **Postura de Segurança**: 
  - **Default**: *Zero Trust* (Inbound vazio).
  - **Opcional**: Variável `allow_ssh_cidr` para liberar SSH sob demanda.
- **Networking**: `public_subnet_0` com `associate_public_ip_address = true` (Requisito implícito de utility pública).

## 3. Outputs Adicionados
- `utility_ec2_id`: ID da instância para referência/debug via CLI.
- `utility_ec2_public_ip`: IP público para acesso rápido.

## 4. Comandos de Validação
1. **Lint/Format**: `terraform fmt -recursive` (Executado).
2. **Logic/Syntax**: `terraform validate` (Passou com sucesso).
3. **AWS Check**:
   ```bash
   aws ec2 describe-instances --filters "Name=tag:Name,Values=test-chico-utility"
   ```
