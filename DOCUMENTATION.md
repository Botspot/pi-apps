# Inside Pi-Apps: everything a power-user should know
This guide will attempt to explain how Pi-Apps works. By nature, this cannot be complete, so feel free to look through the scripts yourself and ask the Pi-Apps developers questions.
## Table of contents
- [Introduction](#introduction)
- [The app-folder](#the-app-folder)
- [The main Pi-Apps folder](#the-main-pi-apps-folder)
- [The App Status folder](#the-app-status-folder)
- [The `manage` script](#the-manage-script)
- [The `updater` script](#the-updater-script)
- [The `api` script and available functions](#the-api-script)
- [The `gui` script](#the-gui-script)
- [The `createapp` script](#the-createapp-script)
- [The `settings` script](#the-settings-script)
- [The `preload` script](#the-preload-script)
- [The `preload-daemon` script](#the-preload-daemon-script)
- [The `terminal-run` script](#the-terminal-run-script)
- [The `categoryedit` script](#the-categoryedit-script)
- [The `logviewer` script](#the-logviewer-script)
- [The `viewlog` script](#the-viewlog-script)
- [Automatic app updaters](#automatic-app-updaters)
# How Pi-Apps works
## Introduction
- Pi-Apps is written in **`bash`**. This is a scripting language for Linux, with origins in the 80s. Bash is not a compiled language like C, it's an interpreted language, similar to Python and Windows .bat files.  
  Bash serves a different purpose than a compiled language: orchestrating OS-level events and prioritizing programming-time over execution-time. It is system-dependent and architecture-dependent.  
  You probably interact with `bash` without even realizing it! Nearly all Linux distributions today use a **bash terminal**. *If you have ever opened a terminal, you have interacted with bash.*
- Pi-Apps is comprised of **bash scripts**. These are text files that are filled with bash commands. To illustrate this, you can often *open* a bash script, *copy* the contents, and *paste* it into a bash terminal. And it will work exactly the same as if you executed the file! In fact, if Pi-Apps was reorganized into a single standalone bash script, you could *copy and paste the entire thing* into a terminal and have a working app store!
- If Pi-Apps is only bash scripts, **how does it display a GUI**? (graphical user interface) Good question. When Pi-Apps was just a concept, I knew that bash was the obvious choice for installing apps. And that makes sense: if you normally install an application by running commands in a *bash-terminal*, it only makes sense to use a *bash-script*.  
  Bash was the best choice for installing apps, but what about the GUI? Most GUIs are made in C, C++, Python or JavaScript with GTK, Qt, or Electron. These were workable options, but for long-term maintainability and convenience I wanted to only use **one language for the whole thing**. Someone suggested `zenity` - a simple dialog program meant for bash scripts. I tried it, but was soon frustrated by its limitations. Then I discovered **`yad`** - an improved version of zenity with many more options. Pi-Apps uses `yad` for everything.
## The app-folder
It makes sense to start here. After all, what is an app store without apps?  
Basically, for every app, there is a **folder**. This folder is called an "**app-folder**". On a default pi-apps installation, all app-folders are located in `/home/pi/pi-apps/apps`.  
The folder's name is the app's name. The Arduino app is a folder located at `apps/Arduino`.  
There are a few files in each app-folder:
- `install` - This is a bash script to install the app.
  - Naming the script "install" indicates that it is compatible with 32-bit and 64-bit CPU architectures.
  - All apps have access to the `arch` variable that contains `64` (for arm64) or `32` (for armhf) if per-architecure changes are necessary.
- `install-32` - This is a bash script to install the app on 32-bit operating systems.
  - Naming the script "install-32" indicates that it is designed for the 32-bit CPU architecture only.
  - If no "install-64" script exists, **then this app will only be displayed on 32-bit systems.**
- `install-64` - This is a bash script to install the app on 64-bit operating systems.
  - Naming the script "install-64" indicates that it is designed for the 64-bit CPU architecture only.
  - If no "install-32" script exists, then **this app will only be displayed on 64-bit systems.**
- `uninstall` - This is a bash script to uninstall the app.
- `icon-24.png` and `icon-64.png` - These are the app's icons.
- `description` - This is a text file to explain what the app is, how it works, and why anybody would want it.
  - The first line of this file is used as the **tooltip** (mouse hover-text) in the list of apps.
- `credits` - This is a text file to give credit to the person who made the app.
- `website` - This is a text file containing the website URL of a given project.
  - Usually it points to a website where users can learn more about the app.
## The main Pi-Apps folder
The Pi-Apps folder contains several main subfolders. These folders have special characteristics and are treated differently during updates.
- The `data` folder and `logs` folder contain files that should ***never be updated***. They contains settings, cached files, app-status files, log files, etc.
- The `apps` folder contains apps. During an update it this folder is handled differently too.
- Other folders like `icons` and `etc` are handled the same as individual files in the main pi-apps folder. 
## The App Status folder
Pi-Apps keeps track of each app's status: installed or uninstalled. (as well as a few other possible values)  
Each app's status is located in the `data/status` folder.  
For example, on a default Pi-Apps installation, the status file for **arduino** is located at: `/home/pi/pi-apps/data/status/Arduino`.  
Each file in this folder will contain one of these possible values:
- `installed` - The app is currently installed.
- `uninstalled` - The app is currently uninstalled.
- `corrupted` - The app failed to install/uninstall.
- `disabled` - The app is in a disabled state: it will not be installed under any circumstances. 
  - This status is useful for TwisterOS where Box86 comes pre-installed. We don't want Pi-Apps installing Box86 under any circumstances, even if another app requires it to be installed.

As mentioned earlier, Pi-Apps runs on bash scripts. Each script has a certain job to do, and together they make Pi-Apps work.  
Below is a concise explanation for how each script works:
## The `manage` script
#### Location:
On a default pi-apps installation, you will find this script at `/home/pi/pi-apps/manage`. 
#### Purpose:
The `manage` script will install apps, uninstall apps, and update apps. It can be compared to the `apt` tool on Debian Linux.
#### Usage:
The manage script won't do much if you run it standalone:
```
$ ~/pi-apps/manage
You need to specify an operation, and in most cases, which app to operate on.
```
You need to tell the `manage` script to *do* something.
```
$ ~/pi-apps/manage install Arduino
```
Now we're getting somewhere! You just installed the Arduino app.
The `manage` script supports these **modes**:
- `install`: installs the specified app.
  Several things occur before the app's installation script is run:
  - The specified app must exist.
  - The app must not be disabled. If it is, the `manage` script exits with an exit-code of zero.
  - If your system is unsupported (determined by the `is_supported_system` function in the api script), a warning will appear, along with a 10-second wait-time.
  - The app's installation script is determined. Depending on the app and on your system's CPU architecture, the script-name may be "`install`", "`install-32`", or "`install-64`".
  - Determine a unique filename for the log-file to be generated. (This file will store the entire output of the installation process.)
  - Finally, the app's installation script is executed.
    - It is executed with the `nice` command, to lower the priority of the process so that the rest of the system remains responsive, even while compiling.
    - Its output is redirected to the log-file, *and* to stdout. (usually the terminal)
  - If the app's installation script **succeeded** (if it exited with a return code of `0`):
    - The the log-file is renamed to `install-success-$app`
    - The `manage` script exits with a return code of `0`.
  - However, if the app's installation script failed (any return code except `0`):
    - The the log-file will be renamed to `install-fail-$app`.
    - The `manage` script exits with a return code of `1`.
- `uninstall`: exactly like the `install` mode except that it uninstalls the specified app.
  - These two modes are so similar that they share the same code!
- `install-if-not-installed`: Installs the specified app, only if it has not already been installed.
  - This mode is especially useful for apps that **need another app to be installed first**.
  For example, the **`Wine (x86)`** app requires Box86. It accomplishes that with this command:
  ```bash
  "${DIRECTORY}/manage" install-if-not-installed Box86 || error "Box86 failed to install somehow!"
  ```
- `multi-install`: installs multiple apps, one at a time. How to specify multiple apps? By using a ***multi-line argument***, like this:
  ```bash
  $ ~/pi-apps/manage multi-install "Arduino
  BalenaEtcher
  CloudBuddy
  Downgrade Chromium"
  ```
  Note about `multi-install`: This mode includes 
  elements.
  - Before installing anything, `manage` will check if any apps are **already installed**. If so, a `yad` dialog will appear and ask if you *really* want to install that app again.
      - If you choose "No", the app is removed from the list of apps to install.
  - Then, each app will be installed, one at a time.
      - It does this by running the manage script in the `install` mode, once for each app
  - If any apps fail to install, a `yad` dialog will appear and ask permission to send the error log to Pi-Apps developers.
- `multi-uninstall`: exactly like `multi-install` except that it uninstalls the list of apps.
  - These two modes are so similar that they share the same code!
- `check-all`: This mode is the Pi-Apps equivalent to an `apt update`. It lists updatable apps.
  - It downloads the latest pi-apps repository to the `update/pi-apps` folder. (using `git clone` or `git pull`, as appropriate) Now, there are two versions of Pi-Apps on the local filesystem: the "**local version**" and the "**latest version**".
  - Each app-folder is compared.
      - If the app-folder ***only*** exists in the local version, then no action is taken.
      - If the app-folder ***only*** exists in the online version, then it must be a new app and is added to the list of updatable apps.
      - If the app-folder exists in both locations and the **contents do match**, then no action is taken.
      - If the app-folder exists in both locations but the **contents don't match**, the online version must have received an update. As a result, the app is added to the list of updatable apps.
  - Finally, the list of updatable apps (one app per line) is written to standard output and the script exits.
- `update`: This mode will update a single app. (like an `apt upgrade`)
  It copies the new version from the update folder to the main folder, reinstalling if necessary.
  - First, the app may need to be installed, or it may not:
      - If the app is currently installed, *and* its current installation script does not match the online version, then the app is uninstalled.
  - Then the current (old) app-folder is sent to the system's **Trash** folder.
      - This is a failsafe: just in case you made changes to the app-folder, you have an option to restore those changes. (as opposed to permanent deletion)
  - The app-folder is copied from the `update/pi-apps/apps` folder to the main `apps` folder.
  - If the app was uninstalled earlier, it will now be installed back.
- `update-all`: This mode will check for app-updates and install them without any user-interaction.
  The `manage` script will run itself in the `check-all` mode, then, for every app that `check-all` mentioned, it will `update` each app.

## The `updater` script
#### Location:
On a default pi-apps installation, you will find this script at `/home/pi/pi-apps/updater`. 
#### Purpose:
This script handles Pi-Apps updates, both for apps and for files. Apps do not have version numbers, so updating involves comparing the installation-script of the existing app-folder with the installation-script of the new app-folder.
#### Usage:
```bash
~/pi-apps/updater gui
```
This will check for updatable apps and files, then will display them in a graphical list, (using `yad` of course), and will give you the option to update certain items and not others.  
But that's not all you can do with this script. The `updater` script supports multiple **modes**, useful for a variety of situations:
- `gui` - Check for updates and list them graphically.
  - This is the **default mode** if you did not specify one.
  - If you choose to update anything, a **terminal** will appear to update apps.
- `gui-yes` - Exactly the same as the `gui` mode, except that the updates are automatically applied in a terminal.
- `autostarted` or `onboot` - This mode is intended to be **run on boot**.
  - First, determine if the **update-interval** setting allows an update-check today.
    - If not, the script exits.
  - Then, make sure that **at least one app has been installed**.
    - This is accomplished by checking if there are any files in the `data/status` folder.
    A fresh installation of Pi-Apps will not have any files in that folder, because no apps have been installed yet.
    - If there are no files in that folder, the script will exit.
  - After that, assuming there are updates available, display a **notification** in the lower-right corner of the screen.
    - This notification is designed to not interfere with **typing**.
  - If you click **Details**, you will see the graphical list of updates, just like with the `gui` mode.
  - Once updates are complete, another notification will appear to say "Pi-Apps updates complete."
- `cli` - This mode is intended to be run in a **terminal**. It checks for updates, lists the updates, and prompts for a Y/N answer.
- `cli-yes` - Check for updates, then **automatically apply** them all.
- `set-status` - **Check for updates** and then exit.
  - The list of updatable **apps** is written to `"${DIRECTORY}/data/update-status/updatable-apps"`, with the DIRECTORY variable being the location of your Pi-Apps folder. (default: `/home/pi/pi-apps`)
  - The list of updatable **files** is written to `"${DIRECTORY}/data/update-status/updatable-files"`.
  - The script will exit with code `0` if updates are available, otherwise `1`.
- `get-status` - Check if an **update *was* available** the last time `set-status` was run.
  - This is based on the **length** of the `updatable-files` and `updatable-apps` files.
  - Doing it this way allows for an **instant** update-check - necessary for a gui to run quickly. Nobody wants to wait for an update-check to finish before Pi-Apps will launch.
  - The script will exit with code `0` if updates are available, otherwise `1`.

Updater also supports a **fast mode**. This is necessary for the Pi-Apps GUI, where you don't want to wait a few seconds after clicking the "Updates" category. Using the fast mode will rely on the previous update-check. It won't check for updates, it will simply display them.  
To use the fast mode:
```bash
~/pi-apps/updater gui fast
```
## The `api` script
#### Location:
On a default pi-apps installation, you will find this script at `/home/pi/pi-apps/api`. 
#### Purpose:
This script is a collection of **functions** that do various things. Functions are small chunks of bash-code that can be run like a normal command.
#### Usage:
```bash
source ~/pi-apps/api
```
You can now run any of the functions inside the api script as if they were real commands.  
Alternatively, the `api` script supports running a single function *without* being sourced:
```bash
~/pi-apps/api apt_lock_wait
```
#### List of functions:
Note: new functions are added often. If you don't see a function on this list but do see it in the api, please let us know.
- `error` - display a custom message in red and exit with a return code of `1`.
  Usage:
  ```
  error "The command 'sudo apt update' failed!"
  ```
  This is often seen at the end of a command with the `||` operator:
  ```
  sudo apt update || error "The command 'sudo apt update' failed!"
  ```
- `warning` - Display a custom message in yellow and prefix it with "WARNING: ".
  - Useful for everything where something is wrong but it's not a fatal error.
  - This function outputs to `stderr`.
- `status` - Display a custom message in light-blue.
  - Used by scripts to indicate current status, like "Downloading...", "Extracting...", and "Please wait."
  - This function outputs to `stderr`.
  - Some scripts don't want the ending newline, so this function allows for flags to be passed to the `echo` command. 
  - Example usage:
    ```bash
    status -n "Downloading... "
    ```
- `status_green` - Display a custom message in green.
  - Used by scripts to indicate the success of an action, like "Installed FreeCAD successfully", "Update complete", and "All packages have been purged successfully."
  - This function outputs to `stderr`.
- `generate_logo` - Displays the Pi-Apps logo in a terminal.
  - Note: Some keen users may notice that the logo looks different on Debian ***Bullseye*** than on older releases. This is necessary to avoid trying to display missing characters. See: https://github.com/Botspot/pi-apps/issues/1441
- `add_english` - Ensures an English locale is installed so that log-diagnosing tools can function properly.
  - This was added in [PR #1031](https://github.com/Botspot/pi-apps/pull/1031)

Apt/dpkg/package functions below.

- `package_info` - List everything `dpkg` knows about the specified package.
  - This retrieves a block of text from the `/var/lib/dpkg/status` file.
  - This only works if the package is currently installed.
- `package_installed` - determine if the specified package is installed.
  - Returns an exit code of `0` if the package is installed, otherwise it returns `1`.
- `package_available` - determine if the specified package is able to be installed with `apt`.
  - This uses `grep` to search the `/var/lib/apt/lists/` folder.
  - Returns an exit code of `0` if the package was found, otherwise it returns `1`.
- `package_dependencies` - List the dependencies of a package
  - This simply isolates a line from the output of the `package_info` function.
  - This is *much* faster than doing an `apt-cache search`.
  - This only works if the package is currently installed.
- `package_latest_version` - Return the latest available version of the specified package.
  - This function is useful for apps that depend on a recent version of a package.
- `package_is_new_enough` - Given a package and a version threshold, determine if the package-version is greater than the threshold.
  - This function is an extension of the `package_latest_version` function above, to simplify scripting.
  - If the package has a higher version than the threshold value, the return coide is `0`, otherwise it returns `1`.
  - Example usage, from the Mission Planner app:
    ```bash
    status -n "Is the mono-complete package new enough? "
    
    if package_is_new_enough mono-complete 6.8.0 ;then
      status_green 'Yes' #answer the question asked above
    else
      status_green 'No' #answer the question asked above
      echo "Adding Mono repository..."
      install_packages apt-transport-https dirmngr gnupg ca-certificates || exit 1
      sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF || error "Failed to add a key to the repos!"
      echo "deb https://download.mono-project.com/repo/debian stable-raspbianbuster main" | sudo tee /etc/apt/sources.list.d/mono-official-stable.list
    fi
    install_packages mono-complete || exit 1
    ```
- `anything_installed_from_repo` - Check if any apt-packages have been installed from the given repository-URL.
  - Example usage:
    ```bash
    anything_installed_from_repo http://archive.raspberrypi.org/debian/
    ```
  - Returns with code `0` if a package was found, otherwise `1`. It also returns the name of the package that was found.
  - This function is mainly intended to be used by the `remove_repofile_if_unused` function, which is described below.
- `remove_repofile_if_unused` - Given a path to an apt-repository file, determine if it is being used and remove it if it's unnecessary.
  - This function is very useful for apps that have to add their own APT repository. Some apps share repositories, so it's important to check if the `/etc/apt/sources.list.d/XXXX.list` file is in use before removing it.
  - This function uses the `anything_installed_from_repo` function, and if it returns `1` for all URLs found in the file, then the file is deemed unnecessary and is removed.
  - Example usage:
    ```bash
    remove_repofile_if_unused /etc/apt/sources.list.d/mono-official-stable.list
    ```
    For testing, you can tell the function to not actually delete anything by adding the `test` flag:
    ```bash
    remove_repofile_if_unused /etc/apt/sources.list.d/mono-official-stable.list test
    ```
    In this mode, it will return text like "`The given repository is not in use and can be deleted:`".
- `apt_lock_wait` - waits until apt locks are released.
- `less_apt` - Reduce the output of an `apt` operation.
  - Example usage:
    ```bash
    sudo apt update 2>&1 | less_apt
    ```
- `apt_update` - A wrapper function to run `sudo apt update`.
  - This will wait for apt locks to be released, handle status information, and display helpful tips if packages are upgradable or autoremovable.
  - Arguments to the function will be passed on to the `apt` command.

Below are three functions that manage **the Pi-Apps local APT repository**.  
This is a special folder (`/tmp/pi-apps-local-packages`) used by the `install_packages` function to handle installing local deb files. Installing local packages from a repository improves dependency-handling, condenses the operation into one `apt` operation, and allows the packages to be specified in any order.  

- `repo_add` - Add the specified deb file(s) to the local repository.
  - This simply copies specified files to the `/tmp/pi-apps-local-packages` folder.
- `repo_refresh` - Index the local repository, create a `Packages` file, and a `source.list`.
  - At this point, you can make `apt` use the repository by passing this flag to it: `-o Dir::Etc::SourceList=/tmp/pi-apps-local-packages/source.list`
- `repo_rm` - Removes the local repository.
- `app_to_pkgname` - Convert an app-name to an `apt`-compatible package name.
  - This function generates the name to use for creating dummy apt packages. The naming scheme is: `pi-apps-XXXXXXXX` (each `X` can be any lowercase letter or number)
  - View which dummy packages are installed now by running `apt search pi-apps-` in a terminal.
- `install_packages` - Used by apps to install packages.
  - Some background information first:  
    - Goal: Pi-Apps is designed for people who install an app, try it out, then later uninstall it. You should not have to think twice before installing an app. Users should have confidence that **uninstalling the app will undo all changes and restore all disk-space.**
    - Problem: Many apps need to install apt **packages** in order to work. On the surface, this does not seem like a big problem at all: if "app1" installs "package1", "package2", and "package3", then those packages should be purged while uninstalling "app1". What's the problem with that? **Dependencies.**  
  - What if some other utility requires "package1" to function? Now that you uninstalled "app1", "package1" just got uninstalled.
    - Best-case scenario: that utility will not work anymore.
    - Worst-case scenario: you just broke an essential part of your system and it will fail to boot.
  - Solution: When uninstalling an app, **only remove packages that are not required by anything else**. To accomplish this, we can't just install packages the normal way with `sudo apt install`. Instead, we need to generate a **dummy deb** - a custom apt package that lists "package1", "package2", and "package3" as **dependencies**. Later, when the app is being uninstalled, the dummy deb is removed and a simple `apt autoremove` is enough to safely remove the packages.
  - The `install_packages` function replaces the old `pkg-install` script which has been removed from pi-apps.
  - Example usage:
    ```bash
    install_packages package1 /path/to/package2.deb https://example.com/package3.deb package4-* || exit 1
    ```
  - First, each argument is analyzed.
    - If it's a URL, the file is downloaded and added to the local repository.
    - If it's a deb-file, it's added to the local repository.
    - If it contains regex (regular expression, aka the `*` character), a list of packages is generated using the `apt-cache search` command.
  - Next, the local repository is initialized. (if necessary)
  - Now an `apt_update` takes place.
  - It's time to configure and install an empty apt-package that "depends on" the packages we want to install. We refer to it as a "dummy deb".
    - First the name of the dummy deb is determined, using the `app_to_pkgname` function.
    - If the dummy deb is *already* installed, `install_packages` will inherit its dependencies and then re-install the dummy deb. This means that **the `install-packages` function can be used multiple times** in an app's script because it's accumulative.
    - The dummy deb is created, packaged, and finally installed.
- `purge_packages` - Used by apps to remove packages that they previously installed.
  - This function accepts no arguments. It reads the `$app` variable, purges its associated dummy deb, and autoremoves any packages that are no longer necessary.
- `get_icon_from_package` - Given a package (or space-separated list of packages), this function will automatically find the program icon for it.
  - This is useful for the `createapp` script to automatically find a suitable icon for package-apps you're trying to add.
  - This uses `dpkg-query` to list all files each package installed. The list is filteres to only show `.png` files in `/icons/` or `/pixmaps/` folders.
  - The list is sorted by filesize to find the picture with the most pixels.

End of apt functions. Flatpak functions below.

- `flatpak_install` - Install an app from Flatpak. This function simplifies the process for script-writers and improves terminal-output.
  - Example usage:
    ```bash
    flatpak_install librepcb || exit 1
    ```
    Script-writers: Don't forget to install the flatpak package first! (`install_packages flatpak || exit 1`)
    Also, a menu entry needs to be created. See the LibrePCB app, it's better to show than to explain. ;)
- `flatpak_uninstall` - Uninstall an app from Flatpak. This function simplifies the process for script-writers and has been designed to avoid false errors.
  - For example, if `flatpak` is already uninstalled, then trying to run `flatpak` will return an error.
  - Similarly, if the flatpak-app is already uninstalled, then `flatpak` will return an error!
  - This function solves both of those edge-cases and prevents unnecessary errors from ocurring.
  - Example usage:
    ```bash
    flatpak_uninstall librepcb || exit 1
    ```

End of Flatpak functions. App functions below.

- `list_apps` - List all apps that match a given criteria. (In a newline-separated format)
  - `list_apps local` will list apps that exist locally.
  - `list_apps` is the same as `list_apps local`.
  - `list_apps app` will list all apps, both local and online.
  - `list_apps installed` will list apps that are currently installed.
  - `list_apps corrupted` will list apps that are currently corrupted.
  - `list_apps disabled` will list apps that are currently disabled.
  - `list_apps uninstalled` will list apps that are currently uninstalled.
  - `list_apps have_status` will list apps that currently have a known status. (A clean Pi-Apps installation won't have any status files)
  - `list_apps missing_status` will list apps that don't have status files.
  - `list_apps cpu_installable` will list apps that have an installation script compatible with your operating system's CPU architecture.
    - If "app1" only has an `install-64` script but your system is 32-bit, then "app1" will be excluded from this list.
    - Likewise, if "app1" only has an `install-32` script but your system is 64-bit, then "app1" will be excluded from this list.
  - `list_apps package` will list apps that don't have scripts but have a `packages` file.
  - `list_apps standard` will list apps that do have scripts and don't have a `packages` file.
  - `list_apps hidden` will list apps that are in the special "hidden" category.
  - `list_apps visible` will list apps that are **not** in the special "hidden" category.
  - `list_apps online` will list apps that exist in the `update/pi-apps/apps` folder.
  - `list_apps online_only` will list apps that are **only** in the `update/pi-apps/apps` folder.
  - `list_apps local_only` will list apps that are **not** in the `update/pi-apps/apps` folder.
- `list_intersect` - Takes two lists of apps and *intersects* them, meaning that only apps that are listed in **both** lists are returned.
  For example, this will show apps that are both cpu_installable and visible:
  ```
  list_apps cpu_installable | list_intersect "$(list_apps visible)"
  ```
- `list_subtract` - Takes two lists of apps and *subtracts* one from other, meaning that only apps listed in the first list and **not** in the second list, are returned.
  For example, this will show apps that are *not* compatible with your system's architecture:
  ```
  list_apps local | list_subtract "$(list_apps cpu_installable)"
  ```
- `read_category_files` - Generates a list of categories; data compiled from the `data/category-overrides` and `etc/categories` files, with added support for unlisted apps.
- `app_categories` - Format the categories file, then list all apps, as if they were inside folders, based on the categories file. Also lists all apps under special "Installed" and "All Apps" categories.

- `shlink_link` - Increase/decrease the "number of users" a certain app has.
  - There are two [shlink](https://shlink.io/) links for every app: one link for installing it, and one link for uninstalling it.
  - Assuming the "Enable Analytics" setting was not turned off, this function will "click" one of those links.
  - How this link system works:
    - A Github Actions [script](https://github.com/Botspot/pi-apps/blob/master/.github/workflows/create_shlink_links.yml) on the main Pi-Apps repository automatically creates install/uninstall shlinks for every new app that is added.
    - The Pi-Apps server running a shlink instance (at https://analytics.pi-apps.io) will record the number of "clicks" for each link.
    - Another Github Actions script uploads shlink's statistics to the [pi-apps-analytics](https://github.com/Botspot/pi-apps-analytics) repository, which can then be retrieved by Pi-Apps clients through the `usercount` function, explained below. 
- `usercount` - returns the number of users an app has, based on the current number in the [pi-apps-analytics](https://github.com/Botspot/pi-apps-analytics) repository.
  To display the number of users for the Arduino app:
  ```
  usercount Arduino
  ```
- `script_name` - returns name of install script(s) for the specified app. Possible outputs: '', 'install', 'install-32', 'install-64', 'install-32 install-64'
  Usage:
  ```
  script_name Arduino
  ```
- `script_name_cpu` - Given an app, this returns the name of the app's installation script that would be run if you ran it.
  - For example, if your operating system is 32-bit and the app has an `install-32` script, this function would return "install-32".
  - If your operating system is 64-bit and the app has an `install-64` script, this function would return "install-64".
  - If the app has an `install` script, this function would return "install".
  - If none of the above, don't return anything.
- `app_status` - return the given app's current status.
  - If the app's status file does not exist, this function returns 'uninstalled'.
  - Otherwise, this function returns the contents of the app's status file.
- `app_type` - Determine if an app is a `standard` app or if it's a `package`.
- `will_reinstall` - Return an exit code of `0` if the specified app would be reinstalled during an update, otherwise return an exit code of `1`.
  - If the app's existing installation script is not identical to the new version of the installation script, AND the app is currently installed, exit with a code of `0`, otherwise exit `1`.
- `app_search` - Search all apps for the specified search query.
  - In each app-folder, this will search for matches in the following files:
    - `description`
    - `credits`
    - `website`
  - It hides incompatible and invisible apps before displaying the results. (list of app names, one per line)
- `app_search_gui` - A graphical front-end for the `app_search` function.
  - This displays all results from `app_search` in a graphical list.
  - One app should be selected from the list before clicking OK.
    - If only one app is displayed in the list, no need to select it.
  - The chosen app (if any) is returned.
- `generate_app_icons` - Resize a specified image and place the icons in the specified app-folder.
  - This requires imagemagick to be installed. If it's missing, a dialog box will appear and ask permission to install it.
  - Example usage:
    ```bash
    generate_app_icons /path/to/my-image.png my-app
    ```
- `refresh_pkgapp_status` - For the specified package-app, if dpkg thinks it's installed, then mark it as installed.
- `refresh_all_pkgapp_status` - For every package-app, if dpkg thinks it's installed, then mark it as installed.
- `refresh_app_list` - Forcibly regenerate the app list for the GUI. This overrides the usual shortcuts made by the `preload` script and guarantees that the app list will really be regenerated. It's useful for the `updater`, where unforeseen changes in script design may cause the app list to be displayed improperly.

Logfile functions below.
- `get_logfile` - Find the most recent logfile for the specified app.
- `log_diagnose` - Search a specified logfile for phrases that indicate non-errors.
  - Many errors are not Pi-Apps's fault. Most are outside of Pi-Apps's control, but caused by user-interference, Internet problems, or apt configuration errors.
  - Errors are categorized into three types: `system`, `internet`, `package`, and unknown.
    - If a known phrase is identified, the `$error_type` variable is set to either `system` or `internet` or `package`.
    - If no phrases were identified, the `$error_type` variable will be set to `unknown`. Only when the error_type is "unknown" will Pi-Apps allow the user to send an error report.
  - Each detected error has an accompanying caption for the user to read. This caption explains what the problem is and how to fix it.
    - As multiple error messages might be identified, the error captions are stored in an **array** variable called `$error_caption`. Storing explanations in an array allows multiple explanations to be displayed to the user.
  - Before exiting, this function returns the collected information. The first line is the value of `$error_type`, while subsequent lines are the value(s) of `$error_caption`.
- `format_logfile` - Log files store the entire output of all apps being installed or uninstalled. This function formats the logfile to improve its readability.
  - Unwanted patterns are removed, like terminal color-codes, long arrays of periods, etc.
  - All instances of the `\r` character are replaced by the `\n` character.
  - A header is added to the file, containing the output from `get_device_info`.
- `send_error_report` - Sends a log file to the Pi-Apps developers.
- `send_error_report_gui` - A graphical front-end for `send_error_report` - asks the user permission before sending an error log.
  - Please note that this is currently not being used. The `manage` script has its own error-reporting gui and directly uses `send_error_report`.

Below are all functions that don't have anything to do with apps.
- `runonce` - this function runs code only once, ever. Used by other scripts to run one-time workarounds to ensure a smooth transition as Pi-Apps evolves.
  - For example, this is a real usage of `runonce` in the Pi-Apps `gui` script:
    ```bash
    #ensure curl is installed
    runonce <<"EOF"
      if ! command -v curl >/dev/null ;then
        sudo apt install -y curl
      fi
    EOF
    ```
    It installs `curl` on the system, but only tries once.
  - This works by hashing the entire command first, using `sha256sum`.
  - If the hash matches a line in the `data/runonce_hashes` file, nothing occurs. Otherwise, the command is executed.
- `text_editor` - Use a text editor to open a file.
  - This obeys your choice of "Preferred text editor":
    ```
    text_editor /path/to/your.file
    ```
- `view_file` - Display a maximized `yad` window to view a file. This is used to view logfiles.
- `is_supported_system` - determines if your operating system is supported. This returns an exit-code of `0` if supported, otherwise`1`.
  If any of the below criteria are true, then your system is unsupported:
  - The kernel matches "x86" or "i686 or "i386".
  - The `/proc/version` file matches "Android".
  - The operating system's `PRETTY_NAME` matches "stretch", "wheezy", "jessie", "manjaro" or "Ubuntu 16".
  - The kernel matches "armv6*".
  - The script is being run as `root`.
  - The system has less than 500MB of free space.
- `get_device_info` - summarizes the current system setup for debug use.
  - To view the output on your  system, run this command:
  ```
  ~/pi-apps/api get_device_info
  ```
  - This function is used in the `format_log_file` function.
- `get_codename` - Simple function to return the codename of the operating system.
  - On Raspberry Pi OS Bullseye, this function returns: `bullseye`
  - This is useful for scripts that need to do different things depending on the exact system they are running on. The MultiMC5 app is a great example of this.
- `enable_module` - Always load a defined kernel module on system boot
  - It creates a file `/etc/modules-load.d/${module}.conf` for which tells a systemd service to load the defined module at boot.
  - Run this function as part of your install script instead of a `modprobe` in a .desktop file or startup script
    ```bash
    enable_module fuse || exit 1
    ```

Command interceptors below:
- `git_clone` - Wrapper function for the `git clone` command with improvements:
  - Status information is displayed. ("Downloading XXXXXX repository...")
  - `git`'s output is suppressed. But if the operation fails, its full output will be displayed in the error message.
  - Before cloning the repo, the destination folder is removed. This prevents the common error "`Fatal: destination path 'XXXXXX' already exists and is not an empty directory.`".
  - There may be times when an app-script doesn't want the output suppressed, or status information, or the folder removed first. That's why this function is an "opt-in" function; script-writers have to consciencely switch to `git_clone` if they want to.
- `wget` - This function overrides the `wget` command in all app-scripts. To speed up app-installation, it uses the `aria2c` tool when possible. Aria2c is faster and more reliable than wget, but it can't be used in all situations.
  - To determine if `aria2c` can be used, this function parses all flags given to it. It stores the url and the output filename.
    - If any flags other than `-q`, `-O`, and `-qO` are passed, `wget` is used.
    - If the `aria2c` command does not exist, `wget` is used.
    - If the output is not a file but is being sent to `stdout` (using the `-qO-` flag, for example), `wget` is used.
  - If `aria2c` is enabled, it runs with the following flags:
  `-c -x 16 -s 16 -m 10 --retry-wait 30 --console-log-level=error --show-console-readout=false --summary-interval=0 "$url" --dir '/' -o "${file:1}" --allow-overwrite`
    - If the `-q` flag was passed, the `--quiet` flag is sent to aria2c.
  - Otherwise, if aria2c was ruled out, `wget` is run as it normally would.
  - This function is designed to operate seamlessly in 100% of cases. App-developers *should not have to even know* that this function is really translating `wget` commands to `aria2c` - it should operate exactly the same as `wget`, but faster.
- `chmod` - Wrapper function for the `chmod` command with status information.
  - This displays "`Making executable: /path/to/file`".
- `unzip` - Wrapper function for the `unzip` command with status information.
  - This displays "`Extracting: /path/to/file`".

And with that, we come to the end of functions in the `api` script. If you see a function that's not listed here, please let us know.

## The `gui` script
#### Location:
On a default pi-apps installation, you will find this script at `/home/pi/pi-apps/gui`. 
#### Purpose:
This script handles Pi-Apps's entire user-interface.
#### Usage:
To run Pi-Apps: 
```bash
~/pi-apps/gui
```
To start Pi-Apps at a specific app:
```bash
~/pi-apps/gui Arduino
```
To start Pi-Apps on a specific category:
```bash
~/pi-apps/gui 'All Apps/'
```
#### How it works:
1. The `api` script is sourced.
2. The pi-apps logo is displayed in the terminal (using the `generate_logo` function)
3. A series of `runonce` entries are executed in the background.
4. The message of the day is determined.
    - To save time, it's stored in `data/announcements`.
    - If that file is missing or it's more than a day old, it is downloaded from [the pi-apps-announcements repository](https://github.com/Botspot/pi-apps-announcements).
    - One random line is taken from the file and used as the message for this session.
5. We now come to a `while` loop that runs the GUI. Inside is an `if` statement that obeys the following values of the `$action` variable:
    - `main-window` - Handles the app list.
      - This may be a yad window or an xlunch window, depending on the "App List Style" setting.
      - Xlunch is compiled, if necessary.
    - `details` - Displays the details of the current app.
    - `search` - Sets the `$app` variable to the output of the `app_search_gui` function.
    - The rest of the modes need no explanation. They are: `exit`, `back`, `install`, `uninstall`, `scripts`, `edit`, `credits`, `enable`, `viewlog`, `mind-reading`, `view-updates`, `unknown`.
## The `createapp` script
#### Location:
On a default pi-apps installation, you will find this script at `/home/pi/pi-apps/createapp`. 
#### Purpose:
A GUI to help you create/edit an app. 
#### Usage:
To create a new app:
```bash
~/pi-apps/createapp
```
To edit an existing app:
```bash
~/pi-apps/createapp Arduino
```
#### How it works:
This script is one long `while` loop with a `case` statement for each step. (similar to the `gui` script)  
Each dialog allows you to go forward or backward and the current step is stored in the `$step` variable.  
That's about it. View the script to see how each step works.
## The `settings` script
#### Location:
On a default pi-apps installation, you will find this script at `/home/pi/pi-apps/settings`. 
#### Purpose:
To manage settings for Pi-Apps.
#### Usage:
To launch the graphical settings window:
```bash
~/pi-apps/settings
```
To check for missing setting-values and fill them with the default values, use this flag:
```bash
~/pi-apps/settings refresh
```
To revert all settings to their default values:
```bash
~/pi-apps/settings revert
```
#### How it works:
Each setting is stored in *two* places in the main pi-apps folder:
- The setting's possible values, default value, and explanation is stored in the `etc/setting-params` folder.
  - For example, the `etc/setting-params/App List Style` file contains:
    ```
    #Pi-Apps can display the apps as a compact list (yad), or as a group of larger icons. (xlunch)
    yad
    xlunch-dark
    xlunch-dark-3d
    xlunch-light-3d
    ```
  - All commented lines are the explanation, also known as the tooltip.
    - For this file, it is:
      ```
      #Pi-Apps can display the apps as a compact list (yad), or as a group of larger icons. (xlunch)
      ```
  - The first uncommented line is the default value for the setting.
    - For this file, it is:
      ```
      yad
      ```
  - Subsequent uncommented lines are additional possible values.
    - For this file, they are:
      ```
      xlunch-dark
      xlunch-dark-3d
      xlunch-light-3d
      ```
- The setting's current value is stored in the `data/settings` folder. This is a single file that contains a single-line value.
  - For example, if I set the app list style to "xlunch-dark-3d", the `data/settings/App List Style` file will contain "`xlunch-dark-3d`".

This dual-file/dual-folder approach is necessary to retain your choice, while allowing there to be future updates to settings, and/or their possible values. (Remember, the `data` directory is never updated but the `etc` folder is.)
## The `preload` script
#### Location:
On a default pi-apps installation, you will find this script at `/home/pi/pi-apps/preload`. 
#### Purpose:
To generate the app-list for a given category, and prioritizing minimum execution-time.
#### Usage:
To generate the app-list of the "Installed" category for yad:
```bash
~/pi-apps/preload yad 'Installed'
```
To generate the app-list for xlunch for the main page (no category)
```bash
~/pi-apps/preload /home/pi/pi-apps/preload xlunch ''
```
#### How it works:
This script is designed for maximum speed. As a result, it uses many tricks to run faster.
1. Compile the `genapplist-yad` program. This is a C program designed to improve preloading times, but if it fails, a bash-based fallback is used.
    - It uses `gcc` to compile the `/etc/genapplist-yad.c`file to the `/etc/genapplist-yad` binary.
    - This program is tested; if it fails to produce 5 lines of output for one input app, the program is deleted to use the bash-based fallback.
2. Determine if it's **necessary** to generate the app-list.
    - If nothing has been modified in the `apps` folder, the `settings` folder, the `update-status` folder, the `etc` folder, the `api` script, the `preload` script, and the `categories` file, **skip** generating the app-list, **return the contents** of the previous app-list in the `data/preload` folder, and **exit**.
3. If it is necessary to generate the app-list, use the `app_categories` function to generate a list of all apps in their respective categories.
4. Limit the list of apps to the current category. (so if we're viewing the "Installed" category, hide all apps that are not in there.)
5. If the "Shuffle App list" setting is enabled, shuffle the list of apps and categories now.
    - Note: categories are always displayed above apps.
6. Remove apps that are not compatible with the operating system's CPU architecture.
7. Generate the list of visible categories.
8. Generate the list of visible apps.
    - If the GUI-mode is yad, use the `genapplist-yad` program if it exists.
    - Otherwise, generate the list of apps the slower bash-based way.
9. Save the resulting app-list to a file in the `data/preload` folder. (so that next time `preload` is run, it might not have to generate anything)
10. In the background, place all app-icons in the disk cache. This improves load-time.
11. Output the resulting app-list.
12. Run the `preload-daemon` script in the background to preload other categories. That way, when using Pi-Apps, by the time you click any category, it has just been preloaded and is ready-to-go.
## The `preload-daemon` script
#### Location:
On a default pi-apps installation, you will find this script at `/home/pi/pi-apps/etc/preload-daemon`.  
This file is located in the `etc` folder because it's one of the smaller scripts.
#### Purpose:
To generate the app-list for all categories.
#### Usage:
Preload all categories for `yad`, repeating every 30 seconds for a total of 20 times:
```bash
~/pi-apps/etc/preload-daemon yad
```
Preload all categories for `xlunch` only once:
```bash
~/pi-apps/etc/preload-daemon xlunch once
```
## The `terminal-run` script
#### Location:
On a default pi-apps installation, you will find this script at `/home/pi/pi-apps/etc/terminal-run`.  
This file is located in the `etc` folder because it's one of the smaller scripts.
#### Purpose:
This script may be Botspot's *greatest contribution to the open-source world*. Apart from this script, there is no reliable way to:
- Run a *newline-separated* list of commands in a new terminal window.
- Set the terminal's title, as desired.
- Keep the script running until the terminal has been closed.
- Support a variety of terminals.
#### Usage:
This command will run two commands in a terminal and set the terminal's title to "Upgrading your packages":
```bash
~/pi-apps/etc/terminal-run 'sudo apt update
sudo apt upgrade' "Upgrading your packages"
```
The `terminal-run` script will not exit until the terminal closes.
#### How it works:
As mentioned earlier, this script supports running a ***list*** of commands in a terminal. That may sound easy enough, but it's not.
- Terminals are not designed to support this. Most terminals can, with some clever tricks, but it varies on a case-by-case basis.

As mentioned earlier, this script will keep running until the terminal has been closed. How is that possible?
- Before running any commands in a terminal, a special file is created in the `/tmp` folder. This file is empty for now.
- Then, the terminal is instructed to write its PID (process ID) *to the file*.
- Now, while the terminal is running, the `terminal-run` script can regularly check if that PID process is still running.
  - It does this by periodically checking if the `/proc/${PID}` folder exists.
- When the PID stops, it indicates that the terminal has been closed. Now the `terminal-run` script exits.

Supported terminals:
- lxterminal
- xfce4-terminal
- mate-terminal
- xterm
- konsole
- terminator
- gnome-terminal
- x-terminal-emulator

Debug mode: if you set the `DEBUG` variable to `1`, `terminal-run` will output the name of the currently-used terminal.
- This is useful for debugging, when no terminal appears and we want to know which terminal was being used.
## The `categoryedit` script
#### Location:
On a default pi-apps installation, you will find this script at `/home/pi/pi-apps/etc/categoryedit`.  
This file is located in the `etc` folder because it's one of the smaller scripts.
#### Purpose:
Manage Pi-Apps categories.  
As of commit https://github.com/Botspot/pi-apps/commit/ab1fcb5a114ab720df1712aaf151a9733e18a94c, there are *two* categories files: a local one and a global one. The global file is kept updated like any other file, while the local file is empty by default but can contain **overrides**.  
The global categories file: `/home/pi/pi-apps/etc/categories`  
The local categories file: `/home/pi/pi-apps/data/category-overrides`  
#### Usage:
Run the category editor:
```bash
~/pi-apps/etc/categoryedit
```
Move the Arduino app to the Internet category:
```bash
~/pi-apps/etc/categoryedit Arduino Internet
```
Move the Arduino app to the top level (no category):
```bash
~/pi-apps/etc/categoryedit Arduino
```
## The `logviewer` script
#### Location:
On a default pi-apps installation, you will find this script at `/home/pi/pi-apps/etc/logviewer`.  
This file is located in the `etc` folder because it's one of the smaller scripts.
#### Purpose:
Browse the list of log files, opening any files that you click on with the `viewlog` script.
#### Usage:
```bash
~/pi-apps/etc/logviewer
```
## The `viewlog` script
#### Location:
On a default pi-apps installation, you will find this script at `/home/pi/pi-apps/etc/viewlog`.  
This file is located in the `etc` folder because it's one of the smaller scripts.
#### Purpose:
View the specified log file in a text editor.
#### Usage:
```bash
~/pi-apps/etc/viewlog ~/pi-apps/logs/install-success-Arduino.log
```
Notes:
- This script will kill previous instances of itself.
- This script **does not obey** the "Preferred text editor" setting.
  - Why? Viewing a log in ***`geany`*** (the default "Preferred text editor" setting) is cumbersome and breaks the whole concept of closing the editor once you click on a new logfile.

## Automatic App Updaters
#### Location:
These are scripts which reside on the github repo for pi-apps specificially for keeping app versions updated with their upstream projects and repos. These automatic app updaters are found in the `.github/workflows/updates` folder.
Each script/app in pi-apps which has automatic version updating functionality has a script in this folder. The script name is the same as the app name.
#### Purpose:
To keep versions of apps in pi-apps up to date with the latest fixes, features, and improvements.
#### What can updater script do:
Updater scripts have access to a few special functions and scripts that normal pi-apps install scripts do not have access to.
It is easier to explain with an example of an updater script.

#### Github release example:<br>
```
#!/bin/bash

webVer=$(get_release angryip/ipscan)
all_url="https://github.com/angryip/ipscan/releases/download/${webVer}/ipscan_${webVer}_all.deb"

source $GITHUB_WORKSPACE/.github/workflows/update_github_script.sh
```
This is Angry IP scanners's update script. New releases of the .deb are posted on the `angrypi/scan` github, so a few times a day, the pi-apps github actions runs this script to check for new releases of Angry IP Scanner.
There are a few special functions designed for github scripts to use, so that they can obtain the latest app version.
```
get_release() {
  curl --silent "https://api.github.com/repos/$1/releases/latest" | jq -r '.tag_name' | sed s/v//g
}
get_prerelease() {
  curl --silent "https://api.github.com/repos/$1/releases" | jq -r 'map(select(.prerelease)) | first | .tag_name' | sed s/v//g
}
```
`get_release` followed by the app `githubowner/reponame` will obtain the latest github release version number<br>
`get_prerelease` followed by the app `githubowner/reponame` will obtain the latest github prerelease version number.

For pi-apps install scripts written with this in mind, this version number can be used to automatically generate a pi-apps PR with the updated version. Simply set the URL of the deb/binary found on the github with the `webVer` variable substituted in `all_url` for install scripts, `armhf_url` for install-32 scripts, and `arm64_url` for install-64 scripts, and call the update_github_script. Pi-apps install scripts should be formated with a `version` varaible for this automatic script to update with the latest version.<br>
See angry ip scanners's `install` file for an example:
```
#!/bin/bash

version=3.8.2
install_packages openjdk-11-jdk rpm fakeroot "https://github.com/angryip/ipscan/releases/download/${version}/ipscan_${version}_all.deb" || exit 1
```

#### Debian repo example:<br>
For apps which are published to a debian repo, but it is not desired to add the repo to a users install, the update_debian_repo_script can be used to automatically update an apps install scripts.

```
#!/bin/bash

armhf_webPackages="https://apt.raspbian-addons.org/debian/dists/precise/main/binary-armhf/Packages"
arm64_webPackages="https://apt.raspbian-addons.org/debian/dists/precise/main/binary-arm64/Packages"
armhf_packagename="antimicrox"
arm64_packagename="antimicrox"

# The corresponding appname in pi-apps will have its corresponding filepath= variable update
# the filepath variable will contain the full filepath of the debian package with the version included

source $GITHUB_WORKSPACE/.github/workflows/update_debian_repo_script.sh
```
Debian repos contain what is called a `Packages` file, this file contains all the control data for all packages hosted on that repo under that distro, and architecture. Shown above is the anitmicrox updater script.<br>
The package used on pi-apps is hosted at the `raspbian-addons` repo, so we specify the location of the `Packages` file on that repo using `armhf_webPackages` and `arm64_webPackages`.<br>
We then specify what the package name we would like to have checked from that repo is named, in this case, its `antimicrox` set to the variables `armhf_packagename` `arm64_packagename`.<br>
Finally, to update the pi-apps scripts, we call the update_debian_repo_script as shown.

The corresponding app install scripts in pi-apps should contain a `filename` variable (`filename_32` and `filename_64` if there are separate armhf and arm64 filenames in the same `install` script) with the entire URL path of the .deb file contained.<br>
See antimicrox's `install-64` file for an example:
```
#!/bin/bash

filepath="https://apt.raspbian-addons.org/debian/pool/main/a/antimicrox/antimicrox_3.2.1_arm64.deb"

install_packages "${filepath}" || exit 1
```
