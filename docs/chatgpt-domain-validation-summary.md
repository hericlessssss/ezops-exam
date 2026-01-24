# Resumo para Validação no ChatGPT (Domain & Wiring)

Use este resumo para validar a configuração final de Domínio, DNS e Evidências.

## 1. Mudanças na Infraestrutura
- **Padronização de DNS**:
  - Frontend: `app.test-chico.<domain>`
  - Backend: `api.test-chico.<domain>`
- **Variável Dinâmica**: Adicionado `backend_target` em `infra/environments/test/variables.tf` (default vazio/placeholder) para permitir injeção via CLI.
- **Lógica Condicional**: `main.tf` usa variável `backend_target` se fornecida, ou mantém placeholder seguro para evitar erros antes do deploy do K8s.

## 2. Ingress & Kubernetes
- **Host Padronizado**: `ingress.yaml` atualizado para `api.test-chico.example.com` (alinhado com padrão documentation).
- **Fluxo Post-Apply**: Documentado que o DNS do ALB deve ser capturado *após* o apply do Ingress e retroalimentado no Terraform.

## 3. Artefatos de Entrega
- **[docs/domain-setup.md](docs/domain-setup.md)**: Guia passo a passo de como configurar Hosted Zone e rodar o "ciclo vicioso" do Route53 <-> ALB.
- **[docs/evidence-checklist.md](docs/evidence-checklist.md)**: Checklist "exam-style" com comandos exatos para provar que tudo funciona (Terraform, K8s, Curl, Browser).

## 4. Status Final
- **Código**: Formatado e Validado.
- **Prontidão**: Pronto para `terraform apply` assim que credenciais e Hosted Zone ID forem fornecidos.
