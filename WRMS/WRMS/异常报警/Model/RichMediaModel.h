//
//  RichMediaModel.h
//  LeftSlide
//
//  Created by YangJingchao on 15/10/30.
//  Copyright © 2015年 陕西永诺信息科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RichMediaModel : NSObject

@property(nonatomic,strong)NSString *mconUrl;
@property(nonatomic,strong)NSString *mCreateTime;
@property(nonatomic,strong)NSString *mCreateUserAccnt ;
@property(nonatomic,strong)NSString *mitemLogId;
@property(nonatomic,strong)NSString *mlogId;
@property(nonatomic,strong)NSString *mtype;
@property(nonatomic,strong)NSString *mupdateTime;
@property(nonatomic,strong)NSString *mupdateUserAccnt;

-(instancetype)initWithDict:(NSDictionary *)dict;
@end
