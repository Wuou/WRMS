//
//  DataAlyApi.h
//  LeftSlide
//
//  Created by YangJingchao on 16/5/19.
//  Copyright © 2016年 陕西永诺. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^dataSucBlock)();
typedef void (^dataSucArrBlock)();

@interface DataAlyApi : NSObject

/**
 *  水位报警工单月统计
 *
 *  @param startTime   开始时间
 *  @param endTime     结束时间
 *  @param ArrY_Chart  选项1Model数组
 *  @param ArrY_Chart2 选项2Model数组
 *  @param ArrX_Chart  X轴Model数组
 *  @param returnBlock 成功block
 */
+ (void)apiWithAlarmOrderMonth:(NSString *)startTime
                       endTime:(NSString *)endTime
                         nsArr:(NSMutableArray *)ArrY_Chart
                        nsArr2:(NSMutableArray *)ArrY_Chart2
                        nsArrX:(NSMutableArray *)ArrX_Chart
                  successBlock:(dataSucArrBlock)returnBlock;
/**
 *  水位报警工单日统计
 *
 *  @param statistic   结束时间
 *  @param ArrY_Chart  选项1Model数组
 *  @param ArrY_Chart2 选项2Model数组
 *  @param ArrX_Chart  X轴Model数组
 *  @param returnBlock 成功block
 */
+ (void)apiWithAlarmOrderDay:(NSString *)statistic
                         nsArr:(NSMutableArray *)ArrY_Chart
                        nsArr2:(NSMutableArray *)ArrY_Chart2
                        nsArrX:(NSMutableArray *)ArrX_Chart
                  successBlock:(dataSucArrBlock)returnBlock;


/**
 *  水位趋势月统计
 *
 *  @param startTime   开始时间
 *  @param endTime     结束时间
 *  @param ArrY_Chart  选项1Model数组
 *  @param ArrY_Chart2 选项2Model数组
 *  @param ArrX_Chart  X轴Model数组
 *  @param returnBlock 成功block
 */
+ (void)apiWithWaterMonth:(NSString *)startTime
                       endTime:(NSString *)endTime
                         nsArr:(NSMutableArray *)ArrY_Chart
                        nsArr2:(NSMutableArray *)ArrY_Chart2
                        nsArrX:(NSMutableArray *)ArrX_Chart
                  successBlock:(dataSucArrBlock)returnBlock;

/**
 *  水位趋势日统计
 *
 *  @param statistic   时间
 *  @param ArrY_Chart  选项1Model数组
 *  @param ArrY_Chart2 选项2Model数组
 *  @param ArrX_Chart  X轴Model数组
 *  @param returnBlock 成功block
 */
+ (void)apiWithWaterDay:(NSString *)statistic
                         nsArr:(NSMutableArray *)ArrY_Chart
                        nsArr2:(NSMutableArray *)ArrY_Chart2
                        nsArrX:(NSMutableArray *)ArrX_Chart
                  successBlock:(dataSucArrBlock)returnBlock;


@end
