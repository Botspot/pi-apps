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
wget -qO- https://raw.githubusercontent.com/Botspot/pi-apps/master/install | bash
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
