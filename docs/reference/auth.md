# 🔐 Authentication Reference

This project implements a pragmatic **JWT Authentication** strategy.

## 🔑 Key Features
*   **JWT Access Token**: Short-lived (15m). Returned in JSON response.
*   **JWT Refresh Token**: Long-lived (7d). Stored in **HttpOnly Cookie**.
*   **Users Table**: Simple table in PostgreSQL (`blog.users`).

## 📡 Endpoints

### 1. Login
*   **POST** `/auth/login`
*   **Payload**: `{ "email": "admin@ezops.com", "password": "password123" }`
*   **Response**:
    ```json
    { "data": { "accessToken": "eyJhbG..." } }
    ```
*   **Cookie**: Sets `refreshToken` (HttpOnly).
*   **Notes**: Requires `credentials: include` (or `withCredentials: true`) in frontend.

### 2. Refresh Token
*   **POST** `/auth/refresh-tokens`
*   **Payload**: `{}` (Can send fingerprint optionally, ignored for now)
*   **Response**: Returns new Access Token.
*   **Cookie**: Reads `refreshToken` cookie.

### 3. Current User
*   **GET** `/users/current`
*   **Header**: `Authorization: Bearer <accessToken>`
*   **Response**:
    ```json
    { "data": { "id": 1, "name": "Admin", "email": "..." } }
    ```

### 4. Logout
*   **POST** `/auth/logout`
*   **Action**: Clears `refreshToken` cookie.

## 🛠️ Configuration
*   **Env Vars**:
    *   `JWT_SECRET`: Secret key for signing tokens.
    *   `CORS_ALLOWED_ORIGINS`: Must be set to allow credentials.

## 👤 Default User
*   **Email**: `admin@ezops.com`
*   **Password**: `password123`
