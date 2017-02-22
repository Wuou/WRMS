//
//  PointTypeModel.m
//  WRMS
//
//  Created by YangJingchao on 2016/9/8.
//  Copyright © 2016年 YangJingchao. All rights reserved.
//

#import "PointTypeModel.h"

@implementation PointTypeModel
-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(![dictionary[@"pointTypeId"] isKindOfClass:[NSNull class]]){
        self.pointTypeId = dictionary[@"pointTypeId"];
    }
    if(![dictionary[@"pointTypeName"] isKindOfClass:[NSNull class]]){
        self.pointTypeName = dictionary[@"pointTypeName"];
    }
    return self;
}

@end
