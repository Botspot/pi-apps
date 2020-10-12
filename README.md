# Pi-Apps   ![logo](https://github.com/Botspot/pi-apps/blob/master/icons/logo-64.png?raw=true)
## Raspberry Pi App Store for Open Source Projects

There are many open-source, community-developed software projects for Raspberry Pi, yet very few people know about them. Pi-Apps aims to improve that, functioning as a software catalog and standardizing installation.

**Pi-Apps is very new and is a work in progress.** Please [report](https://github.com/Botspot/pi-apps/issues/new) any errors you encounter.

### To install Pi Apps
```
git clone https://github.com/Botspot/pi-apps
/home/pi/pi-apps/install
```
The install script ensures YAD is installed and creates a menu button. Nothing is modified outside your home directory.
### To run Pi Apps
Menu -> Accessories -> Pi Apps, or type `./pi-apps/gui`.
### Basic usage
- This is the **main window**:  
![main window](https://github.com/Botspot/pi-apps/blob/master/icons/screenshots/main%20window.png?raw=true)  
Use the main window to quickly browse the selection of apps and easily install them.  
- If you double-click an app, or select and app and click Details, you will see the **Details window**.  
![details](https://github.com/Botspot/pi-apps/blob/master/icons/screenshots/details%20window.png?raw=true)  
- The **updater window** may pop up when you launch Pi-Apps:  
![updates](https://github.com/Botspot/pi-apps/blob/master/icons/screenshots/updates%20available.png?raw=true)  
Unless you have a very good reason not to, clicking 'Update now' is strongly recommended.  
- Pi-Apps **Settings** can be configured by launching Menu -> Preferences -> Pi-Apps Settings.  
![settings](https://github.com/Botspot/pi-apps/blob/master/icons/screenshots/settings.png?raw=true)  
- If you click **New App** in Settings, you can easily create your own Apps with a wizard-style sequence of windows.  
![create app](https://github.com/Botspot/pi-apps/blob/master/icons/screenshots/create%20app.png?raw=true)  
It helps you select an icon, create & debug install/uninstall scripts, write a description, and more.  
### How it works
 - Each 'App' is simply a small `install` script, `uninstall` script, two icon sizes, and two text files containing the description and a website URL.
 - Each App is stored in its own separate directory. `/home/pi/pi-apps/apps/` holds all these app directories. The Zoom app, for example, would be located at `/home/pi/pi-apps/apps/Zoom/`.
 - Because of the contained nature of each app folder, it's really easy to 'package' your own apps: just put the folder in a ZIP file and send it to friends. (or upload it as a [new issue](https://github.com/Botspot/pi-apps/issues/new) so your app can be added to Pi-Apps)
 - When you click Install, the selected App's install script is executed.
 - When you click Uninstall, the selected App's uninstall script is executed.
