//
//  AVPlayer.m
//  LeftSlide
//
//  Created by YangJingchao on 15/10/27.
//  Copyright © 2015年 eamon. All rights reserved.
//

#import "YNVedioPlayerVC.h"

@interface YNVedioPlayerVC ()

@end

@implementation YNVedioPlayerVC

- (void)viewDidLoad {
    self.arrNowVedio = [[NSMutableArray alloc]init];
    NSMutableArray *arrMov = [[NSMutableArray alloc]initWithArray:self.arrPhoto];

    NSLog(@"删除下标数组%@",self.arrNowVedio);
    [self.btnDel setSelected:YES];
    self.pageNum = 1;
    self.mysv.pagingEnabled = YES;
    NSLog(@"==%@",self.arrPhoto);
    self.labelTitle.text = [NSString stringWithFormat:@"%zd/%zd",self.tag+1,[arrMov count]];
    [self.mysv setContentSize:CGSizeMake(([UIScreen mainScreen].bounds.size.width -2) *[arrMov count], self.mysv.frame.size.height)];

    [self.imgPhoto setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [self.imgPhoto2 setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [self.imgPhoto3 setFrame:CGRectMake( [UIScreen mainScreen].bounds.size.width * 2, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    

    
    switch (self.tag) {
        case 0:
        {
            [self.mysv setContentOffset:CGPointMake(0, 0) animated:YES];
        }
            break;
        case 1:
        {
             [self.mysv setContentOffset:CGPointMake([UIScreen mainScreen].bounds.size.width, 0) animated:YES];
        }
            break;
        case 2:
        {
             [self.mysv setContentOffset:CGPointMake([UIScreen mainScreen].bounds.size.width *2, 0) animated:YES];
        }
            break;
        default:
            break;
    }

    if ([arrMov count] ==1) {
        NSURL *url1 = [NSURL fileURLWithPath:[arrMov objectAtIndex:0]];
        _player1 = [AVPlayer playerWithURL:url1];
        AVPlayerLayer *playerLayer1 = [AVPlayerLayer playerLayerWithPlayer:_player1];
        playerLayer1.frame = CGRectMake( 0,0,[UIScreen mainScreen].bounds.size.width ,[UIScreen mainScreen].bounds.size.height);
        [self.imgPhoto.layer addSublayer:playerLayer1];
    }
    
    if ([arrMov count] ==2) {
        
        NSURL *url1 = [NSURL fileURLWithPath:[arrMov objectAtIndex:0]];
        _player1 = [AVPlayer playerWithURL:url1];
        AVPlayerLayer *playerLayer1 = [AVPlayerLayer playerLayerWithPlayer:_player1];
        playerLayer1.frame = CGRectMake( 0,0  ,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height);
        [self.imgPhoto.layer addSublayer:playerLayer1];
        
        NSURL *url2 = [NSURL fileURLWithPath:[arrMov objectAtIndex:1]];
        _player2 = [AVPlayer playerWithURL:url2];
        AVPlayerLayer *playerLayer2 = [AVPlayerLayer playerLayerWithPlayer:_player2];
        playerLayer2.frame = CGRectMake( [UIScreen mainScreen].bounds.size.width,0  ,[UIScreen mainScreen].bounds.size.width ,[UIScreen mainScreen].bounds.size.height);
        [self.imgPhoto2.layer addSublayer:playerLayer2];
    
    }
    if ([arrMov count] ==3) {
        NSURL *url1 = [NSURL fileURLWithPath:[arrMov objectAtIndex:0]];
        _player1 = [AVPlayer playerWithURL:url1];
        AVPlayerLayer *playerLayer1 = [AVPlayerLayer playerLayerWithPlayer:_player1];
        playerLayer1.frame = CGRectMake( 0,0  ,[UIScreen mainScreen].bounds.size.width ,[UIScreen mainScreen].bounds.size.height );
        [self.imgPhoto.layer addSublayer:playerLayer1];
        
        NSURL *url2 = [NSURL fileURLWithPath:[arrMov objectAtIndex:1]];
        _player2 = [AVPlayer playerWithURL:url2];
        AVPlayerLayer *playerLayer2 = [AVPlayerLayer playerLayerWithPlayer:_player2];
        playerLayer2.frame = CGRectMake( [UIScreen mainScreen].bounds.size.width,0  ,[UIScreen mainScreen].bounds.size.width ,[UIScreen mainScreen].bounds.size.height);
        [self.imgPhoto2.layer addSublayer:playerLayer2];
        
        NSURL *url3 = [NSURL fileURLWithPath:[arrMov objectAtIndex:2]];
        _player3 = [AVPlayer playerWithURL:url3];
        AVPlayerLayer *playerLayer3 = [AVPlayerLayer playerLayerWithPlayer:_player3];
        playerLayer3.frame = CGRectMake( [UIScreen mainScreen].bounds.size.width *2,0  ,[UIScreen mainScreen].bounds.size.width ,[UIScreen mainScreen].bounds.size.height);
        [self.imgPhoto3.layer addSublayer:playerLayer3];

    }
    
    [super viewDidLoad];
   
    // Do any additional setup after loading the view from its nib.
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    if(scrollView.contentOffset.x == 0 ){
        self.pageNum = 1;

        if (!self.isDel1) {
            [self.btnDel setSelected:YES];
        }else{
            [self.btnDel setSelected:NO];
        }
        self.labelTitle.text = [NSString stringWithFormat:@"1/%zd",[self.arrPhoto count]];
    }
    if(scrollView.contentOffset.x > 0 && scrollView.contentOffset.x < [UIScreen mainScreen].bounds.size.width){
        if (!self.isDel2) {
            [self.btnDel setSelected:YES];
        }else{
            [self.btnDel setSelected:NO];
        }
        self.pageNum = 2;
        self.labelTitle.text = [NSString stringWithFormat:@"2/%zd",[self.arrPhoto count]];

    }
    if(scrollView.contentOffset.x > [UIScreen mainScreen].bounds.size.width && scrollView.contentOffset.x < [UIScreen mainScreen].bounds.size.width *2){
        if (!self.isDel3) {
            [self.btnDel setSelected:YES];
        }else{
            [self.btnDel setSelected:NO];
        }
        self.pageNum = 3;
        self.labelTitle.text = [NSString stringWithFormat:@"3/%zd",[self.arrPhoto count]];

    }
//    NSLog(@"当前第%zd页",self.pageNum);
}

-(IBAction)playAction:(id)sender{
    switch (self.pageNum) {
        case 1:
        {
            [_player1 play];
            [self.btn1 setHidden:YES];
            //计算播放总时间，然后点击播放后，隐藏后的按钮再次显示出来
            CMTime duration = _player1.currentItem.asset.duration;
            float seconds = CMTimeGetSeconds(duration);
            [self performSelector:@selector(toShowPlayBtn) withObject:nil afterDelay:seconds];
        }
            break;
        case 2:
        {
            [_player2 play];
            [self.btn2 setHidden:YES];
            CMTime duration = _player2.currentItem.asset.duration;
            float seconds = CMTimeGetSeconds(duration);
            [self performSelector:@selector(toShowPlayBtn2) withObject:nil afterDelay:seconds];
        }
            break;
        case 3:
        {
            [_player3 play];
            [self.btn3 setHidden:YES];
            CMTime duration = _player3.currentItem.asset.duration;
            float seconds = CMTimeGetSeconds(duration);
            [self performSelector:@selector(toShowPlayBtn3) withObject:nil afterDelay:seconds];
        }
            break;
        default:
            break;
    }
    
}

//重复播放第一段视频 1
-(void)toShowPlayBtn{
    //解决重新播放无效果，现在需要向通知中心注册AVPlayerItemDidPlayToEndTimeNotification消息
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(playerItemDidReachEnd:)
     name:AVPlayerItemDidPlayToEndTimeNotification
     object:[self.player1 currentItem]];
    self.player1.volume = 1.0;
    [self.btn1 setHidden:NO];
}

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    [self.player1 seekToTime:kCMTimeZero];
}

//重复播放2
-(void)toShowPlayBtn2{
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(playerItemDidReachEnd2:)
     name:AVPlayerItemDidPlayToEndTimeNotification
     object:[self.player2 currentItem]];
    self.player2.volume = 1.0;
    [self.btn2 setHidden:NO];
}

- (void)playerItemDidReachEnd2:(NSNotification *)notification {
    [self.player2 seekToTime:kCMTimeZero];
}

//重复播放3
-(void)toShowPlayBtn3{
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(playerItemDidReachEnd3:)
     name:AVPlayerItemDidPlayToEndTimeNotification
     object:[self.player3 currentItem]];
    self.player3.volume = 1.0;
    [self.btn3 setHidden:NO];
}

- (void)playerItemDidReachEnd3:(NSNotification *)notification {
    [self.player3 seekToTime:kCMTimeZero];
}


- (IBAction)DeleteAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    BOOL isselect = btn.selected;
    if (isselect) {
        switch (self.pageNum) {
            case 1:
            {
                NSLog(@"删除第一个");

                self.isDel1 = YES;
            }
                break;
            case 2:
            {
               NSLog(@"删除第二个");
                self.isDel2 = YES;
            }
                break;
            case 3:
            {
               NSLog(@"删除第三个");
                self.isDel3 = YES;
            }
                break;
            default:
                break;
        }
        [btn setSelected:NO];
    }else{
        switch (self.pageNum) {
            case 1:
            {
               NSLog(@"添加第一个");
                self.isDel1 = NO;
            }
                break;
            case 2:
            {
                NSLog(@"添加第二个");
                self.isDel2 = NO;
            }
                break;
            case 3:
            {
                NSLog(@"添加第三个");
                self.isDel3 = NO;
            }
                break;
            default:
                break;
        }
        [btn setSelected:YES];
    }
}


- (IBAction)closeAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    NSDictionary *dictonary = [[NSMutableDictionary alloc] init];

    // 0代表删除 1代表不删除
    if (self.isDel1) {
        [dictonary setValue:@"0" forKey:@"vediourl1"];
    }else{
         [dictonary setValue:@"1" forKey:@"vediourl1"];
    }
    if (self.isDel2) {
        [dictonary setValue:@"0" forKey:@"vediourl2"];
    }else{
         [dictonary setValue:@"1" forKey:@"vediourl2"];
    }
    if (self.isDel3) {
        [dictonary setValue:@"0" forKey:@"vediourl3"];
    }else{
         [dictonary setValue:@"1" forKey:@"vediourl3"];
    }
    
    //顺便发起一个通知，刷新隐患上传页面的声音图标
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"RefreshVedioAction" object:nil userInfo:dictonary];
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"RefreshAddTraceVedio" object:nil userInfo:dictonary];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
