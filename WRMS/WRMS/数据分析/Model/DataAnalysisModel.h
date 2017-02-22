//
//  DataAnalysisModel.h
//  LeftSlide
//  报警Model
//  Created by YangJingchao on 15/11/16.
//  Copyright © 2015年 陕西永诺信息科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataAnalysisModel : NSObject
/** 百分比*/
@property(nonatomic,strong)NSString *strpercent;
/** 显示*/
@property(nonatomic,strong)NSString *strshow;
/** 警告类型*/
@property(nonatomic,strong)NSString *stralarmType;
/** 总量*/
@property(nonatomic,strong)NSString *strtotalNum;
/** 完成百分比*/
@property(nonatomic,strong)NSString *strnomalpercent;
/** 未完成百分比*/
@property(nonatomic,strong)NSString *strmissingpercent;

-(instancetype)initWithDict:(NSDictionary *)dict;
@end
