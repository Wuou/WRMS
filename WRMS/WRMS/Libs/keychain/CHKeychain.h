//
//  CHKeychain.h
//  KeyChainDemo
//
//  Created by YangJingchao on 2016/9/18.
//  Copyright © 2016年 YangJingchao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Security/Security.h>


@interface CHKeychain : NSObject

+ (void)save:(NSString *)service data:(id)data;
+ (id)load:(NSString *)service;
+ (void)delete:(NSString *)service;

@end
