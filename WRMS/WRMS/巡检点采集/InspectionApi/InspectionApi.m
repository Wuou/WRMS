//
//  InspectionApi.m
//  LeftSlide
//
//  Created by YangJingchao on 2016/7/21.
//  Copyright © 2016年 eamon. All rights reserved.
//

#import "InspectionApi.h"
#import "ThreeModel.h"
#import "PointTypeModel.h"
#import "RichMediaModel.h"

@implementation InspectionApi

+ (void)apiWithInspecList:(UITableView *)tableView
                  pageNum:(NSInteger)pageNum
               arrProduct:(NSMutableArray *)arrProduct
               pageChange:(PageChangeBlock)pageChange
                repeatArr:(RepeatBlock)repeatBlock{
    
    
    
    NSMutableDictionary *dictonary = [NSMutableDictionary  dictionary];
    
    [dictonary setValue:[utils getlogName] forKey:@"userAccnt"];
    [dictonary setValue:[NSString stringWithFormat:@"%zd",pageNum]   forKey:@"pageNo"];

    [YNRequest YNPost:LBS_QueryMonitorPointList parameters:dictonary success:^(NSDictionary *dic) {
        
        NSString *codeStr     = [dic objectForKey:@"rcode"];
        NSString *totalStr    = [dic objectForKey:@"total"];
        if ([codeStr isEqualToString:@"0x0000"])
        {
            if ([totalStr integerValue] == 0) {
                [SVProgressHUD showInfoWithStatus:@"没有更多数据"];
                pageChange();
            }else{
                NSArray *rowsDic = [dic objectForKey:@"rows"];
                
                for (NSDictionary *mydic in rowsDic) {
                    NSLog(@"%@",mydic);
                    PointModel *pmodel = [[PointModel alloc] initWithDictionary:mydic];
                    [arrProduct addObject:pmodel];
                }
                repeatBlock();
                if([arrProduct count] == 0) {
                    [SVProgressHUD showInfoWithStatus:@"无数据"];
                }else{
                    [SVProgressHUD dismiss];
                }
            }
        }else {
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
        [SVProgressHUD showInfoWithStatus:@"网络异常"];
    }];
}


+ (void)apiWtihPicList:(NSMutableArray *)arrMedia
               pointID:(NSString *)pointID
              sucBlock:(inspecSucBlock)sucBlock {
    
    NSMutableDictionary *dictonary = [NSMutableDictionary dictionary];
    [dictonary setValue:pointID forKey:@"pointId"];
    
    //请求
    [YNRequest YNPost:LBS_QueryMonitorPointItemList parameters:dictonary success:^(NSDictionary *dic) {
        
//        NSLog(@"%@", dic);
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


+ (void)apiAddInspec:(NSDictionary *)dictionary
              arrPic:(NSMutableArray *)arrPic
           uploadPic:(UploadPicBlock)uploadPicBlock
      viewController:(UIViewController *)viewController {

    [YNRequest YNPost:LBS_CreateMonitorPoint parameters:dictionary success:^(NSDictionary *dic) {
        
//        NSLog(@"%@", dic);
        NSString *codeStr     = [dic objectForKey:@"rcode"];
        NSString *msgStr     = [dic objectForKey:@"rmessage"];
        if ([codeStr isEqualToString:@"0x0000"])
        {
            NSArray *arrRows= [dic objectForKey:@"rows"];
            if (arrPic.count > 0) { // 如果照片数组大于0，则启动照片上传功能
                
                uploadPicBlock(arrRows[0]);
            }else{
                
                [SVProgressHUD showInfoWithStatus:@"新增监测点成功！"];
                [viewController.navigationController popViewControllerAnimated:YES];
            }
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"RefreshInspecList" object:nil userInfo:nil];
            
        }else{
            if (![codeStr isEqualToString:@"0x0016"]) {
                [SVProgressHUD showInfoWithStatus:msgStr];
            }
            
        }
        
    } fail:^{
        [SVProgressHUD showInfoWithStatus:@"网络异常"];
    }];
    
}

+ (void)apiUpdateInspec:(NSDictionary *)dictionary
                 arrPic:(NSMutableArray *)arrPic
              uploadPic:(UploadPicBlock)uploadPicBlock
         viewController:(UIViewController *)viewController{
    
    [YNRequest YNPost:LBS_CreateMonitorPoint parameters:dictionary success:^(NSDictionary *dic) {
        NSString *codeStr = [dic objectForKey:@"rcode"];
        NSString *msgStr = [dic objectForKey:@"rmessage"];
        if ([codeStr isEqualToString:@"0x0000"])
        {
            NSArray *arrRows= [dic objectForKey:@"rows"];
            if (arrPic.count > 0) { // 如果照片数组大于0，则启动照片上传功能
                
                uploadPicBlock(arrRows[0]);
            }else{
                
                [SVProgressHUD showInfoWithStatus:@"新增监测点成功！"];
                NSInteger index = [[viewController.navigationController viewControllers]indexOfObject:viewController];
                [viewController.navigationController popToViewController:[viewController.navigationController.viewControllers objectAtIndex:index - 2] animated:YES];
            }
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"RefreshInspecList" object:nil userInfo:nil];
        }else{
            if (![codeStr isEqualToString:@"0x0016"])
            [SVProgressHUD showInfoWithStatus:msgStr];
        }
        
    } fail:^{
        [SVProgressHUD showInfoWithStatus:@"网络异常"];
    }];
}

+ (void)apiGetWellImeiWithTfID:(NSString *)tfID
                       success:(GetImeiSuccessBlock)success
                          fail:(GetImeiFailBlock)fail {
    NSString *ids = tfID;
    ids           = [ids stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (tfID !=nil || ![tfID isEqualToString:@""]) {
        //创建JSON
        NSMutableDictionary *dictonary = [[NSMutableDictionary alloc] init];
        [dictonary setValue:ids forKey:@"mchnId"];
        [dictonary setValue:[utils getUnitID] forKey:@"unitId"];
        
        //请求
        [YNRequest YNPost:LBS_QueryMchnList parameters:dictonary success:^(NSDictionary *dic) {
            
            NSString *codeStr     = [dic objectForKey:@"rcode"];
            if ([codeStr isEqualToString:@"0x0000"]) {
                NSArray *rowsDic = [dic objectForKey:@"rows"];
                for (NSDictionary *mydic in rowsDic) {
                    success(mydic);
                }
            }else{
                [SVProgressHUD showErrorWithStatus:@"请输入正确的设备编号"];
                fail();
            }
            
        } fail:^{
            [SVProgressHUD showInfoWithStatus:@"网络异常"];
        }];
    }
}

+ (void)apiGetTypeDataWithArrType:(NSMutableArray *)arrType {
    [arrType removeAllObjects];
    //创建JSON
    NSMutableDictionary *dictonary = [[NSMutableDictionary alloc] init];
    [dictonary setValue:[utils getlogName] forKey:@"userAccnt"];
    //请求
    [YNRequest YNPost:LBS_QueryMonitorPointTypeList parameters:dictonary success:^(NSDictionary *dic) {
        
        NSString *codeStr     = [dic objectForKey:@"rcode"];
        if ([codeStr isEqualToString:@"0x0000"]) {
            NSArray *rowsDic = [dic objectForKey:@"rows"];
            for (NSDictionary *mydic in rowsDic) {
                PointTypeModel *threemodel = [[PointTypeModel alloc]initWithDictionary:mydic];
                [arrType addObject:threemodel];
            }
        }
    } fail:^{
        [SVProgressHUD showInfoWithStatus:@"网络异常"];
    }];
    
}

+ (void)apiGetUnitWithArrUnit:(NSMutableArray *)arrUnit
                        ArrID:(NSMutableArray *)arrID
                      arrText:(NSMutableArray *)arrText
                   isShowList:(IsShowUnitListBlock)isShowList {
    [arrUnit removeAllObjects];
    //创建JSON
    NSMutableDictionary *dictonary = [[NSMutableDictionary alloc] init];
    //请求
    [YNRequest YNPost:LBS_QueryUnitTree parameters:dictonary success:^(NSDictionary *dic) {
        NSString *codeStr     = [dic objectForKey:@"rcode"];
        if ([codeStr isEqualToString:@"0x0000"]) {
            NSArray *rowsDic = [dic objectForKey:@"rows"];
            for (NSDictionary *mydic in rowsDic) {
                ThreeModel *threemodel = [[ThreeModel alloc]initWithDict:mydic];
                [arrUnit addObject:threemodel];
            }
            for (ThreeModel *tmodel in arrUnit) {
                if (![arrID containsObject:tmodel.strid]) {
                    [arrID addObject:tmodel.strid];
                }
                if (![arrText containsObject:tmodel.strtext]) {
                    [arrText addObject:tmodel.strtext];
                }
            }
            //            NSLog(@"==%@",self.arrID_Unit);
            //如果当前负责单位在查询的单位列表里，则不显示列表，反则显示
            if ( [arrID containsObject:[utils getUnitID]]) {
                isShowList();
            }
        }
    } fail:^{
        [SVProgressHUD showInfoWithStatus:@"网络异常"];
    }];
}

@end
