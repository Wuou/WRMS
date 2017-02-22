#基本用法
1 #import "YNRequest.h"

2 初始化

	//参数
	NSDictionary *dictonary = [[NSMutableDictionary alloc] init];
    [dictonary setValue:[utils getlogName] forKey:@"createUserAccnt"];
    [dictonary setValue:[NSString stringWithFormat:@"%zd",pageNum] forKey:@"pageNo"];
    
    [YNRequest YZPOST:LBS_QueryManholeCovers parameters:dictonary success:^(NSDictionary *dic) {
    
        NSString *codeStr     = [dic objectForKey:@"rcode"];
        NSString *totalStr    = [dic objectForKey:@"total"];
        if ([codeStr isEqualToString:@"0x0000"])
        {
            if ([totalStr integerValue] == 0)
            {
                [SVProgressHUD showInfoWithStatus:@"没有更多数据"];
                // 执行page -=1操作
                pageChange();
            }else
            {
                NSArray *rowsDic = [dic objectForKey:@"rows"];
                for (NSDictionary *mydic in rowsDic)
                {
                    WellModel *wellmodel = [[WellModel alloc]initWithDict:mydic];
                    [arrProduct addObject:wellmodel];
                }
 
                repeatBlock();
                if([arrProduct count] == 0)
                {
                    [SVProgressHUD showInfoWithStatus:@"暂时无数据..."];
                }else
                {
                    [SVProgressHUD dismiss];
                }
            }
        }else
        {
            [SVProgressHUD dismiss];
        }
        
    } fail:^{
        
        [SVProgressHUD showInfoWithStatus:@"网络异常,请检查网络"];
    }];
```
