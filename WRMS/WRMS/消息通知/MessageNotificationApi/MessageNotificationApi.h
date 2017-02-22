//
//  MessageNotificationApi.h
//  LeftSlide
//
//  Created by zhujintao on 16/8/12.
//  Copyright © 2016年 YongNuoTech. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  分页数改变
 */
typedef void (^PageChangeBlock)();


@interface MessageNotificationApi : NSObject
/**
 *  查询推送消息列表
 *
 *  @param msgArr       消息数组
 *  @param pageNum      页码数
 *  @param oneTableView 列表组件
 *  @param pageChange   分页回调
 */
+ (void)apiWithGetMessageNotificateionListMsgArr:(NSMutableArray *)msgArr
                                         pageNum:(NSInteger)pageNum
                                       tableView:(UITableView *)oneTableView
                                      pageChange:(PageChangeBlock)pageChange;
@end
