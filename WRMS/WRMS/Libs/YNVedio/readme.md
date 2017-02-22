YNVedeio - 视频录制、播放组件

介绍:
1 YNVedioRecordVC.h 视频录制类
2 YNVedioPlayerVC.h 视频播放类

用法：
录制类，直接跳转到该类就可以录制
视频播放类，点击视频，跳转到该类，传值注意，如下：
```
YNVedioPlayerVC *apvc =[[YNVedioPlayerVC alloc]init];
apvc.urlVedio =  [self.arrVideoUrl objectAtIndex:0];
apvc.tag = 0;
apvc.arrPhoto = self.arrVideoUrl;
```
参数：
urlVedio 是当前的视频URL
tag 当前点击第几个视频
arrPhoto 是所有视频的url数组 