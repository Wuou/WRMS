//
//  MessageNotificationVCCell.m
//  LeftSlide
//
//  Created by mymac on 15/11/6.
//  Copyright © 2015年 eamon. All rights reserved.
//

#import "MessageNotificationVCCell.h"
#import "MsgModel.h"
@implementation MessageNotificationVCCell

- (void)setMsgModel:(MsgModel *)msgModel {
    
    self.titleLbl.text = [NSString stringWithFormat:@"%@",msgModel.title];
    self.timeLbl.text  = [[NSString stringWithFormat:@"%@",msgModel.sendTime] substringFromIndex:5];
    self.contentLb.text = [NSString stringWithFormat:@"%@",msgModel.content];
}
@end
