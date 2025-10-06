# ms-auth-service-elixir

Authentication microservice (signup / signin) implemented in **Elixir**.  
This service follows the Programming Manifesto and the acceptance criteria of the challenge:

- Layered architecture (Clean Architecture).
- ContextData propagated with `message-id` and `x-request-id`.
- Functional and deterministic in-memory persistence.
- Contract-first API (OpenAPI).
- Consistent error handling (no passwords in responses/logs).
- Unit and integration tests.

---

## 🚀 Main Endpoints

- `POST /signup`  
  Registers a new user.  
  - Validations: required and valid email, password >= 8 characters, unique email.  
  - Expected errors:  
    - `INVALID_EMAIL_FORMAT` → 400  
    - `WEAK_PASSWORD` → 400  
    - `EMAIL_ALREADY_EXISTS` → 409  

- `POST /signin`  
  Authenticates an existing user.  
  - Validations: correct credentials.  
  - Expected errors:  
    - `USER_NOT_FOUND` → 404  
    - `INVALID_CREDENTIALS` → 401  

### Required Headers
- `message-id` (UUID, required in all requests).  
- `x-request-id` (UUID, propagated in all responses).  

---

## 📑 Documentation

API specification is available at:  


## cURLS:
# Exitoso: 
curl --location 'http://localhost:8083/api/signup' \
--header 'Content-Type: application/json' \
--header 'x-request-id: 11111111-1111-1111-1111-111111111111' \
--data-raw '{
    "email": "daniela1@google.com",
    "password": "supersegura"
}'
<img width="809" height="219" alt="image" src="https://github.com/user-attachments/assets/fe51aaec-d7bc-444a-8796-c3dcd980a52f" />

# Email duplicado

curl --location 'http://localhost:8083/api/signup' \
--header 'Content-Type: application/json' \
--header 'x-request-id: 11111111-1111-1111-1111-111111111111' \
--data-raw '{
    "email": "daniela@google.com",
    "password": "supersegura"
}'

# Answer:
<img width="802" height="308" alt="image" src="https://github.com/user-attachments/assets/163d5632-f341-4e7b-a17b-bf920eb656d7" />

# Sesión exitosa
curl --location 'http://localhost:8083/api/signin' \
--header 'Content-Type: application/json' \
--data-raw '{
    "email": "daniela@google.com",
    "password": "supersegura"
}'

# Answer: 
<img width="808" height="252" alt="image" src="https://github.com/user-attachments/assets/61b11799-eaa1-41ed-8b7d-34878b945aa2" />

# Sesion Email no existe
curl --location 'http://localhost:8083/api/signin' \
--header 'Content-Type: application/json' \
--data-raw '{
    "email": "pepito@google.com",
    "password": "supersegura"
}'

# Answer:
<img width="821" height="304" alt="image" src="https://github.com/user-attachments/assets/fcaee0a1-0d04-467d-956d-21a06db2c951" />

# Sesión password incorrecta
curl --location 'http://localhost:8083/api/signin' \
--header 'Content-Type: application/json' \
--data-raw '{
    "email": "daniela@google.com",
    "password": "password1"
}'

# Answer: 
<img width="809" height="324" alt="image" src="https://github.com/user-attachments/assets/711ed6fc-5cb5-4e0c-b784-0bac7452001e" />



