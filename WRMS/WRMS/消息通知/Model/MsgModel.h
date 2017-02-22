//
//  MsgModel.h
//  LeftSlide
//
//  Created by YangJingchao on 15/12/4.
//  Copyright © 2015年 eamon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MsgModel : NSObject
@property (nonatomic, strong) NSString * content;
@property (nonatomic, strong) NSString * createTime;
@property (nonatomic, strong) NSString * createUserAccnt;
@property (nonatomic, strong) NSString * isSend;
@property (nonatomic, strong) NSString * mchnId;
@property (nonatomic, strong) NSString * messageId;
@property (nonatomic, strong) NSString * messageType;
@property (nonatomic, strong) NSString * platformType;
@property (nonatomic, strong) NSString * pushExtras;
@property (nonatomic, strong) NSString * pushTag;
@property (nonatomic, strong) NSString * registrationId;
@property (nonatomic, strong) NSString * remark;
@property (nonatomic, strong) NSString * sendTime;
@property (nonatomic, strong) NSString * timedSend;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * updateTime;
@property (nonatomic, strong) NSString * updateUserAccnt;
@property (nonatomic, strong) NSString * userAccount;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;

@end
