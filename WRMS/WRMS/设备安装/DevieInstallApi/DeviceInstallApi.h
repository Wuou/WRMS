//
//  DevieInstallApi.h
//  LeftSlide
//
//  Created by YangJingchao on 16/5/20.
//  Copyright © 2016年 陕西永诺. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^deviceSucBlock)();
typedef void (^deviceReturnBlock)();

typedef void (^DeviceIMEIExitBlock)(NSDictionary *dic);

@interface DeviceInstallApi : NSObject

+ (void)apiWithDeviceList:(NSString *)lontitude
                 latitude:(NSString *)lat
                  pageNum:(NSUInteger)num
                  uitable:(UITableView *)table
                    nsArr:(NSMutableArray *)arr
             successBlock:(deviceSucBlock)returnBlock
                returnBlock:(deviceReturnBlock)success;

/**
 *  是否存在IMEI
 *
 *  @param TFmchnId   id
 *  @param TFcodeImei IMEI
 */
+ (void)apiWithIMEIisExit:(NSString *)TFmchnId
             successBlock:(DeviceIMEIExitBlock)successB
              returnBlock:(deviceReturnBlock)returnB;


/**
 *  设备安装
 *
 *  @param TFmchnId    TFmchnId
 *  @param strcoversId strcoversId
 *  @param fromType    fromType
 *  @param returnBlock 成功

 */
+ (void)apiWithInstallDevice:(NSString *)TFmchnId
                 strcoversId:(NSString *)strcoversId
                 strCodeImei:(NSString *)Imei
                successBlock:(deviceSucBlock)sucBlock;

@end
