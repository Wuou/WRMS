//
//  MessageNotificationApi.m
//  LeftSlide
//
//  Created by zhujintao on 16/8/12.
//  Copyright © 2016年 YongNuoTech. All rights reserved.
//

#import "MessageNotificationApi.h"
#import "MsgModel.h"

@implementation MessageNotificationApi

+ (void)apiWithGetMessageNotificateionListMsgArr:(NSMutableArray *)msgArr
                                         pageNum:(NSInteger)pageNum
                                       tableView:(UITableView *)oneTableView
                                      pageChange:(PageChangeBlock)pageChange {
    NSDictionary *dictonary = [[NSMutableDictionary alloc] init];
    [dictonary setValue:[utils getlogName] forKey:@"userAccount"];
    [dictonary setValue:@"ios" forKey:@"platformType"];
    [dictonary setValue:[NSString stringWithFormat:@"%zd",pageNum]   forKey:@"pageNo"];
    [dictonary setValue:@"20"   forKey:@"pageSize"];
    [YNRequest YNPost:LBS_QueryMessageList parameters:dictonary success:^(NSDictionary *dic) {
        
        NSString *codeStr = [dic objectForKey:@"rcode"];
        if ([codeStr isEqualToString:@"0x0000"]) {
            NSArray *rowsDic = [dic objectForKey:@"rows"];
            if ([rowsDic count] == 0) {
                [SVProgressHUD showInfoWithStatus:@"没有数据"];
                pageChange();
            }
            for (NSDictionary *mydic in rowsDic) {
                MsgModel *msgModel = [[MsgModel alloc]initWithDictionary:mydic];
                [msgArr addObject:msgModel];
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
        
        [oneTableView reloadData];
        [SVProgressHUD dismiss];
        [oneTableView.header endRefreshing];
        [oneTableView.footer endRefreshing];
    } fail:^{
        
    }];
}
@end
