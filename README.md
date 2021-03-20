![logo](https://github.com/Botspot/pi-apps/blob/master/icons/proglogo.png?raw=true)
## Raspberry Pi App Store for Open Source Projects

Linux is harder to master than Windows. It's geared toward power users, and you will encounter problems if you follow tutorials.
Because of the lack of available software on the `apt` repositories, most Raspberry Pi owners never use their Pies to their full, desktop PC, potential.  
Countless **Raspberry Pies remain in disuse** for this very reason. Something must be done!  
Introducing **Pi-Apps**, basically a list of pre-made apps you can install with **one click**.  

**[ETA Prime](https://www.youtube.com/watch?v=oqNWJ52DLes)** (a very well known RPi YouTuber) says:

> "It's an **awesome** Raspberry Pi app store and it **works really well** and there's *lots* of **great stuff in here** and it's super **easy to install**.  
> I want to give the devs of Pi-Apps a big shout-out."

## To install Pi-Apps
```
wget -qO- https://raw.githubusercontent.com/Botspot/pi-apps/master/install | bash
```
<details>
<summary>Manual installation</summary>

```
git clone https://github.com/Botspot/pi-apps
~/pi-apps/install
```
</details>

The install script ensures YAD is installed, creates two menu buttons, an autostarted updater, and a file (`/usr/local/bin/pi-apps`) that allows pi-apps to be run from terminal. Besides those, nothing is modified outside your home directory.

<details>
<summary>To uninstall Pi-Apps</summary>
To uninstall Pi-Apps:

```
~/pi-apps/uninstall
```
</details>

## To run Pi-Apps
Menu -> Accessories -> Pi Apps, or run `pi-apps` in a terminal. Run Pi-Apps from its directory with `~/pi-apps/gui`.
### Useful links
- [![Pi-Apps Discord server](https://img.shields.io/discord/770629697909424159.svg?color=7289da&label=Pi-Apps%20Discord%20server&logo=discord)](https://discord.gg/RXSTvaUvuu)
- [Send Botspot a donation](https://paypal.me/josephmarchand)
- [View changelog](https://github.com/Botspot/pi-apps/blob/master/CHANGELOG.md)
- [Report an error](https://github.com/Botspot/pi-apps/issues/new)
- [Leepspvideo Pi-Apps walkthrough](https://www.youtube.com/watch?v=zxyWQ3FV98I)
- [ETA Prime's Pi-Apps & Minecraft Java video](https://www.youtube.com/watch?v=oqNWJ52DLes)

## What do others say about Pi-Apps?
> "Awesome. Thanks for doing this." - **[Novaspirit Tech](youtube.com/novaspirittech)** (large RPi YouTuber)

> Thanks so much to Botspot for creating this; it's a great program." - **[leepspvideo](https://www.youtube.com/watch?v=zxyWQ3FV98I)** (large RPi YouTuber)

> "I love pi-apps. It's great and installs tons of useful software that people don't know how to install. Great work Botspot!" - **[RPi Projects and More](https://www.youtube.com/channel/UCkv0fW0EIUTKw6pYEnTjTbQ)** (RPi YouTuber)

> "I gave Pi-Apps a go a while back and have suggested it to others quite a few times.
> We can't provide all the options people may want, so it helps a lot that there are people like you who can help bridge the gap. Thank you Botspot!" - (RPi developer)

> "Thanks for the great work making it all simple for everybody." - [**ShiftPlusOne**](https://www.raspberrypi.org/forums/viewtopic.php?f=63&t=290329&p=1755860#p1755857) (RPi moderator)

> "Good luck with your projects, Botspot, you're really making waves!" - **[Sakaki](https://github.com/sakaki-)** (RPi legend)

> "I love Pi-Apps and I chase all my friends around tryna get them to install it" - Beiop from Discord

### Basic usage
- This is the **main window**:  
![main window](https://github.com/Botspot/pi-apps/blob/master/icons/screenshots/main%20window.png?raw=true)  
Use the main window to select an app category you want to view. Open a category folder by double-clicking on it.  
- After selecting a category, you will see a list of apps:  
![app list](https://github.com/Botspot/pi-apps/blob/master/icons/screenshots/app%20list.png?raw=true)  
- If you double-click an app, or select and app and click ![info.png](https://raw.githubusercontent.com/Botspot/pi-apps/master/icons/info.png), you will see the **Details window**.  
![details](https://github.com/Botspot/pi-apps/blob/master/icons/screenshots/details%20window.png?raw=true)  
- Pi-Apps may display a notification on boot. If you choose to view the updates, the **updater window** will appear:  
![updates](https://github.com/Botspot/pi-apps/blob/master/icons/screenshots/updates%20available.png?raw=true)  
- Pi-Apps **Settings** can be configured by launching Menu -> Preferences -> Pi-Apps Settings.  
![settings](https://github.com/Botspot/pi-apps/blob/master/icons/screenshots/settings.png?raw=true)  

## To-do

- [X] Make **app creation system**. (completed with the `createapp` script)  
- [X] Add Pi-Apps to **Twister OS**. (completed on 11/2/2020 via the Twister 1.8.5 patch.)  
- [X] Support individual **32-bit** and **64-bit** install scripts.  
- [X] Allow **multiple apps** to be selected from the app list and be installed simultaneously.  
- [X] Add a **search function** to the app list. It's still experimental: to enable it, switch to **xlunch** in **Pi-Apps Settings** -> **App List Style**.
- [X] Break up the long app list with some **categories**.  
- [X] Add a new category containing all apps currently **installed**.

<details>
<summary>Terminal & script usage</summary>

 - Each 'App' is simply a small `install` script, `uninstall` script, two icon sizes, and two text files containing the description and a website URL.
 - Each App is stored in its own separate directory. `~/pi-apps/apps/` holds all these app directories. The Zoom app, for example, would be located at `~/pi-apps/apps/Zoom/`.
 - Because of the contained nature of each app folder, it's really easy to 'package' your own apps: just put the folder in a ZIP file and send it to friends. (or upload it as a [new issue](https://github.com/Botspot/pi-apps/issues/new) so your app can be added to Pi-Apps)
 - When you click Install, the selected App's `install` script is executed. (Or, in some cases, the `install-32` or `install-64` script is executed.)
 - When you click Uninstall, the selected App's `uninstall` script is executed.
## Terminal usage
 - The `manage` script is similar to `apt-get` - it handles installing apps, uninstalling them, keeping them updated, and more. `Manage` does not include a GUI, but in one case, a dialog will ask if you really want to install the same app twice.
   - To **install** an app, run this:
`~/pi-apps/manage install Zoom`
   - To **uninstall** an app:
`~/pi-apps/manage uninstall Zoom`
   - To **update** a single app:  
`~/pi-apps/manage update Zoom`
Note that if an app is up-to-date, no files will be moved around.
   - To **check** all apps for updates:  
 `~/pi-apps/manage check-all`
 This command will return a list of updatable apps, separated by the `|` character.
   - To **update all** apps:
  `~/pi-apps/manage update-all`
  Please note that this will not update the Pi-Apps main scripts! It only updates your apps and that's an important distinction.
   - To update everything:
   `~/pi-apps/updater`
 - To **list** all apps:
 `ls ~/pi-apps/apps`
 Note that this will also list the `template` app, which is usually hidden.

## App folder:
Each app folder contains some of these files:
 - `credits` Contains credits for the app. This file may mention who created the app originally, who compiled it, who submitted it to Pi-Apps, etc. Few apps use this file.
 - `description` This stores the app's description. If you hover your mouse over an app in the app list, it will display a tooltip derived from the first line of this file.
 - `icon-24.png` This is a 24x24 pixel icon that is displayed in the app list.
 - `icon-64.png` This is a 64x64 pixel icon that is displayed in the Details page.
 - `install` If the app installs correctly on both 32bit and 64bit, and it only needs one install script for either CPU type, one single install script is used.
 - `install-32` This script installs an app on 32bit OS'es, and is 32bit-specific.
 - `install-64` This script installs an app on 64bit OS'es, and is 64bit-specific.
Sidenote: if an app only has an `install-32` script, then Pi-Apps will assume it's for 32bit OS'es only and will hide that app on 64bit installations.
 - `uninstall` This script uninstalls the app. It must undo all changes made during install, but with one exception: **It must not permanently delete any user-generated config!** [We don't want people's Minecraft worlds being deleted during an update.](https://github.com/Botspot/pi-apps/issues/44)

</details>

<details>
<summary>Creating an app</summary>
It's easy to make your own Pi-App.

- First, launch Pi-Apps Settings.
- Click New App.
- This launches the Create App Wizard. This series of dialog boxes will guide you through the process of making your very own app.
- It will ask for:
	- **Name** of app (**required**)
	- **Icon**: should be a **square** icon, at least **64x64** px. Note that Windows .bmp icons rarely scale properly.
	- **Website**: In general, the website link should point to where users will find **help** and more **information** about the app.
	- OS architecture **compatibility**: Select if your app is **32-bit** compatible, **64-bit** compatible, or **both**.
	- **Description**: Explain to a total noob user **what the app is**, what the app **does**, and how to get it running. 
	- **Credits**: Give yourself credit for adding it to Pi-Apps! :)
- In the subsequent pages, Pi-Apps will assist you in making your own **bash scripts** to install and uninstall the app.  

### Making an `install` script

What's a *bash script*? I'm glad you asked.  
Basically, ask yourself this question: "**What commands should I run in a terminal to install this app?**"  
Simply **write down all those commands in a file** Pi-Apps opens for you.  
Here's the `install-32` script from the Arduino app: (located at `~/pi-apps/apps/Arduino/install-32`)
```bash
#!/bin/bash

DIRECTORY="$(dirname "$(dirname "$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )")")"

function error {
  echo -e "\\e[91m$1\\e[39m"
  exit 1
}

wget https://downloads.arduino.cc/arduino-1.8.13-linuxarm.tar.xz || error "failed to download!"

tar -xf arduino-1.8.13-linuxarm.tar.xz || error "failed to extract with tar!"
arduino-1.8.13/install.sh || error "failed to run install as non-root user!"
sudo arduino-1.8.13/install.sh || error "failed run install as root user!"

rm $HOME/Desktop/arduino-arduinoide.desktop
rm arduino-1.8.13-linuxarm.tar.xz
exit 0
```
Let's walk through the script, one line at a time.  
- This stuff belongs at the top of all Pi-Apps scripts.⏬ Don't worry much about it.
```bash
#!/bin/bash

DIRECTORY="$(dirname "$(dirname "$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )")")"

function error {
  echo -e "\\e[91m$1\\e[39m"
  exit 1
}
```
- This downloads the Arduino software from [Arduino's downloads page](https://www.arduino.cc/en/software). ⏬
```bash
wget https://downloads.arduino.cc/arduino-1.8.13-linuxarm.tar.xz || error "failed to download!"
```
- Oh, but what's that ⏫? `error`? The **`error`** command is used in all Pi-Apps scripts to **exit if something goes wrong**. For example, if the above line *failed* to download Arduino for some reason, the script will **stop and talk**. (in the terminal, it will exit with a red error saying "`failed to download!`")
- This line extracts the zipped folder we just downloaded. ⏬ (again, notice the `error` command that will notify us if this current command fails)
```bash
tar -xf arduino-1.8.13-linuxarm.tar.xz || error "failed to extract with tar!"
```
- These two commands run Arduino's built-in installation bash scripts. ⏬
```bash
arduino-1.8.13/install.sh || error "failed to run install as non-root user!"
sudo arduino-1.8.13/install.sh || error "failed run install as root user!"
```
- And this remaining portion of the script will clean up unnecessary files afterwards.⏬
```bash
rm $HOME/Desktop/arduino-arduinoide.desktop
rm arduino-1.8.13-linuxarm.tar.xz
exit 0
```
- Notice that these ⏫ commands don't have `error`s. That's because we don't care if these commands fail.

### Other things to be aware of
The Arduino app was quite simple because it already included its own installation scripts. Not all apps are like this. Below are other tips that will come in handy when making your own apps, or understanding other pre-made install scripts.

- To download a github repository, you can't use `wget`. Use the `git clone` command instead. For example, `git clone https://github.com/Botspot/pi-apps`, which will download the git repository to the ~/pi-apps folder by default. (As usual, add an `|| error` clause at the end in case the download fails.)
- To install a package, don't use `apt`! Doing this causes problems, no matter which approach you try:
  - Your app could install the `ffmpeg` package when installing the app, and uninstall `ffmpeg` when uninstalling the app. What's the problem here? Some people will already have `ffmpeg` installed on the system, and they will be quite annoyed when it goes missing after uninstalling your app.
  - To solve the above issue, your app could only install the `ffmpeg` package, and *not even try* to uninstall it. This solution *would work*, but it's a very bad choice, both for disk usage, and for the Pi-Apps policy where users expect an uninstall script to undo everything.
  - Solution: **don't use `apt`.** Use Pi-Apps's **`pkg-install`** script. Pkg-install uses `apt`, but it records which packages each app installs. When you uninstall the app, the `purge-installed` script will uninstall these packages that were written down earlier.  
`pkg-install` usage:  
`"${DIRECTORY}/pkg-install" "package1 package2 package3" "$(dirname "$0")" || exit 1`  
That ⏫ is roughly equivalent to something like `sudo apt update && sudo apt install -y package1 package2 package3 || exit 1`  
And to **remove** all packages your app installed earlier:  
`"${DIRECTORY}/purge-installed" "$(dirname "$0")" || exit 1`  
In case you were wondering, the `pkg-install` and `purge-installed` scripts know which app is running them thanks to the `"$(dirname "$0")"` portion.  
 - Shortcut: create small text files using `echo` inside the install script. Many scripts use this technique to create menu button files:
```
echo "[Desktop Entry]
Name=Ultimaker Cura
GenericName=3D Printing Software
Comment=Cura converts 3D models into paths for a 3D printer. It prepares your print for maximum accuracy, minimum printing time and good reliability with many extra features that make your print come out great.
Exec=bash -c 'sudo modprobe fuse; ~/Cura.AppImage'
Icon=$(dirname $0)/icon-64.png
Terminal=false
Type=Application
MimeType=application/sla;application/vnd.ms-3mfdocument;application/prs.wavefront-obj;image/bmp;image/gif;image/jpeg;image/png;model/x3d+xml;
Categories=Graphics;Education;Development;Science;
Keywords=3D;Printing;
StartupNotify=true" > ~/.local/share/applications/cura.desktop
```
This ⏫ was taken from the Cura app's `install-32` script. It creates a file at `~/.local/share/applications/cura.desktop`. (Don't forget to make the uninstall script remove it!)
 - Delete files with `rm /path/to/file-i-wanna-delete.txt`. It's good practice to use `rm -f` to hide errors in case the file doesn't exist. For deleting entire folders, use `rm -rf`.
 - Move files to the Trash with `gio trash /path/to/file/or/folder-i-wanna-delete`.

### Making an `uninstall` script
It should **undo all changes** made during installation, with one exception: uninstalling an app must not delete the app's configuration files. [We don't want people's Minecraft worlds being deleted during an update.](https://github.com/Botspot/pi-apps/issues/44)  
Here's the Arduino app's `uninstall` script. ⏬
```bash
#!/bin/bash
arduino-1.8.13/uninstall.sh
sudo arduino-1.8.13/uninstall.sh
rm -rf arduino-1.8.13
```
You may notice that the `DIRECTORY=` and `function error` lines are missing. ⏫ In this case, leaving them out is fine, but it's bad form. Updating the Arduino app now would trigger an unneeded pop-up for all users, so it stays as-is.  
Script explanation:  
- These run scripts that have resided in Arduino's folder. ⏬ They will remove the menu buttons for us and take care of most of the uninstall process.  
```
arduino-1.8.13/uninstall.sh
sudo arduino-1.8.13/uninstall.sh
```
- And this will delete the Arduino folder. ⏬
```
rm -rf arduino-1.8.13
```

</details>

## Directory tree
 - `~/pi-apps/` This is the main folder that holds everything. In all scripts, it is represented as the `${DIRECTORY}` variable.
   - `CHANGELOG.md` [This file](https://github.com/Botspot/pi-apps/blob/master/CHANGELOG.md) is a written history for all important events for Pi-Apps, including dates for when each app was added. It's worth a read! :)
   - `COPYING` This file contains the GNU General Public License v3 for Pi-Apps.
   - `createapp` GUI script - this is run when you click "Create App" in Settings.  
   ![create app](https://github.com/Botspot/pi-apps/blob/master/icons/screenshots/create%20app.png?raw=true)
   - `gui` The main GUI window. This script  is responsible for displaying the App list and the Details page.
   ![main window](https://github.com/Botspot/pi-apps/blob/master/icons/screenshots/main%20window.png?raw=true)
   - `install` This script is used to install Pi-Apps. Adds a couple menu launchers, and makes sure YAD is installed.
   - `manage` This script handles installing, uninstalling, and updating Apps. It does not check or update any files outside the `apps/` directory.
   - `pi-apps.desktop` This file is a .desktop launcher, exactly the same as the main Pi-Apps launcher in Menu.
   - `pkg-install` If an App requires some `apt` packages in order to run, its `install` script will run `pkg-install`. Pkg-install records which app installed what (in the installed-packages folder BTW), so when you uninstall an App, those packages will be removed.
   - `preload` This script generates the app list for the `gui` script. If no files have been modified since last launch, `preload` won't regenerate the app list, but instead will return a previously saved version of the list. This approach reduces Pi-Apps's launch time by around 1 second.
   - `purge-installed` This does exactly the opposite of `pkg-install` This script is run when an App is being uninstalled. Purge-installed will uninstall all packages the app installed.
   - `README.md` You are reading this file right now!
   - `settings` This GUI script is executed when you launch 'Pi-Apps Settings' from the Menu.
   ![settings](https://github.com/Botspot/pi-apps/blob/master/icons/screenshots/settings.png?raw=true)
   - `uninstall` Uninstalls Pi-Apps and removes the menu launchers. Asks permission to uninstall YAD.
   - `updater` This GUI script is executed every time  the `gui` script is launched. Updater first compares today's date against the `last-update-check` file. If it's time to check for updates, `updater` first checks for App updates, then checks for other files/folders that have been modified or created. If anything can be updated, a dialog will open and ask permission to update:  
   ![updates](https://github.com/Botspot/pi-apps/blob/master/icons/screenshots/updates%20available.png?raw=true)
   - `data/` This folder holds all local data that should not be overwritten by updates.
     - `categories` - This directory stores everything relating to which categories your apps are in. Currently it only contains one file:
       - `structure` - The file that keeps track of which apps are in which categories. It's edited by the Pi-Apps Category Editor.
     - `installed-packages/` This keeps track of any/all APT packages each app installed. This folder is written to from the `pkg-install` script.
     For example, if Pi Power Tools installs `xserver-xephyr` and `expect`, then the `installed-packages/Pi Power Tools` file will contain "xserver-xephyr expect".
     - `preload/` This directory is used by the `preload` script to improve Pi-Apps' launch time.
       - `timestamps` This file stores timestamps for the most recently modified app, the most recently modified setting, and the most rencently modified status file.
       If any of these entries don't match when `preload` is called, then the app list will be regenerated.
       - `LIST` This file holds the app list. The entire file's contents is piped into the YAD dialog box.
     - `settings/` This stores the current settings saved by the 'Pi-Apps Settings' window. Each file contains one setting. For example, the file `settings/Preferred text editor` contains "geany" by default.
     - `status/` This folder stores all installation information for all apps.
     If you install Zoom, then the `status/Zoom` file will be created, containing "installed". Installed apps will have this status icon in the app list: ![installed](https://github.com/Botspot/pi-apps/blob/master/icons/installed.png?raw=true)  
     If installation was unsuccessful, then the file will contain "corrupted". The corresponding icon looks like: ![corrupted](https://github.com/Botspot/pi-apps/blob/master/icons/corrupted.png?raw=true)  
     If the app has been uninstalled successfully, the icon is ![uninstalled](https://github.com/Botspot/pi-apps/blob/master/icons/uninstalled.png?raw=true)  
     If the app has never been installed or uninstalled, then its `status` file will not exist. The icon for that is: ![none](https://github.com/Botspot/pi-apps/blob/master/icons/none.png?raw=true). Notice the slight amount of red in the center. That's how you can tell the difference.  
     - `update-status/` This folder keeps track of which apps can be updated. Each file's name is of an app, so `update-status/Zoom` stores the update status of the Zoom app. This folder is refreshed whenever `~/pi-apps/manage check-all` is run.
     "latest" means that app is up to date.
     "new" means that app is new from the repository. (in other words, it does not exist locally)
     "local" means that app does not exist on the repository.
     "updatable" means the repository's version and the local version don't match.
     - `hidelist` This file contains app names that should be hidden from the app list. `template` should always be there. If your Pi runs TwisterOS, then `hidelist` will contain several more app names, like balenaEtcher, for example.
     - `last-update-check` This contains a date in numeric form. (Jan. 1 would be `1`, Dec. 31 would be `365`.) The `updater` script uses this file to keep track of when updates were last checked.
   - `etc/` This folder is basically an extension of the main `pi-apps/` folder. Its contents don't need to clutter up the main directory, but they can't go in `data/` because these files should be kept up-to-date.
     - `setting-params/` This stores the GUI entries for the Settings window. For example, if I wanted to add a new setting called "Auto donate", with 'Yes' and 'No' parameters, with Yes being the default setting, I'd create a new file called `setting-params/Auto donate` and it would contain this:
     ```
     #Donate automatically to Botspot every time Pi-Apps is launched
     Yes
     No
     ```
     Now, the next time Settings is opened, you will see:  
     ![auto-donate](https://i.ibb.co/nzBNgFT/auto-donate.png)  
     With this file-based approach, adding new settings (and/or parameters) is much easier to do and in a standardized way. (As opposed to adding new settings by editing a bash script)
     - `bitlylink` - Simple bash script that fetches a Pi-Apps analytics link, if enabled.
     - `categoryedit` - This script is the Pi-Apps Category Editor.
     - `git_url` This simple file stores this link: https://github.com/Botspot/pi-apps
     If you fork this repository and make changes, you will want Pi-Apps checking for updates from your repository, not this main one. Simply change the URL in this file to use your repository.
     - `preload-daemon` - A simple wrapper for the `preload` script. It periodically updates all app lists for each category for minimal latency.
     - `terminal-run` - This script is used to run multi-line scripts in a terminal. As easy as that sounds, in reality each terminal is different. So to be compatible with all Raspberry Pi OS'es, `terminal-run` is necessary to ensure terminal windows open and run properly.
   - `icons/` This stores all the icons that are embedded into various dialogs.
     - `screenshots/` Stores screenshots of various dialogs, mainly used as an image hosting service, though I suppose they could come in handy if an offline help dialog was made.
   - `update/` This folder holds the latest version of the entire Pi-Apps repository. It's contents is re-downloaded every time the `updater` script checks for updates. It is used to compare file hashes, detect when an app or file can be updated, and is used to copy new file versions into the main `pi-apps/` directory during an update.
## Badge
If your application is on Pi-Apps, please consider adding this pretty badge/hyperlink to your README:  
[![badge](https://github.com/Botspot/pi-apps/blob/master/icons/badge.png?raw=true)](https://github.com/Botspot/pi-apps)  
Embed code:  
```
[![badge](https://github.com/Botspot/pi-apps/blob/master/icons/badge.png?raw=true)](https://github.com/Botspot/pi-apps)  
```

### Q&A with Botspot
 - Why did you develop Pi-Apps?  
> For a long time I have been saddened by how few people are aware of open-source RPi software projects. Many of these projects are extremely useful and beneficial, but there has never been a good way to distribute them.  
> The repositories don't host them, and they usually aren't advertised very well, so how will people find them?  
> Most people never find them.  
> One day I realized: Why not make my own app store that specializes in all the community RPi software projects out there? It will help more users find the software, and at the same time it would provide a super simple way to install them.  
> (Which would you rather do - click a shiny Install button, or copy-n-paste a bunch of commands from a sketchy blog tutorial?)

 - How long did it take to program this?  
> About two weeks of nearly non-stop coding to make Pi-Apps from the ground-up. And since then, I've regularly fixed bugs, solved problems, adding new features, and handled new app submissions.

 - Is Pi-Apps still under development?
> Sure is! Initial development is done for the most part, and I don't see any more [major features](https://github.com/Botspot/pi-apps#to-do) being added to Pi-Apps's core functionality. (besides maybe allowing `apt`-package apps in the future)
> But, there's always an app or two that need attention, and dozens of app requests. It's enough work to keep a *team* of developers busy.

 - How can I help?
> - It's always nice to leave a kind word about Pi-Apps on forums and in comments. In addition to helping others find this useful software, you may just get added to [the hall of fame](https://github.com/Botspot/pi-apps#what-do-others-say-about-pi-apps)!
> - You can [donate](https://paypal.me/josephmarchand) if you'd like. The money goes to me (minus the Paypal fees), and helps support future open-source development. Some of the money goes to placing [bounties](https://github.com/ptitSeb/box86/issues/296) on apps that I'd like to see completed by someone else who has skills/time that I don't have.
> - You can look through the [list of app requests](https://github.com/Botspot/pi-apps/issues) and help create the scripts for them.
> - If you see someone complaining about a broken app on Youtube, Reddit, or Facebook, please encourage them to join the [Pi-Apps Discord](https://discord.gg/RXSTvaUvuu) or to [open an issue](https://github.com/Botspot/pi-apps/issues/new) to get the problem solved. (I'm not on those sites very often.)
> - You could help troubleshoot/diagnose issues others are having.
