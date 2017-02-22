//
//  MsgModel.m
//  LeftSlide
//
//  Created by YangJingchao on 15/12/4.
//  Copyright © 2015年 eamon. All rights reserved.
//

#import "MsgModel.h"

@implementation MsgModel
-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(![dictionary[@"content"] isKindOfClass:[NSNull class]]){
        self.content = dictionary[@"content"];
    }
    if(![dictionary[@"createTime"] isKindOfClass:[NSNull class]]){
        self.createTime = dictionary[@"createTime"];
    }
    if(![dictionary[@"createUserAccnt"] isKindOfClass:[NSNull class]]){
        self.createUserAccnt = dictionary[@"createUserAccnt"];
    }
    if(![dictionary[@"isSend"] isKindOfClass:[NSNull class]]){
        self.isSend = dictionary[@"isSend"];
    }
    if(![dictionary[@"mchnId"] isKindOfClass:[NSNull class]]){
        self.mchnId = dictionary[@"mchnId"];
    }
    if(![dictionary[@"messageId"] isKindOfClass:[NSNull class]]){
        self.messageId = dictionary[@"messageId"];
    }
    if(![dictionary[@"messageType"] isKindOfClass:[NSNull class]]){
        self.messageType = dictionary[@"messageType"];
    }
    if(![dictionary[@"platformType"] isKindOfClass:[NSNull class]]){
        self.platformType = dictionary[@"platformType"];
    }
    if(![dictionary[@"pushExtras"] isKindOfClass:[NSNull class]]){
        self.pushExtras = dictionary[@"pushExtras"];
    }
    if(![dictionary[@"pushTag"] isKindOfClass:[NSNull class]]){
        self.pushTag = dictionary[@"pushTag"];
    }
    if(![dictionary[@"registrationId"] isKindOfClass:[NSNull class]]){
        self.registrationId = dictionary[@"registrationId"];
    }
    if(![dictionary[@"remark"] isKindOfClass:[NSNull class]]){
        self.remark = dictionary[@"remark"];
    }
    if(![dictionary[@"sendTime"] isKindOfClass:[NSNull class]]){
        self.sendTime = dictionary[@"sendTime"];
    }
    if(![dictionary[@"timedSend"] isKindOfClass:[NSNull class]]){
        self.timedSend = dictionary[@"timedSend"];
    }
    if(![dictionary[@"title"] isKindOfClass:[NSNull class]]){
        self.title = dictionary[@"title"];
    }
    if(![dictionary[@"updateTime"] isKindOfClass:[NSNull class]]){
        self.updateTime = dictionary[@"updateTime"];
    }
    if(![dictionary[@"updateUserAccnt"] isKindOfClass:[NSNull class]]){
        self.updateUserAccnt = dictionary[@"updateUserAccnt"];
    }
    if(![dictionary[@"userAccount"] isKindOfClass:[NSNull class]]){
        self.userAccount = dictionary[@"userAccount"];
    }
    return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
    NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
    if(self.content != nil){
        dictionary[@"content"] = self.content;
    }
    if(self.createTime != nil){
        dictionary[@"createTime"] = self.createTime;
    }
    if(self.createUserAccnt != nil){
        dictionary[@"createUserAccnt"] = self.createUserAccnt;
    }
    if(self.isSend != nil){
        dictionary[@"isSend"] = self.isSend;
    }
    if(self.mchnId != nil){
        dictionary[@"mchnId"] = self.mchnId;
    }
    if(self.messageId != nil){
        dictionary[@"messageId"] = self.messageId;
    }
    if(self.messageType != nil){
        dictionary[@"messageType"] = self.messageType;
    }
    if(self.platformType != nil){
        dictionary[@"platformType"] = self.platformType;
    }
    if(self.pushExtras != nil){
        dictionary[@"pushExtras"] = self.pushExtras;
    }
    if(self.pushTag != nil){
        dictionary[@"pushTag"] = self.pushTag;
    }
    if(self.registrationId != nil){
        dictionary[@"registrationId"] = self.registrationId;
    }
    if(self.remark != nil){
        dictionary[@"remark"] = self.remark;
    }
    if(self.sendTime != nil){
        dictionary[@"sendTime"] = self.sendTime;
    }
    if(self.timedSend != nil){
        dictionary[@"timedSend"] = self.timedSend;
    }
    if(self.title != nil){
        dictionary[@"title"] = self.title;
    }
    if(self.updateTime != nil){
        dictionary[@"updateTime"] = self.updateTime;
    }
    if(self.updateUserAccnt != nil){
        dictionary[@"updateUserAccnt"] = self.updateUserAccnt;
    }
    if(self.userAccount != nil){
        dictionary[@"userAccount"] = self.userAccount;
    }
    return dictionary;
    
}

@end
