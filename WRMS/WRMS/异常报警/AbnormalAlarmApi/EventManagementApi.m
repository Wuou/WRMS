//
//  EventManagementApi.m
//  LeftSlide
//
//  Created by zhujintao on 16/7/20.
//  Copyright © 2016年 eamon. All rights reserved.
//

#import "EventManagementApi.h"
#import "ErrorAlertModel.h"
#import "AlarmOrderLogListModel.h"
#import "LogItemModel.h"
#import "ThreeModel.h"
#import "RichMediaModel.h"

@implementation EventManagementApi

+ (void)apiWithTableView:(UITableView *)tableView
                 pageNum:(NSInteger)pageNum
                 dataArr:(NSMutableArray *)dataArr
              pageChange:(PageChangeBlock)pageChange
               repeatArr:(RepeatBlock)repeatBlock{
    
    NSMutableDictionary *dictonary = [[NSMutableDictionary alloc] init];
    [dictonary setValue:[utils getlogName] forKey:@"userAccnt"];
    [dictonary setValue:@"0000"            forKey:@"status"];
    [dictonary setValue:[utils getUnitID]  forKey:@"unitId"];
    [dictonary setValue:[NSString stringWithFormat:@"%zd",pageNum]   forKey:@"pageNo"];
    [YNRequest YNPost:LBS_QueryAlarmOrderList parameters:dictonary success:^(NSDictionary *dic) {
        
        //        NSLog(@"%@", dic);
        NSString *codeStr  = [dic objectForKey:@"rcode"];
        NSString *totalStr = [dic objectForKey:@"total"];
        if ([codeStr isEqualToString:@"0x0000"]) {
            if ([totalStr integerValue] == 0) {
                [SVProgressHUD showInfoWithStatus:@"没有更多数据"];
                //执行page -= 1 操作
                pageChange();
            }else{
                NSArray *rowsDic = [dic objectForKey:@"rows"];
                for (NSDictionary *mydic in rowsDic) {
                    ErrorAlertModel *emModel = [[ErrorAlertModel alloc]initWithDictionary:mydic];
                    [dataArr addObject:emModel];
                }
                repeatBlock();
                if ([dataArr count] == 0) {
                    [SVProgressHUD showInfoWithStatus:@"无数据"];
                }else{
                    [SVProgressHUD dismiss];
                }
            }
        }else{
            if ([codeStr isEqualToString:@"0x0016"])
            {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [utils setLoginAgain];
                });
            }else{
                [SVProgressHUD dismiss];
            }
        }
        // 结束tableView的状态
        tableView.userInteractionEnabled = YES;
        tableView.scrollEnabled = YES;
        [tableView.header endRefreshing];
        [tableView.footer endRefreshing];
    } fail:^{
        // 结束tableView的状态
        tableView.userInteractionEnabled = YES;
        tableView.scrollEnabled = YES;
        [tableView.header endRefreshing];
        [tableView.footer endRefreshing];
        [SVProgressHUD showInfoWithStatus:@"网络异常！"];
    }];
}

+ (void)apiWithGetEventLevelWithLevelArr:(NSMutableArray *)levelArr {
    [levelArr removeAllObjects];
    //创建JSON
    NSDictionary *dictonary = [[NSMutableDictionary alloc] init];
    [dictonary setValue:@"ALARM_LEVEL" forKey:@"typeId"];
    //请求
    [YNRequest YNPost:LBS_QueryBaseParamTreeByTypeId parameters:dictonary success:^(NSDictionary *dic) {
        NSString *codeStr = [dic objectForKey:@"rcode"];
        if ([codeStr isEqualToString:@"0x0000"]) {
            NSArray *rowsDic = [dic objectForKey:@"rows"];
            for (NSDictionary *mydic in rowsDic) {
                ThreeModel *threemodel = [[ThreeModel alloc]initWithDict:mydic];
                [levelArr addObject:threemodel];
            }
        }
    } fail:^{
        [SVProgressHUD showInfoWithStatus:@"网络异常,请检查网络"];
    }];
    
}

+ (void)apiWithGetEventTypeDataWithArrType:(NSMutableArray *)arrType {
    [arrType removeAllObjects];
    //创建JSON
    NSDictionary *dictonary = [[NSMutableDictionary alloc] init];
    [dictonary setValue:@"POINT_ALARM_TYPE" forKey:@"typeId"];
    //请求
    [YNRequest YNPost:LBS_QueryBaseParamTreeByTypeId parameters:dictonary success:^(NSDictionary *dic) {
        NSString *codeStr     = [dic objectForKey:@"rcode"];
        if ([codeStr isEqualToString:@"0x0000"]) {
            NSArray *rowsDic = [dic objectForKey:@"rows"];
            for (NSDictionary *mydic in rowsDic) {
                ThreeModel *threemodel = [[ThreeModel alloc]initWithDict:mydic];
                [arrType addObject:threemodel];
            }
        }
    } fail:^{
        [SVProgressHUD showInfoWithStatus:@"网络异常,请检查网络"];
    }];
    
}

+ (void)apiWithErrorOrderStatus:(NSMutableArray *)arrId
                           arr2:(NSMutableArray *)arrText {
    [arrId removeAllObjects];
    [arrText removeAllObjects];
    //创建JSON
    NSMutableDictionary *dictonary = [NSMutableDictionary dictionary];
    [dictonary setValue:@"ALARM_DEAL_STATE" forKey:@"typeId"];
    
    //请求
    [YNRequest YNPost:LBS_QueryBaseParamTreeByTypeId parameters:dictonary success:^(NSDictionary *dic) {
        NSString *codeStr = [dic objectForKey:@"rcode"];
        if ([codeStr isEqualToString:@"0x0000"]) {
            NSArray *rowsDic = [dic objectForKey:@"rows"];
            
            for (NSDictionary *mydic in rowsDic) {
                NSString *strId   = [mydic objectForKey:@"id"];
                NSString *strText = [mydic objectForKey:@"text"];
                if (![strText isEqualToString:@"等待处置"]) {
                    [arrId addObject:strId];
                    [arrText addObject:strText];
                }
            }
        }else{
            [SVProgressHUD dismiss];
        }
    } fail:^{
        [SVProgressHUD showInfoWithStatus:@"网络异常"];
    }];
}

+ (void)apiWithOrderDealListOrderId:(NSString *)orderIdStr
                  alarmOrderListArr:(NSMutableArray *)alarmOrderListArr
                       successBlock:(GetListSucBlock)sucBlock {
    //创建JSON
    NSDictionary *dictonary = [[NSMutableDictionary alloc] init];
    [dictonary setValue:[utils getlogName] forKey:@"userAccnt"];
    [dictonary setValue:orderIdStr forKey:@"orderId"];
    
    //请求
    [YNRequest YNPost:LBS_QueryAlarmOrderLogList parameters:dictonary success:^(NSDictionary *dic) {
        //        NSLog(@"%@", dic);
        NSString *codeStr = [dic objectForKey:@"rcode"];
        NSString *msgStr      = [dic objectForKey:@"rmessage"];
        if ([codeStr isEqualToString:@"0x0000"]) {
            NSArray *rowsDic = [dic objectForKey:@"rows"];
            for (int i = 0; i< rowsDic.count; i++) {
                NSDictionary *mydic = rowsDic[i];
                AlarmOrderLogListModel *orderLogListModel = [[AlarmOrderLogListModel alloc]initWithDictionary:mydic];
                [alarmOrderListArr addObject:orderLogListModel];
            }
            sucBlock();
        }else{
            if ([codeStr isEqualToString:@"0x0016"])
            {
                [SVProgressHUD showErrorWithStatus:@"网络连接超时请返回到主页面重新进入该页面"];
            }else{
                [SVProgressHUD showErrorWithStatus:msgStr];
            }
        }
    } fail:^{
        
    }];
}

+ (void)apiWtihMediaList:(NSMutableArray *)arrMedia
                 orderId:(NSString *)orderID
                sucBlock:(GetMediaSucBlock)sucBlock {
    NSMutableDictionary *dictonary = [NSMutableDictionary dictionary];
    [dictonary setValue:[utils getlogName] forKey:@"userAccnt"];
    [dictonary setValue:orderID forKey:@"logId"];
    [dictonary setValue:@"" forKey:@"type"];
    
    //请求
    [YNRequest YNPost:LBS_QueryAlarmOrderLogItem parameters:dictonary success:^(NSDictionary *dic) {
        NSString *codeStr = [dic objectForKey:@"rcode"];
        if ([codeStr isEqualToString:@"0x0000"])
        {
            NSArray *rowsDic = [dic objectForKey:@"rows"];
            for (NSDictionary *mydic in rowsDic)
            {
                RichMediaModel *rmediamodel = [[RichMediaModel alloc]initWithDict:mydic];
                [arrMedia addObject:rmediamodel];
            }
            sucBlock();
        }
    } fail:^{
        [SVProgressHUD showInfoWithStatus:@"网络异常,请检查网络"];
    }];
}

@end
