//
//  inspectionCell.h
//  LeftSlide
//
//  Created by YangJingchao on 2016/7/19.
//  Copyright © 2016年 eamon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PointModel.h"

@interface inspectionCell : UITableViewCell
/** 圆图片*/
@property (nonatomic,strong ) UIView      *roundnessView;
/** 编号*/
@property (nonatomic,strong ) UILabel     *IDLbl;
/** 标签*/
@property (nonatomic,strong ) UIImageView *tagimageView;
/** 水位状态*/
@property(nonatomic,strong ) UILabel *n2DeviceStateLbl;
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

@property (nonatomic,strong) UILabel *labelMchnId;


//巡检点Model
@property (nonatomic,strong )PointModel *pointModel;
-(void)setText;
@end
