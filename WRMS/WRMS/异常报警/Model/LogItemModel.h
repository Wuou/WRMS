//
//  LogItemModel.h
//  LeftSlide
//
//  Created by zhujintao on 16/7/28.
//  Copyright © 2016年 YongNuoTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LogItemModel : NSObject

/** 创建时间*/
@property (nonatomic, strong) NSString * createTime;
/** 创建者账户*/
@property (nonatomic, strong) NSString * createUserAccnt;
/** 工单组编号*/
@property (nonatomic, strong) NSString * itemLogId;
/** 工单编号*/
@property (nonatomic, strong) NSString * logId;
/** 资源类型*/
@property (nonatomic, strong) NSString * type;
/** 资源链接*/
@property (nonatomic, strong) NSString * conUrl;
/** 更新时间*/
@property (nonatomic, strong) NSString * updateTime;
/** 更新者账号*/
@property (nonatomic, strong) NSString * updateUserAccnt;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;

@end
