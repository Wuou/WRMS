//
//  MySubViewInMain.h
//  WRMS
//
//  Created by mymac on 16/8/25.
//  Copyright © 2016年 YangJingchao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MySubViewInMain : UIView

- (id)initWithFrame:(CGRect)frame imageStr:(NSString *)imageStr title:(NSString *)title;

/** 图标*/
@property (nonatomic, strong) UIImageView *iconImageView;

/** 点击的按钮*/
@property (nonatomic, strong) UIButton *clickBtn;

@end
