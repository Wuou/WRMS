//
//  UserModel.h
//  LeftSlide
//
//  Created by YangJingchao on 2016/9/2.
//  Copyright © 2016年 陕西永诺. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject
@property (nonatomic, strong) NSObject * attributes;
@property (nonatomic, assign) BOOL checked;
@property (nonatomic, strong) NSArray * children;
@property (nonatomic, strong) NSString * iconCls;
@property (nonatomic, strong) NSString * idField;
@property (nonatomic, strong) NSString * parentId;
@property (nonatomic, strong) NSString * state;
@property (nonatomic, strong) NSString * target;
@property (nonatomic, strong) NSString * text;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end
