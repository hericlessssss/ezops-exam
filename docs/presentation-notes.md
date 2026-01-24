# Arquitetura de Referência e Estratégia DevOps

Este documento serve como base de conhecimento (Wiki) detalhando as decisões arquiteturais, padrões adotados e a estratégia de implementação para a infraestrutura e entrega contínua do projeto. O foco aqui é a teoria e o racional por trás de cada componente.

---

## 1. Visão Geral e Estratégia
O objetivo central desta arquitetura é prover uma infraestrutura resiliente, segura e auditável para microsserviços modernos, utilizando a AWS como provedor de nuvem e Kubernetes para orquestração. A solução foi desenhada para atender a requisitos rigorosos de isolamento de rede, entrega contínua automatizada e práticas de "Infrastructure as Code" (IaC).

A stack tecnológica fundamenta-se nos pilares de:
*   **Imutabilidade**: Infraestrutura e artefatos de aplicação controlados por código.
*   **Modularidade**: Componentes desacoplados para fácil manutenção.
*   **Segurança em Camadas**: Proteção desde a rede (VPC) até a distribuição de conteúdo (CDN).

---

## 2. Estratégia de Containerização
A padronização dos ambientes de execução é garantida através da containerização.

### Backend como Microsserviço
A aplicação de backend é tratada como um artefato imutável. O processo de build gera uma imagem containerizada autossuficiente, contendo todas as dependências necessárias para execução. Isso elimina a variabilidade entre ambientes (desenvolvimento vs. produção) e permite escalabilidade horizontal fluida dentro do cluster.

### Frontend: Build Estático vs. Container
Embora o frontend passe por um processo de build containerizado para garantir a reprodutibilidade do artefato gerado, a arquitetura de *runtime* é Serverless. Optou-se por não servir o frontend através de containers ativos, mas sim como arquivos estáticos distribuídos globalmente. Essa decisão reduz drasticamente a superfície de ataque e o custo operacional, além de melhorar a latência para o usuário final.

---

## 3. Infraestrutura como Código (Terraform)
Toda a infraestrutura é provisionada via Terraform, adotando uma abordagem modular.

### Gestão de Estado e Colaboração
Para garantir a integridade da infraestrutura em um ambiente colaborativo, o estado do Terraform (*tfstate*) é armazenado remotamente em um bucket S3 criptografado. Adicionalmente, implementou-se um mecanismo de bloqueio (*state locking*) via DynamoDB. Isso previne condições de corrida onde múltiplas execuções simultâneas poderiam corromper o estado da infraestrutura.

### Arquitetura de Rede (VPC)
A rede foi desenhada seguindo o princípio de privilégio mínimo de acesso:
*   **Subnets Públicas**: Limitadas estritamente a recursos que exigem tráfego de entrada/saída direto da internet (ex: Load Balancers, Gateways NAT e Bastion Hosts).
*   **Subnets Privadas**: Hospedam a maior parte da carga de trabalho (Kubernetes Nodes e Banco de Dados), sem roteamento direto para a internet pública, garantindo uma camada adicional de segurança.

### Orquestração (Amazon EKS)
O Amazon Elastic Kubernetes Service (EKS) foi escolhido para remover a complexidade operacional da gestão do plano de controle (*control plane*) do Kubernetes. A estratégia de *Compute* utiliza grupos de nós gerenciados (*Managed Node Groups*), permitindo que a AWS cuide da atualização e saúde das máquinas virtuais subjacentes, enquanto a equipe de engenharia foca na definição das cargas de trabalho.

### Persistência de Dados (Amazon RDS)
A camada de dados utiliza o Amazon RDS (PostgreSQL) para garantir alta disponibilidade, backups automáticos e gestão simplificada de *patches*. O banco de dados reside estritamente nas subnets privadas, acessível apenas pelas aplicações dentro da VPC.

---

## 4. Distribuição de Conteúdo (Serverless Frontend)
Para o frontend, adotou-se uma arquitetura baseada em **S3 + CloudFront**, que oferece performance superior a containers tradicionais para conteúdo estático.

*   **Bucket Privado (Origin)**: O armazenamento dos arquivos é feito em um bucket S3 com acesso público bloqueado.
*   **CloudFront (CDN)**: Atua como a borda de distribuição.
*   **Origin Access Control (OAC)**: É o mecanismo de segurança que garante que os arquivos no S3 só possam ser acessados através do CloudFront, impedindo acessos diretos não autorizados ao bucket.
*   **SPA Routing**: A configuração foi ajustada para suportar *Single Page Applications*, tratando rotas virtuais (client-side routing) corretamente.

---

## 5. Exposição e Roteamento (DNS & Ingress)
A estratégia de roteamento une o Cloud AWS ao cluster Kubernetes.

### AWS Load Balancer Controller
Em vez de gerenciar Load Balancers manualmente, delegamos essa responsabilidade ao próprio cluster Kubernetes. Através do *AWS Load Balancer Controller* e do conceito de IRSA (*IAM Roles for Service Accounts*), o cluster possui permissão granular para provisionar e configurar Application Load Balancers (ALB) dinamicamente conforme a definição dos objetos *Ingress*.

### Estratégia de DNS
O DNS (Route53) atua como o ponto de entrada unificado.
*   Existe uma interdependência intencional: O DNS do backend depende da criação do ALB pelo Kubernetes.
*   Adotou-se uma estratégia de provisionamento em dois estágios para resolver essa dependência circular, garantindo que o domínio final aponte corretamente para o recurso dinâmico gerado pelo cluster.

---

## 6. Disponibilidade e Troubleshooting
Para cenários de depuração (*troubleshooting*) e validação de conectividade interna, foi provisionada uma instância EC2 utilitária ("Utility/Bastion").
*   **Postura de Segurança**: Esta instância segue uma política de "Zero Trust" padrão, com todas as portas de entrada fechadas (*Default Deny*). O acesso é liberado apenas sob demanda e para IPs específicos, minimizando riscos.

---

## 7. Pipeline de Entrega Contínua (CI/CD)
A automação via GitHub Actions orquestra o ciclo de vida das aplicações.

### Segurança na Autenticação (OIDC)
Abandonou-se o uso de credenciais estáticas de longa duração (Access Keys) em favor do **OpenID Connect (OIDC)**. Isso permite que o GitHub Actions assuma papéis temporários no IAM da AWS, uma prática de segurança muito superior que elimina o risco de vazamento de chaves mestras.

### Fluxo de Deploy
*   **Backend**: O pipeline constrói a imagem, publica no ECR (Elastic Container Registry) com tag imutável (SHA do commit) e instrui o Kubernetes a atualizar a versão da aplicação. O processo inclui verificação de *rollout* para garantir que a nova versão está saudável antes de finalizar.
*   **Frontend**: O pipeline executa o build otimizado e sincroniza os artefatos com o S3, seguido de uma invalidação de cache no CloudFront para garantir que os usuários recebam a versão mais recente imediatamente.
*   **Segurança de Secrets**: Credenciais sensíveis (ex: senhas de banco) não trafegam em arquivos de manifesto. Elas são injetadas dinamicamente no momento do deploy, mantendo o repositório de código seguro.