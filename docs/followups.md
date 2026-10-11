# Follow-ups

Out-of-scope findings surfaced during feature work. Each entry has a Plane work item in project PORTFOLIO.

- Repo-wide `dart format` sweep — 10/20 `lib/` files drift under the current SDK formatter (tall style), including 8 untouched by this feature: `lib/components/all_projects.dart`, `lib/components/counter.dart`, `lib/components/experience.dart`, `lib/components/expertise.dart`, `lib/components/featured_project.dart`, `lib/components/featured_projects.dart`, `lib/components/testimonials.dart`, `lib/models/project.dart`. Keeps the FAST/FULL format gate red repo-wide. Surfaced 2026-10-11 during `feat/headshot-social-card`. Plane: PORTFOLIO-2.
