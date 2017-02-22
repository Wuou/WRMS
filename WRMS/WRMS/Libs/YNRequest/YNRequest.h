//
//  YZNetWorking.h
//  LeftSlide
//
//  Created by YangJingchao on 16/5/18.
//  Copyright © 2016年 陕西永诺. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sys/utsname.h>

typedef void (^SuccessBlock)(NSDictionary *dic);
typedef void (^FailBlock)();
@interface YNRequest : NSObject

/**
 *  请求普通接口方法
 *
 *  @param URLString  地址
 *  @param parameters 参数
 */
+ (void)YNPost:(NSString *)URLString
    parameters:(NSDictionary *)parameters
       success:(SuccessBlock)returnBlock
          fail:(FailBlock)failBlock;


/**
 *  请求单位信息
 *
 *  @param URLString   地址
 *  @param parameters  参数
 *  @param returnBlock 成功block
 *  @param failBlock   失败block
 */
+(void)YNPostWithUnit:(NSString *)URLString
       parameters:(NSDictionary *)parameters
          success:(SuccessBlock)returnBlock
             fail:(FailBlock)failBlock;


@end
