# Pi-Apps   ![logo](https://github.com/Botspot/pi-apps/blob/master/icons/logo-64.png?raw=true)
## Raspberry Pi App Store for Open Source Projects

Some of the best software available for the Pi plaform is the hardest to install.  
Pi-Apps brings all this hard-to-install software to one place, and simplifies the installation process to two clicks with the mouse.

## What do others say about Pi-Apps?
> "It's an awesome Raspberry Pi app store and it works really well and there's lots of great stuff in here and it's super easy to install.
> I want to give the devs of Pi-Apps a big shout-out." - **[ETA Prime](https://www.youtube.com/watch?v=oqNWJ52DLes)**

> "Awesome. Thanks for doing this." - **[Novaspirit Tech](youtube.com/novaspirittech)**

> "It definitely looks really cool.
> Thanks so much to Botspot for creating this; it's a great program." - **[leepspvideo](https://www.youtube.com/watch?v=zxyWQ3FV98I)**

> "I love pi-apps. It's great and installs tons of useful software that people don't know how to install. Great work Botspot!" - **[Raspberry Pi Projects and More](https://www.youtube.com/channel/UCkv0fW0EIUTKw6pYEnTjTbQ)**

> "Pi apps has really terminated the use of the command-line." - vedforeal from Discord

> "Thanks for the great work making it all simple for everybody." - [**ShiftPlusOne** (RPi moderator)](https://www.raspberrypi.org/forums/viewtopic.php?f=63&t=290329&p=1755860#p1755857)

> "Excellent job making Pi-Apps. Everyone is using it now." - FlyingCow from Discord

> "Good luck with your projects, Botspot, you're really making waves!" - **[Sakaki](https://github.com/sakaki-)**

> "I love Pi-Apps and I chase all my friends around tryna get them to install it" - Beiop from Discord

## To install Pi-Apps
```
git clone https://github.com/Botspot/pi-apps
~/pi-apps/install
```
The install script ensures YAD is installed, creates two menu buttons, and an autostarted updater. Nothing is modified outside your home directory.
## To run Pi-Apps
Menu -> Accessories -> Pi Apps, or type `./pi-apps/gui`.
### Useful links
- [![Pi-Apps Discord server](https://img.shields.io/discord/770629697909424159.svg?color=7289da&label=Pi-Apps%20Discord%20server&logo=discord)](https://discord.gg/RXSTvaUvuu)
- [Send Botspot a donation](https://paypal.me/josephmarchand)
- [View changelog](https://github.com/Botspot/pi-apps/blob/master/CHANGELOG.md)
- [Report an error](https://github.com/Botspot/pi-apps/issues/new)
- [Leepspvideo Pi-Apps walkthrough](https://www.youtube.com/watch?v=zxyWQ3FV98I)
- [ETA Prime's Pi-Apps & Minecraft Java video](https://www.youtube.com/watch?v=oqNWJ52DLes)
### Basic usage
- This is the **main window**:  
![main window](https://github.com/Botspot/pi-apps/blob/master/icons/screenshots/main%20window.png?raw=true)  
Use the main window to quickly browse the selection of apps and easily install them.  
- If you double-click an app, or select and app and click Details, you will see the **Details window**.  
![details](https://github.com/Botspot/pi-apps/blob/master/icons/screenshots/details%20window.png?raw=true)  
- The **updater window** may pop up when you launch Pi-Apps, or when your Pi boots:  
![updates](https://github.com/Botspot/pi-apps/blob/master/icons/screenshots/updates%20available.png?raw=true)  
- Pi-Apps **Settings** can be configured by launching Menu -> Preferences -> Pi-Apps Settings.  
![settings](https://github.com/Botspot/pi-apps/blob/master/icons/screenshots/settings.png?raw=true)  
- If you click **New App** in Settings, you can easily create your own Apps using the Create App Wizard.
![create app](https://github.com/Botspot/pi-apps/blob/master/icons/screenshots/create%20app.png?raw=true)  
It helps you select an icon, create & debug install/uninstall scripts, write a description, and more.  
## To-do
- [X] Make app creation system. (completed with the `createapp` script)  
- [X] Add Pi-Apps to Twister OS. (completed on 11/2/2020 via the Twister 1.8.5 patch.)  
- [X] Make 32-bit and 64-bit install scripts.  
- [X] Allow multiple apps to be selected from the app list and be installed simultaneously.  
- [X] Add a search function to the app list. It's still experimental: to enable it, switch to **xlunch** in **Pi-Apps Settings** -> **App List Style**.

## How it works
 - Each 'App' is simply a small `install` script, `uninstall` script, two icon sizes, and two text files containing the description and a website URL.
 - Each App is stored in its own separate directory. `~/pi-apps/apps/` holds all these app directories. The Zoom app, for example, would be located at `~/pi-apps/apps/Zoom/`.
 - Because of the contained nature of each app folder, it's really easy to 'package' your own apps: just put the folder in a ZIP file and send it to friends. (or upload it as a [new issue](https://github.com/Botspot/pi-apps/issues/new) so your app can be added to Pi-Apps)
 - When you click Install, the selected App's `install` script is executed. (Or, in some cases, the `install-32` or `install-64` script is executed.)
 - When you click Uninstall, the selected App's `uninstall` script is executed.
## Terminal usage
 - The `manage` script is similar to `apt-get` - it handles installing apps, uninstalling them, keeping them updated, and more. `Manage` does not include a GUI, though in some cases, a dialog may appear to ask you a question.
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
 
### Directory tree
 - `~/pi-apps/` This is the main folder that holds everything. In all scripts, it is represented as the `${DIRECTORY}` variable.
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
     - `settings/`This stores the current settings saved by the 'Pi-Apps Settings' window. Each file contains one setting. For example, the file `settings/Preferred text editor` contains "geany" by default.
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
     - `preload/` This directory is used by the `preload` script to improve Pi-Apps' launch time.
       - `timestamps` This file stores timestamps for the most recently modified app, the most recently modified setting, and the most rencently modified status file.
       If any of these entries don't match when `preload` is called, then the app list will be regenerated.
       - `LIST` This file holds the app list. The entire file's contents is piped into the YAD dialog box.
     - `installed-packages/` This keeps track of any/all APT packages each app installed. This folder is written to from the `pkg-install` script.
     For example, if Pi Power Tools installs `xserver-xephyr` and `expect`, then the `installed-packages/Pi Power Tools` file will contain "xserver-xephyr expect".
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
     - `git_url` This simple file stores this link: https://github.com/Botspot/pi-apps
     If you fork this repository and make changes, you will want Pi-Apps checking for updates from your repository, not this main one. Simply change the URL in this file to switch to your repository.
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
> 
