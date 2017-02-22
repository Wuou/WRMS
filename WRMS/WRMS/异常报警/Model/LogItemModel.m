//
//  LogItemModel.m
//  LeftSlide
//
//  Created by zhujintao on 16/7/28.
//  Copyright © 2016年 YongNuoTech. All rights reserved.
//

#import "LogItemModel.h"

@implementation LogItemModel

/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(![dictionary[@"createTime"] isKindOfClass:[NSNull class]]){
        self.createTime = dictionary[@"createTime"];
    }
    if(![dictionary[@"createUserAccnt"] isKindOfClass:[NSNull class]]){
        self.createUserAccnt = dictionary[@"createUserAccnt"];
    }
    if(![dictionary[@"itemLogId"] isKindOfClass:[NSNull class]]){
        self.itemLogId = dictionary[@"itemLogId"];
    }
    if(![dictionary[@"logId"] isKindOfClass:[NSNull class]]){
        self.logId = dictionary[@"logId"];
    }
    if(![dictionary[@"type"] isKindOfClass:[NSNull class]]){
        self.type = dictionary[@"type"];
    }
    if(![dictionary[@"conUrl"] isKindOfClass:[NSNull class]]){
        self.conUrl = dictionary[@"conUrl"];
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
    if(self.createTime != nil){
        dictionary[@"createTime"] = self.createTime;
    }
    if(self.createUserAccnt != nil){
        dictionary[@"createUserAccnt"] = self.createUserAccnt;
    }
    if(self.itemLogId != nil){
        dictionary[@"itemLogId"] = self.itemLogId;
    }
    if(self.logId != nil){
        dictionary[@"logId"] = self.logId;
    }
    if(self.type != nil){
        dictionary[@"type"] = self.type;
    }
    if(self.conUrl != nil){
        dictionary[@"conUrl"] = self.conUrl;
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
