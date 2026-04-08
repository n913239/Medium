*(Insert cover image: cover.png)*
![cover](../2026-04-17_claude-code-skills/cover.png)
<!--
Gemini prompt: A cute Ghibli-inspired soft pastel illustration. A chibi engineer character stands in front of a magical toolbox labeled "Skills". The toolbox is open, glowing softly, with colorful tool icons floating out: a broom (clean), a document (convert), a magnifying glass (check). On the left side, a notebook labeled "CLAUDE.md" sits on a desk. The engineer looks excited, reaching for the floating tools. Soft pastel colors (mint, peach, lavender), white background, clean and simple. 16:9 ratio.
-->

# Teach Claude Code Your Workflow — A Hands-On Guide to Custom Skills

> CLAUDE.md tells AI your project rules. Skills teach AI how you work.

---

## Introduction

When I introduced CLAUDE.md, many people said, "Finally, I don't have to explain the project conventions to AI every single time."

But after using it for a while, you might notice a gap: **some things aren't just "conventions" — they're entire workflows.**

For example:
- Every time you clean up commented-out legacy code, you write a long description
- Every time you convert Markdown to Word for delivery, you explain the pandoc flags and post-processing
- Every time you deploy, you walk through the steps again

These don't belong in CLAUDE.md, because they're not "always-on rules" — they're "on-demand capabilities."

**That's exactly what Skills solve.**

---

## What Are Skills?

Skills are Claude Code's custom command system. Create a `SKILL.md` file with instructions, and Claude adds it to its toolkit.

There are two ways to invoke a skill:

- **Manual**: Type `/skill-name`, just like a CLI command
- **Automatic**: Claude decides whether to activate a skill based on your conversation context

Here's how it works under the hood: Claude **always sees every skill's description** in each session (but not the full content), using it to decide when to auto-activate. The full `SKILL.md` instructions only load when actually triggered.

That means **how well you write the description directly affects whether Claude uses the right skill at the right time.**

In short: **CLAUDE.md is rules. Skills are abilities.**

*(Insert image: skills-vs-claudemd.png)*
![skills-vs-claudemd](../2026-04-17_claude-code-skills/skills-vs-claudemd.png)
<!--
Gemini prompt: A cute Ghibli-inspired soft pastel illustration with two panels. Left panel "CLAUDE.md": a kawaii notebook with a checklist and gears icon, labeled "Rules - Always On". Right panel "Skills": a kawaii toolbox with colorful tools popping out, labeled "Abilities - On Demand". Both panels have a small chibi engineer character. Soft pastel colors, white background, simple and clean. 16:9 ratio.
-->

How Skills differ from CLAUDE.md:

*(Insert image: table-comparison.png)*
![table-comparison](../2026-04-17_claude-code-skills/table-comparison.png)
<!--
| | CLAUDE.md | Skills |
|---|---|---|
| Purpose | Project conventions, loaded on every startup | Specific workflows, loaded on demand |
| Trigger | Always active | `/skill-name` manual call, or Claude auto-decides |
| Best for | Coding style, architecture docs, restrictions | Deploy flows, code cleanup, file conversion |
| Location | Project root | `.claude/skills/` directory |
-->

---

## Getting Started: Create Your First Skill

A skill is just a folder with a `SKILL.md`:

```
~/.claude/skills/my-skill/
└── SKILL.md
```

The structure is simple — YAML frontmatter on top, Markdown instructions below:

```yaml
---
name: explain-code
description: Explain code with analogies and diagrams
---

When explaining code, follow these steps:

1. **Start with an analogy**: Compare the code to something from everyday life
2. **Draw a diagram**: Use ASCII art to show the flow or structure
3. **Walk through step-by-step**: Explain what happens at each stage
4. **Highlight a gotcha**: What's a common mistake or misconception?
```

Then use it:

```
/explain-code src/auth/login.ts
```

That's it. No other configuration needed.

---

## Where Do Skills Live?

Where you store a skill determines its scope:

*(Insert image: table-scope.png)*
![table-scope](../2026-04-17_claude-code-skills/table-scope.png)
<!--
| Level | Path | Scope |
|---|---|---|
| Personal | `~/.claude/skills/<skill-name>/SKILL.md` | All your projects |
| Project | `.claude/skills/<skill-name>/SKILL.md` | This project only |
| Enterprise | Managed settings | All users in your org |
-->

**Personal Skills** are for your own habits — things like code cleanup or file conversion that you use across every project.

**Project Skills** are for project-specific workflows. Commit them to the repo, and your teammates can use them too.

---

## Built-in Skills: Ready Out of the Box

Claude Code ships with several Bundled Skills — no installation needed, available in every session:

*(Insert image: table-bundled.png)*
![table-bundled](../2026-04-17_claude-code-skills/table-bundled.png)
<!--
| Skill | Purpose |
|---|---|
| `/batch <instruction>` | Large-scale parallel changes — decomposes work, spawns one agent per unit in a git worktree, each opens a PR |
| `/claude-api` | Loads Claude API reference; auto-triggers when writing Anthropic SDK code |
| `/debug [description]` | Enables debug logging and analyzes the current session |
| `/loop [interval] <prompt>` | Runs a prompt on a recurring interval — great for monitoring deploys or polling PRs |
| `/simplify [focus]` | Spawns three parallel review agents to check recent changes for reuse, quality, and efficiency issues |
-->

These Bundled Skills differ from regular skills in that they're **prompt-based** — not fixed logic, but a playbook that lets Claude orchestrate work on its own, including spawning parallel agents, reading files, and adapting to your codebase.

---

## Official Plugin Marketplace: One-Click Extensions

Beyond built-in skills, Claude Code has an official **Plugin Marketplace** — browse it at [claude.com/plugins](https://claude.com/plugins), or open it directly inside Claude Code with the `/plugin` command.

Installation is straightforward:

```
/plugin install github@claude-plugins-official
```

Current plugin categories include:

**Code Intelligence**
— Gives Claude real-time type checking, jump-to-definition, and find-references via LSP (Language Server Protocol). Supports TypeScript, Python, Swift, Go, Rust, Java, and more.

**External Integrations**
— GitHub, GitLab, Slack, Jira/Confluence, Figma, Notion, Sentry, Vercel, Supabase, and more — letting Claude interact directly with these services.

**Development Workflows**
— `commit-commands` (Git commit flows), `pr-review-toolkit` (PR Review), and more — common dev workflows packaged as ready-to-use commands.

The difference between Plugins and Skills: **a Plugin is a complete extension package** that can contain Skills, Agents, Hooks, MCP Servers, and even LSP Servers. If a Skill is a screwdriver, a Plugin is the entire toolbox.

Teams can also set up their own Marketplace for centralized plugin management:

```
/plugin marketplace add your-org/claude-plugins
```

Once added, team members can install shared tools with one click — no manual setup per person.

*(Insert image: plugin-marketplace.png)*
![plugin-marketplace](../2026-04-17_claude-code-skills/plugin-marketplace.png)
<!--
Gemini prompt: A cute Ghibli-inspired soft pastel illustration of a magical marketplace storefront. The shop sign reads "Plugin Marketplace". Shelves display colorful plugin boxes with labels like "GitHub", "TypeScript", "Slack". A chibi engineer character browses the shelves with a shopping basket. Some plugin boxes glow softly. Soft pastel colors (mint, peach, lavender, sky blue), white background, clean and simple. 16:9 ratio.
-->

**But every team and individual has unique workflows. Off-the-shelf Plugins and Skills won't always fit your needs.** That's where custom Skills come in.

---

## Real-World Examples: Three Skills I Actually Use

Concepts are abstract. Let's look at Skills I use every day.

### Example 1: clean-legacy — Remove Commented-Out Code

Anyone who's inherited a legacy codebase knows the pain — commented-out code everywhere. It's ugly, but you're afraid to delete it in case something is still needed.

This Skill handles exactly that:

```yaml
---
name: clean-legacy
description: Clean legacy code - remove commented-out code (not regular comments) and compress excess blank lines
argument-hint: [file-path or directory]
user-invocable: true
---

# Clean Legacy Code

When asked to clean code, perform these tasks:

## 1. Remove commented-out code (keep regular comments)

Criteria — the following patterns indicate "commented-out code" and should be deleted:
- `// let oldValue = 123` → Delete (pure code)
- `// This is an explanatory comment` → Keep (description)
- `// MARK:`, `// TODO:` → Keep (markers)
- File header copyright info → Keep

## 2. Compress excess blank lines
Reduce 2+ consecutive blank lines to 1
```

Usage:

```
/clean-legacy Sources/MyClass.swift
/clean-legacy Sources/              # entire directory works too
```

**The key is the judgment logic:** it doesn't delete all comments. It distinguishes "commented-out code" from "real explanatory comments." Descriptive comments are preserved, `// MARK:` and `// TODO:` stay, and only code-like comments get removed.

### Example 2: clean-check — Verify Cleanup Results

Worried about accidental deletions? Run a verification:

```yaml
---
name: clean-check
description: Verify clean-legacy results - confirm git diff only contains deleted comments and blank lines
argument-hint: [file-path (optional)]
user-invocable: true
---

# Verify Cleanup Results

Use after running clean-legacy. Check git diff to confirm:
- Only deletions (no code additions)
- Deleted lines are all comments or blank lines
- No actual code was accidentally removed
```

It analyzes the git diff, classifying each deleted line as "safe" or "suspicious," and flags anything that needs your attention:

```
✅ Check passed

📊 Change summary:
  - Deleted comments: 23 lines
  - Deleted blanks: 15 lines
  - Total: 38 safe deletions

Conclusion: All deletions are comments or blanks. No code functionality affected.
```

**These two Skills work as a complete workflow**: clean first, verify second. Much safer than manually deleting code.

### Example 3: convert-docx — Markdown to Word

I often need to deliver Word documents, but I prefer writing in Markdown and converting to `.docx` at the end.

The problem is that pandoc's output has missing table borders — every time, I'd have to fix them manually. So I packaged the entire flow into a Skill:

```yaml
---
name: convert-docx
description: Convert Markdown to Word (.docx) with automatic table border and column width fixes
argument-hint: <md-file-path>
user-invocable: true
---

# Markdown to Word (with table border fixes)

1. Run pandoc conversion
2. Run fix_tables.py to fix table borders and column widths
3. Open the generated .docx file
```

Usage:

```
/convert-docx project-spec.md
```

One command — no remembering pandoc flags, no manual Python post-processing.

**Building on the official skill**

Claude Code has a built-in `docx` skill that also uses pandoc under the hood — it works well for most cases. However, pandoc's Word output is missing `<w:tblBorders>` definitions at the XML level, so tables appear without borders and column widths are fixed.

For deliverable documents, this detail matters. Testing with the same document:

*(Insert image: table-docx-compare.png)*
![table-docx-compare](../2026-04-17_claude-code-skills/table-docx-compare.png)
<!--
| Item | `/convert-docx` | Official `docx` skill (pandoc) |
|------|:---------------:|:-------------------------:|
| Table borders | ✅ Complete | ❌ No borders |
| Column width | ✅ Auto-fit | ❌ Fixed width |
| Image embedding | ✅ Normal | ✅ Normal |
| Steps required | 1 step | 1 step (but needs manual border fix) |
-->

The custom Skill adds a `fix_tables.py` post-processing script that uses `python-docx` to inject borders into every table and switch column widths to autofit. Convert and deliver in one step.

**This is the value of custom Skills: enhancing official tools to fit your specific needs.**

*(Insert image: skills-workflow.png)*
![skills-workflow](../2026-04-17_claude-code-skills/skills-workflow.png)
<!--
Gemini prompt: A cute Ghibli-inspired soft pastel illustration showing a workflow. Three kawaii tool icons in a row connected by arrows: (1) a broom icon labeled "clean-legacy" sweeping code, (2) a magnifying glass with checkmark labeled "clean-check" inspecting, (3) a document icon with Word logo labeled "convert-docx" transforming. A small chibi engineer character watches happily. Soft pastel colors, white background, clean layout. 16:9 ratio.
-->

---

## Frontmatter Reference

The YAML at the top of `SKILL.md` controls skill behavior. Here are the commonly used fields:

*(Insert image: table-frontmatter.png)*
![table-frontmatter](../2026-04-17_claude-code-skills/table-frontmatter.png)
<!--
| Field | Description | Default |
|---|---|---|
| `name` | Skill name — what you type after `/` | Directory name |
| `description` | Describes purpose; Claude uses this to decide whether to auto-load | None |
| `argument-hint` | Hint shown during autocomplete | None |
| `disable-model-invocation` | Set `true` to allow manual invocation only; Claude won't auto-trigger | `false` |
| `user-invocable` | Set `false` to hide from `/` menu; only Claude can invoke | `true` |
| `allowed-tools` | Restrict which tools the Skill can use | All |
| `model` | Specify model to use (e.g., Haiku) to save tokens | Inherits session |
| `effort` | Reasoning effort: `low`, `medium`, `high`, `max` | Inherits session |
| `context` | Set `fork` to run in an isolated subagent | None |
-->

---

## Who Can Trigger? Two Key Settings

This is easy to confuse, so here's a table to clarify:

*(Insert image: table-invocation.png)*
![table-invocation](../2026-04-17_claude-code-skills/table-invocation.png)
<!--
| Setting | You can invoke | Claude auto-invokes | Best for |
|---|---|---|---|
| Default (nothing set) | Yes | Yes | General-purpose Skills |
| `disable-model-invocation: true` | Yes | No | Deploy, notifications, or any side-effect operations |
| `user-invocable: false` | No | Yes | Background knowledge, e.g., legacy system architecture |
-->

**Reminder:** For operations with side effects like deploy, always add `disable-model-invocation: true`. You don't want Claude deciding "the code looks ready" and running a deploy on its own.

---

## Skills with Arguments

Skills can accept arguments via the `$ARGUMENTS` placeholder:

```yaml
---
name: fix-issue
description: Fix a GitHub issue
disable-model-invocation: true
---

Fix GitHub issue $ARGUMENTS following our coding standards.

1. Read the issue description
2. Understand the requirements
3. Implement the fix
4. Write tests
5. Create a commit
```

```
/fix-issue 123
```

Claude replaces `$ARGUMENTS` with `123`.

For multiple arguments, use `$0`, `$1`, `$2` to access individual values:

```yaml
---
name: migrate-component
description: Migrate a component from one framework to another
---

Migrate the $0 component from $1 to $2. Preserve all existing behavior and tests.
```

```
/migrate-component SearchBar React Vue
```

---

## Advanced: Inject Dynamic Context

Skills support the `` !`command` `` syntax — shell commands that run before the skill content is sent to Claude, with the output injected in place:

```yaml
---
name: pr-summary
description: Summarize PR changes
context: fork
---

## PR Info
- PR diff: !`gh pr diff`
- Changed files: !`gh pr diff --name-only`

Based on the above, produce a PR summary.
```

The `` !`gh pr diff` `` runs first, and the actual diff output replaces the placeholder. Claude sees the real data, not the command itself.

---

## Advanced: Skills with Supporting Files

Skills aren't limited to `SKILL.md` — they can include an entire directory:

```
my-skill/
├── SKILL.md           # Main instructions (required)
├── template.md        # Template file
├── examples/
│   └── sample.md      # Example output
└── scripts/
    └── validate.sh    # Script Claude can execute
```

For instance, my `convert-docx` skill includes a `fix_tables.py` script that Claude finds and runs automatically during the conversion workflow.

**Key point:** Reference these files from `SKILL.md` so Claude knows they exist:

```markdown
## Additional Resources

- Complete API docs: see [reference.md](reference.md)
- Usage examples: see [examples.md](examples.md)
```

The official recommendation is to keep `SKILL.md` under 500 lines and move detailed reference material to supporting files.

---

## Compatibility with Legacy Commands

If you've been using `.claude/commands/`, don't worry — **legacy commands are fully compatible.**

- `.claude/commands/deploy.md` and `.claude/skills/deploy/SKILL.md` work the same way
- If both exist with the same name, Skills take precedence
- Skills add frontmatter configuration and supporting files

No rush to migrate, but for new commands, use the Skills format.

---

## Bonus: A Fourth Skill Born While Writing This Article

The table images in this article were actually generated by a Skill.

Halfway through writing, I realized every article involves the same work: Markdown table → HTML → screenshot → PNG. Doing it manually is tedious, and you have to remember the HTML styles and playwright commands each time.

So I packaged it into `/gen-table-image`:

```yaml
---
name: gen-table-image
description: Extract tables from HTML comments in Markdown articles and convert to PNG images
argument-hint: <md-file-path> [table-name]
disable-model-invocation: true
---
```

Usage:

```
/gen-table-image index.md                    # generate all table images in the article
/gen-table-image index.md table-comparison   # regenerate just one
```

It scans the `.md` file, finds `![table-xxx](table-xxx.png)` paired with Markdown tables inside HTML comments, converts them to styled HTML, and screenshots with playwright. Concept images (those with Gemini prompts) are automatically skipped.

All 6 table images in this article were produced with a single command.

**Skills are born naturally — not through deliberate planning, but by packaging something up the second time you catch yourself repeating it.**

---

## Tips for Writing Good Skills

Here are some lessons learned from practical use:

1. **Write a good description** — Claude relies on the description to decide when to auto-load. Include keywords users would naturally say
2. **Add `disable-model-invocation` for side effects** — Deploy, notifications, production changes — manual trigger only for safety
3. **Use arguments** — Make Skills flexible; one Skill can handle multiple scenarios
4. **Combine Skills** — Like clean-legacy + clean-check, multiple Skills form a complete workflow
5. **Personal vs. project** — Personal habits go in `~/.claude/skills/`; team workflows go in the project's `.claude/skills/` and get committed to the repo
6. **Use the right model to save tokens** — Not every Skill needs the most powerful model. For pattern-matching tasks like code cleanup or format conversion, add `model: haiku` in the frontmatter. Same results, much lower token cost

---

## Conclusion

CLAUDE.md solved "AI doesn't know my project conventions." Skills take it further, solving "AI doesn't know my workflow."

Three key takeaways:

- **CLAUDE.md is rules, Skills are abilities** — The former is always active; the latter activates on demand
- **Skill = one SKILL.md + optional supporting files** — Simple structure, easy to get started
- **Controlling who triggers matters** — Operations with side effects must be set to manual-only invocation

In one sentence: **Skills turn your repetitive workflows into one-line commands.**

If you're already using Claude Code, start with the task you repeat most often and package it into your first Skill. Once you start, you'll see automation opportunities everywhere.

Thanks for reading. If you're using Claude Code too, feel free to share what Skills you've built in the comments.
