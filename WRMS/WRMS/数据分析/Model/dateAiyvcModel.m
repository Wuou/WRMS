//
//  dateAiyvcModel.m
//  LeftSlide
//
//  Created by 杨景超 on 15/12/16.
//  Copyright © 2015年 陕西永诺信息科技. All rights reserved.
//

#import "dateAiyvcModel.h"

@implementation dateAiyvcModel
-(instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init])
    {
        self.stralarmType         = dict[@"alarmType"];
        self.stralarmTypeName     = dict[@"alarmTypeName"];
        self.strareaId            = dict[@"areaId"];
        self.strareaName          = dict[@"areaName"];
        self.strareaType          = dict[@"areaType"];

        self.strareaTypeName      = dict[@"areaTypeName"];
        self.strcoversType        = dict[@"coversType"];
        self.strcoversTypeName    = dict[@"coversTypeName"];
        self.strendDate           = dict[@"endDate"];
        self.strinProgress        = dict[@"inProgress"];
        self.inProgressPercent    = dict[@"inProgressPercen"];

        self.strnoNeedDeal        = dict[@"noNeedDeal"];
        self.strnoNeedDealPercent = dict[@"noNeedDealPercent"];
        self.strresolved          = dict[@"resolved"];
        self.strresolvedPercent   = dict[@"resolvedPercent"];
        self.strstartDate         = dict[@"startDate"];
        self.strstatisticDate     = dict[@"statisticDate"];

        self.strtotalNum          = dict[@"totalNum"];
        self.strunitId            = dict[@"unitId"];
        self.strunitName          = dict[@"unitName"];
        self.struserAccn          = dict[@"userAccnt"];
        self.strwaitDeal          = dict[@"waitDeal"];
        self.waitDealPercent      = dict[@"waitDealPercent"];

        self.coversNum            = dict[@"coversNum"];
        self.createMonth          = dict[@"createMonth"];
        self.createDay            = dict[@"createDay"];
        self.mchnNum              = dict[@"mchnNum"];
        self.avgDealTime          = dict[@"avgDealTime"];
        self.totalCount           = dict[@"totalCount"];
        self.alarmTime            = dict[@"alarmTime"];
        self.hours                = dict[@"hours"];
        self.paramNames           = dict[@"paramNames"];
        self.totalCounts          = dict[@"totalCounts"];
        
        self.waterLevel           = dict[@"waterLevel"];
        self.reportTime           = dict[@"reportTime"];
    }
    
    return  self;
}

@end
