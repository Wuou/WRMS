//
//  WellCell.h
//  公共cell
//
//  Created by yangjingchao on 15/10/14.
//  Copyright (c) 2015年 yongnuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WaterModel.h"
#import "Devicemodel.h"
#import "PointModel.h"

//cell右侧按钮点击代理
@protocol touchRightBtnDelegate <NSObject>
@optional
//水位纠错
-(void)touchWellError:(id)sender;
@optional
//设备安装
-(void)touchDeviceInstall:(id)sender;
@optional
//设备更换
-(void)touchDeviceChange:(id)sender;
@optional
//撤防布防
-(void)touchDrawWell:(id)sender;
@end

@interface WaterCell : UITableViewCell
/** 圆图片*/
@property (nonatomic,strong ) UIView      *roundnessView;
/** 编号*/
@property (nonatomic,strong ) UILabel     *IDLbl;
/** 标签*/
//@property (nonatomic,strong ) UIImageView *tagimageView;
/** 水位状态*/
//@property(nonatomic,strong ) UILabel *n2DeviceStateLbl;
/** 地址*/
@property (nonatomic,strong ) UILabel     *addrLbl;
/** 左侧数字编号*/
@property (nonatomic,strong ) UILabel     *leftIDLbl;
/** 终端编号*/
@property (nonatomic,strong ) UILabel     *terminalIDLbl;
/** 终端类型*/
@property (nonatomic,strong ) UILabel     *terminalType;
/** 终端状态*/
@property (nonatomic,strong ) UILabel     *terminalStatusLbl;
/** 公用cell 右侧button*/
@property (nonatomic, strong) UIButton    *rightBtn;
@property (nonatomic,strong) PointModel *pmodel;
/** 水位Model*/
@property (nonatomic,strong ) WaterModel   *model;
/** 设备Model*/
@property (nonatomic,copy   ) Devicemodel *devicemodel;
/** 区分公用cell内容的文字差异*/
@property (nonatomic, copy  ) NSString    *text;
@property (nonatomic,copy   ) NSString    *typStr;

@property(nonatomic,assign)id<touchRightBtnDelegate>delegate;

@end
