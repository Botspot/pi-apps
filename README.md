<p align="center">
    <img src="https://github.com/Botspot/pi-apps/blob/master/icons/proglogo.png?raw=true" alt="Pi-Apps logo">
</p>
<p align="center">The most popular app store for Raspberry Pi computers. 100% open-source bash scripts (including the GUI).
<p align="center">
  <a href="https://github.com/Botspot/pi-apps/blob/master/CHANGELOG.md">
    View changelog</a>
|
  <a href="https://discord.gg/RXSTvaUvuu">
    Join the <img src="https://img.shields.io/discord/770629697909424159.svg?color=7289da&label=Discord%20server&logo=discord" alt="Join the Discord server"></a>
  |
  <a href="https://github.com/Botspot/pi-apps/issues/new?template=bug_report.md">
    Report an error</a>
  |
  <a href="https://github.com/Botspot/pi-apps/issues/new?template=suggestion.md">
    Submit a suggestion</a>
  |
  <a href="https://github.com/Botspot/pi-apps/issues/new?template=app-request.md">
    Submit an app</a>
<p align="center"><strong>Made with &#10084; by <a href="https://github.com/Botspot">Botspot</a></strong> and <a href="https://github.com/Botspot/pi-apps/graphs/contributors">others</a>

## Introduction
Let's be honest: **Linux is harder to master than Windows.** Sometimes it's not user-friendly, and following an outdated tutorial may break your Raspberry Pi's operating system.  
There is no centralized software repository, except for the `apt` repositories which lack many desktop applications.  
Surely there is a better way! **There is.**  
Introducing Pi-Apps, an expanding, well-maintained collection of app installation-scripts that you can run with **one click**.  

To learn more:
- [ETA Prime's video](https://www.youtube.com/watch?v=oqNWJ52DLes) to install Minecraft with Pi-Apps. At the end, he says:
  > "It's an awesome Raspberry Pi app store and it works really well and there's lots of great stuff in here and it's super easy to install. I want to give the devs of Pi-Apps a big shout-out."
- [Pi-Apps walkthrough by leepspvideo](https://www.youtube.com/watch?v=zxyWQ3FV98I). He said:
  > "Thanks so much to Botspot for creating this; it's a great program."

## To install Pi-Apps
```
wget -qO- https://raw.githubusercontent.com/Botspot/pi-apps/master/install | bash
```
<img src="https://github.com/Botspot/pi-apps/blob/master/icons/screenshots/main%20window.png?raw=true" align="right" width="230px"/>
Supported systems:

- Raspberry Pi OS 32-bit: fully supported.
- Twister OS: fully supported.
- Raspberry Pi OS 64-bit: fully supported.
- Bullseye, Kali, Ubuntu: you may encounter errors for some apps.
- Android, ChromeOS, non-ARM, non-Debian: Not supported. Your mileage may vary.

<details>
<summary><b>To install manually</b> if you prefer to see what happens under the hood</summary>
 
```
git clone https://github.com/Botspot/pi-apps
~/pi-apps/install
```
</details>

<details>
<summary><b>To uninstall Pi-Apps</b></summary>
This will not uninstall any apps that you installed through Pi-Apps.

```
~/pi-apps/uninstall
```
</details>

## To run Pi-Apps
- From the start menu: Accessories -> Pi Apps
- Use the terminal-command: `pi-apps`
- Run Pi-Apps from its directory: `~/pi-apps/gui`
## To Update Pi-Apps
- Pi-apps will update automatically
- To forcefully update run `~/pi-apps/updater gui`
- Or if you prefer cli interface `~/pi-apps/updater cli`

## What do others say about Pi-Apps?
> "This is an awesome application for your Pi to install applications like WoR-flasher." - **[Novaspirit Tech](https://youtu.be/9dO448vYv18?t=164)** (large RPi YouTuber)

> "I gave Pi-Apps a go a while back and have suggested it to others quite a few times.
> We can't provide all the options people may want, so it helps a lot that there are people like you who can help bridge the gap. Thank you Botspot!" - email from a Raspberry Pi employee

> "Thanks for the great work making it all simple for everybody." - [**ShiftPlusOne**](https://www.raspberrypi.org/forums/viewtopic.php?f=63&t=290329&p=1755860#p1755857) (RPi moderator) on the RPi forums

> "Good luck with your projects, Botspot, you're really making waves!" - email from **[Sakaki](https://github.com/sakaki-)** - a legendary RPi developer

<hr>

# Read [the wiki](https://github.com/Botspot/pi-apps/wiki)  for the full documentation

### Basic usage
- This is the **main window**.  
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

## :raised_hands: Contributing
You don't need to be a programmer to help!  
You can [make suggestions](https://github.com/Botspot/pi-apps/issues/new?template=suggestion.md), [report bugs](https://github.com/Botspot/pi-apps/issues/new?template=bug_report.md), [suggest apps](https://github.com/Botspot/pi-apps/issues/new?template=app-request.md), or if you know a little bash you could [submit an app](https://github.com/Botspot/pi-apps/wiki/Creating-an-app)!

You can also join our cheerful community: <img src="https://img.shields.io/discord/770629697909424159.svg?color=7289da&label=Discord%20server&logo=discord" alt="Join the Discord server"></a>

## To-do

- [X] Make an **app-creation assistant**. (completed with the `createapp` script)  
- [X] Add Pi-Apps to **Twister OS**. (completed on 11/2/2020 via the Twister 1.8.5 patch.)  
- [X] Support individual **32-bit** and **64-bit** install scripts.  
- [X] Allow **multiple apps** to be selected from the app list and installed sequentially.  
- [X] Add a **search function** to the app list. To enable it, switch to an **xlunch** theme in **Pi-Apps Settings** -> **App List Style**.
- [X] Break up the long app list with some **categories**.  
- [X] Add a new category containing all apps currently **installed**.
- [X] Make updates display directly in the app-list.

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
> The repositories don't host them, and they are rarely advertised well, so how will people find them?  
> Most people never find them.  
> One day I realized: Why not make an app store that specializes in all the community RPi software projects out there? It will help more users find the software, and at the same time it would provide a super simple way to install them.  
> (Which would you rather do - click an Install button, or copy-n-paste multiple commands from someone's blog?)

 - How long did it take to program this?  
> To lay the groundwork, it took two weeks of nearly non-stop coding. Since then, I've continually optimized performance, fixed bugs, added new features, and added numerous new apps.

 - Is Pi-Apps still under development?
> Sure is! We're always on the lookout for new app-suggestions, and solve app-installation issues by reading incoming bug reports.

 - Is Pi-Apps free?
> Absolutely!
