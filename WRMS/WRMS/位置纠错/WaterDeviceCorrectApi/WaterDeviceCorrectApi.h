//
//  WellErrorApi.h
//  LeftSlide
//
//  Created by YangJingchao on 16/5/19.
//  Copyright © 2016年 陕西永诺. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^wellErrSucBlock)();

typedef void (^wellErrArrSucBlock)();
typedef void (^WellErrArrReturnBlock)();

@interface WaterDeviceCorrectApi : NSObject

/**
 *  位置纠错
 *
 *  @param coversId    水位id
 *  @param alti        海拔
 *  @param user        创建人
 *  @param lon         经度
 *  @param lat         纬度
 *  @param returnBlock 成功block
 */
+ (void)apiWithErrorUpdate:(NSString *)coversId
                  altitude:(NSString *)alti
                createUser:(NSString *)user
                 longitude:(NSString *)lon
                  latitude:(NSString *)lat
                  location:(NSString *)loca
              successBlock:(wellErrSucBlock)returnBlock;


/**
 *  附近监测点列表
 *
 *  @param lon         经度
 *  @param lat         纬度
 *  @param num         当前页数
 *  @param arrData     Model数组
 *  @param tableView   tableview
 *  @param returnBlock 成功block
 */
+ (void)apiWithErrorList:(NSString *)lon
                latitude:(NSString *)lat
                 pageNum:(NSInteger)num
             uiTableView:(UITableView *)tableView
                     arr:(NSMutableArray *)arrData returnBlock:(WellErrArrReturnBlock)success
            successBlock:(wellErrArrSucBlock)returnBlock;

@end
