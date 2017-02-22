//
//  EventManagementVC.h
//  LeftSlide
//
//  Created by zhujintao on 16/7/20.
//  Copyright © 2016年 eamon. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ErrorAlertModel;
@interface ErrorAlertVC : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *myTB;
/** 右侧+按钮*/
@property (nonatomic,strong)YNNavigationRightBtn *rightBtn;
/** 定义一个展示数组*/
@property (nonatomic, strong) NSMutableArray      *showArr;
/** 定义一个接收数据的数组*/
@property (nonatomic,strong)NSMutableArray       *arrProduct;
@property (nonatomic,strong)YNTableView *eventManagementTable;
@property (nonatomic,strong)ErrorAlertModel *emModel;
/** 参数经度对应的值*/
@property (nonatomic,strong ) NSString            *latStr;
/** 参数纬度对应的值*/
@property (nonatomic,strong ) NSString            *longStr;
/** 参数海拔对应的值*/
@property (nonatomic,strong ) NSString            *heightStr;
/** 地址*/
@property (nonatomic,strong ) NSString            *locStr;
/** 当前分页数*/
@property (nonatomic, assign) NSInteger            pageNum;
@end
