//
//  PlayVoiceVC.h
//  LeftSlide
//
//  Created by mymac on 16/1/19.
//  Copyright © 2016年 陕西永诺. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^DeleteVoiceBlock)();

@interface YNVoicePlayVC : UIViewController

@property (nonatomic, strong) NSString *voiceURL;
@property (strong, nonatomic) IBOutlet UIButton *playButton;

@property (nonatomic, copy) DeleteVoiceBlock deleteBlock;

@end
