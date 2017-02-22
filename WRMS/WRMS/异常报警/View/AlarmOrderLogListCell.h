//
//  AlarmOrderLogListCell.h
//  LeftSlide
//
//  Created by zhujintao on 16/7/27.
//  Copyright © 2016年 YongNuoTech. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AlarmOrderLogListModel,ErrorAlertModel;
@interface AlarmOrderLogListCell : UITableViewCell

/** 记录编号*/
@property (nonatomic,strong ) UILabel     *logIdLbl;
/** 报警类别*/
@property (nonatomic,strong ) UILabel     *alarmTypeNameLbl;
/** 分发单位*/
@property (nonatomic,strong ) UILabel     *issuedUnitUserLbl;
/** 创建时间*/
@property (nonatomic,strong ) UILabel     *createTimeLbl;
/** 分割线*/
@property (nonatomic,strong ) UILabel     *cellLineLbl;
@property (nonatomic,strong)AlarmOrderLogListModel *orderListModel;
@property (nonatomic,strong)ErrorAlertModel *emModel;
@end
