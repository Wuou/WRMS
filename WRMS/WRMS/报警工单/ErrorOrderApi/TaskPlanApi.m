//
//  TaskPlanApi.m
//  LeftSlide
//
//  Created by YangJingchao on 2016/9/8.
//  Copyright © 2016年 YongNuoTech. All rights reserved.
//

#import "TaskPlanApi.h"
#import "UserModel.h"
#import "TaskPlanModel.h"

@implementation TaskPlanApi

+ (void)apiWithIssuedUserList:(NSMutableArray *)arrUserList
                  issuedBlock:(issuedUserSucBlock)sucBlock {
    //创建JSON
    NSDictionary *dictonary = [[NSMutableDictionary alloc] init];
    [dictonary setValue:[utils getUnitID] forKey:@"unitId"];
    
    //请求
    [YNRequest YNPost:LBS_QueryIssuedUserList parameters:dictonary success:^(NSDictionary *dic) {
        NSString *codeStr = [dic objectForKey:@"rcode"];
        if ([codeStr isEqualToString:@"0x0000"]) {
            NSArray *rowsDic = [dic objectForKey:@"rows"];
            for (NSDictionary *mydic in rowsDic) {
                UserModel *umodel = [[UserModel alloc]initWithDictionary:mydic];
                [arrUserList addObject:umodel];
            }
            sucBlock();
        }else{
            [SVProgressHUD dismiss];
        }
    } fail:^{
        [SVProgressHUD showInfoWithStatus:@"网络异常,请检查网络"];
    }];
}

+ (void)apiWithIssuedUnitList:(NSMutableArray *)arrUnitList
                       unitId:(NSString *)strOrderUnitId
                  issuedBlock:(issuedUnitBlock)unitSucBlock {
    //创建JSON
    NSDictionary *dictonary = [[NSMutableDictionary alloc] init];
    [dictonary setValue:strOrderUnitId forKey:@"parentUnitId"];
    
    //请求
    [YNRequest YNPost:LBS_QueryIssuedUnitList parameters:dictonary success:^(NSDictionary *dic) {
        NSString *codeStr = [dic objectForKey:@"rcode"];
        if ([codeStr isEqualToString:@"0x0000"]) {
            NSArray *rowsDic = [dic objectForKey:@"rows"];
            for (NSDictionary *mydic in rowsDic) {
                UserModel *umodel = [[UserModel alloc]initWithDictionary:mydic];
                [arrUnitList addObject:umodel];
            }
            unitSucBlock();
        }else{
            [SVProgressHUD dismiss];
        }
    } fail:^{
        [SVProgressHUD showInfoWithStatus:@"网络异常,请检查网络"];
    }];
}

+ (void)apiWithIssued:(NSString *)strOrder
               remark:(NSString *)strRemark
         issuedUserId:(NSString *)strUserId
         issuedUnitId:(NSString *)strUnitId
                 time:(NSString *)strTime
           isSucBlock:(issuedBlock)isSucBlock {
    //创建JSON
    NSDictionary *dictonary = [[NSMutableDictionary alloc] init];
    [dictonary setValue:[utils getlogName] forKey:@"userAccnt"];
    [dictonary setValue:strOrder forKey:@"orderId"];
    [dictonary setValue:strUserId forKey:@"userAccntStr"];
    [dictonary setValue:strUnitId forKey:@"unitId"];
    [dictonary setValue:strTime forKey:@"executionDate"];

    //请求
    [YNRequest YNPost:LBS_IssuedAlarmOrder parameters:dictonary success:^(NSDictionary *dic) {
        NSString *codeStr = [dic objectForKey:@"rcode"];
        NSString *msgStr = [dic objectForKey:@"rmessage"];
        if ([codeStr isEqualToString:@"0x0000"]) {
            [SVProgressHUD showSuccessWithStatus:@"下发成功！"];
            isSucBlock();
        }else{
            if (![codeStr isEqualToString:@"0x0016"]) {
                [SVProgressHUD showErrorWithStatus:msgStr];
            }
        }
    } fail:^{
        [SVProgressHUD showInfoWithStatus:@"网络异常,请检查网络"];
    }];
}




@end
