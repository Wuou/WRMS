//
//  MessageNotificationinfoVC.m
//  LeftSlide
//
//  Created by mymac on 15/11/6.
//  Copyright © 2015年 eamon. All rights reserved.
//

#import "MessageNotificationinfoVC.h"

@interface MessageNotificationinfoVC ()

@end

@implementation MessageNotificationinfoVC
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.strTitle;
    self.tvContent.text = self.strContent;
}

#pragma mark - event Responses
-(IBAction)close:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
