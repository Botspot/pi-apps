# Contributing to Pi-Apps

You don't need to be a programmer to help — see the "Contributing" section of the [README](README.md) for non-code ways to pitch in (starring the repo, filing suggestions/bug reports, or joining [our Discord](https://discord.gg/RXSTvaUvuu), which the dev team uses to coordinate and plan new features). This file covers contributing code: apps and core changes.

## Where to start

- **New app or app update?** [Create and submit an app](https://pi-apps.io/wiki/development/Creating-an-app/) — the wiki page covers the acceptance guidelines (must be a legal, all-ages, everyday-desktop-use GUI app; ARM64+ARM32 support is preferred; package-apps must complement an existing category, not stand alone) as well as how to use the in-app Create App Wizard (Settings → New App) or `./createapp` to scaffold it. `apps/template/` is the same skeleton in file form. Please follow the existing formatting used by other app scripts.
- **Fixing a bug or changing core scripts?** Skim [AGENTS.md](AGENTS.md) for the architecture overview and the conventions install/uninstall scripts must follow (never call `apt`/`dpkg` directly, use `install_packages`/`purge_packages`, etc).
- **Anything else** — full narrated docs for every script, every `api` function, and every `data`/`etc` file live at [pi-apps.io/wiki/development/](https://pi-apps.io/wiki/development/) ("Documentation" and "Directory Tree" pages are the best entry points).

## Validating your change

There's no build step or automated test suite — see "Validating changes" in [AGENTS.md](AGENTS.md#validating-changes) for the full rundown. In short:

1. Run `shellcheck` against anything you touched.
2. If you changed an app's install/uninstall script, run the `test_build.yml` GitHub Actions workflow on your own fork (Actions tab → "Run workflow"). Currently-supported OS images (see [README.md](README.md#supported-systems)) are pre-checked by default, so you can usually just fill in the app name and run it as-is.
3. Make sure install/install-32/install-64/uninstall scripts are executable (mode 775).

## Submitting

Open a pull request against `master`. For new apps, you can also use the ["Submit a new app"](https://github.com/Botspot/pi-apps/issues/new?assignees=&labels=App+Request%2CZip%2FPR+included&template=app-submission.yml) issue template if you'd rather hand it off than open a PR yourself.

Bug reports, general suggestions, and app requests each have their own template on the [issues page](https://github.com/Botspot/pi-apps/issues/new/choose).

## Code of conduct & security

Please follow our [Code of Conduct](CODE_OF_CONDUCT.md). To report a security vulnerability, see [SECURITY.md](SECURITY.md), because in most cases this is not a pi-apps issue.
