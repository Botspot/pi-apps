# Security Policy for Pi-Apps

## Overview

Pi-Apps follows a rolling release model, which means we continuously update our codebase rather than releasing discrete versions with semantic versioning. All users are always encouraged to run the latest version of Pi-Apps.

## Supported Versions

| Version | Support Status |
|---------|---------------|
| Latest (Rolling Release) | ✅ Supported |
| Previous states | ❌ Not Supported |

Unlike semantically versioned software, Pi-Apps does not maintain separate release branches. Things like app updates and general fixes are applied directly to the main codebase and distributed to all users through the built-in updater that runs automatically on boot and silently in the background checks for any new commits and automatically updates the app if there is a new commit.

To learn more about rolling releases, check [here](https://en.wikipedia.org/wiki/Rolling_release).

There is a separate support policy for supported distributions, here is the list below:

| Version | Support Status |
|---------|---------------|
| Debian 12 (official releases only from Debian, not unofficial releases like Armbian)| ✅ Supported |
| Debian 11 (official releases only from Debian, not unofficial releases like Armbian)| ✅ Supported, will be cut off support soon |
| Ubuntu 24.04 LTS | ✅ Supported |
| Ubuntu 22.04 LTS | ✅ Supported |
| Ubuntu 20.04 LTS | ✅ Supported, will be cut off support soon |
| Raspberry Pi OS (based on Debian 12) | ✅ Supported |
| Raspberry Pi OS Legacy (based on Debian 11) | ✅ Supported, will be cut off support soon |
| Other/older distributions | ❌ Not Supported |

You must be running a supported distribution to make a issue about failure to install an app/broken app on Pi-Apps, otherwise your issue will be closed as unsupported.

Typically only the last 2 LTS versions of Debian (or 3 for Ubuntu) are supported on Pi-Apps and assume your system as unsupported once normal LTS support ends for the given version. (this does not count [ELTS](https://wiki.debian.org/LTS/Extended) for Debian, or extended LTS support via [Ubuntu Pro](https://ubuntu.com/pro) for Ubuntu)

## Automatic Updates

Pi-Apps includes a built-in updater that checks for updates:
- Automatically on boot (with notification)
- Manually through the GUI or terminal command: `~/pi-apps/updater gui` or `~/pi-apps/updater cli`

We strongly recommend allowing these automatic updates to ensure you receive app updates and general fixes promptly.

## Vulnerability Reporting

If you discover a security vulnerability in Pi-Apps (this is unlikely to happen in Pi-Apps and more likely to happen in the apps that Pi-Apps installs), don't submit an issue on Pi-Apps, instead submit an issue via the app's maintainers instructions on how to report a vulnerability.

## Best Practices for Users

Pi-Apps cannot guarantee the security of third-party applications. Users should exercise caution when installing applications, even through Pi-Apps.

To maintain the security of your Pi-Apps installation:

1. **Keep Pi-Apps Updated**: Allow automatic updates or run the updater regularly
2. **Report Suspicious Behavior**: If an app behaves suspiciously, report it immediately to the app's maintainers or if it's a install script that is behaving suspiciously, then report it instead to the Pi-Apps maintainers via a issue (or PR if you know how to remove suspicious behavior from a script)
3. **Review Scripts**: You can view the installation scripts for any app before installing it as per the Pi-Apps app install structure.

Thank you for helping keep Pi-Apps secure for everyone! 
