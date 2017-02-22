//
//  YZNetWorking.m
//  LeftSlide
//
//  Created by YangJingchao on 16/5/18.
//  Copyright © 2016年 陕西永诺. All rights reserved.
//

#import "YNRequest.h"



@interface YNRequest()

@end

@implementation YNRequest

+ (void)YNPost:(NSString *)URLString
    parameters:(NSDictionary *)parameters
       success:(SuccessBlock)returnBlock
          fail:(FailBlock)failBlock {
    NSString *value;
    BOOL isValidJSONObject =  [NSJSONSerialization isValidJSONObject:parameters];
    if (isValidJSONObject) {
        /*
         第一个参数:OC对象 也就是我们dict
         第二个参数:
         NSJSONWritingPrettyPrinted 排版
         kNilOptions 什么也不做
         */
        NSData *data =  [NSJSONSerialization dataWithJSONObject:parameters options:kNilOptions error:nil];
        //打印JSON数据
        value = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    }
    
    //当请求登录接口，才加密参数
    if ([URLString isEqualToString:@"LBS_UserLogin"])
    {
        NSData *aesdataresult = [SecurityUtil encryptAESData:value];
        value = [SecurityUtil encodeBase64Data:aesdataresult];
    }
    NSMutableArray *params = [NSMutableArray array];
    [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:value,@"input",nil]];
//    NSLog(@"=%@",params);
    //参数、地址等
    YNRequestWithArgs *args = [[YNRequestWithArgs alloc] init];
    args.methodName   = URLString;
    args.soapParams   = params;
    args.httpWay = ServiceHttpSoap1;
    if([URLString isEqualToString:@"LBS_UserLogin"]) {
        args.soapHeader = [NSString stringWithFormat:@"<token>%@</token>",@"9e5f309af1333fe8ca9133956e7e6232"];
    }else{
        args.soapHeader = [NSString stringWithFormat:@"<username>%@</username><authenticode>%@</authenticode>",[utils getlogName],[SecurityUtil encryptMD5String:[utils getAuthenCode]]];
    }
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager HTTPRequestOperationWithArgs:args success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *theXML   = operation.responseString ;
        NSArray *array1    = [NSArray arrayWithObjects:@"return>",@"</",nil];
        NSArray *ziFuArray = [NSArray arrayWithObjects:array1,nil];
        for (NSArray *array in ziFuArray) {
            NSRange range = [theXML rangeOfString:[array objectAtIndex:0]];
            if(range.length > 0)
            {
                theXML = [theXML substringFromIndex:range.location + 7];
                range  = [theXML rangeOfString:[array objectAtIndex:1]];
                if(range.length > 0)
                {
                    theXML = [theXML substringToIndex:range.location+(range.length - 2)];
                }
                break;
            }
        }
        NSData *dd    = [theXML dataUsingEncoding:NSUTF8StringEncoding];
        NSData *data2 = [GTMBase64 decodeData:dd];
        //当登录接口返回数据，才解密返回的数据
        if([URLString isEqualToString:@"LBS_UserLogin"]) {
            theXML = [SecurityUtil decryptAESData:data2];
        }
        NSLog(@"=%@",theXML);
        NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:[theXML dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
//        NSLog(@"=%@",diction);
        returnBlock(diction);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failBlock();
    }];
}


+(void)YNPostWithUnit:(NSString *)URLString
       parameters:(NSDictionary *)parameters
          success:(SuccessBlock)returnBlock
             fail:(FailBlock)failBlock {
    NSMutableArray *params = [NSMutableArray array];
    [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:[utils getUnitID],@"input", nil]];
    
    YNRequestWithArgs *args = [[YNRequestWithArgs alloc] init];
//    args.methodName = LBS_QueryUnitByUnitId;
    args.soapParams = params;
    args.httpWay = ServiceHttpSoap1;
    args.soapHeader = [NSString stringWithFormat:@"<username>%@</username><authenticode>%@</authenticode>",[utils getlogName],[SecurityUtil encryptMD5String:[utils getAuthenCode]]];
    //    NSLog(@"参数%@",params);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager HTTPRequestOperationWithArgs:args success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *theXML   = operation.responseString;
        NSArray *array1    = [NSArray arrayWithObjects:@"return>",@"</",nil];
        NSArray *ziFuArray = [NSArray arrayWithObjects:array1,nil];
        for (NSArray *array in ziFuArray)
        {
            NSRange range = [theXML rangeOfString:[array objectAtIndex:0]];
            if(range.length > 0) {
                theXML = [theXML substringFromIndex:range.location + 7];
                range  = [theXML rangeOfString:[array objectAtIndex:1]];
                if(range.length > 0)
                {
                    theXML = [theXML substringToIndex:range.location+(range.length - 2)];
                }
                break;
            }
        }
        
        NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:[theXML dataUsingEncoding:NSUTF8StringEncoding]
                                                                options:NSJSONReadingMutableContainers error:nil];
        returnBlock(diction);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failBlock();
    }];
}


@end
