YNVoice - 音频录制、播放组件
介绍：
1 YNVoiceRecordVC.h  音频录制类
2 YNVoicePlayVC.h 音频播放类

使用方法：
录制类，直接跳转
播放类
```
    YNVoicePlayVC *voiceVC = [[YNVoicePlayVC alloc] init];
    voiceVC.deleteBlock = ^(){
        
        // 删除录音
        [self deleteVoice];
    };
    voiceVC.voiceURL = [self.arrVoiceUrl objectAtIndex:0];
    [self presentViewController:voiceVC animated:YES completion:nil];
```