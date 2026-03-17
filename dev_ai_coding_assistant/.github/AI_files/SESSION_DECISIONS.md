# Session Decisions Log

<!--
SESSION_DECISIONS.md
Purpose: Tracks all decisions, changes, and important choices made during sessions.
Usage: Copilot appends new decisions here after each significant change. Users can review or edit to clarify decision history or rationale.
-->

## Decision Entry Template

*Copy this template for new decisions:*

```markdown
## YYYY-MM-DD: Decision Title

### What Was Decided
Brief description of the decision made.

### Rationale
Why this choice was made - the reasoning and context.

### Alternatives Considered
Other options that were evaluated and why they weren't chosen.

### Implementation
How this decision will be/was implemented in the code.

### Impact
What parts of the project are affected by this decision.

### Status
✅ Completed / ⏳ In Progress / 🚫 Blocked / 🔄 Revised

### Related Decisions
Links to other related decisions (if any).
```

---

## Example Decision Entries

*These are examples to guide you - replace with your actual decisions*

---

## 2025-11-07: Choice of Database Technology

### What Was Decided

Use PostgreSQL as the primary database instead of MongoDB.

### Rationale

- Project requires complex relational queries
- ACID compliance needed for financial transactions
- Team has more experience with SQL
- Better tooling and ecosystem for our use case

### Alternatives Considered

1. **MongoDB** - Rejected because:
   - Lacks transaction support for our needs
   - Schema flexibility not needed for our structured data
   - Would require learning new query language

2. **MySQL** - Rejected because:
   - PostgreSQL has better support for advanced data types (JSON, arrays)
   - PostGIS extension needed for geographic queries
   - Better full-text search capabilities

### Implementation

- Install PostgreSQL 15.3
- Create database schema with migrations (Flyway)
- Use connection pooling (pgBouncer)
- Set up read replicas for scaling

### Impact

- All data models defined with SQL schemas
- Migration scripts in `db/migrations/`
- ORM configuration updated
- Docker compose includes PostgreSQL service

### Status

✅ Completed

---

## 2025-11-06: API Authentication Strategy

### What Was Decided

Implement JWT-based authentication with RS256 signing (not HS256).

### Rationale

- Microservices architecture requires token verification without shared secrets
- Public key distribution allows services to verify tokens independently
- Better security model - private key only on auth service
- Industry standard approach

### Alternatives Considered

1. **Session-based authentication** - Rejected because:
   - Requires shared session store across services
   - Doesn't scale horizontally as easily
   - More complex for API clients

2. **HS256 JWT** - Rejected because:
   - Shared secret distribution is security risk
   - All services need secret to verify tokens
   - Harder to rotate secrets

### Implementation

```typescript
// Auth service generates tokens with private key
const token = jwt.sign(payload, privateKey, { 
  algorithm: 'RS256',
  expiresIn: '1h'
});

// Other services verify with public key
const decoded = jwt.verify(token, publicKey);
```

- Private key stored in auth service only
- Public key distributed to all services
- Token refresh mechanism implemented
- 1-hour expiration for security

### Impact

- Auth service: Token generation endpoint
- All services: Middleware for token validation
- Public key distribution via config management
- Client libraries updated for token handling

### Status

✅ Completed

### Related Decisions

- See 2025-11-05: Microservices Architecture Decision

---

## 2025-11-05: Microservices Architecture Decision

### What Was Decided

Split monolithic application into microservices with these boundaries:

1. **Auth Service** - User authentication and authorization
2. **User Service** - User profile management
3. **Product Service** - Product catalog
4. **Order Service** - Order processing
5. **Payment Service** - Payment processing

### Rationale

- Monolith becoming too large to maintain (150k+ LOC)
- Different services have different scaling requirements
- Team growing - need better separation of concerns
- Want to enable independent deployments

### Alternatives Considered

1. **Keep monolith** - Rejected because:
   - Deployments becoming risky and slow
   - Can't scale components independently
   - Hard to assign ownership to teams

2. **Modular monolith** - Rejected because:
   - Still single deployment unit
   - Doesn't solve independent scaling
   - Modules tend to get coupled over time

### Implementation

- **Phase 1** (Completed): Extract Auth Service
- **Phase 2** (In Progress): Extract Payment Service
- **Phase 3** (Planned): Extract remaining services
- Communication: REST + async messaging (RabbitMQ)
- Service discovery: Consul
- API Gateway: Kong

### Impact

- Codebase reorganized into service folders
- Shared libraries extracted to npm packages
- CI/CD updated for multi-service deployment
- Monitoring and logging centralized (ELK stack)

### Status

⏳ In Progress (Phase 2)

### Related Decisions

- See 2025-11-06: API Authentication Strategy

---

## 2025-11-04: Docker for Development Environment

### What Was Decided

Use Docker Compose for local development environment.

### Rationale

- Consistent environment across team members
- Eliminates "works on my machine" problems
- Easy to onboard new developers
- Matches production environment closely

### Alternatives Considered

1. **Manual setup** - Rejected because:
   - Time-consuming for new team members
   - Inconsistencies between dev machines
   - Hard to keep documentation updated

2. **Vagrant** - Rejected because:
   - Heavier weight than Docker
   - Slower startup times
   - Less widely adopted in team

### Implementation

```yaml
# docker-compose.yml
services:
  app:
    build: .
    ports:
      - "3000:3000"
    volumes:
      - .:/app
    depends_on:
      - db
      - redis
  
  db:
    image: postgres:15
    environment:
      POSTGRES_DB: myapp
    ports:
      - "5432:5432"
  
  redis:
    image: redis:7
    ports:
      - "6379:6379"
```

Commands:
```bash
docker-compose up    # Start all services
docker-compose down  # Stop all services
```

### Impact

- All developers use same environment
- README updated with Docker setup instructions
- CI/CD uses same Docker images
- Development faster - no manual service management

### Status

✅ Completed

---

## 2025-11-03: Code Formatting with Prettier

### What Was Decided

Enforce code formatting with Prettier, configured as:

- Single quotes for strings
- 2 spaces for indentation
- No semicolons
- Trailing commas in multi-line
- 80 character line width

### Rationale

- Eliminate formatting debates
- Consistent code style across team
- Automatic formatting on save
- Reduces code review noise

### Alternatives Considered

1. **ESLint for formatting** - Rejected because:
   - Prettier is specifically designed for formatting
   - ESLint better suited for code quality rules
   - Can use both together

2. **Manual style guide** - Rejected because:
   - Hard to enforce consistently
   - Wastes time in code reviews
   - Human error prone

### Implementation

```json
// .prettierrc
{
  "singleQuote": true,
  "semi": false,
  "tabWidth": 2,
  "trailingComma": "es5",
  "printWidth": 80
}
```

- Pre-commit hook runs Prettier
- CI checks formatting
- VS Code configured to format on save

### Impact

- Entire codebase reformatted
- Git history shows large formatting commit
- Developer workflow includes automatic formatting
- Code reviews focus on logic, not style

### Status

✅ Completed

---

## Session Notes

*Use this section for temporary notes during active session*

### Current Session (2025-11-07)

**Working On:**
- [What you're currently working on]

**Decisions Made Today:**
- [List decisions made in current session]

**Next Steps:**
- [What needs to be done next]

**Blockers:**
- [Any issues blocking progress]

---

## Tips for Maintaining This File

1. **Be consistent** - Use the template format for all decisions
2. **Be specific** - Include enough detail to understand the decision later
3. **Link related decisions** - Cross-reference when decisions build on each other
4. **Update status** - Keep decision status current (completed, in progress, etc.)
5. **Include code examples** - Show how decisions are implemented
6. **Explain trade-offs** - Document why alternatives weren't chosen
7. **Date everything** - Always include dates for temporal context
8. **Review periodically** - Read through old decisions to maintain consistency

---

*This file should be updated after every significant decision or architectural choice.*
*Keep it current and detailed - it's your project's decision history and knowledge base.*
