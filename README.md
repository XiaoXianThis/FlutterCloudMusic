# 简易云音乐
Flutter开发的桌面版网易云第三方播放器（仿官方客户端）



边学flutter边写出来的破项目，能跑起来就算成功。


# 界面
本项目基本是仿照官方客户端布局写的，做了美化与调整，上手即用无需改变使用习惯。

![img 截图](https://raw.githubusercontent.com/XiaoXianThis/FlutterCloudMusic/main/IMG/IMG-01.png)
![img 截图](https://raw.githubusercontent.com/XiaoXianThis/FlutterCloudMusic/main/IMG/IMG-02.png)

# 特点
+ 使用`Flutter`开发，程序体积比官方小很多（压缩后`20M`左右），内存使用也低于官方客户端。


+ 字体使用了`HarmonyOS Sans`，文字观感舒适。

# 注意
本项目只是个人练习项目，不提供任何在线服务，所有网络内容都来自调用网易云音乐官方接口取得，所有在线内容的版权都归官方所有，API 由 Binaryify / [NeteaseCloudMusicApi](https://github.com/Binaryify/NeteaseCloudMusicApi) 提供，如果可能侵权我会及时停止开发。

另外本项目并没有任何取代官方版本的意思，只会开发音乐相关核心功能，并不会加入其他功能（如播客、电台、动态、视频等），如果你需要使用完整功能，推荐直接使用 [官方客户端](https://music.163.com/#/download)。

# 支持平台
目前只支持 Windows。



# 功能
- [x] 二维码登录
- [x] 获取用户歌单
- [x] 喜欢音乐
- [x] 收藏歌单
- [x] 歌单详情
- [x] 搜索（目前仅单曲、歌单可用）
- [x] 下载音乐（提供链接）
- [x] 播放音乐
- [x] 显示会员、等级等信息
- [x] 无版权歌曲变灰
- [x] 搜索关键词高亮
- [x] 歌曲音质显示
- [ ] 后台播放
- [ ] 音质切换
- [ ] 收藏歌曲到歌单
- [ ] 歌词页面
- [ ] 评论区
- [ ] 用户详情
- [ ] 歌手详情
- [ ] 专辑详情
- [ ] 下载管理
- [ ] 最近播放记录
- [ ] 私人FM
- [ ] 发现音乐
- [ ] 音乐云盘


# 下载
可前往 [Releases](https://github.com/XiaoXianThis/FlutterCloudMusic/releases) 页面下载，解压后运行`music.exe`即可看到主界面，可自行创建桌面快捷方式。

下载新版本后，请删除原来版本所有文件，然后重新解压，也可解压到另一个的目录使用。

# BUG
自己的编程水平我还是有点数的，保证100%有BUG，你如果有幸遇到了可以来提[Issues](https://github.com/XiaoXianThis/FlutterCloudMusic/issues/new)。

由于是业余项目，非致命BUG不保证及时修复。

# LICENSE
[MIT](https://github.com/XiaoXianThis/FlutterCloudMusic/blob/main/LICENSE)