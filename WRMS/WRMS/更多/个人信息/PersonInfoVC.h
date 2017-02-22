//
//  PersonInfoVC.h
//  LeftSlide
//
//  Created by YangJingchao on 15/10/19.
//  Copyright © 2015年 eamon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UpdatePswVC.h"
#import "TDengluVC.h"


@interface PersonInfoVC : UIViewController
/** 姓名*/
@property(nonatomic,strong)IBOutlet UILabel *labelName;
/** 账号*/
@property(nonatomic,strong)IBOutlet UILabel *labelAccount;
/** 所属单位*/
@property(nonatomic,strong)IBOutlet UILabel *labelUnitName;

@end
