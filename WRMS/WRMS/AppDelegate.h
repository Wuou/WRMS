//
//  AppDelegate.h
//  WRMS
//
//  Created by YangJingchao on 2016/8/15.
//  Copyright © 2016年 YangJingchao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

/** 判断发送验证加密，重新登录的次数*/
@property (nonatomic, assign) NSInteger loginTimes;
@property (nonatomic,assign ) NSInteger scrollIndex;//操作之前的scrollindex

@property (nonatomic,strong ) NSString *latStr;//全局的纬度
@property (nonatomic,strong ) NSString *lonStr;//全局的经度
@property (nonatomic,strong ) NSString *altitude;//全局的高度

/** 判断是否点击桌面图标进入程序*/
@property (nonatomic, assign) BOOL isClickIcon;

/** 极光推送需要用到的计时器*/
@property (nonatomic,strong)NSTimer *jpushTimer;

@end

