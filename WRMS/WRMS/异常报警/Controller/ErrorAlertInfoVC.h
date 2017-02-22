//
//  EventManagementInfoVC.h
//  LeftSlide
//
//  Created by zhujintao on 16/7/20.
//  Copyright © 2016年 eamon. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ErrorAlertModel;
@interface ErrorAlertInfoVC : UIViewController

@property (weak, nonatomic) IBOutlet UIScrollView *mySV;
/** Lbl显示报警类别*/
@property (weak, nonatomic) IBOutlet UILabel *alarmTypeLbl;
/** Lbl显示报警等级*/
@property (weak, nonatomic) IBOutlet UILabel *alarmLevelLbl;
/** Lbl显示单位名称*/
@property (weak, nonatomic) IBOutlet UILabel *unitNameLbl;
/** Lbl显示创建者*/
@property (weak, nonatomic) IBOutlet UILabel *createUserAccntLbl;
/** Lbl显示处理时间*/
@property (weak, nonatomic) IBOutlet UILabel *dealTimeLbl;
/** Lbl显示处理详情*/
@property (weak, nonatomic) IBOutlet UILabel *dealDescLbl;
/** Lbl显示报警原因*/
@property (weak, nonatomic) IBOutlet UILabel *alarmReasonLbl;
/** Lbl显示分割线*/
@property (weak, nonatomic) IBOutlet UILabel *cutLbl;
/** Lbl显示地址*/
@property (weak, nonatomic) IBOutlet UILabel *locationLbl;
/** Lbl显示地址标题*/
@property (weak, nonatomic) IBOutlet UILabel *locationTitle;
@property (nonatomic,strong) NSString *strFromType; 

@property (nonatomic,strong)ErrorAlertModel *wmodel;
@property (nonatomic,strong)NSString *orderIdStr;

@end
