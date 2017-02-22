//
//  UserModel.m
//  LeftSlide
//
//  Created by YangJingchao on 2016/9/2.
//  Copyright © 2016年 陕西永诺. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel
-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(![dictionary[@"attributes"] isKindOfClass:[NSNull class]]){
        self.attributes = dictionary[@"attributes"];
    }
    if(![dictionary[@"checked"] isKindOfClass:[NSNull class]]){
        self.checked = [dictionary[@"checked"] boolValue];
    }
    
    if(![dictionary[@"children"] isKindOfClass:[NSNull class]]){
        self.children = dictionary[@"children"];
    }
    if(![dictionary[@"iconCls"] isKindOfClass:[NSNull class]]){
        self.iconCls = dictionary[@"iconCls"];
    }
    if(![dictionary[@"id"] isKindOfClass:[NSNull class]]){
        self.idField = dictionary[@"id"];
    }
    if(![dictionary[@"parentId"] isKindOfClass:[NSNull class]]){
        self.parentId = dictionary[@"parentId"];
    }
    if(![dictionary[@"state"] isKindOfClass:[NSNull class]]){
        self.state = dictionary[@"state"];
    }
    if(![dictionary[@"target"] isKindOfClass:[NSNull class]]){
        self.target = dictionary[@"target"];
    }
    if(![dictionary[@"text"] isKindOfClass:[NSNull class]]){
        self.text = dictionary[@"text"];
    }	
    return self;
}
@end
