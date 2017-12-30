# 关于我们
我们来自织天科技，专注于线下商城App的开发，目前开发作品有“影秀城“。随着功能的越来越丰富，工程也变的越来越复杂。从早期的商户发布动态，到现在用户可以自己发布极具个性的发现，运营人员可以在编辑中插入各种信息，而不光是图片和文字；甚至我们还接入很多线下系统，从停车场，商城erp，到室内导航。
工程越来越复杂，导致了很多问题。我们开始考虑在团队内推广组件化的思想。通过组件化，降低每次更新影响的范围，也可以保持可测性。
我们将会持续将工程中与业务无关，又极具重用性的模块剥离出来与大家共享。

# 欢迎大家提出建议
写信到 bodimall@163.com

# iOS 扫码功能,有如下特点：
1. 使用iOS原生的扫码功能；
2. 直接集成到页面中；扫码结果通过block回调返回；
3. 支持扫码识别或完全手工输入；
4. 使用Mansory进行布局。

# 集成步骤：
1. 直接在podfile中引用：ISWBarScanner
2. 记得在你的工程plist中添加：NSCameraUsageDescription

# TODO：
1. 更加细腻的处理摄像权限问题；
2. 提供更多自定义界面，文案的接口；
3. 灵活配置可识别的条码范围；
4. 适配更多界面。

# 如图：
<img src="https://github.com/hzzhitian/ISWBarScanner/blob/master/ScreenShot/2017-12-30%20105046.png" width="320">
<img src="https://github.com/hzzhitian/ISWBarScanner/blob/master/ScreenShot/2017-12-30%20105055.png" width="320">
<img src="https://github.com/hzzhitian/ISWBarScanner/blob/master/ScreenShot/2017-12-30%20105102.png" width="320">
<img src="https://github.com/hzzhitian/ISWBarScanner/blob/master/ScreenShot/2017-12-30%20105123.png" width="320">
