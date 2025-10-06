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
