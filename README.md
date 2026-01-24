# ezops-exam

End-to-end AWS DevOps implementation for a practical exam: containerization, IaC, Kubernetes, and CI/CD.

## Project Structure

- `apps/backend`: Node.js Express API.
- `apps/frontend`: Vue.js Single Page Application.
- `infra/`: Terraform configuration (Planned).
- `k8s/`: Kubernetes manifests (Planned).
- `.github/workflows`: CI/CD pipelines (Planned).

## Local Development (Docker)

The easiest way to run the project locally is using Docker Compose.

### Prerequisites

- Docker
- Docker Compose

### Running

1. **Start the application:**
   ```bash
   make up
   # OR
   docker-compose up -d
   ```

2. **Access the application:**
   - Frontend: [http://localhost:8080](http://localhost:8080)
   - Backend API: [http://localhost:5000/posts](http://localhost:5000/posts)
   - Health Check: [http://localhost:5000/health](http://localhost:5000/health)

3. **Stop the application:**
   ```bash
   make down
   # OR
   docker-compose down
   ```

4. **View Logs:**
   ```bash
   make logs
   ```

### Validation Checklist

- [ ] Navigate to `http://localhost:8080`. You should see the Vue.js Welcome App.
- [ ] Navigate to `http://localhost:5000/posts`. You should see a JSON response (e.g., `[]`).
- [ ] Navigate to `http://localhost:5000/health`. You should see `OK`.

## Environment Variables

| Variable | Service | Description | Default (Docker) |
|----------|---------|-------------|------------------|
| `DB_HOST` | Backend | Database Hostname | `db` |
| `DB_PORT` | Backend | Database Port | `5432` |
| `DB_USER` | Backend | Database User | `postgres` |
| `DB_PASSWORD` | Backend | Database Password | `postgres` |
| `DB_NAME` | Backend | Database Name | `blog` |

## Future Improvements

The following improvements are planned or recommended for a production-ready environment:

- **Sass Migration**: Migrate from `node-sass` to `sass` (Dart Sass) to support modern Node.js versions in the frontend build.
- **Environment Configuration**: Remove hardcoded configuration in `apps/frontend/src/.env.js` and implement runtime environment variable injection.
- **Security**: Don't run containers as root (add user in Dockerfiles).

## Troubleshooting

- **Frontend Connection Error**: Ensure the backend container is running. The frontend is hardcoded to connect to `localhost:5000`. We map port 3000 (container) to 5000 (host) in `docker-compose.yml` to satisfy this.
- **Database Connection Error**: The backend attempts to connect to the DB on startup. Ensure the `db` service is healthy.
