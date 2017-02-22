//
//  UnitModel.m
//  LeftSlide
//
//  Created by YangJingchao on 15/12/22.
//  Copyright © 2015年 陕西永诺信息科技. All rights reserved.
//

#import "ThreeModel.h"

@implementation ThreeModel
- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init])
    {
        _strattributes = dict[@"attributes"];
        _strchecked    = dict[@"checked"];;
        _strchildren   = dict[@"children"];;
        _striconCls    = dict[@"iconCls"];;
        _strid         = dict[@"id"];;
        _strparentId   = dict[@"parentId"];;
        _strstate      = dict[@"state"];;
        _strtarget     = dict[@"target"];;
        _strtext       = dict[@"text"];;
    }
    
    return  self;
}
@end
