//
//  AddEventManagementVC.h
//  LeftSlide
//
//  Created by zhujintao on 16/7/20.
//  Copyright © 2016年 eamon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddErrorAlertVC : UIViewController
/** 纬度*/
@property (weak, nonatomic) IBOutlet UITextField *tf_latitude;
/** 经度*/
@property (weak, nonatomic) IBOutlet UITextField *tf_lontitude;
/** 报警说明*/
@property (weak, nonatomic) IBOutlet UITextField *tf_level;
/** 类别*/
@property (weak, nonatomic) IBOutlet MyTextField *tf_type;
/** 地址*/
@property (weak, nonatomic) IBOutlet UITextView  *addrTextView;
/** 报警原因*/
@property (strong, nonatomic) IBOutlet UITextField *eventResonTextView;
/** 报警说明标题*/
@property(nonatomic,strong)IBOutlet UILabel      *addrLbl;
/** 存储图片链接*/
@property(nonatomic,strong)NSMutableArray        *arrPicUrl;
/** 存储报警类别*/
@property(nonatomic,strong)NSMutableArray        *arrType;
/** 存储报警等级*/
@property (nonatomic,strong) NSMutableArray      *arrLevel;
@property (nonatomic,strong) NSMutableArray      *arrID_Type;
@property (nonatomic,strong) NSMutableArray      *arrText_Type;
@property (nonatomic,strong) NSMutableArray      *arrID_Level;
@property (nonatomic,strong) NSMutableArray      *arrText_Level;
@property (nonatomic,strong) NSMutableArray      *arrLogId;
/** 获取报警等级*/
@property (nonatomic,strong ) NSString           *strLevel;
/** 获取报警类型*/
@property (nonatomic,strong ) NSString           *strType;
/** 视频展示View*/
@property(nonatomic,strong)IBOutlet UIView       *viewViedo;
/** 录音文件展示View*/
@property(nonatomic,strong)IBOutlet UIView       *viewVoice;

/** 视频照片展示视图*/
@property (weak, nonatomic) IBOutlet UIImageView *videoPic;
@property (weak, nonatomic) IBOutlet UIImageView *videoPic2;
@property (weak, nonatomic) IBOutlet UIImageView *videoPic3;
/** 用于视频下面的文字*/
@property(nonatomic,strong)IBOutlet UILabel      *videoLbl;
@property(nonatomic,strong)IBOutlet UILabel      *videoLbl2;
@property(nonatomic,strong)IBOutlet UILabel      *videoLbl3;

/** 播放按钮*/
@property(nonatomic,strong)IBOutlet UIButton     *videoPlayBtn;
@property(nonatomic,strong)IBOutlet UIButton     *videoPlayBtn2;
@property(nonatomic,strong)IBOutlet UIButton     *videoPlayBtn3;
@property (assign,nonatomic) BOOL isVideoModelType;
@property (assign,nonatomic) BOOL isVideo;
/** 存放视频相对路径，方便上传时批量上传*/
@property(nonatomic,strong)NSMutableArray        *arrVideoUrl;
/** 存放音频文件*/
@property(nonatomic,strong)NSMutableArray        *arrVoiceUrl;
@property(nonatomic,strong)NSMutableArray        *datasPic;
/** 请求的个数*/
@property(nonatomic,assign)NSInteger requestNum;
/** 完成请求的个数*/
@property(nonatomic,assign)NSInteger requestFinshedNum;
/** 点击录音文件进行播放*/
@property(nonatomic,strong)IBOutlet UIButton     *btnvoice;

@end
