//
//  WellModel.m
//  LeftSlide
//
//  Created by YangJingchao on 15/12/16.
//  Copyright © 2015年 陕西永诺信息科技. All rights reserved.
//

#import "WaterModel.h"

@implementation WaterModel
-(instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init])
    {
        self.coversIdCustom       = dict[@"coversIdCustom"];
        self.alarmFlagstr         = dict[@"alarmFlag"];
        self.alarmStatusstr       = dict[@"alarmStatus"];
        self.alarmstatusNamestr   = dict[@"alarmstatusName"];
        self.altitudestr          = dict[@"altitude"];
        self.areaIdstr            = dict[@"areaId"];
        self.areaNamestr          = dict[@"areaName"];
        self.codeImeistr          = dict[@"codeImei"];
        self.coversIdstr          = dict[@"coversId"];
        self.coversIdsstr         = dict[@"coversIds"];
        self.coversInstallTimestr = dict[@"coversInstallTime"];
        self.coversNamestr        = dict[@"coversName"];
        self.coversTypestr        = dict[@"coversType"];
        self.coversTypeNamestr    = dict[@"coversTypeName"];
        self.createTimestr        = dict[@"createTime"];
        self.createUserAccntstr   = dict[@"createUserAccnt"];
        self.districtstr          = dict[@"district"];
        self.installTimestr       = dict[@"installTime"];
        self.latitudestr          = dict[@"latitude"];
        self.linkTelstr           = dict[@"linkTel"];
        self.linkUserstr          = dict[@"linkUser"];
        self.locationstr          = dict[@"location"];
        self.longitudestr         = dict[@"longitude"];
        self.mchnIdstr            = dict[@"mchnId"];
        self.mchnStatestr         = dict[@"mchnState"];
        self.mchnStateNamestr     = dict[@"mchnStateName"];
        self.modeIdstr            = dict[@"modeId"];
        self.modeNamestr          = dict[@"modeName"];
        self.nearbyFlagstr        = dict[@"nearbyFlag"];
        self.remarkstr            = dict[@"remark"];
        self.requestFlagstr       = dict[@"requestFlag"];
        self.statusstr            = dict[@"status"];
        self.statusNamestr        = dict[@"statusName"];
        self.unitIdstr            = dict[@"unitId"];
        self.unitNamestr          = dict[@"unitName"];
        self.updateTimestr        = dict[@"updateTime"];
        self.updateUserAccntstr   = dict[@"updateUserAccnt"];
        
        if(![dict[@"pointId"] isKindOfClass:[NSNull class]]){
            self.pointId = dict[@"pointId"];
        }
        if(![dict[@"pointName"] isKindOfClass:[NSNull class]]){
            self.pointName = dict[@"pointName"];
        }
        if(![dict[@"pointTypeId"] isKindOfClass:[NSNull class]]){
            self.pointTypeId = dict[@"pointTypeId"];
        }
        if(![dict[@"pointTypeName"] isKindOfClass:[NSNull class]]){
            self.pointTypeName = dict[@"pointTypeName"];
        }
        
        if(![dict[@"waterHeight"] isKindOfClass:[NSNull class]]){
            self.waterHeight = [dict[@"waterHeight"] floatValue];
        }
        
        if(![dict[@"waterMchnId"] isKindOfClass:[NSNull class]]){
            self.waterMchnId = dict[@"waterMchnId"];
        }
        if(![dict[@"waterMchnName"] isKindOfClass:[NSNull class]]){
            self.waterMchnName = dict[@"waterMchnName"];
        }
        
        if(![dict[@"waterMchnState"] isKindOfClass:[NSNull class]]){
            self.waterMchnState = dict[@"waterMchnState"];
        }
        
        if(![dict[@"waterMchnStateName"] isKindOfClass:[NSNull class]]){
            self.waterMchnStateName = dict[@"waterMchnStateName"];
        }
        
    }
    
    return  self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    
}


@end
