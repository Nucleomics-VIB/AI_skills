# Current Context

<!--
CURRENT_CONTEXT.md
Purpose: Stores the current state, environment, and relevant context for the session.
Usage: Copilot updates this file with new context and reads it before making decisions. Users can review or edit to clarify session context.
-->

## Project Overview

**Project Name:** [Your Project Name]

**Description:**
[Brief description of what this project does and its purpose]

**Current Phase:**
[e.g., Initial Development / Feature Addition / Refactoring / Production Maintenance]

---

## Technology Stack

### Languages

- **Primary:** [e.g., Python 3.11, TypeScript 5.0, Bash]
- **Secondary:** [e.g., SQL, HTML/CSS]

### Frameworks & Libraries

- [e.g., React 18.2]
- [e.g., Express 4.18]
- [e.g., Django 4.2]

### Tools & Infrastructure

- **Version Control:** [e.g., Git]
- **Package Manager:** [e.g., npm, pip, cargo]
- **Build Tools:** [e.g., Webpack, Vite, Make]
- **Container:** [e.g., Docker, Docker Compose]
- **Database:** [e.g., PostgreSQL 15, MongoDB 6.0]

---

## Environment Information

### Development Environment

**OS:** [e.g., macOS 14.0, Ubuntu 22.04, Windows 11]

**Editor:** [e.g., VS Code 1.84]

**Shell:** [e.g., bash, zsh, PowerShell]

### Deployment Environment

**Host OS:** [e.g., Ubuntu 22.04 LTS]

**Deployment Path:** [e.g., /opt/production/app/]

**Server:** [e.g., Nginx, Apache, None (containerized)]

**Runtime:** [e.g., Node.js 18.x, Python 3.11, Java 17]

---

## Directory Structure

```
project-root/
├── AI_files/                  # AI memory system (this folder)
│   ├── AI_INSTRUCTIONS.md
│   ├── CURRENT_CONTEXT.md
│   ├── SESSION_DECISIONS.md
│   └── README.md
├── src/                       # Source code
├── tests/                     # Test files
├── docs/                      # Documentation
├── scripts/                   # Utility scripts
├── config/                    # Configuration files
└── README.md
```

### Key Paths

| Path | Purpose |
|------|---------|
| `src/` | Main source code |
| `tests/` | Unit and integration tests |
| `docs/` | Project documentation |
| `scripts/` | Build, deployment, utility scripts |
| `config/` | Configuration files |

---

## Project State

### Current Focus

*What are you currently working on?*

**Example:**
- Implementing user authentication module
- Refactoring database access layer
- Adding CI/CD pipeline
- Fixing bug #123 in payment processing

### Active Files

*Which files are you currently editing?*

**Example:**
- `src/auth/jwt-handler.ts` - JWT token generation
- `src/auth/middleware.ts` - Authentication middleware
- `tests/auth/jwt.test.ts` - JWT tests

### Recent Changes

*Major changes from recent sessions*

**Example:**
- 2025-11-07: Migrated from REST to GraphQL for API
- 2025-11-06: Updated database schema for user roles
- 2025-11-05: Implemented caching layer with Redis

---

## Configuration Details

### Environment Variables

**Required:**

- `DATABASE_URL` - Database connection string
- `API_KEY` - External API key
- `SECRET_KEY` - Application secret for sessions

**Optional:**

- `DEBUG` - Enable debug mode (default: false)
- `LOG_LEVEL` - Logging level (default: info)
- `PORT` - Server port (default: 3000)

### Configuration Files

| File | Purpose |
|------|---------|
| `.env` | Environment variables (not in Git) |
| `.env.example` | Template for .env |
| `config.yaml` | Application configuration |
| `docker-compose.yml` | Docker services |

---

## Dependencies

### System Requirements

- [e.g., Node.js >= 18.0]
- [e.g., Python >= 3.11]
- [e.g., Docker >= 20.10]
- [e.g., PostgreSQL >= 14]

### External Services

- [e.g., AWS S3 for file storage]
- [e.g., SendGrid for email]
- [e.g., Stripe for payments]

---

## Data Storage

### Databases

**Primary Database:**

- Type: [e.g., PostgreSQL]
- Version: [e.g., 15.3]
- Location: [e.g., localhost:5432 / aws-rds.amazonaws.com]

**Cache:**

- Type: [e.g., Redis]
- Version: [e.g., 7.0]
- Location: [e.g., localhost:6379]

### File Storage

- **Local:** [e.g., `./data/uploads/`]
- **Cloud:** [e.g., S3 bucket: my-app-files]

---

## Network & Ports

### Development

- **Application:** http://localhost:3000
- **Database:** localhost:5432
- **Cache:** localhost:6379

### Production

- **Application:** https://app.example.com
- **API:** https://api.example.com
- **Admin:** https://admin.example.com

---

## Special Considerations

### Known Issues

*Current bugs, limitations, or workarounds*

**Example:**
- Database queries may timeout on large datasets (use pagination)
- File uploads limited to 10MB (configured in nginx)
- API rate limited to 1000 req/hour per IP

### Constraints

*Technical or business constraints*

**Example:**
- Must support IE11 for enterprise clients
- Cannot use GPL-licensed libraries
- Database migrations must be reversible
- Zero downtime deployments required

### Future Plans

*Upcoming changes or features*

**Example:**
- Migrate to microservices architecture (Q1 2026)
- Add real-time notifications with WebSockets
- Implement multi-language support

---

## Quick Reference

### Common Commands

```bash
# Development
npm run dev          # Start dev server
npm test            # Run tests
npm run build       # Build for production

# Deployment
docker-compose up -d    # Start services
docker-compose logs -f  # View logs
./scripts/deploy.sh     # Deploy to production

# Database
npm run migrate        # Run migrations
npm run seed           # Seed database
```

### Useful Links

- **Repository:** [GitHub URL]
- **Documentation:** [Docs URL]
- **Issue Tracker:** [Issues URL]
- **Deployment Dashboard:** [Dashboard URL]

---

## Session Flags

*Temporary flags for current session (remove when done)*

### Active Flags

- [ ] `REFACTORING_AUTH` - Currently refactoring authentication module
- [ ] `TESTING_DISABLED` - Tests temporarily disabled during migration
- [ ] `EXPERIMENTAL_FEATURE_X` - Testing new feature X

### Completed Flags

- [x] `DATABASE_MIGRATION` - Database schema updated (completed 2025-11-05)

---

## Notes

*Any additional context that doesn't fit above categories*

**Example:**
- Performance is critical for this application - always consider optimization
- Security is paramount - never skip input validation
- Code review required for all changes - document thoroughly

---

*Last Updated: 2025-11-07*
*Update this file whenever project context, environment, or focus areas change.*
