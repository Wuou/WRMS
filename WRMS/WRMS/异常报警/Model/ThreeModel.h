//
//  UnitModel.h
//  LeftSlide
//
//  Created by YangJingchao on 15/12/22.
//  Copyright © 2015年 陕西永诺信息科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ThreeModel : NSObject
//attributes = "<null>";
//checked = 0;
//children =             (
//);
//iconCls = "";
//id = 2015111315553365;
//parentId = "";
//state = "";
//target = "";
//text = "\U957f\U5b89\U533a\U73af\U4fdd\U5c40";

@property (nonatomic,strong) NSString *strattributes;
@property (nonatomic,strong) NSString *strchecked;
@property (nonatomic,strong) NSString *strchildren;
@property (nonatomic,strong) NSString *striconCls;
@property (nonatomic,strong) NSString *strid;
@property (nonatomic,strong) NSString *strparentId;
@property (nonatomic,strong) NSString *strstate;
@property (nonatomic,strong) NSString *strtarget;
@property (nonatomic,strong) NSString *strtext;

-(instancetype)initWithDict:(NSDictionary *)dict;
@end
