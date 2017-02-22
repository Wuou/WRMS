//
//  dateAiyvcModel.h
//  LeftSlide
//   工单Model
//  Created by 杨景超 on 15/12/16.
//  Copyright © 2015年 陕西永诺信息科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface dateAiyvcModel : NSObject

/** 报警类型*/
@property(nonatomic,strong)NSString *stralarmType;
/** 报警类型名称*/
@property(nonatomic,strong)NSString *stralarmTypeName;
/** 区域ID*/
@property(nonatomic,strong)NSString *strareaId;
/** 区域名称*/
@property(nonatomic,strong)NSString *strareaName;
/** 区域类型*/
@property(nonatomic,strong)NSString *strareaType;
/** 区域类型名称*/
@property(nonatomic,strong)NSString *strareaTypeName;
/** 水位类型*/
@property(nonatomic,strong)NSString *strcoversType;
/** 水位类型名称*/
@property(nonatomic,strong)NSString *strcoversTypeName;
/** 结束日期*/
@property(nonatomic,strong)NSString *strendDate;
/** 处理进度*/
@property(nonatomic,strong)NSString *strinProgress;
/** 进度百分比*/
@property(nonatomic,strong)NSString *inProgressPercent;
/** 暂无需要处理*/
@property(nonatomic,strong)NSString *strnoNeedDeal;
/** 暂无需要处理所占百分比*/
@property(nonatomic,strong)NSString *strnoNeedDealPercent;
/** 处理完成*/
@property(nonatomic,strong)NSString *strresolved;
/** 处理完成所占百分比*/
@property(nonatomic,strong)NSString *strresolvedPercent;
/** 开始时间*/
@property(nonatomic,strong)NSString *strstartDate;
@property(nonatomic,strong)NSString *strstatisticDate;
@property(nonatomic,strong)NSString *strtotalNum;
/** 单位ID*/
@property(nonatomic,strong)NSString *strunitId;
/** 单位名称*/
@property(nonatomic,strong)NSString *strunitName;
/** 用户账号*/
@property(nonatomic,strong)NSString *struserAccn;
/** 等待处理*/
@property(nonatomic,strong)NSString *strwaitDeal;
/** 等待处理百分比*/
@property(nonatomic,strong)NSString *waitDealPercent;
@property(nonatomic,strong)NSString *coversNum;
/** 创建月份*/
@property(nonatomic,strong)NSString *createMonth;
/** 创建当天时间*/
@property(nonatomic,strong)NSString *createDay;
@property(nonatomic,strong)NSString *mchnNum;
/** 平均处理时间*/
@property(nonatomic,strong)NSString *avgDealTime;
/** 总数*/
@property(nonatomic,strong)NSString *totalCount;
/** 报警时间*/
@property(nonatomic,strong)NSString *alarmTime;
/** 小时*/
@property(nonatomic,strong)NSString *hours;
/** 参数名*/
@property(nonatomic,strong)NSString *paramNames;
/** 总量*/
@property(nonatomic,strong)NSString *totalCounts;
/** 水位*/
@property (nonatomic, strong) NSString *waterLevel;
/** 报告时间*/
@property (nonatomic, strong) NSString *reportTime;

-(instancetype)initWithDict:(NSDictionary *)dict;

@end
