//
//  LoginApi.h
//  LeftSlide
//
//  Created by mymac on 16/7/19.
//  Copyright © 2016年 eamon. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^LoginSuccessBlock)();

@interface LoginApi : NSObject

+ (void)apiLoginSystemWithAccount:(NSString *)account
                         password:(NSString *)password
                loginSuccessBlock:(LoginSuccessBlock)block;

@end
