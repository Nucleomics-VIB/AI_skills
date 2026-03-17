# File-Assisted Memory System for Copilot

Persistent context, decisions, and rules that survive across coding sessions.

## 📑 Table of Contents

- [Overview](#overview)
- [Core Files](#core-files)
- [How It Works](#how-it-works)
- [Setup](#setup)
- [Best Practices](#best-practices)
- [Troubleshooting](#troubleshooting)

---

## Overview

**Problem:** AI assistants forget context, repeat mistakes, violate rules.

**Solution:** Three files Copilot reads before every response:
- ✅ AI_INSTRUCTIONS.md - Your coding rules
- ✅ CURRENT_CONTEXT.md - Project state
- ✅ SESSION_DECISIONS.md - Decision history

**Result:** Consistent, context-aware AI assistance.

---

## Core Files

### AI_INSTRUCTIONS.md
**Purpose:** Rules and coding standards

**Add:**
- Critical rules (never hardcode credentials, etc.)
- Coding standards (documentation, testing, etc.)
- Tool restrictions (terminal commands, etc.)
- Language-specific patterns

**Example:**
```markdown
## Critical Rules
- Never hardcode credentials (use .env)
- All functions must have documentation
- Use config.yaml for paths/settings
```

### CURRENT_CONTEXT.md
**Purpose:** Project state and tech stack

**Add:**
- Project description
- Technology stack & versions
- Directory structure
- Environment details
- Current focus areas

**Example:**
```markdown
## Project Overview
**Name:** My API  
**Tech Stack:** Python 3.11, FastAPI, PostgreSQL 15  
**Phase:** MVP Development
```

### SESSION_DECISIONS.md
**Purpose:** Decision log with rationale

**Add entry after significant decisions:**
```markdown
## 2025-11-07: Database Choice

### What Was Decided
Use PostgreSQL instead of MongoDB

### Rationale
- Need ACID transactions
- Complex relational queries required
- Team has PostgreSQL experience

### Status
✅ Completed
```

---

## How It Works

### Copilot Workflow

```
1. User makes request
   ↓
2. Copilot reads all 3 AI_files
   ↓
3. Applies rules and context
   ↓
4. Generates compliant code
   ↓
5. Documents decision (if significant)
```

### You Maintain

- **Add rules** to AI_INSTRUCTIONS.md as patterns emerge
- **Update context** in CURRENT_CONTEXT.md when project changes
- **Document decisions** in SESSION_DECISIONS.md after choices

---

## Setup

### Initial Setup (5 minutes)

**1. Edit AI_INSTRUCTIONS.md:**
```markdown
## Project-Specific Rules
- [Add your coding standards]
- [Add required patterns]
- [Add constraints]
```

**2. Edit CURRENT_CONTEXT.md:**
```markdown
## Technology Stack
- Primary Language: [Your language]
- Framework: [Your framework]
- Database: [Your database]

## Directory Structure
- src/ - Source code
- tests/ - Test files
```

**3. Edit SESSION_DECISIONS.md:**
```markdown
## 2025-11-07: Initial Setup
### Status
✅ Completed
```

### Configure VS Code

Create `.vscode/settings.json`:
```json
{
  "github.copilot.chat.welcomeMessage": "Always read .github/AI_files/ before responding"
}
```

Update `.github/copilot-instructions.md`:
```markdown
Before responding:
1. Read `.github/AI_files/AI_INSTRUCTIONS.md`
2. Read `.github/AI_files/CURRENT_CONTEXT.md`
3. Read `.github/AI_files/SESSION_DECISIONS.md`
```

---

## Best Practices

### DO

- ✅ **Be specific** - Clear rules are enforced better
- ✅ **Document decisions** - Capture rationale while fresh
- ✅ **Update context** - Keep CURRENT_CONTEXT current
- ✅ **Start simple** - Add rules gradually
- ✅ **Include examples** - Show what you mean

### DON'T

- ❌ **Be vague** - "Be careful" isn't actionable
- ❌ **Skip documentation** - You'll forget why
- ❌ **Let context drift** - Out of date is worse than missing
- ❌ **Over-complicate** - Simple rules work best
- ❌ **Contradict yourself** - Update old rules explicitly

### Decision Documentation Template

```markdown
## YYYY-MM-DD: Decision Title

### What Was Decided
[Brief description]

### Rationale
[Why this choice]

### Alternatives Considered
[What else you looked at]

### Implementation
[How it's implemented]

### Status
✅ Completed / ⏳ In Progress / 🚫 Blocked
```

---

## Troubleshooting

| Problem | Solution |
|---------|----------|
| Copilot not following rules | Add explicit examples to AI_INSTRUCTIONS.md |
| Rules being violated | Make rule more specific, add enforcement note |
| Context out of date | Review/update CURRENT_CONTEXT.md monthly |
| Decisions conflicting | Document change in SESSION_DECISIONS.md |
| Forgot why decision made | Always document rationale immediately |

---

## Examples

### Example Rule (AI_INSTRUCTIONS.md)

```markdown
## Database Access Rules

**ALWAYS use repository pattern:**
```python
# Good
user = user_repository.get_by_id(user_id)

# Bad - never query database directly in controllers
user = db.session.query(User).filter_by(id=user_id).first()
```

**Enforcement:** Code review will reject direct database access.
```

### Example Context (CURRENT_CONTEXT.md)

```markdown
## Current Focus

**Sprint Goal:** Implement user authentication module

**Active Files:**
- `src/auth/jwt_handler.py` - Token generation
- `src/auth/middleware.py` - Auth middleware
- `tests/auth/test_jwt.py` - JWT tests

**Blockers:** None
```

### Example Decision (SESSION_DECISIONS.md)

```markdown
## 2025-11-07: API Authentication Method

### What Was Decided
Use JWT with RS256 (public/private key) instead of HS256 (shared secret)

### Rationale
- Microservices can verify tokens independently
- No shared secret distribution needed
- Better security model

### Alternatives Considered
- **HS256 JWT**: Rejected - requires sharing secret across services
- **Session cookies**: Rejected - doesn't scale for API

### Implementation
- Auth service generates tokens with private key
- Services verify with public key
- Tokens expire after 1 hour

### Status
✅ Completed
```

---

**Questions?** Test the system - ask Copilot: "What rules should you follow for this project?"
- Project description and goals
- Technology stack and versions
- Directory structure and paths
- Environment configuration
- Current development phase
- Active tasks or focus areas

**Updated:** When project scope, paths, or environment changes

**Example Context:**
- "Working on Node.js 18.x project with TypeScript 5.0"
- "Deploy to /opt/production/app/ on Ubuntu 22.04 server"
- "Currently refactoring authentication module"

---

### 3. `SESSION_DECISIONS.md`
**Purpose:** Comprehensive log of all decisions and changes.

**Contains:**
- Timestamped decision entries
- Rationale for architectural choices
- Implementation details
- Trade-offs and alternatives considered
- Links between related decisions
- Status of tasks (completed, pending, blocked)

**Updated:** After every significant decision or completion

**Example Entry:**
```markdown
## 2025-11-07: Database Migration Strategy

### Decision
Use gradual migration with dual-write pattern instead of big-bang cutover.

### Rationale
- Zero downtime requirement
- Ability to rollback if issues found
- Lower risk for production system

### Implementation
- Phase 1: Dual-write to old and new DB
- Phase 2: Validation period (2 weeks)
- Phase 3: Switch reads to new DB
- Phase 4: Deprecate old DB

### Status
✅ Phase 1 completed
⏳ Phase 2 in progress
```

---

**Questions?** Test the system - ask Copilot: "What rules should you follow for this project?"
