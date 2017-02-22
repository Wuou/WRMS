//
//  AlarmOrderLogListModel.h
//  LeftSlide
//
//  Created by zhujintao on 16/7/27.
//  Copyright © 2016年 YongNuoTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlarmOrderLogListModel : NSObject

/** 报警原因*/
@property (nonatomic, strong) NSString * alarmReason;
/** 报警发生时间*/
@property (nonatomic, strong) NSString * alarmTime;
/** 报警类型*/
@property (nonatomic, strong) NSString * alarmType;
/** 报警类型名称*/
@property (nonatomic, strong) NSString * alarmTypeName;
/** 水位编号*/
@property (nonatomic, strong) NSString * coversId;
/** 创建时间*/
@property (nonatomic, strong) NSString * createTime;
/** 创建账户*/
@property (nonatomic, strong) NSString * createUserAccnt;
/** 处理详情*/
@property (nonatomic, strong) NSString * dealDesc;
/** 处理时间*/
@property (nonatomic, strong) NSString * dealTime;
/** 处理人*/
@property (nonatomic, strong) NSString * dealUser;
/** 报警发布者*/
@property (nonatomic, strong) NSString * issuedUnitUser;
/** 记录编号*/
@property (nonatomic, strong) NSString * logId;
/** 数组，用于存储记录*/
@property (nonatomic, strong) NSArray  * logItems;
/** 机器编号*/
@property (nonatomic, strong) NSString * mchnId;
/** 订单编号*/
@property (nonatomic, strong) NSString * orderId;
/** 备注*/
@property (nonatomic, strong) NSString * remark;
/** 状态*/
@property (nonatomic, strong) NSString * status;
/** 状态名称*/
@property (nonatomic, strong) NSString * statusName;
/** 单位编号*/
@property (nonatomic, strong) NSString * unitId;
/** 单位名称*/
@property (nonatomic, strong) NSString * unitName;
/** 矫正时间*/
@property (nonatomic, strong) NSString * updateTime;
/** 矫正者账户*/
@property (nonatomic, strong) NSString * updateUserAccnt;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end
