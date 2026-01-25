# ✅ Guia de Validação Final

## 1. Testar Localmente (Docker Compose)
Use este guia para validar se o ambiente local está correto.

### A. Subir o Ambiente
```bash
docker-compose down -v
docker-compose up --build -d
```

### B. Validar Migração Automática (Seed)
Verifique os logs do container backend:
```bash
docker-compose logs backend
```
**Sucesso:** Procure por:
> `[Migration] DB Connection successful.`
> `[Migration] Schema applied successfully.`
> `Server running on port 3000`

### C. Validar CORS e API
Teste se a API aceita requisições do Frontend (localhost:8080).
```bash
curl -v -X OPTIONS http://localhost:5000/posts \
  -H "Origin: http://localhost:8080" \
  -H "Access-Control-Request-Method: GET"
```
**Sucesso:** Procure por:
> `< HTTP/1.1 204 No Content`
> `< Access-Control-Allow-Origin: http://localhost:8080`
> `< Access-Control-Allow-Methods: GET,POST,PUT,PATCH,DELETE,OPTIONS`

---

## 2. Testar em Staging (Pós-Deploy)
Após o commit e push, valide no ambiente real.

### A. Validar Backend e Migrations
Verifique os logs do Pod no Kubernetes:
```bash
kubectl logs -n stg-chico deployment/ezops-backend
```
Você deve ver as mesmas mensagens de `[Migration]` do teste local.

### B. Validar Aplicação Frontend
1. Acesse: https://app-ezops.gratianovem.com.br/news
2. Abra o **Developer Tools > Network**.
3. Verifique a chamada para `posts`.
   * **Status**: 200 OK (não mais erro de CORS/bloqueado).
   * **Response**: JSON com os posts (mesmo que vazio `[]`).

### C. Validar Health Check
Acesse via browser ou curl:
https://api-ezops.gratianovem.com.br/health
**Resposta**: "OK"

### D. Validar Autenticação (Novo)
Teste o login com o usuário padrão via console do navegador (Network tab) ao tentar logar no Frontend ou via curl:
```bash
curl -X POST https://api-ezops.gratianovem.com.br/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@ezops.com", "password":"password123"}'
```
**Resposta Esperada**:
> Status 200 OK
> JSON: `{ "data": { "accessToken": "..." } }`
