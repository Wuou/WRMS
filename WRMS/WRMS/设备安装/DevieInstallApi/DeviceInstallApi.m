//
//  DevieInstallApi.m
//  LeftSlide
//
//  Created by YangJingchao on 16/5/20.
//  Copyright © 2016年 陕西永诺. All rights reserved.
//

#import "DeviceInstallApi.h"
#import "YNRequest.h"
#import "SVProgressHUD.h"
#import "Devicemodel.h"
#import "utils.h"

@implementation DeviceInstallApi

+ (void)apiWithDeviceList:(NSString *)lontitude
                 latitude:(NSString *)lat
                  pageNum:(NSUInteger)num
                  uitable:(UITableView *)table
                    nsArr:(NSMutableArray *)arr
             successBlock:(deviceSucBlock)returnBlock
              returnBlock:(deviceReturnBlock)success {
    
    [SVProgressHUD showWithStatus:@"加载中..."];
    //创建JSON
    NSDictionary *dictonary = [[NSMutableDictionary alloc] init];
    [dictonary setValue:lontitude forKey:@"longitude"];
    [dictonary setValue:lat forKey:@"latitude"];
    [dictonary setValue:[utils getUnitID] forKey:@"unitId"];
    [dictonary setValue:[NSString stringWithFormat:@"%zd",num] forKey:@"pageNo"];
    //请求
    [YNRequest YNPost:LBS_QueryNearbyPoints parameters:dictonary success:^(NSDictionary *dic) {
        
        NSString *codeStr     = [dic objectForKey:@"rcode"];
        NSString *totalStr    = [dic objectForKey:@"total"];
        if ([codeStr isEqualToString:@"0x0000"]) {
            if ([totalStr integerValue] == 0) {
                [SVProgressHUD showInfoWithStatus:@"无数据"];
                returnBlock();
            }else
            {
                NSArray *rowsDic = [dic objectForKey:@"rows"];
                for (NSDictionary *mydic in rowsDic) {
                    Devicemodel *model = [[Devicemodel alloc]initWithDict:mydic];
                    [arr addObject:model];
                }
                success();
                
                if([arr count] == 0) {
                    [SVProgressHUD showInfoWithStatus:@"无数据"];
                }else
                {
                    [SVProgressHUD dismiss];
                }
            }
        }else
        {
            if ([codeStr isEqualToString:@"0x0016"]) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [utils setLoginAgain];
                });
            }else{
                [SVProgressHUD dismiss];
            }
            
        }
        [table.header endRefreshing];
        [table.footer endRefreshing];
    } fail:^{
        [table.header endRefreshing];
        [table.footer endRefreshing];
        [SVProgressHUD showInfoWithStatus:@"网络异常,请检查网络"];
    }];
}

+ (void)apiWithIMEIisExit:(NSString *)TFmchnId
             successBlock:(DeviceIMEIExitBlock)successB
              returnBlock:(deviceReturnBlock)returnB {
    NSString *ids =  TFmchnId;
    if (TFmchnId != nil || ![TFmchnId isEqualToString:@""])
    {
        ids = [ids stringByReplacingOccurrencesOfString:@" " withString:@""];
        //创建JSON
        NSDictionary *dictonary = [[NSMutableDictionary alloc] init];
        [dictonary setValue:ids forKey:@"mchnId"];
        [dictonary setValue:[utils getUnitID] forKey:@"unitId"];
        
        //请求
        [YNRequest YNPost:LBS_QueryMchnList parameters:dictonary success:^(NSDictionary *dic) {
            
            NSString *codeStr     = [dic objectForKey:@"rcode"];
            NSString *msgStr      = [dic objectForKey:@"rmessage"];
            if ([codeStr isEqualToString:@"0x0000"]) {
                successB(dic);
            }else{
                if ([codeStr isEqualToString:@"0x0016"]) {
                    //                    [SVProgressHUD showErrorWithStatus:codeAuthMsg];
                }else{
                    [SVProgressHUD showErrorWithStatus:msgStr];
                }
                returnB();
            }
            
        } fail:^{
            [SVProgressHUD showInfoWithStatus:@"网络异常,请检查网络"];
        }];
    }
}

+ (void)apiWithInstallDevice:(NSString *)TFmchnId
                 strcoversId:(NSString *)strcoversId
                 strCodeImei:(NSString *)Imei
                successBlock:(deviceSucBlock)sucBlock {
    NSString *ids = TFmchnId;
    if ([ids isEqualToString:@" "] || [ids isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请输入设备编号"];
    }else{
        ids = [ids stringByReplacingOccurrencesOfString:@" " withString:@""];
        //创建JSON
        NSDictionary *dictonary = [[NSMutableDictionary alloc] init];
        
        [dictonary setValue:strcoversId forKey:@"pointId"];
        [dictonary setValue:ids forKey:@"waterMchnId"];
        [dictonary setValue:Imei forKey:@"codeImei"];
        [dictonary setValue:[utils getlogName] forKey:@"userAccnt"];
        //请求
        [YNRequest YNPost:LBS_UpdateMonitorPointMchn parameters:dictonary success:^(NSDictionary *dic) {
            
            NSString *codeStr = [dic objectForKey:@"rcode"];
            NSString *msgStr  = [dic objectForKey:@"rmessage"];
            if ([codeStr isEqualToString:@"0x0000"]) {
                [SVProgressHUD showSuccessWithStatus:@"安装成功"];
                sucBlock();
            }else
            {
                if ([codeStr isEqualToString:@"0x0016"]) {
                    //                    [SVProgressHUD showErrorWithStatus:codeAuthMsg];
                }else{
                    [SVProgressHUD showErrorWithStatus:msgStr];
                }
            }
            
        } fail:^{
            [SVProgressHUD showInfoWithStatus:@"网络异常,请检查网络"];
        }];
    }
}

@end
