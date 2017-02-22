//
//  WellErrorApi.m
//  LeftSlide
//
//  Created by YangJingchao on 16/5/19.
//  Copyright © 2016年 陕西永诺. All rights reserved.
//

#import "WaterDeviceCorrectApi.h"
#import "YNRequest.h"
#import "WaterModel.h"
#import "SVProgressHUD.h"

@implementation WaterDeviceCorrectApi
NSString *latitude;
NSString *lontitude;
+ (void)apiWithErrorUpdate:(NSString *)coversId
                  altitude:(NSString *)alti
                createUser:(NSString *)user
                 longitude:(NSString *)lon
                  latitude:(NSString *)lat
                  location:(NSString *)loca
              successBlock:(wellErrSucBlock)returnBlock {
    [SVProgressHUD showWithStatus:@"正在纠错,请稍等..." maskType:SVProgressHUDMaskTypeClear];
    //创建JSON
    NSDictionary *dictonary = [[NSMutableDictionary alloc] init];
    [dictonary setValue:coversId forKey:@"pointId"];
    [dictonary setValue:alti forKey:@"altitude"];
    [dictonary setValue:@"水位纠错" forKey:@"remark"];
    [dictonary setValue:user forKey:@"createUserAccnt"];
    [dictonary setValue:[utils getlogName] forKey:@"updateUserAccnt"];
    [dictonary setValue:lon forKey:@"longitude"];
    [dictonary setValue:lat forKey:@"latitude"];
    [dictonary setValue:loca forKey:@"location"];
    //请求
    [YNRequest YNPost:LBS_CreateMonitorPointCorrection parameters:dictonary success:^(NSDictionary *dic) {
        NSString *codeStr = [dic objectForKey:@"rcode"];
        if ([codeStr isEqualToString:@"0x0000"]) {
            [SVProgressHUD showSuccessWithStatus:@"纠错成功"];
            returnBlock();
        }else{
            [SVProgressHUD showErrorWithStatus:@"纠错失败"];
        }
    } fail:^{
        [SVProgressHUD showInfoWithStatus:@"网络异常,请检查网络"];
    }];
}

+ (void)apiWithErrorList:(NSString *)lon
                latitude:(NSString *)lat
                 pageNum:(NSInteger)num
             uiTableView:(UITableView *)tableView
                     arr:(NSMutableArray *)arrData
             returnBlock:(WellErrArrReturnBlock)success
            successBlock:(wellErrArrSucBlock)returnBlock {
    
    [YNLocation getMyLocation:latitude lontitude:lontitude height:nil successBlock:^(NSString *strLat, NSString *strLon, NSString *strHeight) {
        latitude = strLat;
        lontitude = strLon;
    }];
    
    [SVProgressHUD showWithStatus:@"正在加载中..."];
    NSDictionary *dictonary = [[NSMutableDictionary alloc] init];
    [dictonary setValue:[utils getUnitID] forKey:@"unitId"];
    [dictonary setValue:lontitude forKey:@"longitude"];
    [dictonary setValue:latitude forKey:@"latitude"];
    [dictonary setValue:[NSString stringWithFormat:@"%zd",num] forKey:@"pageNo"];
    
    if ([[utils getUserType] isEqualToString:@"00000001"] || [[utils getUserType] isEqualToString:@"00000002"]) {
    }else{
        [dictonary setValue:[utils getUnitID] forKey:@"unitId"];
    }
    
    //请求
    [YNRequest YNPost:LBS_QueryNearbyPoints parameters:dictonary success:^(NSDictionary *dic) {
        NSString *codeStr     = [dic objectForKey:@"rcode"];
        NSString *totalStr    = [dic objectForKey:@"total"];
        if ([codeStr isEqualToString:@"0x0000"]) {
            if ([totalStr integerValue] == 0)
            {
                returnBlock();
                [SVProgressHUD showInfoWithStatus:@"暂时无数据..."];
            }else{
                NSArray *rowsDic = [dic objectForKey:@"rows"];
                for (NSDictionary *mydic in rowsDic) {
                    WaterModel *tordermodel = [[WaterModel alloc]initWithDict:mydic];
                    [arrData addObject:tordermodel];
                }
                success();
                [SVProgressHUD dismiss];
                [tableView reloadData];
            }
        }
        if ([codeStr isEqualToString:@"0x0016"]) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [utils setLoginAgain];
            });
        }else{
            [SVProgressHUD dismiss];
        }
        [tableView.header endRefreshing];
        [tableView.footer endRefreshing];
    } fail:^{
        [tableView.header endRefreshing];
        [tableView.footer endRefreshing];
        [SVProgressHUD showInfoWithStatus:@"网络异常,请检查网络"];
    }];
}

@end
