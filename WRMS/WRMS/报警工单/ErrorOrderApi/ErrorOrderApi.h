//
//  ErrorOrderApi.h
//  LeftSlide
//
//  Created by YangJingchao on 16/5/19.
//  Copyright © 2016年 陕西永诺. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^orderSucBlock)();
typedef void (^orderArrSucBlock)();

@interface ErrorOrderApi : NSObject

/**
 *  报警工单列表
 *
 *  @param user        当前user
 *  @param returnBlock 成功block
 */
+ (void)apiWithErrorOrderList:(NSMutableArray *)arr
                  uiTableView:(UITableView *)tb
                 successBlock:(orderSucBlock)returnBlock;
/**
 *  获取报警状态
 *
 *  @param arr1        报警id数组
 *  @param arr2        报警内容数组
 *  @param tb          uitableview
 *  @param returnBlock 成功block
 */
+ (void)apiWithErrorOrderStatus:(NSMutableArray *)arr1
                           arr2:(NSMutableArray *)arr2
                 successBlock:(orderArrSucBlock)returnBlock;


@end
