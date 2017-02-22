//
//  MainApi.h
//  LeftSlide
//
//  Created by mymac on 16/5/19.
//  Copyright © 2016年 陕西永诺. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^myBlock)();
typedef void (^timerActionBlock)();
typedef void (^getDataFailBlock)();

@interface MainApi : NSObject

/**
 *  自定义封装请求接口数据
 *
 *  @param UIViewController 首页控制器参数
 *  @param timer            首页timer,管理网络超时
 *  @param button           首页重新加载按钮
 *  @param menuArr          首页接收数据数组
 *  @param returnBlock      请求成功回调方法
 */
+ (void)apiWithUIViewController:(UIViewController *)UIViewController
                                    arr:(NSMutableArray *)menuArr
                   successBlock:(myBlock)returnBlock
                  arrIsNilBlock:(getDataFailBlock)failBlock;

// 上传极光生成的registrationID 来唯一标识当前用户
//+ (void)apiUploadRegisterationID;

@end
