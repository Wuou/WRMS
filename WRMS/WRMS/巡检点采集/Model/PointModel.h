//
//  PointModel.h
//  LeftSlide
//
//  Created by YangJingchao on 15/11/4.
//  Copyright © 2015年 eamon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PointModel : NSObject
@property (nonatomic, strong) NSString * alarmFlag;
@property (nonatomic, strong) NSString * alarmStatus;
@property (nonatomic, strong) NSString * alarmStatusName;
@property (nonatomic, strong) NSString * altitude;
@property (nonatomic, strong) NSString * codeImei;
@property (nonatomic, strong) NSString * createTime;
@property (nonatomic, strong) NSString * createUserAccnt;
@property (nonatomic, strong) NSString * district;
@property (nonatomic, strong) NSString * installTime;
@property (nonatomic, strong) NSString * latitude;
@property (nonatomic, strong) NSString * location;
@property (nonatomic, strong) NSString * longitude;
@property (nonatomic, strong) NSString * pointId;
@property (nonatomic, strong) NSString * pointName;
@property (nonatomic, strong) NSString * pointTypeId;
@property (nonatomic, strong) NSString * pointTypeName;
@property (nonatomic, strong) NSString * remark;
@property (nonatomic, strong) NSString * unitId;
@property (nonatomic, strong) NSString * unitName;
@property (nonatomic, strong) NSString * updateTime;
@property (nonatomic, strong) NSString * updateUserAccnt;
@property (nonatomic, strong) NSString * userAccnt;
@property (nonatomic, assign) CGFloat waterHeight;
@property (nonatomic, strong) NSString * waterMchnId;
@property (nonatomic, strong) NSString * waterMchnName;
@property (nonatomic, strong) NSString * waterMchnState;
@property (nonatomic, strong) NSString * waterMchnStateName;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end
