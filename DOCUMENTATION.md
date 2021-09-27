# Inside Pi-Apps: everything a power-user should know
This guide will attempt to explain how Pi-Apps works. By nature, this cannot be complete, so feel free to look through the scripts yourself and ask the Pi-Apps developers questions.
## Table of contents
- [Introduction](#introduction)
- [The app-folder](#the-app-folder)
- [The main Pi-Apps folder](#the-main-pi-apps-folder)
- [The App Status folder](#the-app-status-folder)
- [The `manage` script](#the-manage-script)
- [The `pkg-install` script](#the-pkg-install-script)
- [The `updater` script](#the-updater-script)
- [The `api` script](#the-api-script)
- [The `gui` script](#the-gui-script)
- [The `createapp` script](#the-createapp-script)
- [The `settings` script](#the-settings-script)
- [The `preload` script](#the-preload-script)
- [The `preload-daemon` script](#the-preload-daemon-script)
- [The `terminal-run` script](#the-terminal-run-script)
- [The `categoryedit` script](#the-categoryedit-script)
- [The `logviewer` script](#the-logviewer-script)
- [The `viewlog` script](#the-viewlog-script)
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
  For example, the **`Wine (x86)`** app requires Box86. It accomplishes that with this comand:
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

## The `pkg-install` script
#### Location:
On a default pi-apps installation, you will find this script at `/home/pi/pi-apps/pkg-install`. 
#### Purpose:
Some background information first:  
- Goal: Pi-Apps is designed for people who install an app, try it out, then later uninstall it. You should not have to think twice before installing an app. Users should have confidence that **uninstalling the app will undo all changes and restore all disk-space.**
- Problem: Many apps need to install apt **packages** in order to work. On the surface, this does not seem like a big problem at all: if "app1" installs "package1", "package2", and "package3", then those packages should be purged while uninstalling "app1". What's the problem with that? **Dependencies.**  
What if some other utility requires "package1" to function? Now that you uninstalled "app1", "package1" just got uninstalled.
  - Best-case scenario: that utility will not work anymore.
  - Worst-case scenario: you just broke an essential part of your system and it will fail to boot.
- Solution: When uninstalling an app, **only remove packages that are not required by anything else**. To accomplish this, we can't just install packages the normal way with `sudo apt install`. Instead, we need to generate a **dummy deb** - a custom apt package that lists "package1", "package2", and "package3" as **dependencies**. Later, when the app is being uninstalled, the dummy deb is removed and a simple `apt autoremove` is enough to safely remove the packages.
#### Usage:
In an app's `install` script, there may be a line like this to install "package1", "package2", and "package3":
```bash
DIRECTORY=$HOME/pi-apps
"${DIRECTORY}/pkg-install" 'package1 package2 package3' "$(dirname "$0")" || exit 1
```
This is equivalent to:
```bash
sudo apt update --allow-releaseinfo-change
sudo apt install -yf --no-install-recommends --allow-downgrades package1 package2 package3
```
#### How it works:
1. First, `pkg-install` sets the language variables to `C`. This ensures that apt's output is parsed correctly, even if the system is using a different language,
2. `pkg-install` runs `sudo apt update`.
3. The output of `sudo apt update` is parsed for various messages from `apt`.
    - If the output contains "autoremove to remove them", you will receive a message that some packages can be removed with `apt autoremove`.
    - If the output contains "packages can be upgraded", you will receive a message that some packages can be upgraded.
    - If the output contains "W:" or "E:" or "Err:", `pkg-install` will **exit with an error** saying that your apt system is messed up.
    The exact error message depends on apt's exact output - it is designed to help users navigate through apt errors and provides instructions for how to sign a repository, remove a broken repository, or check for an Internet connection.
4. If any filenames (paths to a local deb package) are specified, `pkg-install` will install each one, then mark it as autoremovable. (Using this command: `sudo apt-mark auto "$packagename"`
5. If any package names include **regular expression**, `pkg-install` expands the names with `apt-cache search`.
6. Finally, the dummy deb is created. As mentioned earlier, this package will list the desired packages as dependencies.
    - The dummy deb for each app has to be named something unique. But this poses a problem because apps can have space characters while apt does not support space characters.
    - This problem is resolved by naming each dummy-deb based on a **hash of its name**.
    - The code used to do this is:
   ```bash
   echo -n 'pi-apps-' ; echo "$app" | md5sum | cut -c1-8 | awk '{print $1}'
   ```
    - Feel free to replace `"$app"` with an app-name of your choice to see what its package name would be.
7. If the dummy deb's name is already installed, purge it and then continue.
8. Finally, the dummy deb is installed with `apt`. All packages mentioned in the "`Depends:`" field of the dummy deb are installed as a dependency of the dummy deb.
9. If apt fails, its errors are diagnosed in the same way errors were diagnosed earlier when `sudo apt update` was run.
10. `pkg-install` exits with a code of `0` if everything was successful, otherwise it exits with a code of `1`.
### The `purge-installed` script
#### Location:
On a default pi-apps installation, you will find this script at `/home/pi/pi-apps/purge-installed`. 
#### Purpose:
This script is the opposite of `pkg-install`: it uninstalls the dummy deb, then runs `sudo apt autoremove`.
#### Usage:
In an app's `uninstall` script, there may be a line like this:
```bash
DIRECTORY=$HOME/pi-apps
"${DIRECTORY}/purge-installed" "$(dirname "$0")" || exit 1
```
## The `updater` script
#### Location:
On a default pi-apps installation, you will find this script at `/home/pi/pi-apps/updater`. 
#### Purpose:
This script handles Pi-Apps updates, both for apps and for files. Apps do not have version numbers, so updating involves comparing the installation-script of the existing app-folder with the installation-script of the new app-folder.
#### Usage:
```bash
~/pi-apps/updater
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
Note: new functions are added often. If you don't see a function on this list but do see it on the api, please open an issue to let us know.
- `error` - display a custom message in red and exit with a return code of `1`.
  Usage:
  ```
  error "The command 'sudo apt update' failed!"
  ```
  This is often seen at the end of a command with the `||` operator:
  ```
  sudo apt update || error "The command 'sudo apt update' failed!"
  ```
- `list_apps` - List all apps that match a given criteria. (In a newline-separated format)
  - `list_apps local` will list apps that exist locally.
  - `list_apps` is the same as `list_apps local`.
  - `list_apps installed` will list apps that are currently installed.
  - `list_apps corrupted` will list apps that are currently corrupted.
  - `list_apps disabled` will list apps that are currently disabled.
  - `list_apps uninstalled` will list apps that are currently uninstalled.
  - `list_apps cpu_installable` will list apps that have an installation script compatible with your operating system's CPU architecture.
    - If "app1" only has an `install-64` script but your system is 32-bit, then "app1" will be excluded from this list.
    - Likewise, if "app1" only has an `install-32` script but your system is 64-bit, then "app1" will be excluded from this list.
  - `list_apps hidden` will list apps that are in the special "hidden" category.
  - `list_apps visible` will list apps that are **not** in the special "hidden" category.
  - `list_apps online` will list apps that exist in the `update/pi-apps/apps` folder.
  - `list_apps online_only` will list apps that are **only** in the `update/pi-apps/apps` folder.
  -  `list_apps local_only` will list apps that are **not** in the `update/pi-apps/apps` folder.
- `list_intersect` - Takes two lists of apps and *intersects* them, meaning that only apps that are listed in **both** lists are returned.
  For example, this will show apps that are both cpu_installable and visible:
  ```
  list_apps cpu_installable | list_intersect "$(list_apps visible)"
  ```
- `list_subtract` - Takes two lists of apps and *subtracts* one from other, meaning that only apps listed in the first list and **not** in the second list, are returned.
  For example, this will show apps that are not compatible with your system's architecture:
  ```
  list_apps local | list_intersect "$(list_apps cpu_installable)"
  ```
- `app_categories` - Format the categories file, then list all apps, as if they were inside folders, based on the categories file. Also lists all apps under special "Installed" and "All Apps" categories.
- `bitly_link` - Increase/decrease the "number of users" a certain app has.
  - Botspot creates [bitly](https://bitly.com) links for every app: one link for installing it, and one link for uninstalling it.
  - Bitly will track how many times each link has been clicked.
  - Assuming the "Enable Analytics" setting was not turned off, this function will "click" one of those links.
  - Botspot uses a script to upload bitly's statistics to the [pi-apps-analytics](https://github.com/Botspot/pi-apps-analytics) repository.
- `usercount` - returns the number of users an app has, based on the current number in the [pi-apps-analytics](https://github.com/Botspot/pi-apps-analytics) repository.
  To display the number of users for the Arduino app:
  ```
  usercount Arduino
  ```
- `text_editor` - Use a text editor to open a file.
  - This obeys your choice of "Preferred text editor".
  Usage:
  ```
  text_editor /path/to/your.file
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
-  `will_reinstall` - exits with a code of `0` if given app would be reinstalled during an update, otherwise exit `1`.
  - If the app's existing installation script is not identical to the new version of the installation script, AND the app is currently installed, exit with a code of `0`, otherwise exit `1`.
- `app_search` - Search all apps for the specified search query.
  - In each app-folder, this will search for matches in the following files:
    -  `description`
    - `credits`
    - `website`
  - It hides incompatible and invisible apps before displaying the results. (list of app names, one per line)
- `app_search_gui` - A graphical front-end for the `app_search` function.
  - This displays all results from `app_search` in a graphical list.
  - One app should be selected from the list before clicking OK.
    - If only one app is displayed in the list, no need to select it.
  - The chosen app (if any) is returned.

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
- `apt_lock_wait` - waits until apt locks are released.
- `is_supported_system` - determines if your operating system is supported. This returns an exit-code of `0` if supported, otherwise`1`.
If any of the below criteria are true, then your system is unsupported:
  - The kernel matches "x86" or "i686 or "i386".
  - The operating system's `PRETTY_NAME` matches "stretch", "wheezy", "jessie", "manjaro" or "Ubuntu 16".
  - The kernel matches "armv6*".
  - The script is being run as `root`.
  - The system has less than 1GB of free space.
- `get_device_info` - summarizes the current system setup for debug use.
  - To view the output on your  system, run this command:
  ```
  ~/pi-apps/api get_device_info
  ```
  - This function is used in the `format_log_file` function.
- `format_log_file` - Log files store the entire output of all apps being installed or uninstalled. This function formats the logfile to improve its readability.
  - Unwanted patterns are removed, like terminal color-codes, long arrays of periods
  - All instances of the `\r` character are replaced by the `\n` character.
  - Adds a header to the log file with the output from the `get_device_info` function.
- `send_error_report` - Sends a log file to the Pi-Apps developers.
- `send_error_report_gui` - A graphical front-end for `send_error_report` - asks the user permission before sending an error log.
- `generate_logo` - Displays the Pi-Apps logo in a terminal.
- `wget` - This function overrides the `wget` command in all app-scripts. To speed up app-installation, it uses the `aria2c` tool when possible. Aria2c is faster and more reliable than wget, but it can't be used in all situations.
  - To determine if `aria2c` can be used, this function parses all flags given to it. It stores the url and the output filename. If any flags other than `-q`, `-O`, and `-qO` are passed, `wget` is used.
  - If the `aria2c` command does not exist, the `wget` command is used.
    - If `aria2c` is enabled, it runs with the following flags:
  `-c -x 16 -s 16 -m 10 --retry-wait 30 --show-console-readout=false --console-log-level=error --summary-interval=5 "$url" --dir '/' -o "${file:1}" --allow-overwrite`
    - If the `-q` flag was passed, aria2c's output is sent to `/dev/null`.
  - Otherwise, if aria2c was ruled out, `wget` is run as it normally would.
  - This function is designed to operate seamlessly in 100% of cases. App-developers *should not have to even know* that this function is really translating `wget` commands to `aria2c` - it should operate exactly the same as `wget`, but faster.
- And with that, we come to the end of functions in the`api` script. If you see a function that's not listed here, please let us know.
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
1. The splash screen appears.
2. The `api` script is sourced.
3. The pi-apps logo is displayed in the terminal (using the `generate_logo` function)
4. A series of `runonce` entries are executed in the background.
5. The message of the day is determined.
    - To save time, it's stored in `data/announcements`.
    - If that file is missing or it's more than a day old, it is downloaded from [the pi-apps-announcements repository](https://github.com/Botspot/pi-apps-announcements).
    - One random line is taken from the file and used as the message for this session.
6. We now come to a `while` loop that runs the GUI. Inside is an `if` statement that obeys the following values of the `$action` variable:
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
The file containing categories is located in `data/categories/structure`.
#### Usage:
Run the category editor:
```bash
~/pi-apps/etc/categoryedit
```
Move the Arduino app to the Internet category:
```bash
~/pi-apps/etc/categoryedit Arduino Internet
```
Remove the Arduino app from the list of categories:
```bash
~/pi-apps/etc/categoryedit Arduino --delete
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
- This script does not obey the "Preferred text editor" setting.
  - Viewing a log in ***`geany`*** (the default "Preferred text editor" setting) is cumbersome and breaks the whole concept of closing the editor once you click on a new logfile.
