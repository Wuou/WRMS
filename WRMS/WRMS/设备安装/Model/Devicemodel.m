//
//  DeviceInstallVCmodel.m
//  LeftSlide
//
//  Created by 杨景超 on 15/12/21.
//  Copyright © 2015年 陕西永诺信息科技. All rights reserved.
//

#import "Devicemodel.h"

@implementation Devicemodel
-(instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init])
    {
        self.coversIdCustom     = dict[@"coversIdCustom"];
        self.strlocation        = dict[@"location"];//地址
        self.strcoversId        = dict[@"coversId"];//水位编号
        self.strmodeId          = dict[@"modeId"];//水位型号//
        self.strcoversTypeName  = dict[@"coversTypeName"];//水位型号

        self.strmchnId          = dict[@"mchnId"];//设备编号
        self.strcodeImei        = dict[@"codeImei"];//imei
        self.strunitName        = dict[@"unitName"];//所属单位
        self.strinstallTime     = dict[@"createTime"];//安装时间
        self.strlinkUser        = dict[@"linkUser"];//联系人
        self.strlinkTel         = dict[@"linkTel"];//联系电话
        self.strstatusName      = dict[@"statusName"];//水位状态
        self.strremark          = dict[@"remark"];//备注信息
        self.strlongitude       = dict[@"longitude"];//
        self.straltitude        = dict[@"latitude"];//
        self.strmodeName        = dict[@"modeName"];//
        self.strunitId          = dict[@"unitId"];//单位编号
        self.strupdateUserAccnt = dict[@"updateUserAccnt"];//
        self.mchnStatestr       = dict[@"mchnState"];
        self.mchnStateNamestr   = dict[@"mchnStateName"];
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

@end
