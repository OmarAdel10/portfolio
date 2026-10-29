# Omar Adel — Portfolio

Personal portfolio of **Omar Adel** — software engineer building cross-platform apps with Flutter and C# .NET, edge-backend services, and practical AI tooling.

This is a single-page, server-rendered **static site built with [Jaspr](https://jaspr.site) (Dart)** and deployed to **Cloudflare Pages**.

[![Build & Deploy to Cloudflare Pages](https://github.com/OmarAdel10/portfolio/actions/workflows/deploy.yml/badge.svg)](https://github.com/OmarAdel10/portfolio/actions/workflows/deploy.yml)

## Contents

- [What this is](#what-this-is)
- [Site sections](#site-sections)
- [Features and interactions](#features-and-interactions)
- [Tech stack](#tech-stack)
- [Architecture](#architecture)
- [Project structure](#project-structure)
- [Theming and design tokens](#theming-and-design-tokens)
- [Content and data](#content-and-data)
- [Local development](#local-development)
- [Verification and quality gates](#verification-and-quality-gates)
- [Build and deployment (CI/CD)](#build-and-deployment-cicd)
- [SEO and metadata](#seo-and-metadata)
- [Known follow-ups](#known-follow-ups)

## What this is

A portfolio website for Omar Adel showcasing cross-platform app development, backend/cloud/payments work, and AI tooling. The page is pre-rendered to plain HTML at build time and hydrated on the client for interactivity (theme toggle, mobile menu, project filters, animations).

All page content lives in Dart source under `lib/`; the build produces a self-contained static bundle in `build/jaspr/` (HTML, CSS, client JS, assets) that can be served from any static host.

## Site sections

Rendered top to bottom by `App.build()` in `lib/app.dart`:

| Section | Anchor | Source file |
| --- | --- | --- |
| Sticky header (nav, theme toggle, mobile drawer) | `#top` | `lib/components/header.dart` |
| Hero (portrait, headline, CTAs) | `#top` | `lib/components/hero.dart` |
| Animated tech ticker (`MarqStrip`) | — | `lib/app.dart` |
| Expertise (three skill cards) | `#expertise` | `lib/components/expertise.dart` |
| Featured Project spotlight | `#projects` | `lib/components/featured_project.dart` |
| My Work (filterable project grid) | `#projects-work` | `lib/components/all_projects.dart` + `project_card.dart` |
| Education & Training | `#experience` | `lib/components/experience.dart` |
| How I Work (working principles) | `#testimonials` | `lib/components/testimonials.dart` |
| Contact card | `#contact` | `lib/components/contact.dart` |
| Footer | — | `lib/components/footer.dart` |

## Features and interactions

- **Light/dark theme** — toggled from the header, persisted in `localStorage` under `portfolio-theme`. An inline head script applies the saved theme before first paint so the page never flashes light-to-dark.
- **Mobile navigation** — below 900px the desktop nav is replaced by a hamburger drawer with the theme toggle available in the header row.
- **Scroll-reveal animations** — elements marked `.reveal` fade/rise in as they enter the viewport; driven by an rAF-throttled scroll/resize handler plus a `MutationObserver` for hydration-time DOM changes. Content is fully visible without JavaScript (reveals only hide when the `js-enabled` class is present).
- **Interactive dot-matrix background** — a fixed canvas of drifting dots that react to the pointer within a 140px radius; dot color follows the current `--ink` token and re-reads it on theme switches. Renders a single static frame on touch devices.
- **Custom cursor** — a snapping dot with an eased trailing ring that grows over links, buttons, and cards. Enabled only for fine pointers (disabled on touch/coarse pointers).
- **Email fallback** — links carrying the `.email-fallback` class try `mailto:` first and, if the tab still has focus after 1.5s (i.e. no mail app opened), open Gmail web compose instead. Applied to the Contact card's email link.
- **Project filtering** — pill buttons filter the project grid by category with a live count and an empty state.
- **Tech ticker** — CSS marquee of technologies (three copies for a seamless `-33.333%` loop) that pauses on hover.
- **Reduced motion** — `prefers-reduced-motion: reduce` disables animations/transitions, keeps the native cursor, and shows all reveal content immediately.

## Tech stack

| Layer | Choice |
| --- | --- |
| Language | Dart (`sdk: ^3.10.0`) |
| Framework | `jaspr: ^0.23.4` with `jaspr: mode: static` (pre-rendered static site) |
| Web interop | `universal_web: ^1.1.1` (DOM / `localStorage` access on the client) |
| Build tooling | `jaspr_cli`, `jaspr_builder`, `build_runner`, `build_web_compilers` (dev dependencies) |
| Lints | `package:lints/recommended.yaml` + the `jaspr_lints` analyzer plugin |
| Hosting | Cloudflare Pages (project `omaradel-portfolio`) via `cloudflare/wrangler-action` |
| CI | GitHub Actions — `.github/workflows/deploy.yml` |

## Architecture

Jaspr renders the same component tree in two environments; `pubspec.yaml` sets static mode so `jaspr build` emits pre-rendered HTML plus the client bundle.

- `lib/main.server.dart` — **server entrypoint**, executed at pre-render time. Builds the whole `Document`:
  - `<head>`: title, description/keywords/author metas, Open Graph and Twitter metas, JSON-LD `Person` markup, canonical link, favicon links, PWA manifest, and the three inline scripts (theme init, motion/reveal + email fallback, background canvas + cursor).
  - `<body>`: the app shell (custom-cursor elements + `App`).
- `lib/main.client.dart` — **client entrypoint**; initializes Jaspr and runs `ClientApp`, which hydrates the `@client`-annotated components.
- `lib/app.dart` — root `App` component, annotated `@client` (pre-rendered on the server, hydrated on the client). Owns the page layout and the `MarqStrip` ticker.
- `lib/main.server.options.dart` / `lib/main.client.options.dart` — **generated files** (`// GENERATED FILE, DO NOT MODIFY`) produced by `jaspr_builder`. They register the client entrypoints and collect every component's `styles` getter into the server build. Regenerate via the Jaspr CLI (or `dart run build_runner build`) after adding or removing components — never edit by hand.
- `lib/constants/theme.dart` — design tokens, light/dark palettes, shared CSS primitives, and personal link constants.
- `lib/data/projects.dart` + `lib/models/project.dart` — the project catalog and its model.
- `lib/components/` — one file per page section, plus the reusable `ProjectCard`.

## Project structure

```text
.
├── lib/
│   ├── main.server.dart          # server entrypoint: pre-render, <head>, SEO
│   ├── main.client.dart          # client entrypoint: hydration
│   ├── main.server.options.dart  # generated — do not edit
│   ├── main.client.options.dart  # generated — do not edit
│   ├── app.dart                  # root App component + MarqStrip ticker
│   ├── components/
│   │   ├── header.dart           # sticky nav, theme toggle, mobile drawer
│   │   ├── hero.dart             # hero: portrait, headline, CTAs
│   │   ├── expertise.dart        # skill cards
│   │   ├── featured_project.dart # featured project spotlight
│   │   ├── all_projects.dart     # filterable project grid
│   │   ├── project_card.dart     # reusable project card
│   │   ├── experience.dart       # education & training
│   │   ├── testimonials.dart     # working principles
│   │   ├── contact.dart          # contact card
│   │   └── footer.dart           # site footer
│   ├── constants/
│   │   └── theme.dart            # design tokens, palettes, personal links
│   ├── data/
│   │   └── projects.dart         # project catalog + filter categories
│   └── models/
│       └── project.dart          # Project model
├── web/                          # static assets copied verbatim into the build
│   ├── favicon.ico               # mascot favicon
│   ├── robots.txt                # crawl rules + sitemap pointer
│   ├── sitemap.xml               # single-URL sitemap
│   ├── site.webmanifest          # PWA manifest (name, colors, icons)
│   └── images/                   # avatar portraits, og-image, favicons, logos/
├── .github/workflows/deploy.yml  # build + Cloudflare Pages deploy
├── analysis_options.yaml         # lints, jaspr_lints plugin, formatter config
├── pubspec.yaml                  # dependencies + jaspr static mode
├── docs/followups.md             # tracked follow-ups (mirrored in Plane)
└── README.md
```

> Template remnants: `lib/components/counter.dart` and `lib/components/featured_projects.dart` are left over from the Jaspr starter and are not mounted in the app.

## Theming and design tokens

`lib/constants/theme.dart` is the single source of truth for the visual system — a warm cream / olive-charcoal palette with IBM Plex Sans and IBM Plex Mono, flat hairline-bordered cards, and a single saturated yellow-orange primary (`#f7a501`).

- **Color system** — every color is a CSS custom property. `lightVars` is applied on `:root`; `darkVars` applies under `html[data-theme="dark"]`. Flipping the `data-theme` attribute retints the entire site.
- **Theme toggle** — the header writes `data-theme` and `localStorage['portfolio-theme']` (via `universal_web`). The inline head script applies the saved value before first paint.
- **Tokens** — spacing scale (`spaceXs` … `spaceSection` = 80px), radii (`radiusXs` … `radiusFull`), breakpoints (480 / 768 / 1024 / 1280), plus shared primitives: `.container`, `.section`, `.section-head`, `.eyebrow`, `.section-title`, `.btn` variants, `.card`, `.tag`, and the filter `.pill`.
- **Fonts** — loaded via a Google Fonts `css.import` inside the theme styles.
- **Motion** — keyframes (`heroRise`, `heroAvatarFloat`, `heroRingPulse`, `mascotWiggle`, `marquee`) live alongside the tokens, with a global reduced-motion override.

## Content and data

### Personal links and contact details

Edit the constants at the top of `lib/constants/theme.dart`:

| Constant | Used for |
| --- | --- |
| `githubUrl`, `linkedinUrl` | Header/footer/contact links |
| `emailAddress`, `mailtoUrl` | Email link + prefilled mailto template (`mailtoUrl` is derived from `emailAddress`) |
| `phoneNumber`, `phoneUrl`, `whatsappUrl` | Contact card (WhatsApp / phone) |

The email fallback script in `lib/main.server.dart` (`EMAIL`, `SUBJ`, `BODY`) carries its own copy of the address/subject/body — keep it in sync when changing contact details.

### Projects

The catalog lives in `lib/data/projects.dart` (`mainProjects` + `additionalProjects`, 11 projects total). To add a project, append a `Project` entry:

| Field | Type | Notes |
| --- | --- | --- |
| `name` | `String` | Card title |
| `description` | `String` | Card copy |
| `language` | `String` | Shown as the top tag; also drives the emoji fallback when no logo is set |
| `category` | `String` | Must match a pill in `projectCategories` to be filterable |
| `stars`, `forks` | `int` | GitHub stats (currently static placeholders) |
| `url` | `String` | "View on GitHub" link |
| `homepage` | `String?` | Optional "Live Demo" link |
| `topics` | `List<String>` | Outline chips (cards show the first five) |
| `isFeatured` | `bool` | The first `true` entry becomes the Featured Project card |
| `logoUrl` | `String?` | Logo path under `/images/logos/...`; `null` falls back to a language emoji |
| `logoUrlLight` / `logoUrlDark` | `String?` | Optional theme-specific logo pair (used by the News App entry) |
| `thumbnailUrl` | `String?` | Reserved; not rendered by current components |

Filter pills come from `projectCategories` — currently `All`, `Mobile`, `AI / Data`, `Tools`. `All` is a UI-only value; `Web` is intentionally omitted until a web project exists.

### Assets

Everything in `web/` is copied into the build output as-is:

- `images/avatar.jpg` — hero portrait; `images/avatar.png` — mascot (contact card + favicons source).
- `images/og-image.jpg` — 1200x630 social card used by Open Graph/Twitter metas.
- `favicon.ico`, `images/favicon-16x16.png`, `images/favicon-32x32.png`, `images/apple-touch-icon.png` — mascot favicons.
- `images/logos/*` — per-project product logos.

### Content placeholders

`lib/components/experience.dart` and `lib/components/testimonials.dart` carry `TODO(owner)` comments: the education entries and working-principle quotes are placeholders that should be replaced with real content/endorsements before going live.

### Changing the domain

The production origin appears in several places and must be updated together:

1. `productionUrl` in `lib/main.server.dart` — feeds canonical, `og:url`, and social image URLs.
2. The `_jsonLd` string in `lib/main.server.dart` — JSON-LD `url`/`image`.
3. `web/robots.txt` — sitemap pointer.
4. `web/sitemap.xml` — the single `<loc>` entry.

## Local development

Prerequisites: **Dart SDK 3.10 or newer** (matching `sdk: ^3.10.0` in `pubspec.yaml`). No Flutter SDK is required — this is a pure Dart/Jaspr project.

```bash
# 1. Resolve dependencies
dart pub get

# 2. Start the dev server (hot restart, served on http://localhost:8080)
dart run jaspr_cli:jaspr serve

# 3. Production build → build/jaspr/
dart run jaspr_cli:jaspr build
```

If you prefer a global CLI, `dart pub global activate jaspr_cli` exposes the same commands as `jaspr serve` / `jaspr build`.

The dev server also regenerates the `main.*.options.dart` files when components change. When adding a section:

1. Create `lib/components/<name>.dart` with a component and its `styles` getter.
2. Mount it inside `App.build()` in `lib/app.dart`.
3. Add any nav/footer anchor links (`header.dart`, `footer.dart`).
4. Re-run `serve`/`build` (or `dart run build_runner build`) so the generated options register the new styles.

## Verification and quality gates

```bash
# Formatting (CI-style check; does not rewrite files)
dart format --output=none --set-exit-if-changed lib

# Static analysis (must exit 0)
dart analyze
```

Notes:

- There is **no test suite yet** — no `test/` directory and no test dependencies (tracked as PORTFOLIO-3).
- A repo-wide `dart format` drift under the current SDK formatter is known and tracked (PORTFOLIO-2); the format gate will fail until that sweep lands.
- `analysis_options.yaml` enables `package:lints/recommended.yaml`, the `jaspr_lints` analyzer plugin (`prefer_html_components`, `sort_children_last`), and a 120-column formatter config.

## Build and deployment (CI/CD)

Deployment is handled by `.github/workflows/deploy.yml` ("Build & Deploy to Cloudflare Pages"):

| Job | Runs on | Does |
| --- | --- | --- |
| `build` | Pushes to `master`, PRs targeting `master`, manual dispatch | `dart pub get`, `dart run jaspr_cli:jaspr build`, uploads `build/jaspr` as an artifact |
| `deploy-production` | Pushes to `master` only | Publishes the artifact to Cloudflare Pages project `omaradel-portfolio`, branch `master` |
| `deploy-preview` | PRs from branches in this repository | Publishes a preview deployment per head branch |

Required repository secrets: `CLOUDFLARE_API_TOKEN` and `CLOUDFLARE_ACCOUNT_ID`.

Branch flow: work lands on feature branches and merges into `development` (integration); `development` is released into `master` via PR, and the `master` push triggers the production deployment. Only `master` deploys.

## SEO and metadata

All head wiring lives in `lib/main.server.dart`:

- Title, description, keywords, author, `theme-color`, Twitter card metas, and a `google-site-verification` token via the `Document` `meta` map.
- Open Graph tags are emitted manually from `head` as `property` metas — the `meta` map renders `name` attributes, which strict OGP consumers reject.
- JSON-LD `Person` structured data (name, job title, email, social profiles).
- Canonical link and favicon/manifest links.
- Static `web/robots.txt` (allow all + sitemap), `web/sitemap.xml`, and `web/site.webmanifest` (standalone display, theme colors, icon set).

## Known follow-ups

Tracked in `docs/followups.md` and mirrored as Plane work items in the `PORTFOLIO` project:

- **PORTFOLIO-2** — repo-wide `dart format` sweep (10/20 `lib/` files drift under the current SDK formatter, keeping the format gate red).
- **PORTFOLIO-3** — test infrastructure gap (no test framework/tests; head emission and mascot rendering have no pinned regression tests).
- **PORTFOLIO-4** — all-branch CI gates (current workflow builds/deploys only on `master` + PRs to `master`; no format/analyze/smoke CI on every branch yet).
