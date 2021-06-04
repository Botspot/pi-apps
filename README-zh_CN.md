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
### Botspot 问答
 - 你为什么开发 Pi-Apps？
> 长期以来，我一直为很少有人知道开源 RPi 软件项目而感到难过。其中许多项目非常有用和有益，但从来没有一种好的方式来分发它们。
> 存储库不托管它们，而且它们通常没有很好地宣传，那么人们将如何找到它们？
> 大多数人永远找不到它们。
> 有一天我意识到：为什么不创建一个专门从事所有社区 RPi 软件项目的应用程序商店呢？它将帮助更多用户找到该软件，同时它将提供一种超级简单的安装方式。
>（你更喜欢哪一个——点击一个闪亮的安装按钮，或者从一个粗略的博客教程中复制粘贴一堆命令？）

 - 编写这个程序需要多长时间？
> 大约两周几乎不间断的编码为奠定基础。从那时起，我不断优化性能、修复错误、解决问题、添加新功能并处理新的应用程序提交。

 - Pi-Apps 还在开发中吗？
> 当然是！最初的开发大部分已经完成，我没有看到更多 [主要功能](https://github.com/Botspot/pi-apps#to-do) 被添加到 Pi-Apps 的核心功能中。 （除了将来可能允许`apt`-package 应用程序）
> 但是，总有一两个应用程序需要关注，以及数十个应用程序请求。这足以让一个*团队*的开发人员忙碌起来。

 - Pi-Apps 是免费的吗？
> 绝对！ Pi-Apps 不是产品或服务：欢迎任何人使用它；没有人应该感到被迫/被要求捐赠。

 - 我能提供什么帮助？
> - 在论坛和评论中留下关于 Pi-Apps 的好话总是很好。除了帮助别人找到这个有用的软件，你可能会被添加到[名人堂](https://github.com/Botspot/pi-apps#what-do-others-say-about-pi-apps ）！
> - 如果你愿意，你可以[捐赠](https://paypal.me/josephmarchand)。这笔钱归我所有（减去 Paypal 费用），并帮助支持未来的开源开发。一些钱用于将 [赏金](https://github.com/ptitSeb/box86/issues/296) 放在我希望由拥有我没有的技能/时间的其他人完成的应用程序上有。
> - 您可以查看 [应用请求列表](https://github.com/Botspot/pi-apps/issues) 并帮助为它们创建脚本。
> - 如果您在 Youtube、Reddit 或 Facebook 上看到有人抱怨应用程序损坏，请鼓励他们加入 [Pi-Apps Discord](https://discord.gg/RXSTvaUvuu) 或 [open an issue]( https://github.com/Botspot/pi-apps/issues/new）来解决问题。 （我不经常访问这些网站。）
> - 您可以帮助解决/诊断其他人遇到的问题。
