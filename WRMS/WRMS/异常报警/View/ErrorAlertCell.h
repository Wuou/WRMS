//
//  EventManagementCell.h
//  LeftSlide
//
//  Created by zhujintao on 16/7/20.
//  Copyright © 2016年 eamon. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ErrorAlertModel;
//右侧地理按钮的点击报警
@protocol touchRightBtnDelegate <NSObject>
//地图展示报警位置
- (void)touchlocBtnAction:(id)sender;

@end
@interface ErrorAlertCell : UITableViewCell

/** 圆图片*/
@property (nonatomic,strong ) UIView *roundnessView;
/** 编号*/
@property (nonatomic,strong ) UILabel *IDLbl;
/** 报警类型*/
@property (nonatomic,strong ) UILabel     *eventTypeLbl;
/** 报警等级*/
@property (nonatomic,strong ) UILabel *levelLbl;
/** 标签*/
@property (nonatomic,strong ) UIImageView *tagimageView;
/** 地址*/
@property (nonatomic,strong ) UILabel *addrLbl;
/** 左侧数字编号*/
@property (nonatomic,strong ) UILabel *leftIDLbl;
/** 位置按钮*/
@property (nonatomic,strong ) UIButton *locBtn;
/** 报警类型名称*/
@property (nonatomic,strong ) UILabel *alarmTypeNameLbl;
@property (nonatomic,strong) UILabel *labelStatusTitle;
@property (nonatomic,strong) UILabel *labelStatus;
@property (nonatomic,strong ) ErrorAlertModel *emModel;
//声明代理
@property (nonatomic,weak) id<touchRightBtnDelegate> delegate;

@end
