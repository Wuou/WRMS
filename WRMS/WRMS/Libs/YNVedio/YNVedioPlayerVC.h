//
//  AVPlayer.h
//  LeftSlide
//
//  Created by YangJingchao on 15/10/27.
//  Copyright © 2015年 eamon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@interface YNVedioPlayerVC : UIViewController
@property (strong ,nonatomic) AVPlayer *player1;//播放器，用于录制完视频后播放视频
@property (strong ,nonatomic) AVPlayer *player2;
@property (strong ,nonatomic) AVPlayer *player3;

@property(nonatomic,strong)NSString *urlVedio;
@property(nonatomic,strong)NSString *urlVedio2;
@property(nonatomic,strong)NSString *urlVedio3;
@property(nonatomic,assign)NSInteger tag;
@property(nonatomic,strong)NSMutableArray *arrPhoto;
@property(nonatomic,strong)NSMutableArray *arrNowVedio;
@property(nonatomic,strong)IBOutlet UIImageView *imgPhoto;
@property(nonatomic,strong)IBOutlet UIImageView *imgPhoto2;
@property(nonatomic,strong)IBOutlet UIImageView *imgPhoto3;
@property(nonatomic,strong)IBOutlet UIScrollView *mysv;
@property(nonatomic,assign)NSInteger pageNum;
@property(nonatomic,strong)IBOutlet UILabel *labelTitle;
@property(nonatomic,strong)IBOutlet UIButton *btnDel;

@property(nonatomic,strong)IBOutlet UIButton *btn1;
@property(nonatomic,strong)IBOutlet UIButton *btn2;
@property(nonatomic,strong)IBOutlet UIButton *btn3;
@property(nonatomic,assign)BOOL isDel1;
@property(nonatomic,assign)BOOL isDel2;
@property(nonatomic,assign)BOOL isDel3;

@end
