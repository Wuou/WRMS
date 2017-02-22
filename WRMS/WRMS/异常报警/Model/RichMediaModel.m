//
//  RichMediaModel.m
//  LeftSlide
//
//  Created by YangJingchao on 15/10/30.
//  Copyright © 2015年 陕西永诺信息科技. All rights reserved.
//

#import "RichMediaModel.h"

@implementation RichMediaModel
-(instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init])
    {
        self.mCreateTime = dict[@"createTime"];
       self.mCreateUserAccnt  = dict[@"createUserAccnt"];
        self.mitemLogId = dict[@"itemLogId"];
        self.mlogId = dict[@"logId"];
        self.mtype = dict[@"type"];
        self.mupdateTime = dict[@"updateTime"];
        self.mupdateUserAccnt = dict[@"updateUserAccnt"];
        self.mconUrl = dict[@"conUrl"];
    }
    return  self;
}

@end
