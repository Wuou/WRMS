//
//  ErrorOrderApi.m
//  LeftSlide
//
//  Created by YangJingchao on 16/5/19.
//  Copyright © 2016年 陕西永诺. All rights reserved.
//

#import "ErrorOrderApi.h"
#import "YNRequest.h"
#import "ErrorAlertModel.h"
#import "SVProgressHUD.h"

@implementation ErrorOrderApi

+ (void)apiWithErrorOrderList:(NSMutableArray *)arr
                  uiTableView:(UITableView *)tb
                 successBlock:(orderSucBlock)returnBlock {
    [SVProgressHUD showWithStatus:@"正在加载中..."];
    //参数
    NSDictionary *dictonary = [[NSMutableDictionary alloc] init];
    [dictonary setValue:[utils getlogName] forKey:@"userAccnt"];
    
    //请求
    [YNRequest YNPost:LBS_QueryAlarmOrderTaskList parameters:dictonary success:^(NSDictionary *dic) {
        
        NSString *totalStr    = [dic objectForKey:@"total"];
        NSString *codeStr = [dic objectForKey:@"rcode"];
        if ([codeStr isEqualToString:@"0x0000"])
        {
            NSArray *rowsDic = [dic objectForKey:@"rows"];
            if ([totalStr integerValue] == 0) {
                [SVProgressHUD showInfoWithStatus:@"暂时无数据..."];
            }else{
                for (NSDictionary *mydic in rowsDic) {
                    ErrorAlertModel *wellmodel = [[ErrorAlertModel alloc]initWithDictionary:mydic];
                    [arr addObject:wellmodel];
                }
            }
            if([arr count] == 0) {
                [SVProgressHUD showInfoWithStatus:@"暂时无数据..."];
            }else{
                [SVProgressHUD dismiss];
            }
            returnBlock();
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
        [tb.header endRefreshing];
        [tb.footer endRefreshing];
    } fail:^{
        [tb.header endRefreshing];
        [tb.footer endRefreshing];
        [SVProgressHUD showInfoWithStatus:@"网络异常,请检查网络"];
    }];
}

+ (void)apiWithErrorOrderStatus:(NSMutableArray *)arr1
                           arr2:(NSMutableArray *)arr2
                   successBlock:(orderArrSucBlock)returnBlock {
    //创建JSON
    NSDictionary *dictonary = [[NSMutableDictionary alloc] init];
    [dictonary setValue:@"ALARM_DEAL_STATE" forKey:@"typeId"];
    
    //请求
    [YNRequest YNPost:LBS_QueryBaseParamTreeByTypeId parameters:dictonary success:^(NSDictionary *dic) {
        NSString *codeStr = [dic objectForKey:@"rcode"];
        if ([codeStr isEqualToString:@"0x0000"]) {
            NSArray *rowsDic = [dic objectForKey:@"rows"];
            for (NSDictionary *mydic in rowsDic) {
                NSString *strId   = [mydic objectForKey:@"id"];
                NSString *strText = [mydic objectForKey:@"text"];
                [arr1 addObject:strId];
                [arr2 addObject:strText];
            }
            returnBlock();
        }else{
            [SVProgressHUD dismiss];
        }
    } fail:^{
        [SVProgressHUD showInfoWithStatus:@"网络异常,请检查网络"];
    }];
}

@end
