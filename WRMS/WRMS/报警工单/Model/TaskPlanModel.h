//
//  TaskPlanModel.h
//  LeftSlide
//
//  Created by YangJingchao on 2016/9/13.
//  Copyright © 2016年 YongNuoTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TaskPlanModel : NSObject
@property (nonatomic, strong) NSString * area;
@property (nonatomic, strong) NSString * checkDate;
@property (nonatomic, strong) NSString * createTime;
@property (nonatomic, strong) NSString * createUserAccnt;
@property (nonatomic, strong) NSString * cycleTime;
@property (nonatomic, strong) NSString * descrip;
@property (nonatomic, strong) NSString * endTime;
@property (nonatomic, strong) NSString * line;
@property (nonatomic, strong) NSString * point;
@property (nonatomic, strong) NSString * startTime;
@property (nonatomic, strong) NSString * taskEndTime;
@property (nonatomic, strong) NSString * taskId;
@property (nonatomic, strong) NSString * taskName;
@property (nonatomic, strong) NSString * taskStartTime;
@property (nonatomic, strong) NSString * taskState;
@property (nonatomic, strong) NSString * taskType;
@property (nonatomic, strong) NSString * taskTypeName;
@property (nonatomic, strong) NSString * taskdetail;
@property (nonatomic, strong) NSString * unitId;
@property (nonatomic, strong) NSString * unitName;
@property (nonatomic, strong) NSString * updateTime;
@property (nonatomic, strong) NSString * updateUserAccnt;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end
