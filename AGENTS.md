# AGENTS.md

This file provides guidance to Agents when working with code in this repository.

## What this is

Pi-Apps is a shell-script-based app store for Raspberry Pi / ARM Linux (Debian/Ubuntu derivatives, plus Nintendo Switch Switchroot and Nvidia Jetson). There is no compiled code — the entire project is bash scripts plus a directory of per-app install/uninstall scripts and metadata. `apps/` contains ~257 app subdirectories, each a self-contained package.

A full narrated reference for every script and every `data`/`etc` file is published at [pi-apps.io](https://pi-apps.io) under Development ("Documentation", "Directory Tree", "Creating an App"); source markdown is in `src/wiki/development/` of [github.com/Pi-Apps-Coders/website](https://github.com/Pi-Apps-Coders/website) (a separate repo — check if it's cloned as a sibling directory before assuming it's available locally). Consult it for anything not covered below — it documents essentially every `api` function and every runtime file's exact meaning.

## Validating changes

There is no build step and no automated test suite in the traditional sense. Validation is:

- **Shellcheck** — CI (`.github/workflows/shellcheck.yml`) runs `shellcheck` against the core scripts and every app's install/install-32/install-64/uninstall script. Run it locally before committing:
  ```bash
  shellcheck api createapp gui install manage preload settings uninstall updater
  shellcheck "apps/<App Name>/install" "apps/<App Name>/uninstall"
  ```
  Only shellcheck errors (not warnings/info) fail CI — see the `sed` filter in that workflow for the exact severity cutoff.
- **Live install/uninstall test** — `.github/workflows/test_build.yml` is a manually-dispatched workflow that boots a real OS image (PiOS Bullseye/Bookworm/Trixie, Ubuntu Noble, or Switchroot L4T) in a chroot runner and does `./manage install "<App>"` then `./manage uninstall "<App>"`. There's no local equivalent unless you actually have ARM hardware or a matching chroot — when changing an app script, reason carefully about correctness since you generally can't execute it in this dev environment (x86, non-Debian, or non-ARM).
- File permissions matter: install/install-32/install-64/uninstall scripts must be mode 775 (enforced/auto-fixed by `.github/workflows/check_PR.yml`).

## Architecture

### Top-level scripts (all bash, run from repo root, expect `DIRECTORY` = repo root)

- **`api`** — the shared function library (~4200 lines). Almost everything sources this (`source "${DIRECTORY}/api"`). Every function has a one-line `#comment` describing its purpose right after the `{`; grep those to find what's available before writing a new helper. Key groups: package management (`install_packages`, `purge_packages`, `package_installed`, `apt_lock_wait`, `add_external_repo`), app introspection (`app_status`, `app_type`, `list_apps`, `script_name`, `will_reinstall`), repo/PPA helpers (`ubuntu_ppa_installer`, `debian_ppa_installer`, `repo_add`/`repo_refresh`), UI helpers wrapping `yad` (`userinput_func`, `multi_install_gui`), system detection (`is_supported_system`, `get_model`, `get_codename`), and generic wrappers around `wget`/`chmod`/`unzip`/`nproc` that add status output.
- **`manage`** — CLI/engine that actually performs install/uninstall/update/refresh for one or more apps (`./manage install "App Name"`). This is what CI's test workflow drives directly. Modes: `install`, `uninstall`, `install-if-not-installed` (for one app depending on another, e.g. Wine depending on Box86), `multi-install`/`multi-uninstall` (newline-separated app lists), `check-all` (diff local `apps/` against the freshly pulled `update/pi-apps/apps/` to list updatable apps), `update`/`update-all`.
- **`gui`** — the yad-based graphical app store front end (main window, categories, search, app details).
- **`preload`** — generates the yad-formatted app list shown in the GUI, with its own change-detection/caching (`mktimestamps`) so it doesn't regenerate needlessly.
- **`updater`** — checks the `update/pi-apps` clone (a git checkout of upstream master under `update/pi-apps/`) against the local copy to find app/script updates, both GUI (`updater gui`) and CLI (`updater cli`) modes.
- **`createapp`** — wizard for scaffolding a new app directory interactively (yad dialogs).
- **`settings`** — reads/writes `data/settings/<Setting Name>` files based on definitions in `etc/setting-params/`.
- **`install` / `uninstall`** — bootstrap scripts for installing/removing Pi-Apps itself on a system (apt dependency install, `~/pi-apps` setup), not for individual apps.
- **`etc/`** — supporting data/scripts, kept up to date by updates (unlike `data/`): `categories` (the global, canonical app→category mapping — see below), `setting-params/` (one file per setting: first uncommented line is the default, subsequent lines are other allowed values, `#`-prefixed line is the tooltip), `runonce-entries` (one-time migrations executed via the `runonce()` api function, hash-tracked in `data/runonce_hashes` so each entry runs at most once per user), `categoryedit` (CLI to move an app to a category, writes to `data/category-overrides`), `import-app`, `terminal-run` (runs a newline-separated command list in a new terminal window across all supported terminal emulators, blocking until the terminal closes — used instead of hand-rolling terminal detection), `preload-daemon`, `genapplist-yad(.c)` (a small C helper `preload` auto-compiles for speed, falling back to bash if compilation fails).
- **`data/`** — user-local runtime state that updates must never touch: `data/status/<App>` (`installed`/`uninstalled`/`corrupted`/`disabled`), `data/settings/<Name>`, `data/category-overrides` (per-user overrides layered on top of `etc/categories`), `data/update-status`, `data/preload`, `data/runonce_hashes`.

### App directory format (`apps/<App Name>/`)

Two kinds of apps, distinguished by `app_type()` in `api`:

- **Standard app** — has an `install` script, or `install-32`/`install-64`, or both, plus an `uninstall` script. `install` (no suffix) means the same script handles both CPU architectures; it can read the `$arch` variable (`"32"` or `"64"`) to branch internally. `install-32`/`install-64` are architecture-specific alternatives to that — if only `install-64` exists, the app is only ever shown/installable on 64-bit systems (and vice versa for `install-32`). Scripts are plain bash sourced with all `api` functions available (`script_name_cpu()`/`script_name()` in `api` determine which script applies). See `apps/template/` for the canonical skeleton and inline guidance.
- **Package app** — has a `packages` file instead of install scripts: one or more existing apt package names (supports `|` as an "any of these" separator, see `pkgapp_packages_required()` in `api`). No install/uninstall scripts needed; Pi-Apps handles it generically as a thin wrapper. Per project convention, package-apps should only be added to *complement* an existing category of script-apps, not stand alone in a new category — Pi-Apps intentionally isn't "a GUI for apt".

Every app also has: `description` (first line = tooltip), `credits`, `website`, `icon-24.png`, `icon-64.png`.

Category membership lives in `etc/categories` (global, kept in sync with upstream) as `App Name|Category[/Subcategory]` lines; per-user overrides layer on top from `data/category-overrides`, written by `etc/categoryedit`. Don't hand-edit category assignment inside an app directory — there's no such file there.

### Writing install/uninstall scripts — required conventions

- **Never call `apt`/`apt-get`/`dpkg` directly.** Use `install_packages pkg1 pkg2 ... || exit 1` in `install`, and `purge_packages || exit 1` in `uninstall`. `install_packages` builds a per-app dummy `.deb` that depends on the requested packages, so `purge_packages` can safely autoremove exactly what this app pulled in — without touching packages the user already had or that another app also depends on. Calling apt directly breaks that accounting.
- Use `error "message"` (from `api`) after `||` to abort with a clear red message on any command that must succeed; skip `error` for genuinely optional/best-effort cleanup commands.
- `uninstall` must undo everything `install` did — *except* it must never delete user-generated data/config (e.g. don't wipe a Minecraft world just because the app is being reinstalled/updated).
- For downloading a git repo, prefer the `git_clone` wrapper over bare `git clone` (removes the destination dir first, suppresses noisy output, surfaces errors clearly). `wget` is itself intercepted by an `api` function that transparently upgrades to `aria2c` when possible — no code changes needed to benefit from it.
- Branch on OS/arch using `api`-provided context (`$__os_id`, `$__os_release`, `$arch`, `get_codename`, `get_model`) rather than re-deriving it; see `apps/PrusaSlicer/install-32` for the idiom.

### Multi-target support

The same codebase targets Raspberry Pi OS (Bullseye/Bookworm/Trixie), Ubuntu (Jammy/Noble) on Pi, Nvidia Jetson, and Nintendo Switch Switchroot L4T. Check existing apps for the idiom before adding new OS/arch-conditional logic.

### Automated app-version updates

`.github/workflows/update_apps.yml` runs per-app updater scripts in `.github/workflows/updates/<App Name>.sh` on a schedule to bump download URLs/versions in that app's install script — when bumping an app version by hand, check whether a corresponding updater script already exists in `.github/workflows/updates/` and should also be kept in sync. These updater scripts have access to helpers not available to normal install scripts (e.g. `get_release owner/repo` to fetch a GitHub repo's latest release tag via `update_github_script.sh`, or `update_debian_repo_script.sh` for apps published to a Debian-style repo); the corresponding app's `install`/`install-32`/`install-64` must define a `version` (or `filepath`/`filepath_32`/`filepath_64`) variable for the updater to substitute into. See `Creating-an-app.md` / `DOCUMENTATION.md` in the website docs for worked examples.
