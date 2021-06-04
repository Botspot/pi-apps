![logo](https://github.com/Botspot/pi-apps/blob/master/icons/proglogo.png?raw=true)
## 树莓派应用商店 - 专为开源项目提供
Languages: [English](./README.md) | 简体中文

Linux 比 Windows 更难掌握。它面向高级用户，如果你照着教程做，可能还是会遇到问题。由于 `apt` 源中缺少可用的软件，因此大多数树莓派所有者从未充分利用树莓派来发挥其完整 PC 的潜力。
正是由于这个原因，很多**树莓派都在吃灰**。我们要改变这个状况！
简单地说，`Pi-Apps`是一个可以一键安装的预制应用程序列表。

**[ETA Prime](https://www.youtube.com/watch?v=oqNWJ52DLes)**（知名树莓派 YouTuber）说：

> “这是一个很棒的树莓派应用商店。它确实能正常运行，里面有许多很棒的东西，并且安装起来非常容易。
> 我想向 Pi-Apps 的开发人员大声疾呼。”

## 安装 Pi-Apps
```
wget -qO- https://cdn.jsdelivr.net/gh/Botspot/pi-apps@master/install | bash
```
安装脚本可以确保已安装 YAD，还会创建两个菜单按钮，一个运行的更新程序以及一个允许从终端运行 pi-apps 的文件(`/usr/local/bin/pi-apps`) 。除此之外，Pi-Apps 文件夹之外没有任何修改。

<details>
<summary><b>手动安装</b> 如果你想看看一键安装脚本会执行哪些命令的话</summary>
手动安装 Pi-Apps:
 
```
git clone https://github.com/Botspot/pi-apps
~/pi-apps/install
```
</details>

<details>
<summary><b>卸载 Pi-Apps</b></summary>
卸载 Pi-Apps:

```
~/pi-apps/uninstall
```
</details>

## 运行 Pi-Apps

菜单 -> 附件 -> Pi Apps，或在终端中运行 Pi Apps。使用 `~/pi-apps/gui` 命令在其目录中运行 Pi-Apps。
## 有用的链接
- [![Pi-Apps Discord 服务器](https://img.shields.io/discord/770629697909424159.svg?color=7289da&label=Pi-Apps%20Discord%20server&logo=discord)](https://discord.gg/RXSTvaUvuu)
- [捐助 Botspot](https://paypal.me/josephmarchand)
- [查看更新日志](https://github.com/Botspot/pi-apps/blob/master/CHANGELOG.md)
- [报告 Bug](https://github.com/Botspot/pi-apps/issues/new)
- [Leepspvideo Pi-Apps 体验](https://www.youtube.com/watch?v=zxyWQ3FV98I)
- [ETA Prime's Pi-Apps & Minecraft Java 视频](https://www.youtube.com/watch?v=oqNWJ52DLes)

## 其他人对 Pi-Apps 有何评价？
> “太棒了。谢谢您这样做。” - **[Novaspirit Tech](youtube.com/novaspirittech)** (大 RPi YouTuber)在 Discord 上发布

> 非常感谢 Botspot 创造了这个程序；这是一个很棒的程序。” - **[leepspvideo](https://www.youtube.com/watch?v=zxyWQ3FV98I)** (大 RPi YouTuber)

> “我喜欢bpi-apps。它很棒，并安装了许多人们不知道如何安装的有用软件。Botspot 很棒！” - **[RPi Projects and More](https://www.youtube.com/channel/UCkv0fW0EIUTKw6pYEnTjTbQ)** (RPi YouTuber)

> “我用了 Pi-Apps 一段时间，并向其他人推荐了好几次。
> 我们无法提供人们可能想要的所有选择，因此像您这样的人对缩小差距很有帮助。谢谢 Botspot！” - 树莓派开发人员在电子邮件中写到

> “感谢出色的工作，使它对每个人都变得简单。” - [**ShiftPlusOne**](https://www.raspberrypi.org/forums/viewtopic.php?f=63&t=290329&p=1755860#p1755857) (RPi moderator) 在树莓派论坛上写道

> “祝您和您的项目好运，Botspot，您真的在掀起波澜！” - **[Sakaki](https://github.com/sakaki-)** (RPi legend) 在电子邮件中写道

> “我❤️Pi-Apps，因为它真是太棒了！我用 MacOS 主题和 Win10 主题和很多人开了玩笑” - LEHAtupointow 在 Discord 上写道

<hr>

# 完整文档见 [Wiki](https://github.com/Botspot/pi-apps/wiki) 

### 基本用法
- 这是**主窗口**:  
![主窗口](https://github.com/Botspot/pi-apps/blob/master/icons/screenshots/main%20window.png?raw=true)  
使用主窗口选择要查看的应用类别。双击打开一个类别文件夹。  
- 选择类别后，您会看到一个应用列表：  
![应用列表](https://github.com/Botspot/pi-apps/blob/master/icons/screenshots/app%20list.png?raw=true)  

- 如果您双击某个应用程序，或选择应用程序并单击![info.png](https://raw.githubusercontent.com/Botspot/pi-apps/master/icons/info.png)，您将看到**详细信息**窗口。  
![详细信息](https://github.com/Botspot/pi-apps/blob/master/icons/screenshots/details%20window.png?raw=true)  
- Pi-Apps 可能会在启动时显示通知。 如果您选择查看更新，**更新程序窗口**将会出现：  
![更新](https://github.com/Botspot/pi-apps/blob/master/icons/screenshots/updates%20available.png?raw=true)  
- Pi-Apps **设置** 可以通过启动 菜单 -> 偏好 -> Pi-Apps Settings 进行配置。  
![设置](https://github.com/Botspot/pi-apps/blob/master/icons/screenshots/settings.png?raw=true)  

## To-do

- [X] 制作**应用创建系统**。 （用`createapp` 脚本完成）
- [X] 将 Pi-Apps 添加到 **Twister OS**。 （通过 Twister 1.8.5 补丁于 11/2/2020 完成。）
- [X] 支持单独的 **32-bit** 和 **64-bit** 安装脚本。
- [X] 允许从应用列表中选择**多个应用**并同时安装。
- [X] 应用列表增加**搜索功能**。 它仍然是实验性的：要启用它，请在 **Pi-Apps Settings** -> **App List Style** 中切换到 **xlunch**。
- [X] 用一些**类别**来分解长长的应用程序列表。
- [X] 添加一个包含当前 **已安装** 的所有应用程序的新类别。

## 徽章
如果您的应用程序在 Pi-Apps 上，请考虑将这个漂亮的徽章/超链接添加到您的自述文件中：
[![徽章](https://github.com/Botspot/pi-apps/blob/master/icons/badge.png?raw=true)](https://github.com/Botspot/pi-apps)  
嵌入代码:  
```
[![badge](https://github.com/Botspot/pi-apps/blob/master/icons/badge.png?raw=true)](https://github.com/Botspot/pi-apps)  
```
