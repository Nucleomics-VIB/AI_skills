# 🤖 AI Assistant Rules for This Workspace

## ABSOLUTE RULES - ENFORCEABLE

These rules apply to ALL AI assistance in this workspace from November 10, 2025 onwards.

---

## ❌ STRICTLY FORBIDDEN

### Terminal Command Execution
- **NEVER use `run_in_terminal` tool**
- **NEVER execute commands in any terminal**
- **NEVER run scripts or code myself**
- **NEVER attempt to run anything in bash, node, or any shell**

**Why:** The AI's terminal environment is non-functional. Only YOUR terminal works.

---

## ✅ ALWAYS DO

### File Editing
- **DO edit workspace files directly** using tools like `replace_string_in_file`, `create_file`, `edit_notebook_file`
- **DO modify code, configurations, documentation** without asking permission first
- **DO read and analyze files** to understand the project
- **DO make structural changes** (folder creation, file organization, etc.)

### Terminal Command Suggestions
- **DO display commands as copyable code blocks**
- **DO include clear "Copy to Terminal" markers**
- **DO explain what each command does**
- **DO let the user execute commands** in their terminal
- **DO provide command output parsing** if the user shares results

---

## 📋 Decision Tree

```
User asks for something
    ↓
Does it involve editing files?
    ├─ YES → Edit files myself ✅
    └─ NO  → Does it involve running a command?
             ├─ YES → Show copyable command ✅
             └─ NO  → Provide analysis/information ✅
```

---

## 📝 Examples

### ✅ CORRECT: File Editing
```
User: "Update the Dockerfile to add curl"
AI: [Uses replace_string_in_file to update Dockerfile directly]
Result: File is updated immediately
```

### ✅ CORRECT: Copyable Command
```
User: "How do I build the Docker image?"
AI: "Copy this to your terminal:
    ./scripts/build-docker.sh --version v1.0.0"
Result: User copies and executes in their terminal
```

### ❌ WRONG: Terminal Execution
```
User: "Build the Docker image"
AI: [Attempts to use run_in_terminal]
Result: FORBIDDEN - violates this rule
```

---

## 🔐 Enforcement Mechanism

### How Users Can Enforce This Rule

1. **If AI tries to execute a command:**
   - Stop the execution immediately
   - Reference this file: `.AI_ASSISTANT_RULES.md`
   - Say: "Rule violation: You cannot run commands"

2. **If AI tries to edit without permission:**
   - This is ALLOWED and encouraged
   - No violation

3. **If AI shows a copyable command:**
   - This is CORRECT behavior
   - User can choose to execute or not

### For Future Conversations

**Start new conversations with this instruction:**

> "Important: Follow the rules in `.AI_ASSISTANT_RULES.md` in this workspace. Never try to run commands in a terminal. Only show copyable commands for me to execute. Edit files directly when appropriate."

---

## 📊 Rule Summary Table

| Action | Allowed? | Tool Used |
|--------|----------|-----------|
| Edit files | ✅ YES | `replace_string_in_file`, `create_file` |
| Create folders | ✅ YES | `create_directory` |
| Run commands | ❌ NO | (no tool) |
| Show commands | ✅ YES | (as text block) |
| Execute scripts | ❌ NO | (forbidden) |
| Modify configs | ✅ YES | `replace_string_in_file` |
| Update docs | ✅ YES | `create_file`, `replace_string_in_file` |

---

## 🎯 Why These Rules?

1. **Terminal is non-functional** - AI's terminal environment doesn't work properly
2. **File editing is reliable** - Direct file modifications always work
3. **User control** - YOU control what runs in your terminal
4. **Safety** - Prevents accidental command execution
5. **Productivity** - AI can still be very helpful with file management

---

## 📍 File Location

This file is located at: `.AI_ASSISTANT_RULES.md`

**Reference this file whenever you need to enforce these rules.**

---

## 🔄 Rule Updates

These rules are active from **November 10, 2025** onwards.

If you need to update these rules, edit this file and communicate the changes.

---

**WORKSPACE AI ASSISTANT RULES - ACTIVE AND ENFORCEABLE**

Last Updated: November 10, 2025
Status: ✅ ACTIVE
