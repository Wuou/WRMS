//
//	EventManagementModel.m
//
//	Create by zhujintao on 22/7/2016
//	Copyright © 2016. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "ErrorAlertModel.h"

@interface ErrorAlertModel ()
@end
@implementation ErrorAlertModel

/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */
-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(![dictionary[@"alarmLevel"] isKindOfClass:[NSNull class]]){
        self.alarmLevel = dictionary[@"alarmLevel"];
    }
    if(![dictionary[@"alarmLevelName"] isKindOfClass:[NSNull class]]){
        self.alarmLevelName = dictionary[@"alarmLevelName"];
    }
    if(![dictionary[@"alarmReason"] isKindOfClass:[NSNull class]]){
        self.alarmReason = dictionary[@"alarmReason"];
    }
    if(![dictionary[@"alarmTime"] isKindOfClass:[NSNull class]]){
        self.alarmTime = dictionary[@"alarmTime"];
    }
    if(![dictionary[@"alarmType"] isKindOfClass:[NSNull class]]){
        self.alarmType = dictionary[@"alarmType"];
    }
    if(![dictionary[@"alarmTypeName"] isKindOfClass:[NSNull class]]){
        self.alarmTypeName = dictionary[@"alarmTypeName"];
    }
    if(![dictionary[@"coversIdCustom"] isKindOfClass:[NSNull class]]){
        self.coversIdCustom = dictionary[@"coversIdCustom"];
    }
    if(![dictionary[@"createTime"] isKindOfClass:[NSNull class]]){
        self.createTime = dictionary[@"createTime"];
    }
    if(![dictionary[@"createUserAccnt"] isKindOfClass:[NSNull class]]){
        self.createUserAccnt = dictionary[@"createUserAccnt"];
    }
    if(![dictionary[@"dealDesc"] isKindOfClass:[NSNull class]]){
        self.dealDesc = dictionary[@"dealDesc"];
    }
    if(![dictionary[@"dealTime"] isKindOfClass:[NSNull class]]){
        self.dealTime = dictionary[@"dealTime"];
    }
    if(![dictionary[@"dealUser"] isKindOfClass:[NSNull class]]){
        self.dealUser = dictionary[@"dealUser"];
    }
    if(![dictionary[@"executionTime"] isKindOfClass:[NSNull class]]){
        self.executionTime = dictionary[@"executionTime"];
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
    if(![dictionary[@"mchnId"] isKindOfClass:[NSNull class]]){
        self.mchnId = dictionary[@"mchnId"];
    }
    if(![dictionary[@"orderId"] isKindOfClass:[NSNull class]]){
        self.orderId = dictionary[@"orderId"];
    }
    if(![dictionary[@"orderLogId"] isKindOfClass:[NSNull class]]){
        self.orderLogId = dictionary[@"orderLogId"];
    }
    if(![dictionary[@"pointId"] isKindOfClass:[NSNull class]]){
        self.pointId = dictionary[@"pointId"];
    }
    if(![dictionary[@"status"] isKindOfClass:[NSNull class]]){
        self.status = dictionary[@"status"];
    }
    if(![dictionary[@"statusName"] isKindOfClass:[NSNull class]]){
        self.statusName = dictionary[@"statusName"];
    }
    if(![dictionary[@"unitId"] isKindOfClass:[NSNull class]]){
        self.unitId = dictionary[@"unitId"];
    }
    if(![dictionary[@"updateTime"] isKindOfClass:[NSNull class]]){
        self.updateTime = dictionary[@"updateTime"];
    }	
    if(![dictionary[@"updateUserAccnt"] isKindOfClass:[NSNull class]]){
        self.updateUserAccnt = dictionary[@"updateUserAccnt"];
    }
    
    return self;
}

@end