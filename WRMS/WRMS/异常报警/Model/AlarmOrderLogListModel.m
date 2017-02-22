//
//  AlarmOrderLogListModel.m
//  LeftSlide
//
//  Created by zhujintao on 16/7/27.
//  Copyright © 2016年 YongNuoTech. All rights reserved.
//

#import "AlarmOrderLogListModel.h"
#import "LogItemModel.h"

@implementation AlarmOrderLogListModel
-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
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
    if(![dictionary[@"coversId"] isKindOfClass:[NSNull class]]){
        self.coversId = dictionary[@"coversId"];
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
    if(![dictionary[@"issuedUnitUser"] isKindOfClass:[NSNull class]]){
        self.issuedUnitUser = dictionary[@"issuedUnitUser"];
    }
    if(![dictionary[@"logId"] isKindOfClass:[NSNull class]]){
        self.logId = dictionary[@"logId"];
    }
    if(dictionary[@"logItems"] != nil && [dictionary[@"logItems"] isKindOfClass:[NSArray class]]){
        NSArray * logItemsDictionaries = dictionary[@"logItems"];
        NSMutableArray * logItemsItems = [NSMutableArray array];
        for(NSDictionary * logItemsDictionary in logItemsDictionaries){
            LogItemModel * logItemsItem = [[LogItemModel alloc] initWithDictionary:logItemsDictionary];
            [logItemsItems addObject:logItemsItem];
        }
        self.logItems = logItemsItems;
    }
    if(![dictionary[@"mchnId"] isKindOfClass:[NSNull class]]){
        self.mchnId = dictionary[@"mchnId"];
    }
    if(![dictionary[@"orderId"] isKindOfClass:[NSNull class]]){
        self.orderId = dictionary[@"orderId"];
    }
    if(![dictionary[@"remark"] isKindOfClass:[NSNull class]]){
        self.remark = dictionary[@"remark"];
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
    if(![dictionary[@"unitName"] isKindOfClass:[NSNull class]]){
        self.unitName = dictionary[@"unitName"];
    }
    if(![dictionary[@"updateTime"] isKindOfClass:[NSNull class]]){
        self.updateTime = dictionary[@"updateTime"];
    }
    if(![dictionary[@"updateUserAccnt"] isKindOfClass:[NSNull class]]){
        self.updateUserAccnt = dictionary[@"updateUserAccnt"];
    }
    return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
    NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
    if(self.alarmReason != nil){
        dictionary[@"alarmReason"] = self.alarmReason;
    }
    if(self.alarmTime != nil){
        dictionary[@"alarmTime"] = self.alarmTime;
    }
    if(self.alarmType != nil){
        dictionary[@"alarmType"] = self.alarmType;
    }
    if(self.alarmTypeName != nil){
        dictionary[@"alarmTypeName"] = self.alarmTypeName;
    }
    if(self.coversId != nil){
        dictionary[@"coversId"] = self.coversId;
    }
    if(self.createTime != nil){
        dictionary[@"createTime"] = self.createTime;
    }
    if(self.createUserAccnt != nil){
        dictionary[@"createUserAccnt"] = self.createUserAccnt;
    }
    if(self.dealDesc != nil){
        dictionary[@"dealDesc"] = self.dealDesc;
    }
    if(self.dealTime != nil){
        dictionary[@"dealTime"] = self.dealTime;
    }
    if(self.dealUser != nil){
        dictionary[@"dealUser"] = self.dealUser;
    }
    if(self.issuedUnitUser != nil){
        dictionary[@"issuedUnitUser"] = self.issuedUnitUser;
    }
    if(self.logId != nil){
        dictionary[@"logId"] = self.logId;
    }
    if(self.logItems != nil){
        NSMutableArray * dictionaryElements = [NSMutableArray array];
        for(LogItemModel * logItemsElement in self.logItems){
            [dictionaryElements addObject:[logItemsElement toDictionary]];
        }
        dictionary[@"logItems"] = dictionaryElements;
    }
    if(self.mchnId != nil){
        dictionary[@"mchnId"] = self.mchnId;
    }
    if(self.orderId != nil){
        dictionary[@"orderId"] = self.orderId;
    }
    if(self.remark != nil){
        dictionary[@"remark"] = self.remark;
    }
    if(self.status != nil){
        dictionary[@"status"] = self.status;
    }
    if(self.statusName != nil){
        dictionary[@"statusName"] = self.statusName;
    }
    if(self.unitId != nil){
        dictionary[@"unitId"] = self.unitId;
    }
    if(self.unitName != nil){
        dictionary[@"unitName"] = self.unitName;
    }
    if(self.updateTime != nil){
        dictionary[@"updateTime"] = self.updateTime;
    }
    if(self.updateUserAccnt != nil){
        dictionary[@"updateUserAccnt"] = self.updateUserAccnt;
    }
    return dictionary;
    
}

@end
