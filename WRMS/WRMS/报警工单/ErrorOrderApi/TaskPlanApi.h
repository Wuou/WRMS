//
//  TaskPlanApi.h
//  LeftSlide
//
//  Created by YangJingchao on 2016/9/8.
//  Copyright © 2016年 YongNuoTech. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void (^taskListBlock)();
typedef void (^issuedUserSucBlock)();
typedef void (^issuedUnitBlock)();
typedef void (^issuedBlock)();
typedef void (^issuedTaskPlanBlock)();
typedef void (^taskDetailBlock)();

@interface TaskPlanApi : NSObject


/**
 *  获取下发人员列表
 *
 *  @param arrUserList 数组
 *  @param sucBlock    成功block
 */
+ (void)apiWithIssuedUserList:(NSMutableArray *)arrUserList
                  issuedBlock:(issuedUserSucBlock)sucBlock;
/**
 *  获取下发单位列表
 *
 *  @param arrUnitList  数组
 *  @param unitSucBlock 成功block
 */
+ (void)apiWithIssuedUnitList:(NSMutableArray *)arrUnitList
                       unitId:(NSString *)strOrderUnitId
                  issuedBlock:(issuedUnitBlock)unitSucBlock;
/**
 *  下发事件工单
 *
 *  @param strOrder  工单编号
 *  @param strRemark 备注
 *  @param strTime   时间
 */
+ (void)apiWithIssued:(NSString *)strOrder
               remark:(NSString *)strRemark
         issuedUserId:(NSString *)strUserId
         issuedUnitId:(NSString *)strUnitId
                 time:(NSString *)strTime
           isSucBlock:(issuedBlock)isSucBlock;


@end
