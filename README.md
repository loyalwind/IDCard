# IDCard
扫描识别中国二代身份证信息
可自动快速读出身份证上的信息（姓名、性别、民族、住址、身份证号码）并截取到身份证图像

+ 1.集成到你开发的app里:
	- 把整个FreeIDCardScan文件夹拖到项目即可
	- 在你的项目的Info.plist文件中，添加权限描述（Key   Value）
		- Privacy - Camera Usage Description 是否允许访问相机
		- Privacy - Photo Library Usage Description 是否允许访问相册

+ 2.代码使用:
```objc
#import "WJScanIDCardManager.h"
[[WJScanIDCardManager sharedManager] startScanIDCardWithCompeletion:^(WJIDInfo *idInfo) {
    // 去解析使用 idInfo ...
}];
````

+ 3.参考资料 [中国大陆第二代身份证识别](https://github.com/zhongfenglee/IDCardRecognition)

