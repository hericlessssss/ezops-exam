# 📚 Migrations & CORS Reference

## 1. Database Migrations & Seeding (Auto-Startup)

### Strategy: "Migrate on Startup"
Instead of relying on external tools or K8s Jobs, the backend application itself creates the database schema when it starts.

**How it works:**
1.  **`create.sql`**: Located in `apps/backend/database/create.sql`. It is now **idempotent** (uses `IF NOT EXISTS`), so it can run safely on every startup.
2.  **`migrationService.js`**: Located in `apps/backend/server/service/migrationService.js`.
    *   Reads `create.sql`.
    *   Connects to the database (with Retry Logic: 10 attempts).
    *   Executes the SQL.
    *   If successful, it resolves the promise.
    *   If it fails after retries, the backend process exits with `1` (causing K8s to restart the pod).
3.  **Entry Point**: `server.js` calls `migrationService.runMigrations()` **before** `app.listen()`. The server port is only opened if the DB is ready.

**Benefits:**
*   **Zero-Touch**: Just deploy the app, and the DB is seeded.
*   **Simple**: No separate InitContainers or K8s Jobs.
*   **Robust**: Handles DB startup delays (race conditions) automatically via retries.

---

## 2. CORS (Cross-Origin Resource Sharing)

### Configuration
CORS is handled by the `cors` npm package in Express.

**Environment Variable:** `CORS_ALLOWED_ORIGINS`
This variable accepts a comma-separated list of trusted domains.

**Example Production:**
`CORS_ALLOWED_ORIGINS=https://app-ezops.gratianovem.com.br`

**Example Local:**
`CORS_ALLOWED_ORIGINS=http://localhost:8080`

**Behavior:**
*   Allowed Methods: `GET, POST, PUT, PATCH, DELETE, OPTIONS`
*   Allowed Headers: `Content-Type, Authorization` (required for Bearer auth).
*   Origins: Checked dynamically against the list.

### Kubernetes Config
In `k8s/staging/backend/configmap.yaml`, `CORS_ALLOWED_ORIGINS` is defined to include the Staging URL.
