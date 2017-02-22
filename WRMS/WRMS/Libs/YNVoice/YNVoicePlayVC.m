//
//  PlayVoiceVC.m
//  LeftSlide
//
//  Created by mymac on 16/1/19.
//  Copyright © 2016年 陕西永诺. All rights reserved.
//

#import "YNVoicePlayVC.h"
#import "MCSoundBoard.h"


@interface YNVoicePlayVC ()<AVAudioPlayerDelegate>

@property (nonatomic, strong) AVAudioPlayer *player;

@property (nonatomic) BOOL isPlay;

@end

@implementation YNVoicePlayVC
#pragma mark - life cycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
//        self.title = @"播放录音";
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
        backItem.title = @"";
        self.navigationItem.backBarButtonItem = backItem;
//        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-shanchu"] style:(UIBarButtonItemStylePlain) target:self action:@selector(deleteAction:)];
        
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [MCSoundBoard addAudioAtPath:self.voiceURL forKey:@"new"];
    self.player = [MCSoundBoard audioPlayerForKey:@"new"];
    self.player.numberOfLoops = 0;
    self.player.delegate = self;
    self.player.volume = 1.0;
    
    [self.playButton setImage:[UIImage imageNamed:@"play_button"] forState:(UIControlStateNormal)];
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    self.isPlay = NO;
}
#pragma mark - 播放按钮点击事件
- (IBAction)playVoiceBtn:(id)sender {
 
    if (!self.isPlay) {
        [self.playButton setImage:[UIImage imageNamed:@"suspend_button"] forState:(UIControlStateNormal)];
        [MCSoundBoard playAudioForKey:@"new" fadeInInterval:0.0];
        self.isPlay = YES;
    }else {
        [self.playButton setImage:[UIImage imageNamed:@"play_button"] forState:(UIControlStateNormal)];
        [MCSoundBoard pauseAudioForKey:@"new" fadeOutInterval:0.0];
        self.isPlay = NO;
    }
}

#pragma mark - AVAudioPlayer Delegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    
    [self.playButton setImage:[UIImage imageNamed:@"play_button"] forState:(UIControlStateNormal)];
    self.isPlay = NO;
}

// 删除录音文件
- (IBAction)deleteAction:(id)sender{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否删除录音?" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:nil];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDestructive) handler:^(UIAlertAction * _Nonnull action) {
        
        // 点击确定就发送一个删除录音通知
        if (self.deleteBlock) {
            
            self.deleteBlock();
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alertVC addAction:cancelAction];
    [alertVC addAction:confirmAction];
    
    [self presentViewController:alertVC animated:YES completion:nil];
    
}

- (IBAction)dismissAction:(id)sender {
    
    [MCSoundBoard stopAudioForKey:@"new"];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
