//
//	EventManagementModel.h
//
//	Create by zhujintao on 22/7/2016
//	Copyright © 2016. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface ErrorAlertModel : NSObject

@property (nonatomic, strong) NSString * alarmLevel;
@property (nonatomic, strong) NSString * alarmLevelName;
@property (nonatomic, strong) NSString * alarmReason;
@property (nonatomic, strong) NSString * alarmTime;
@property (nonatomic, strong) NSString * alarmType;
@property (nonatomic, strong) NSString * alarmTypeName;
@property (nonatomic, strong) NSString * coversIdCustom;
@property (nonatomic, strong) NSString * createTime;
@property (nonatomic, strong) NSString * createUserAccnt;
@property (nonatomic, strong) NSString * dealDesc;
@property (nonatomic, strong) NSString * dealTime;
@property (nonatomic, strong) NSString * dealUser;
@property (nonatomic, strong) NSString * executionTime;
@property (nonatomic, strong) NSString * latitude;
@property (nonatomic, strong) NSString * location;
@property (nonatomic, strong) NSString * longitude;
@property (nonatomic, strong) NSString * mchnId;
@property (nonatomic, strong) NSString * orderId;
@property (nonatomic, strong) NSString * orderLogId;
@property (nonatomic, strong) NSString * pointId;
@property (nonatomic, strong) NSString * status;
@property (nonatomic, strong) NSString * statusName;
@property (nonatomic, strong) NSString * unitId;
@property (nonatomic, strong) NSString * updateTime;
@property (nonatomic, strong) NSString * updateUserAccnt;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

- (NSDictionary *)toDictionary;
@end
