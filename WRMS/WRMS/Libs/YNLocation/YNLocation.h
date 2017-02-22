//
//  myLocation.h
//  LeftSlide
//
//  Created by YangJingchao on 16/5/20.
//  Copyright © 2016年 陕西永诺. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^locationSucBlock)(NSString *strLat,NSString *strLon,NSString *strHeight);
typedef void (^locationFailBlock)();
@interface YNLocation : NSObject

/**
 *  获取蓝牙盒子数据或取手机定位
 *
 *  @param lat       经度
 *  @param lonti     纬度
 *  @param locaBlock 成功block
 *  @param failBlock 失败block
 */
+ (void)getMyLocation:(NSString *)lat
            lontitude:(NSString *)lonti
               height:(NSString *)height
         successBlock:(locationSucBlock)locaBlock;
@end
