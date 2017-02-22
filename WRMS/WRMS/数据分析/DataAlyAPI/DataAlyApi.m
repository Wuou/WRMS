//
//  DataAlyApi.m
//  LeftSlide
//
//  Created by YangJingchao on 16/5/19.
//  Copyright © 2016年 陕西永诺. All rights reserved.
//

#import "DataAlyApi.h"
#import "YNRequest.h"
#import "DataAnalysisModel.h"
#import "dateAiyvcModel.h"
#import "SVProgressHUD.h"

@implementation DataAlyApi

+ (void)apiWithAlarmOrderMonth:(NSString *)startTime
                       endTime:(NSString *)endTime
                         nsArr:(NSMutableArray *)ArrY_Chart
                        nsArr2:(NSMutableArray *)ArrY_Chart2
                        nsArrX:(NSMutableArray *)ArrX_Chart
                  successBlock:(dataSucArrBlock)returnBlock
{
    [SVProgressHUD showWithStatus:@"正在加载中..." maskType:(SVProgressHUDMaskTypeClear)];
    //参数
    NSDictionary *dictonary = [[NSMutableDictionary alloc] init];
    [dictonary setValue:[utils getlogName] forKey:@"userAccnt"];
    [dictonary setValue:startTime forKey:@"startDate"];
    [dictonary setValue:endTime forKey:@"endDate"];
    
    //请求
    [YNRequest YNPost:LBS_StatisticsAlarmOrderByMonth parameters:dictonary success:^(NSDictionary *dic) {
        [SVProgressHUD dismiss];
        NSString *codeStr = [dic objectForKey:@"rcode"];
        if ([codeStr isEqualToString:@"0x0000"])
        {
            NSArray *rowsDic = [dic objectForKey:@"rows"];
            for (NSDictionary *mydic in rowsDic)
            {
                dateAiyvcModel *damodel = [[dateAiyvcModel alloc]initWithDict:mydic];
                //第一组
                NSString *strCoverNum = damodel.totalCount;
                [ArrY_Chart addObject:strCoverNum];
                //第二组
                NSString *strMchnNum = damodel.avgDealTime;
                [ArrY_Chart2 addObject:strMchnNum];
                //日期
                NSString *strDate = damodel.alarmTime;
                [ArrX_Chart addObject:strDate];
            }
            returnBlock();
        }
    } fail:^{
         [SVProgressHUD showInfoWithStatus:@"网络异常,请检查网络"];
    }];
}

+ (void)apiWithAlarmOrderDay:(NSString *)statistic
                       nsArr:(NSMutableArray *)ArrY_Chart
                      nsArr2:(NSMutableArray *)ArrY_Chart2
                      nsArrX:(NSMutableArray *)ArrX_Chart
                successBlock:(dataSucArrBlock)returnBlock
{
    [SVProgressHUD showWithStatus:@"正在加载中..." maskType:(SVProgressHUDMaskTypeClear)];
    //创建JSON
    NSDictionary *dictonary = [[NSMutableDictionary alloc] init];
    [dictonary setValue:[utils getlogName] forKey:@"userAccnt"];
    [dictonary setValue:statistic forKey:@"statisticDate"];
    
    //请求
    [YNRequest YNPost:LBS_StatisticsAlarmOrderByDay parameters:dictonary success:^(NSDictionary *dic) {
        [SVProgressHUD dismiss];
        NSString *codeStr = [dic objectForKey:@"rcode"];
        if ([codeStr isEqualToString:@"0x0000"])
        {
            NSArray *rowsDic = [dic objectForKey:@"rows"];
            for (NSDictionary *mydic in rowsDic)
            {
                dateAiyvcModel *damodel = [[dateAiyvcModel alloc]initWithDict:mydic];
                //第一组
                NSString *strCoverNum = damodel.totalCount;
                [ArrY_Chart addObject:strCoverNum];
                //第二组
                NSString *strMchnNum = damodel.avgDealTime;
                [ArrY_Chart2 addObject:strMchnNum];
                //日期
                NSString *strDate = damodel.alarmTime;
                [ArrX_Chart addObject:strDate];
            }
            returnBlock();
        }
    } fail:^{
         [SVProgressHUD showInfoWithStatus:@"网络异常,请检查网络"];
    }];

}


+ (void)apiWithWaterMonth:(NSString *)startTime
                  endTime:(NSString *)endTime
                    nsArr:(NSMutableArray *)ArrY_Chart
                   nsArr2:(NSMutableArray *)ArrY_Chart2
                   nsArrX:(NSMutableArray *)ArrX_Chart
             successBlock:(dataSucArrBlock)returnBlock
{
    [SVProgressHUD showWithStatus:@"正在加载中..." maskType:(SVProgressHUDMaskTypeClear)];
    //参数
    NSDictionary *dictonary = [[NSMutableDictionary alloc] init];
    [dictonary setValue:[utils getlogName] forKey:@"userAccnt"];
    [dictonary setValue:startTime forKey:@"startDate"];
    [dictonary setValue:endTime forKey:@"endDate"];
    
    //请求 LBS_StatisticsWaterMchnByMonth
    [YNRequest YNPost:LBS_StatisticsWaterMchnByMonth parameters:dictonary success:^(NSDictionary *dic) {
        [SVProgressHUD dismiss];
//        NSLog(@"%@", dic);
        NSString *codeStr = [dic objectForKey:@"rcode"];
        if ([codeStr isEqualToString:@"0x0000"])
        {
            NSArray *rowsDic = [dic objectForKey:@"rows"];
            for (NSDictionary *mydic in rowsDic)
            {
                dateAiyvcModel *damodel = [[dateAiyvcModel alloc]initWithDict:mydic];
                //第一组
                NSString *strCoverNum = damodel.waterLevel;
                [ArrY_Chart addObject:strCoverNum];
                //第二组
                NSString *strMchnNum = damodel.totalCount;
                [ArrY_Chart2 addObject:strMchnNum];
                //日期
                NSString *strDate = damodel.reportTime;
                [ArrX_Chart addObject:strDate];
                
            }
            returnBlock();
        }
        
    } fail:^{
        [SVProgressHUD showInfoWithStatus:@"网络异常,请检查网络"];
    }];
}


+ (void)apiWithWaterDay:(NSString *)statistic
                  nsArr:(NSMutableArray *)ArrY_Chart
                 nsArr2:(NSMutableArray *)ArrY_Chart2
                 nsArrX:(NSMutableArray *)ArrX_Chart
           successBlock:(dataSucArrBlock)returnBlock
{
    [SVProgressHUD showWithStatus:@"正在加载中..." maskType:(SVProgressHUDMaskTypeClear)];
    //创建JSON
    NSDictionary *dictonary = [[NSMutableDictionary alloc] init];
    [dictonary setValue:[utils getlogName] forKey:@"userAccnt"];
    [dictonary setValue:statistic forKey:@"statisticDate"];
    
    //请求
    [YNRequest YNPost:LBS_StatisticsWaterMchnByDay parameters:dictonary success:^(NSDictionary *dic) {
        [SVProgressHUD dismiss];
//        NSLog(@"%@", dic);
        NSString *codeStr = [dic objectForKey:@"rcode"];
        if ([codeStr isEqualToString:@"0x0000"])
        {
            NSArray *rowsDic = [dic objectForKey:@"rows"];
            for (NSDictionary *mydic in rowsDic)
            {
                dateAiyvcModel *damodel = [[dateAiyvcModel alloc]initWithDict:mydic];
                //第一组
                NSString *strCoverNum = damodel.waterLevel;
                [ArrY_Chart addObject:strCoverNum];
                //第二组
                NSString *strMchnNum = damodel.totalCount;
                [ArrY_Chart2 addObject:strMchnNum];
                //日期
                NSString *strDate = damodel.reportTime;
                [ArrX_Chart addObject:strDate];
            }
            returnBlock();
        }
    } fail:^{
        [SVProgressHUD showInfoWithStatus:@"网络异常,请检查网络"];
    }];
}


@end
