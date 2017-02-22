//
//  PointTypeModel.h
//  WRMS
//
//  Created by YangJingchao on 2016/9/8.
//  Copyright © 2016年 YangJingchao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PointTypeModel : NSObject
@property (nonatomic, strong) NSString * pointTypeId;
@property (nonatomic, strong) NSString * pointTypeName;
-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end
