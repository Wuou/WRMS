//
//  DataAnalysisModel.m
//  LeftSlide
//
//  Created by YangJingchao on 15/11/16.
//  Copyright © 2015年 陕西永诺信息科技. All rights reserved.
//

#import "DataAnalysisModel.h"

@implementation DataAnalysisModel
-(instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init])
    {
        self.strpercent = dict[@"alarmNum"];
        self.strshow = dict[@"alarmTypeName"];
        self.stralarmType = dict[@"alarmType"];
        self.strtotalNum = dict[@"totalNum"];
        self.strnomalpercent = dict[@"nomalpercent"];
        self.strmissingpercent = dict[@"missingpercent"];
    }
    return  self;
}
@end
