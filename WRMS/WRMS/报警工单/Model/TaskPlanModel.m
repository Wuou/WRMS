//
//  TaskPlanModel.m
//  LeftSlide
//
//  Created by YangJingchao on 2016/9/13.
//  Copyright © 2016年 YongNuoTech. All rights reserved.
//

#import "TaskPlanModel.h"

@implementation TaskPlanModel
-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(![dictionary[@"area"] isKindOfClass:[NSNull class]]){
        self.area = dictionary[@"area"];
    }
    if(![dictionary[@"checkDate"] isKindOfClass:[NSNull class]]){
        self.checkDate = dictionary[@"checkDate"];
    }
    if(![dictionary[@"createTime"] isKindOfClass:[NSNull class]]){
        self.createTime = dictionary[@"createTime"];
    }
    if(![dictionary[@"createUserAccnt"] isKindOfClass:[NSNull class]]){
        self.createUserAccnt = dictionary[@"createUserAccnt"];
    }
    if(![dictionary[@"cycleTime"] isKindOfClass:[NSNull class]]){
        self.cycleTime = dictionary[@"cycleTime"];
    }
    if(![dictionary[@"descrip"] isKindOfClass:[NSNull class]]){
        self.descrip = dictionary[@"descrip"];
    }
    if(![dictionary[@"endTime"] isKindOfClass:[NSNull class]]){
        self.endTime = dictionary[@"endTime"];
    }
    if(![dictionary[@"line"] isKindOfClass:[NSNull class]]){
        self.line = dictionary[@"line"];
    }
    if(![dictionary[@"point"] isKindOfClass:[NSNull class]]){
        self.point = dictionary[@"point"];
    }
    if(![dictionary[@"startTime"] isKindOfClass:[NSNull class]]){
        self.startTime = dictionary[@"startTime"];
    }
    if(![dictionary[@"taskEndTime"] isKindOfClass:[NSNull class]]){
        self.taskEndTime = dictionary[@"taskEndTime"];
    }
    if(![dictionary[@"taskId"] isKindOfClass:[NSNull class]]){
        self.taskId = dictionary[@"taskId"];
    }
    if(![dictionary[@"taskName"] isKindOfClass:[NSNull class]]){
        self.taskName = dictionary[@"taskName"];
    }
    if(![dictionary[@"taskStartTime"] isKindOfClass:[NSNull class]]){
        self.taskStartTime = dictionary[@"taskStartTime"];
    }
    if(![dictionary[@"taskState"] isKindOfClass:[NSNull class]]){
        self.taskState = dictionary[@"taskState"];
    }
    if(![dictionary[@"taskType"] isKindOfClass:[NSNull class]]){
        self.taskType = dictionary[@"taskType"];
    }
    if(![dictionary[@"taskTypeName"] isKindOfClass:[NSNull class]]){
        self.taskTypeName = dictionary[@"taskTypeName"];
    }
    if(![dictionary[@"taskdetail"] isKindOfClass:[NSNull class]]){
        self.taskdetail = dictionary[@"taskdetail"];
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
@end
