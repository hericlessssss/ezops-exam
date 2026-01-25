# 📊 Relatório de Gaps & Riscos (QA Staging)

## 🚨 P0 - Bloqueadores Críticos (Impedem o fluxo principal)

### 1. Sistema de Login Inexistente no Backend
*   **Sintoma**: O usuário tenta logar, recebe erro 404 (Not Found) ou CORS error (antes da correção).
*   **Causa**: O Frontend possui telas e serviços para Autenticação (`/auth/login`, `/auth/refresh-tokens`) e Usuários (`/users/current`), mas o **Backend não possui essas rotas**.
*   **Impacto**: Impossível acessar áreas privadas ou identificar autor do post.
*   **Recomendação**: Implementar módulo de Auth (JWT) ou Remover Login do Frontend (deixando aberto).

### 2. Rota `/users/current` Inexistente
*   **Sintoma**: Ao carregar a aplicação, o Frontend tenta buscar o usuário logado (`GET /users/current`) e falha.
*   **Impacto**: O Frontend assume que o usuário está deslogado ou quebra o carregamento do perfil.

## ⚠️ P1 - Funcionalidade Limitada

### 3. Filtro de Posts por Usuário
*   **Análise**: O serviço `PostsService.getPostsByUserId` envia parâmetros de filtro. O Backend (`postsRoute.js`) precisa estar preparado para ler `req.query` e filtrar no SQL.
*   **Status**: A verificar no código atual (`postsRoute.js`).

## ✅ Correções Já Realizadas (Stabilization)

### 1. Migrations & Seeding (Resolvido)
*   **Problema Anterior**: Banco subia vazio e exigia comando manual.
*   **Solução Atual**: O Backend agora possui um `migrationService` que roda **automático no startup**, de forma idempotente (`IF NOT EXISTS`). O DB sobe pronto para uso.

### 2. CORS & Segurança (Resolvido)
*   **Problema Anterior**: Erros de CORS bloqueavam o Frontend. Conexão DB sem SSL falhava na AWS.
*   **Solução Atual**:
    *   CORS configurado para aceitar Credenciais e Origens via Env Var (`CORS_ALLOWED_ORIGINS`).
    *   Conexão DB agora usa SSL (`rejectUnauthorized: false`).
    *   Timeouts de Liveness aumentados para evitar crash loops durante migração.

---

## 📝 Próximos Passos Sugeridos

1.  **Imediato**: Deploy das correções de Migrations/CORS (que já estão prontas no seu repo local).
2.  **Decisão de Negócio**: Definir se implementamos o "Login Real" no backend (estimativa: 2-4 horas) ou se removemos o Login do Frontend.
