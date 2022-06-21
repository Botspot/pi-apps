<p align="center">
    <a href="https://pi-apps.io">
        <img src="https://github.com/Botspot/pi-apps/blob/master/icons/proglogo.png?raw=true" alt="Pi-Apps logo">
    </a>
</p>
<p align="center">The most popular app store for Raspberry Pi computers. 100% free, open-source and written in shell scripts.
<p align="center">
  <a href="https://github.com/Botspot/pi-apps/blob/master/CHANGELOG.md">
    View changelog</a>
  |
  <a href="https://github.com/Botspot/pi-apps/wiki/Apps-List">
    Apps List</a>
  |
  <a href="https://github.com/Botspot/pi-apps/issues/new?template=bug-report.yml">
    Report an error</a>
  |
  <a href="https://github.com/Botspot/pi-apps/issues/new?template=suggestion.yml">
    Make a general suggestion</a>
  |
  <a href="https://github.com/Botspot/pi-apps/issues/new?assignees=&labels=App+Request&template=app-suggestion.yml&title=EDIT+ME+Include+the+app+name">
    Suggest new app</a>
  |
  <a href="https://github.com/Botspot/pi-apps/issues/new?assignees=&labels=App+Request%2CZip%2FPR+included&template=app-submission.yml&title=EDIT+ME+Include+the+app+name+and+if+it+is+a+Package+app+or+an+Install+based+App">
    Submit a new app</a>

<p align="center">
    <a href="https://github.com/Botspot/pi-apps/stargazers"><img src="https://img.shields.io/github/stars/Botspot/pi-apps" alt="stars"></a>
    <a href="https://github.com/Botspot/pi-apps/network/members"><img src="https://img.shields.io/github/forks/Botspot/pi-apps" alt="forks"></a>
    <a href="https://github.com/Botspot/pi-apps/graphs/contributors"><img src="https://img.shields.io/github/contributors/Botspot/pi-apps" alt="contributors"></a>
    <a href="https://github.com/Botspot/pi-apps/pulls"><img src="https://img.shields.io/github/issues-pr/Botspot/pi-apps" alt="prs"></a>
    <a href="https://github.com/Botspot/pi-apps/issues"><img src="https://img.shields.io/github/issues/Botspot/pi-apps" alt="issues"></a>
    <a href="https://github.com/Botspot/pi-apps/blob/master/COPYING"><img src="https://img.shields.io/github/license/Botspot/pi-apps" alt="license"></a>
    <a href="https://discord.gg/RXSTvaUvuu"><img src="https://img.shields.io/discord/770629697909424159.svg?color=7289da&label=Discord%20server&logo=discord" alt="Join the Discord server"></a>

<p align="center"><strong>Made with &#10084; by <a href="https://github.com/Botspot">Botspot</a></strong> and <a href="https://github.com/Botspot/pi-apps/graphs/contributors">contributors</a>

## Introduction
Let's be honest: **Linux is harder to master than Windows.** Sometimes it's not user-friendly, and following an outdated tutorial may break your Raspberry Pi's operating system.  
There is no centralized software repository, except for the `apt` repositories which lack many desktop applications.  
Surely there is a better way! **There is.**  
Introducing Pi-Apps, a well-maintained collection of app installation-scripts that you can run with **one click**.  

Pi-Apps now serves **over 1,000,000 people** and hosts [over 200 apps](https://github.com/Botspot/pi-apps/wiki/Apps-List).

## Install Pi-Apps
Open a terminal and run this command:
```bash
wget -qO- https://raw.githubusercontent.com/Botspot/pi-apps/master/install | bash
```
<img src="icons/screenshots/main%20window.png?raw=true" align="right" height="270px"/>

#### Supported systems:

- [Raspberry Pi OS](https://www.raspberrypi.com/software/operating-systems/) (32-bit/64-bit) (Buster/Bullseye): fully supported.
- Kali Linux, Ubuntu, Ubuntu Mate, any other Debian-based ARM OS: Pi-Apps should mostly work but you may encounter errors for some apps.
- Android, ChromeOS, non-ARM, non-Debian operating systems: Not supported. Your mileage may vary.

<details>
<summary><b>To install Pi-Apps manually</b> if you prefer to see what happens under the hood</summary>
 
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
- Pi-apps will automatically check for updates on boot and display a notification to update.
- To manually run the updater, use this command: `~/pi-apps/updater gui`
- It also supports a cli interface: `~/pi-apps/updater cli`

## What do others say about Pi-Apps?
> Message from a **[pi-top](https://pi-top.com)** employee: "Happy to say that I recommend pi-apps to almost every school I work with when they start using Raspberry Pi"

> [Video by **ETA Prime**](https://www.youtube.com/watch?v=oqNWJ52DLes): "It's an awesome Raspberry Pi app store and it works really well and there's lots of great stuff in here and it's super easy to install. I want to give the devs of Pi-Apps a big shout-out."

> [Video by **leepspvideo**](https://www.youtube.com/watch?v=zxyWQ3FV98I): "Thanks so much to Botspot for creating this; it's a great program."

> [Video by **Novaspirit Tech**](https://youtu.be/9dO448vYv18?t=164): "This is an awesome application for your Pi to install applications like WoR-flasher."

> Email from a **Raspberry Pi employee**: "I gave Pi-Apps a go a while back and have suggested it to others quite a few times.
> We can't provide all the options people may want, so it helps a lot that there are people like you who can help bridge the gap. Thank you Botspot!"

> [**ShiftPlusOne** (Raspberry Pi forum moderator)](https://www.raspberrypi.org/forums/viewtopic.php?f=63&t=290329&p=1755860#p1755857): "Thanks for the great work making it all simple for everybody."

> Email from [**Sakaki** (legendary RPi developer)](https://github.com/sakaki-): "Good luck with your projects, Botspot, you're really making waves!"

> Message from one of our many satisfied users: "Thank you for making pi-apps, it has helped me a ton (no more searching hours to find how to install etcher) and I cannot thank you enough."

## Basic usage
Pi-Apps is very easy to use.  
- This is the **main window**.  
![main window](icons/screenshots/main%20window.png?raw=true)  
  - ![icon](icons/screenshots/buttons/search.png?raw=true) Search for apps.
  - ![icon](icons/screenshots/buttons/settings.png?raw=true) Open pi-apps settings.
  - Click on a category to open it.
    
- Opening a category will reveal a **list of apps**:  
![app list](icons/screenshots/app%20list.png?raw=true)  
  - ![icon](icons/screenshots/buttons/back2.png?raw=true) Go back to the main list of categories.
  - Click on an App name to see its details (see **details window** below)

- On the right is the app **details window**:  
![details](icons/screenshots/details%20window.png?raw=true)  
  - ![icon](icons/screenshots/buttons/scripts.png?raw=true) View the shell-scripts responsible for installing or uninstalling the selected app.
  - ![icon](icons/screenshots/buttons/edit.png?raw=true) Modify the app's description, icons, or scripts. (This button is hidden unless you enable it in Settings)
  - ![icon](icons/screenshots/buttons/install.png?raw=true) Install the selected app.
  - ![icon](icons/screenshots/buttons/uninstall.png?raw=true) Uninstall the selected app.
  - ![icon](icons/screenshots/buttons/credits.png?raw=true) See who played a part in adding the app.
  - ![icon](icons/screenshots/buttons/errors.png?raw=true) If the selected app failed to install, this button will allow you to see its error log.
    
- Pi-Apps Settings can be configured by launching Menu -> Preferences -> Pi-Apps Settings.  
![settings](icons/screenshots/settings.png?raw=true)  
In addition to changeable settings, this window also gives access to these tools:
  - ![icon](icons/screenshots/buttons/categories.png?raw=true) Does that one app seem to be in the wrong category? With this button, you can change it.
  - ![icon](icons/screenshots/buttons/new%20app.png?raw=true) Create a new app with a wizard-style set of dialogs. We recommend reading [the tutorial](https://github.com/Botspot/pi-apps/wiki/Creating-an-app).
  - ![icon](icons/screenshots/buttons/log%20files.png?raw=true) View the past weeks-worth of installation logs. This is useful if you ever encounter an app that won't install and want to see the terminal output after you closed the terminal.
  - ![icon](icons/screenshots/buttons/import%20app.png?raw=true) This allows you to easily import a 3rd-party app from elsewhere. It helps Pi-Apps developers test upcoming apps for reliability on a variety of systems.

To learn more about Pi-Apps, read [the documentation](https://github.com/Botspot/pi-apps/blob/master/DOCUMENTATION.md) and the [wiki](https://github.com/Botspot/pi-apps/wiki).

## :raised_hands: Contributing
You don't need to be a programmer to help!  
- The easiest way to help is by "Starring" our repository - it helps more people find Pi-Apps. (Scroll to the top of this page and on the right there is a "Star" button)
- If you know somebody else who has a Raspberry Pi, feel free to tell them about Pi-Apps. We would offer you a referral discount, but Pi-Apps is free, so... `¯\_(ツ)_/¯`
- You can [make suggestions](https://github.com/Botspot/pi-apps/issues/new?template=suggestion.yml), [report bugs](https://github.com/Botspot/pi-apps/issues/new?template=bug-report.yml), or [suggest apps](https://github.com/Botspot/pi-apps/issues/new?template=app-suggestion.yml).
- You can [create and submit an app](https://github.com/Botspot/pi-apps/wiki/Creating-an-app). Don't worry, it's about as easy as using the terminal (and it's even easier if you're submitting a simple apt-package)!
- You can also join our cheerful community: <a href="https://discord.gg/RXSTvaUvuu"><img src="https://img.shields.io/discord/770629697909424159.svg?color=7289da&label=Discord%20server&logo=discord" alt="Join the Discord server"></a>

## Badge
If your application is on Pi-Apps, please consider adding this pretty badge/hyperlink to your README (dark and light modes available):  

[![badge](https://github.com/Botspot/pi-apps/blob/master/icons/badge.png?raw=true)](https://github.com/Botspot/pi-apps)  [![badge](https://github.com/Botspot/pi-apps/blob/master/icons/badge-light.png?raw=true)](https://github.com/Botspot/pi-apps)

Embed code (Dark):  
```
[![badge](https://github.com/Botspot/pi-apps/blob/master/icons/badge.png?raw=true)](https://github.com/Botspot/pi-apps)
```
Embed code (Light):  
```
[![badge](https://github.com/Botspot/pi-apps/blob/master/icons/badge-light.png?raw=true)](https://github.com/Botspot/pi-apps)
```

### Q&A with Botspot
 - Why did you make Pi-Apps?  
> For a long time I have been saddened by how difficult it is to install software on Linux. In that regard, nearly all other operating systems put us to shame.  
> How will people discover useful, free software?  
> Most people **don't**.  
> One day I realized: Why not make a collection of scripts to install popular apps? This would save so much time, and makes it much easier to use a Raspberry Pi as a daily, desktop computer solution.  

 - How long did it take to program this?  
> Why would you think it's not still under development? 🤪  
> Pi-Apps took around 14 days to lay the groundwork, and ever since then it has been continually, and exponentially, improved. I (Botspot) am not the sole programmer anymore - [others](https://github.com/Botspot/pi-apps/graphs/contributors) have stepped in and made improvements too.

 - Is Pi-Apps free?
> Absolutely! In the future, I may allow donations, but Pi-Apps itself will always be free and open-source.
