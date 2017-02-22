//
//  PointModel.m
//  LeftSlide
//
//  Created by YangJingchao on 15/11/4.
//  Copyright © 2015年 eamon. All rights reserved.
//

#import "PointModel.h"

@implementation PointModel
-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(![dictionary[@"alarmFlag"] isKindOfClass:[NSNull class]]){
        self.alarmFlag = dictionary[@"alarmFlag"];
    }
    if(![dictionary[@"alarmStatus"] isKindOfClass:[NSNull class]]){
        self.alarmStatus = dictionary[@"alarmStatus"];
    }
    if(![dictionary[@"alarmStatusName"] isKindOfClass:[NSNull class]]){
        self.alarmStatusName = dictionary[@"alarmStatusName"];
    }
    if(![dictionary[@"altitude"] isKindOfClass:[NSNull class]]){
        self.altitude = dictionary[@"altitude"];
    }
    if(![dictionary[@"codeImei"] isKindOfClass:[NSNull class]]){
        self.codeImei = dictionary[@"codeImei"];
    }
    if(![dictionary[@"createTime"] isKindOfClass:[NSNull class]]){
        self.createTime = dictionary[@"createTime"];
    }
    if(![dictionary[@"createUserAccnt"] isKindOfClass:[NSNull class]]){
        self.createUserAccnt = dictionary[@"createUserAccnt"];
    }
    if(![dictionary[@"district"] isKindOfClass:[NSNull class]]){
        self.district = dictionary[@"district"];
    }
    if(![dictionary[@"installTime"] isKindOfClass:[NSNull class]]){
        self.installTime = dictionary[@"installTime"];
    }
    if(![dictionary[@"latitude"] isKindOfClass:[NSNull class]]){
        self.latitude = dictionary[@"latitude"];
    }
    if(![dictionary[@"location"] isKindOfClass:[NSNull class]]){
        self.location = dictionary[@"location"];
    }
    if(![dictionary[@"longitude"] isKindOfClass:[NSNull class]]){
        self.longitude = dictionary[@"longitude"];
    }
    if(![dictionary[@"pointId"] isKindOfClass:[NSNull class]]){
        self.pointId = dictionary[@"pointId"];
    }
    if(![dictionary[@"pointName"] isKindOfClass:[NSNull class]]){
        self.pointName = dictionary[@"pointName"];
    }
    if(![dictionary[@"pointTypeId"] isKindOfClass:[NSNull class]]){
        self.pointTypeId = dictionary[@"pointTypeId"];
    }
    if(![dictionary[@"pointTypeName"] isKindOfClass:[NSNull class]]){
        self.pointTypeName = dictionary[@"pointTypeName"];
    }
    if(![dictionary[@"remark"] isKindOfClass:[NSNull class]]){
        self.remark = dictionary[@"remark"];
    }
    if(![dictionary[@"unitId"] isKindOfClass:[NSNull class]]){
        self.unitId = dictionary[@"unitId"];
    }
    if(![dictionary[@"unitName"] isKindOfClass:[NSNull class]]){
        self.unitName = dictionary[@"unitName"];
    }
    if(![dictionary[@"updateTime"] isKindOfClass:[NSNull class]]){
        self.updateTime = dictionary[@"updateTime"];
    }
    if(![dictionary[@"updateUserAccnt"] isKindOfClass:[NSNull class]]){
        self.updateUserAccnt = dictionary[@"updateUserAccnt"];
    }
    if(![dictionary[@"userAccnt"] isKindOfClass:[NSNull class]]){
        self.userAccnt = dictionary[@"userAccnt"];
    }
    if(![dictionary[@"waterHeight"] isKindOfClass:[NSNull class]]){
        self.waterHeight = [dictionary[@"waterHeight"] floatValue];
    }
    
    if(![dictionary[@"waterMchnId"] isKindOfClass:[NSNull class]]){
        self.waterMchnId = dictionary[@"waterMchnId"];
    }	
    if(![dictionary[@"waterMchnName"] isKindOfClass:[NSNull class]]){
        self.waterMchnName = dictionary[@"waterMchnName"];
    }
    
    if(![dictionary[@"waterMchnState"] isKindOfClass:[NSNull class]]){
        self.waterMchnState = dictionary[@"waterMchnState"];
    }
    
    if(![dictionary[@"waterMchnStateName"] isKindOfClass:[NSNull class]]){
        self.waterMchnStateName = dictionary[@"waterMchnStateName"];
    }
    return self;
}

@end
