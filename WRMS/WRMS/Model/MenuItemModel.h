//
//  MenuItemModel.h
//  LeftSlide
//
//  Created by mymac on 16/7/21.
//  Copyright © 2016年 YongNuoTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MenuItemModel : NSObject

@property (nonatomic, strong) NSString *nodeId;
@property (nonatomic, strong) NSString *iconCLS;
@property (nonatomic, strong) NSString *navNodeName;
@property (nonatomic, strong) NSString *nodeURL;
@property (nonatomic, strong) NSString *parentName;

@end
