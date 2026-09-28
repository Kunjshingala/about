# CLAUDE.md

Guidance for Claude Code when working in this repository.

## What this is

A single-page professional portfolio / resume site for Kunj Shingala, built with
**Flutter Web** and deployed to GitHub Pages at
<https://kunjshingala.github.io/about/>.

The pubspec package name is `about` (not `portfolio`), so every internal import
is `package:about/...`. The `/about/` base href in CI matches that.

## Commands

The Flutter SDK is pinned to **3.38.9** in `.fvmrc`. The global SDK currently
matches, so bare `flutter` works, but prefer `fvm flutter` so a global SDK
upgrade cannot silently change behavior.

```bash
fvm flutter pub get                    # install deps
fvm flutter run -d chrome              # local dev
fvm flutter test                       # all tests
fvm flutter test test/core/responsive_test.dart   # one file
fvm flutter analyze                    # full analyzer pass
dart analyze lib/path/to/file.dart     # fast single-file check
dart format lib/                       # format
fvm flutter build web --release --base-href /about/   # what CI builds
```

`fvm flutter analyze` must be clean before committing. The lint config is
strict (see below), so "it compiles" is not the bar.

## Architecture

Three layers under `lib/`, no cross-layer shortcuts:

```
lib/
  core/            # no Flutter widgets except theme/enums; pure data + helpers
    constants/     # all copy, URLs, feature flags, static data
    models/        # Project, Experience, Stat  (plain classes + fromJson)
    enums/         # Section  (drives navbar + scroll targets)
    navigation/    # app_router.dart — GoRouter
    services/      # github_service.dart — the only network call in the app
    theme/         # app_colors.dart (ThemeExtension), app_theme.dart
    dimensions.dart, responsive.dart
  presentation/
    blocs/         # flutter_bloc: ResumeBloc, ProjectsBloc, ThemeCubit, HoverCubit
    screens/       # ResumeScreen (/), AllProjectsScreen (/projects)
    widgets/       # one file per page section + shared widgets
```

**Content lives in `lib/core/constants/`, never in widgets.** Bio text, job
title, social URLs, stats, experience entries, and the resume links are all in
`info.dart`, `stats.dart`, `experience.dart`, `education.dart`, `projects.dart`.
Editing copy means editing a constant, not a `Text` widget.

**Feature flags are constants too.** `AppInfo.showTestimonials`,
`AppInfo.showContact`, `AppInfo.showTwitter`, and
`ProjectConstants.isGitHubDynamic` gate whole sections. `ResumeScreen._getSections()`
builds its list with `if (flag)` collection elements, so flipping a flag changes
the section list and therefore the scroll indices. Nothing hardcodes an index.

### Page composition

`ResumeScreen` is the whole homepage. It uses `ScrollablePositionedList` (not a
plain `ListView`) because the navbar needs to scroll to a section by index and
read back which section is active:

- `_getSections()` returns `List<MapEntry<Section?, Widget>>`. A `null` key means
  the item is not a nav target (the footer).
- `_onScroll` derives two things from `ItemPositionsListener`: whether to show
  the navbar logo (item 0 scrolled past), and the active section (the item whose
  leading edge is closest to the top within the 0.4 / 0.1 window).
- Both are pushed into `ResumeBloc`, and `GlassNavbar` rebuilds from it with a
  `buildWhen` guard so scrolling does not rebuild the whole tree.
- Every section is wrapped in `RepaintBoundary`. That is deliberate; web
  scrolling stutters without it.

When adding a section: add the enum case to `Section`, add the `MapEntry` to
`_getSections()`, and build the widget in `presentation/widgets/`. Do not add
scroll logic anywhere else.

### Theming

Colors come from a `ThemeExtension<AppColors>`, accessed via the
`context.colors` extension in `app_colors.dart`:

```dart
color: context.colors.textSecondary   // yes
color: Colors.grey                    // no
color: const Color(0xFF555555)        // no
```

Light and dark are both defined in `AppColors.light` / `AppColors.dark`, and
`ThemeCubit` switches `themeMode`. Any new color must be added as a field on
`AppColors` (constructor, `copyWith`, `lerp`, and both palettes) so dark mode and
theme animation keep working. Hardcoded colors break both.

Spacing and radii come from `Dimensions`. Fluid type uses
`Dimensions.getResponsiveSize(width, factor:, min:, max:)`, which clamps
`width * factor` into a range. Breakpoints come from `Responsive`: mobile
`< 600`, tablet `600–1023`, desktop `>= 1024`. `Dimensions.maxWidth` (1100) caps
the content column.

### State management

`flutter_bloc`, four objects, all provided in `main.dart`:

| Object | Kind | Holds |
|---|---|---|
| `ResumeBloc` | Bloc | `activeSection`, `showLogo` |
| `ProjectsBloc` | Bloc | GitHub project fetch state |
| `ThemeCubit` | Cubit | `ThemeMode` |
| `HoverCubit` | Cubit | a single `bool`, one instance per hoverable widget |

`HoverCubit` is per-widget, scoped by `HoverWrapper`, not global. Hover state
that only one widget cares about can also be a local `StatefulWidget` (the hero
CTA buttons do this); do not reach for a Cubit unless something else needs to
observe it.

### GitHub projects

`GitHubService` fetches *pinned* repos through two third-party hops:
`corsproxy.io` wrapping `github-pinned-repositories.vercel.app`. The comment in
the file explains why (GitHub REST has no pinned-repos endpoint, and the target
API sends no CORS headers). This is the one fragile external dependency in the
app: if projects stop loading, check that proxy chain first, and remember
`ProjectConstants.isGitHubDynamic = false` falls back to
`ProjectConstants.manualProjects`. Repos listed in `excludedRepoNames` are
filtered out by exact name.

`main.dart` delays the initial `FetchProjects()` by 500ms so the first paint is
not competing with the network call.

## Lint rules that bite

`analysis_options.yaml` is strict beyond `flutter_lints`. The ones that
actually come up here:

- `always_use_package_imports` / `avoid_relative_lib_imports` — always
  `package:about/...`, never `../`.
- `sort_constructors_first` — constructor above fields in every class.
- `prefer_const_constructors`, `prefer_const_literals_to_create_immutables`.
- `omit_local_variable_types` — write `final x = ...`, not `final String x = ...`.
- `prefer_final_locals`, `always_declare_return_types`.
- `directives_ordering` — imports sorted.
- `strict-casts`, `strict-inference`, `strict-raw-types` are on, so
  `json.decode` results need explicit casts (`as Map<String, dynamic>`).
- `use_build_context_synchronously` — matters in the `url_launcher` paths.

`todo` is set to `ignore`, so TODO comments do not fail analysis.

## Tests

`fvm flutter test` — 6 files under `test/`, mirroring `lib/`:
models, `Responsive`, three blocs, and one widget test (`MobileDrawer`).
`bloc_test` and `mocktail` are available. Section widgets are mostly untested;
if you change layout logic in one, a widget test is welcome but the existing
suite will not catch you.

## Branches and deploy

- `main` is the deploy branch. Pushing to it triggers
  `.github/workflows/deploy.yml`, which reads the Flutter version from `.fvmrc`,
  builds `--release --base-href /about/`, and publishes to GitHub Pages.
- `dev` is the integration branch. History shows every release landing on `main`
  as a `Merge pull request #N from Kunjshingala/dev`.
- Feature branches (e.g. `revamp`) branch from `dev` and PR into `dev`.

Never push straight to `main` unless the intent is to deploy immediately.

## Conventions

- Commit messages are conventional-ish: `feat:`, `fix:`, `chore:`.
- Section widgets are private-class-per-part, not long `_build...` methods.
  `stats_section.dart` and `hero_section.dart` show the pattern: a public
  `StatelessWidget` that picks a mobile or desktop variant, then small private
  widgets underneath.
- Animations use `flutter_animate`'s extension syntax
  (`.animate().fadeIn(...).slideY(...)`) with staggered `delay: (index * 100).ms`.
- Fonts are `GoogleFonts.inter(...)` throughout.

## Skill routing

When the user's request matches an available skill, invoke it via the Skill tool. When in doubt, invoke the skill.

Key routing rules:
- Product ideas/brainstorming → invoke /office-hours
- Strategy/scope → invoke /plan-ceo-review
- Architecture → invoke /plan-eng-review
- Design system/plan review → invoke /design-consultation or /plan-design-review
- Full review pipeline → invoke /autoplan
- Bugs/errors → invoke /investigate
- QA/testing site behavior → invoke /qa or /qa-only
- Code review/diff check → invoke /review
- Visual polish → invoke /design-review
- Ship/deploy/PR → invoke /ship or /land-and-deploy
- Save progress → invoke /context-save
- Resume context → invoke /context-restore
- Author a backlog-ready spec/issue → invoke /spec
