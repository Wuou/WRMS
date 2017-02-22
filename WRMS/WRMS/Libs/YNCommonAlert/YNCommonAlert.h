//
//  CommonAlertVC.h
//  LeftSlide
//
//  Created by mymac on 16/5/18.
//  Copyright © 2016年 陕西永诺. All rights reserved.
//

#import <Foundation/Foundation.h>

/*------------------AppDelegate-------------*/
#define kReciveMessage @"收到一条消息"
#define kIgnore @"忽略"

/*------------------首页--------------------*/
// 网络连接异常, 刷新界面提示框用到的宏
#define kTitle @"提示!"
#define kNetMessage @"网络连接超时, 请刷新界面"
#define kCancel @"取消"
#define kRefresh @"刷新"

// 弹出连接星网P2终端
#define kP2Message @"请连接星网P2北斗高精度终端"
#define kDetermine @"确定"

// 检查网络设置
#define kNoTitle @""
#define kSettingMessage @"网络连接异常,请检查网络设置!"
#define kSetting @"设置"

/*------------------个人信息界面-------------*/
// 切换账号
#define kExitMessage @"是否确定退出系统?"

/*------------------撤防布防----------------*/
// 点击撤防布防按钮
#define kArmingMessage @"您确定执行此操作吗?"

/*------------------播放录音----------------*/
// 删除录音
#define kErrorMessage @"是否删除录音?"

typedef void (^CallBackBlock)(NSInteger btnIndex);

typedef enum {
    ZYAlertActionStyleDefault = 0,
    ZYAlertActionStyleCancel,
    ZYAlertActionStyleDestructive
}ZYAlertActionStyle;

@interface YNCommonAlert : NSObject

/**
 *  封装alertViewController
 *
 *  @param viewController      alertView所在控制器
 *  @param title               标题
 *  @param message             提示信息
 *  @param block               回调参数
 *  @param cancelBtnTitle      取消按钮
 *  @param destructiveBtnTitle 特殊按钮
 *  @param otherBtnTitles      其他按钮
 */
+ (void)showAlertWith:(UIViewController *)viewController
                title:(NSString *)title
              message:(NSString *)message
        callBackBlock:(CallBackBlock)block
    cancelButtonTitle:(NSString *)cancelBtnTitle
 structiveButtonTitle:(NSString *)destructiveBtnTitle
    otherButtonTitles:(NSString *)otherBtnTitles, ...
            NS_REQUIRES_NIL_TERMINATION;


@end
