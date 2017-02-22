//
//  EventManagementApi.h
//  LeftSlide
//
//  Created by zhujintao on 16/7/20.
//  Copyright © 2016年 eamon. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 获取数据成功*/
typedef void (^GetListSucBlock)();

/**
 *  分页数改变
 */
typedef void (^PageChangeBlock)();

/**
 *  去重复
 */
typedef void (^RepeatBlock)();
//获取媒体文件成功block
typedef void (^GetMediaSucBlock)();
@interface EventManagementApi : NSObject

/**
 *  获取报警列表
 *  @param tableView   当前视图的展开列表
 *  @param pageNum     控制翻页数
 *  @param dataArr     存储model数据
 *  @param pageChange  改变翻页书回调
 */
+ (void)apiWithTableView:(UITableView *)tableView
                 pageNum:(NSInteger)pageNum
                 dataArr:(NSMutableArray *)dataArr
              pageChange:(PageChangeBlock)pageChange
               repeatArr:(RepeatBlock)repeatBlock;

/**
 *  获取报警等级
 */
+ (void)apiWithGetEventLevelWithLevelArr:(NSMutableArray *)levelArr;

/**
 *  获取报警类型
 */
+ (void)apiWithGetEventTypeDataWithArrType:(NSMutableArray *)arrType;
/**
 *  获取报警处理完结状态列表
 *
 *  @param arrStatus
 */
+ (void)apiWithErrorOrderStatus:(NSMutableArray *)arrId
                           arr2:(NSMutableArray *)arrText;

/**
 *  报警处理记录
 *  @param orderIdStr        记录ID
 *  @param alarmOrderListArr 存储底部显示列表
 *  @param sucBlock          获取列表成功时回调
 */
+ (void)apiWithOrderDealListOrderId:(NSString *)orderIdStr
                  alarmOrderListArr:(NSMutableArray *)alarmOrderListArr
                       successBlock:(GetListSucBlock)sucBlock;
/**
 *  获取媒体文件列表
 *  @param orderId 工单id
 *  @param arrMedia 媒体数组
 *  @param sucBlock 成功回调
 */
+ (void)apiWtihMediaList:(NSMutableArray *)arrMedia
                 orderId:(NSString *)orderID
                sucBlock:(GetMediaSucBlock)sucBlock;

@end
