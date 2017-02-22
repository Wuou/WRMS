//
//  MessageNotificationVCCell.h
//  LeftSlide
//
//  Created by mymac on 15/11/6.
//  Copyright © 2015年 eamon. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MsgModel;

@interface MessageNotificationVCCell : UITableViewCell

/** 消息标题*/
@property (strong, nonatomic) IBOutlet UILabel *titleLbl;
/** 消息内容*/
@property (strong, nonatomic) IBOutlet UILabel *contentLb;
/** 发送时间*/
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;

@property (nonatomic,strong)MsgModel *msgModel;
@end
