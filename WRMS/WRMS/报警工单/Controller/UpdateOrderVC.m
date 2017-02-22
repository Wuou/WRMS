//
//  UpdateOrderVC.m
//  LeftSlide
//
//  Created by YangJingchao on 15/12/25.
//  Copyright © 2015年 陕西永诺. All rights reserved.
//

#import "UpdateOrderVC.h"
#import "ErrorOrderApi.h"

@interface UpdateOrderVC () <JKImagePickerControllerDelegate,JKPhotoBrowserDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate, UIImagePickerControllerDelegate>

@property (nonatomic,strong) NSMutableArray          *assetsArray;
@property (nonatomic,strong) NSMutableArray          *arrPicUrl;
@property (nonatomic,strong) UICollectionView        *collectionView;
@property (nonatomic,strong) NSMutableArray          *arrIds;
@property (nonatomic,strong) NSMutableArray          *arrTexts;
@property (strong,nonatomic) UIImagePickerController *imagePicker;
@property (nonatomic,strong) IBOutlet UITextView              *tvDesc;
@property (nonatomic,strong) IBOutlet UITextField             *tfStatus;
@property (nonatomic,strong) NSString                *strStatus;
@property (nonatomic,strong) IBOutlet UIScrollView            *mysv;
@property (nonatomic,strong) ASIFormDataRequest      *request;
@property (nonatomic,strong) IBOutlet UIView                  *viewViedo;
@property (nonatomic,strong) IBOutlet UIView                  *viewVoice;
/** 照片展示视图*/
@property (weak, nonatomic ) IBOutlet UIImageView             *videoPic;
@property (weak, nonatomic ) IBOutlet UIImageView             *videoPic2;
@property (weak, nonatomic ) IBOutlet UIImageView             *videoPic3;
/** 用于视频下面的文字*/
@property (nonatomic,strong) IBOutlet UILabel                 *labelv1;
@property (nonatomic,strong) IBOutlet UILabel                 *labelv2;
@property (nonatomic,strong) IBOutlet UILabel                 *labelv3;
/** 播放按钮*/
@property (nonatomic,strong) IBOutlet UIButton                *btnPlay1;
@property (nonatomic,strong) IBOutlet UIButton                *btnPlay2;
@property (nonatomic,strong) IBOutlet UIButton                *btnPlay3;
@property (assign,nonatomic) BOOL                    isVideoModelType;
@property (assign,nonatomic) BOOL                    isVideo;
/** 存放视频相对路径，方便上传时批量上传*/
@property (nonatomic,strong) NSMutableArray          *arrVideoUrl;
/** 存放音频文件*/
@property (nonatomic,strong) NSMutableArray          *arrVoiceUrl;
@property (nonatomic,strong) NSMutableArray          *datasPic;
/** 请求的个数*/
@property (nonatomic,assign) NSInteger               requestNum;
/** 完成请求的个数*/
@property (nonatomic,assign) NSInteger               requestFinshedNum;
@property (nonatomic,strong) IBOutlet UIButton                *btnvoice;
@property (nonatomic,strong) IBOutlet UIButton                *btnUp;
@property (nonatomic,assign) BOOL                    isFinished;

@end

@implementation UpdateOrderVC

#pragma mark Life Cycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title                            = @"修改工单报警";
        // Custom initialization
        UIBarButtonItem *backItem             = [[UIBarButtonItem alloc] init];
        backItem.title                        = @"";
        self.navigationItem.backBarButtonItem = backItem;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(refreshVoiceIcon:)
                                                     name:@"RefreshVoiceIcon" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(refreshVedioAction:)
                                                     name:@"RefreshVedioAction" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:        @selector(deleteVoice:) name:@"DeleteVoice" object:nil];
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.arrIds      = [[NSMutableArray alloc]init];
    self.arrTexts    = [[NSMutableArray alloc]init];
    self.assetsArray = [[NSMutableArray alloc]init];
    self.arrVideoUrl = [[NSMutableArray alloc]init];//存放视频相对路径，方便上传时批量上传
    self.arrPicUrl   = [[NSMutableArray alloc]init];//存放照片
    self.arrVoiceUrl = [[NSMutableArray alloc]init];//存放音频文件
    self.datasPic    = [[NSMutableArray alloc]init];
    
    [self getStatus];
    
    [self.btnUp.layer setCornerRadius:6];
    self.requestNum        = 0;
    self.requestFinshedNum = 0;
    
    _tvDesc.layer.borderColor = [[UIColor colorWithHexString:layerBorderColor] CGColor];
    _tvDesc.layer.borderWidth = 0.5;
    [_tvDesc.layer setCornerRadius:6];
    _tvDesc.delegate          = self;
    
    //sdlayout 布局
    self.mysv.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    //三个大view的布局  照片、视频、音频
    self.collectionView.sd_layout
    .leftSpaceToView(self.mysv, 20)
    .rightSpaceToView(self.mysv, 20)
    .topSpaceToView(self.tvDesc, 20)
    .heightIs(88);
    
    self.viewViedo.sd_layout
    .widthIs(self.view.bounds.size.width)
    .heightIs(98)
    .leftSpaceToView(self.mysv,20)
    .topSpaceToView(self.self.collectionView, 20);
    
    self.viewVoice.sd_layout
    .leftSpaceToView(self.mysv, 20)
    .rightSpaceToView(self.mysv, 20)
    .topSpaceToView(self.viewViedo, 20)
    .heightIs(50);
    
    //再次处理视频里的三个视频的排序
    //图片
    self.videoPic.sd_layout
    .leftSpaceToView(self.viewViedo, 0)
    .topSpaceToView(self.viewViedo,4)
    .heightIs(80)
    .widthIs(80);
    
    self.videoPic2.sd_layout
    .leftSpaceToView(self.videoPic, 10)
    .topEqualToView(self.videoPic)
    .heightIs(80)
    .widthIs(80);
    
    self.videoPic3.sd_layout
    .leftSpaceToView(self.videoPic2, 10)
    .topEqualToView(self.videoPic2)
    .heightIs(80)
    .widthIs(80);
    
    //按钮
    self.btnPlay1.sd_layout
    .leftSpaceToView(self.videoPic, -40-16 )
    .topSpaceToView(self.videoPic,-40-16 )
    .heightIs(32)
    .widthIs(32);
    
    self.btnPlay2.sd_layout
    .leftSpaceToView(self.videoPic2, -40-16)
    .topEqualToView(self.btnPlay1)
    .heightIs(32)
    .widthIs(32);
    
    self.btnPlay3.sd_layout
    .leftSpaceToView(self.videoPic3, -40-16)
    .topEqualToView(self.btnPlay2)
    .heightIs(32)
    .widthIs(32);
    
    //文字
    self.labelv1.sd_layout
    .leftSpaceToView(self.videoPic, -80)
    .bottomSpaceToView(self.viewViedo,5)
    .heightIs(16)
    .widthIs(80);
    
    self.labelv2.sd_layout
    .leftSpaceToView(self.videoPic2, -80)
    .bottomEqualToView(self.labelv1)
    .heightIs(16)
    .widthIs(80);
    
    self.labelv3.sd_layout
    .leftSpaceToView(self.videoPic3, -80)
    .bottomEqualToView(self.labelv2)
    .heightIs(16)
    .widthIs(80);
    
    [self refreshSVContentsize];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [SVProgressHUD dismiss];
    
    [_request cancel];
}

#pragma mark - JKImagePickerControllerDelegate
- (void)imagePickerController:(JKImagePickerController *)imagePicker didSelectAsset:(JKAssets *)asset isSource:(BOOL)source
{
    [imagePicker dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)imagePickerController:(JKImagePickerController *)imagePicker didSelectAssets:(NSArray *)assets isSource:(BOOL)source
{
    self.assetsArray = [NSMutableArray arrayWithArray:assets];
    //    NSLog(@"照片数组：%@",self.assetsArray);
    
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        
        [self.collectionView reloadData];
    }];
}

- (void)imagePickerControllerDidCancel:(JKImagePickerController *)imagePicker
{
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

static NSString *kPhotoCellIdentifier = @"kPhotoCellIdentifier";

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if([self.assetsArray count] == 0 )
    {
        [self.arrPicUrl removeAllObjects];
        [self.collectionView setSize:CGSizeMake(self.collectionView.frame.size.width,0)];
    }else
    {
        [self.collectionView setSize:CGSizeMake(self.collectionView.frame.size.width,90)];
    }
    
    [self refreshSVContentsize];
    
    return [self.assetsArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCell *cell        = (PhotoCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kPhotoCellIdentifier forIndexPath:indexPath];
    cell.asset             = [self.assetsArray objectAtIndex:[indexPath row]];
    ALAssetsLibrary   *lib = [[ALAssetsLibrary alloc] init];
    [lib assetForURL:cell.asset.assetPropertyURL resultBlock:^(ALAsset *asset) {
        
        NSString *str1 = [cell.asset.assetPropertyURL absoluteString];
        if([str1 rangeOfString:@"MOV"].location != NSNotFound)//如果是视频
        {
            cell.labelContent.text = @"视频";
            [cell.labelContent setHidden:NO];
        }else
        {
            cell.labelContent.text = @"";
            [cell.labelContent setHidden:YES];
        }
    } failureBlock:^(NSError *error) {
        
    }];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(80, 80);
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //    NSLog(@"%ld",(long)[indexPath row]);
    JKImagePickerController *imagePickerController = [[JKImagePickerController alloc] init];
    imagePickerController.delegate                 = self;
    imagePickerController.showsCancelButton        = YES;
    imagePickerController.allowsMultipleSelection  = YES;
    imagePickerController.minimumNumberOfSelection = 0;
    imagePickerController.maximumNumberOfSelection = 6;
    imagePickerController.selectedAssetArray       = self.assetsArray;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
    [self presentViewController:navigationController animated:YES completion:NULL];
}

- (UICollectionView *)collectionView
{
    if (!_collectionView)
    {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing          = 5.0;
        layout.minimumInteritemSpacing     = 5.0;
        layout.scrollDirection             = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView                                = [[UICollectionView alloc] initWithFrame:CGRectMake(11, 160, CGRectGetWidth(self.view.frame)-22, 90) collectionViewLayout:layout];
        _collectionView.backgroundColor                = [UIColor clearColor];
        [_collectionView registerClass:[PhotoCell class] forCellWithReuseIdentifier:kPhotoCellIdentifier];
        _collectionView.delegate                       = self;
        _collectionView.dataSource                     = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator   = NO;
        [self.mysv addSubview:_collectionView];
    }
    
    return _collectionView;
}


#pragma mark - UIImagePickerController Delegate
/**
 *  拍照、拍视频完成
 *
 *  @param picker
 *  @param info
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage])
    {
        UIImage *image;
        if (self.imagePicker.allowsEditing)
        {
            image = [info objectForKey:UIImagePickerControllerEditedImage];
        }else
        {
            image = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }else if([mediaType isEqualToString:(NSString *)kUTTypeMovie])
    {
        int pathNum      = arc4random() % 1000;
        NSURL *url       = [info objectForKey:UIImagePickerControllerMediaURL];
        NSString *urlStr = [url path];
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(urlStr))
        {
            //保存视频到相簿，注意也可以使用ALAssetsLibrary来保存
            //保存视频到相簿
            UISaveVideoAtPathToSavedPhotosAlbum(urlStr, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
            //将mov转成mp4
            AVURLAsset *avAsset        = [AVURLAsset URLAssetWithURL:url options:nil];
            NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
            if ([compatiblePresets containsObject:AVAssetExportPresetLowQuality])
            {
                AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]initWithAsset:avAsset presetName:AVAssetExportPresetPassthrough];
                NSString *exportPath                = [NSString stringWithFormat:@"%@/%zd.mp4",
                                                       [NSHomeDirectory() stringByAppendingString:@"/tmp"],
                                                       pathNum];
                NSFileManager *fileManager          = [NSFileManager defaultManager];
                //如果第一个视频文件存在，则新建视频2路径
                if ([fileManager fileExistsAtPath:exportPath])
                {
                    exportPath = [NSString stringWithFormat:@"%@/%zd.mp4",
                                  [NSHomeDirectory() stringByAppendingString:@"/tmp"],
                                  pathNum];
                    //添加输出后的视频路径
                    [self.arrVideoUrl addObject:exportPath];
                    //                    NSLog(@"%@", exportPath);
                    exportSession.outputURL = [NSURL fileURLWithPath:exportPath];
                }else
                {
                    //添加输出后的视频路径
                    [self.arrVideoUrl addObject:exportPath];
                    //第一个视频存在本地，并保存在数组里
                    //                    NSLog(@"%@", exportPath);
                    exportSession.outputURL = [NSURL fileURLWithPath:exportPath];
                }
                exportSession.outputFileType = AVFileTypeMPEG4;
                [exportSession exportAsynchronouslyWithCompletionHandler:^{
                    
                    switch ([exportSession status]) {
                        case AVAssetExportSessionStatusFailed:
                            break;
                        case AVAssetExportSessionStatusCancelled:
                            break;
                        case AVAssetExportSessionStatusCompleted:
                            break;
                        default:
                            break;
                    }
                }];
            }
        }
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIImagePickerController *)imagePicker
{
    if( _isVideoModelType)
    {
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
        {
            _imagePicker              = [[UIImagePickerController alloc]init];
            //设置image picker的来源，这里设置为摄像头
            _imagePicker.sourceType   = UIImagePickerControllerSourceTypeCamera;
            //设置使用哪个摄像头，这里设置为后置摄像头
            _imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
            if (_isVideo)
            {
                _imagePicker.mediaTypes           = @[(NSString *)kUTTypeMovie];
                _imagePicker.videoQuality         = UIImagePickerControllerQualityType640x480;
                _imagePicker.videoMaximumDuration = 10.0f;
                //设置摄像头模式（拍照，录制视频）
                _imagePicker.cameraCaptureMode    = UIImagePickerControllerCameraCaptureModeVideo;
                _imagePicker.mediaTypes           = [[NSArray alloc] initWithObjects:@"hidden.movie",kUTTypeMovie, nil];
            }else
            {
                _imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
                _imagePicker.mediaTypes        = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
            }
            _imagePicker.allowsEditing = YES;
            _imagePicker.delegate      = self;
        }else
        {
            _imagePicker=[[UIImagePickerController alloc]init];
            //设置image picker的来源，这里设置为相册
            _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            if (_isVideo)
            {
                _imagePicker.mediaTypes = @[(NSString *)kUTTypeMovie];
                _imagePicker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
            }else
            {
                _imagePicker.mediaTypes =  [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
            }
            _imagePicker.allowsEditing = YES;
            _imagePicker.delegate      = self;
        }
    }
    
    return _imagePicker;
}

/**
 *  视频保存后的回调
 *
 *  @param videoPath
 *  @param error
 *  @param contextInfo
 */
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error)
    {
        //        NSLog(@"保存视频过程中发生错误，错误信息:%@",error.localizedDescription);
    }else{
        //        NSLog(@"视频保存成功.");
        if([self.arrPicUrl count] == 0)
        {
            [self.collectionView setSize:CGSizeMake(self.collectionView.frame.size.width, 0)];
        }else
        {
            [self.collectionView setSize:CGSizeMake(self.collectionView.frame.size.width, 90)];
        }
        if([self.arrVideoUrl count] == 0)
        {
            [self.viewViedo setSize:CGSizeMake(self.viewViedo.frame.size.width, 0)];
        }else
        {
            [self.viewViedo setSize:CGSizeMake(self.viewViedo.frame.size.width, 90)];
        }
        if([self.arrVideoUrl count] == 1)
        {
            [self.viewViedo setHidden:NO];
            [self.videoPic setImage:[self getImage:[self.arrVideoUrl objectAtIndex:0]]];
            [self.videoPic setHidden:NO];
            [self.labelv1 setHidden:NO];
            [self.btnPlay1 setHidden:NO];
            [self.videoPic setFrame:CGRectMake(self.videoPic.frame.origin.x, self.videoPic.frame.origin.y, 80, self.videoPic.frame.size.height)];
            [self.btnPlay1 setFrame:CGRectMake(self.btnPlay1.frame.origin.x, self.btnPlay1.frame.origin.y, 32, self.btnPlay1.frame.size.height)];
            [self.labelv1 setFrame:CGRectMake(self.labelv1.frame.origin.x, self.labelv1.frame.origin.y, 80, self.labelv1.frame.size.height)];
            
        }
        if([self.arrVideoUrl count] == 2)
        {
            [self.viewViedo setHidden:NO];
            [self.videoPic2 setImage:[self getImage:[self.arrVideoUrl objectAtIndex:1]]];
            [self.videoPic2 setHidden:NO];
            [self.labelv2 setHidden:NO];
            [self.btnPlay2 setHidden:NO];
            [self.videoPic2 setFrame:CGRectMake(self.videoPic2.frame.origin.x, self.videoPic2.frame.origin.y, 80, self.videoPic2.frame.size.height)];
            [self.btnPlay2 setFrame:CGRectMake(self.btnPlay2.frame.origin.x, self.btnPlay2.frame.origin.y, 32, self.btnPlay2.frame.size.height)];
            [self.labelv2 setFrame:CGRectMake(self.labelv2.frame.origin.x, self.labelv2.frame.origin.y, 80, self.labelv2.frame.size.height)];
            [self.videoPic setImage:[self getImage:[self.arrVideoUrl objectAtIndex:0]]];
            [self.videoPic setHidden:NO];
            [self.labelv1 setHidden:NO];
            [self.btnPlay1 setHidden:NO];
            [self.videoPic setFrame:CGRectMake(self.videoPic.frame.origin.x, self.videoPic.frame.origin.y, 80, self.videoPic.frame.size.height)];
            [self.btnPlay1 setFrame:CGRectMake(self.btnPlay1.frame.origin.x, self.btnPlay1.frame.origin.y, 32, self.btnPlay1.frame.size.height)];
            [self.labelv1 setFrame:CGRectMake(self.labelv1.frame.origin.x, self.labelv1.frame.origin.y, 80, self.labelv1.frame.size.height)];
            
        }
        if([self.arrVideoUrl count] == 3)
        {
            [self.viewViedo setHidden:NO];
            [self.videoPic3 setImage:[self getImage:[self.arrVideoUrl objectAtIndex:2]]];
            [self.videoPic3 setHidden:NO];
            [self.labelv3 setHidden:NO];
            [self.btnPlay3 setHidden:NO];
            [self.videoPic3 setFrame:CGRectMake(self.videoPic3.frame.origin.x, self.videoPic3.frame.origin.y, 80, self.videoPic3.frame.size.height)];
            [self.btnPlay3 setFrame:CGRectMake(self.btnPlay3.frame.origin.x, self.btnPlay3.frame.origin.y, 32, self.btnPlay3.frame.size.height)];
            [self.labelv3 setFrame:CGRectMake(self.labelv3.frame.origin.x, self.labelv3.frame.origin.y, 80, self.labelv3.frame.size.height)];
            [self.videoPic2 setImage:[self getImage:[self.arrVideoUrl objectAtIndex:1]]];
            [self.videoPic2 setHidden:NO];
            [self.labelv2 setHidden:NO];
            [self.btnPlay2 setHidden:NO];
            [self.videoPic2 setFrame:CGRectMake(self.videoPic2.frame.origin.x, self.videoPic2.frame.origin.y, 80, self.videoPic2.frame.size.height)];
            [self.btnPlay2 setFrame:CGRectMake(self.btnPlay2.frame.origin.x, self.btnPlay2.frame.origin.y, 32, self.btnPlay2.frame.size.height)];
            [self.labelv2 setFrame:CGRectMake(self.labelv2.frame.origin.x, self.labelv2.frame.origin.y, 80, self.labelv2.frame.size.height)];
            [self.videoPic setImage:[self getImage:[self.arrVideoUrl objectAtIndex:0]]];
            [self.videoPic setHidden:NO];
            [self.labelv1 setHidden:NO];
            [self.btnPlay1 setHidden:NO];
            [self.videoPic setFrame:CGRectMake(self.videoPic.frame.origin.x, self.videoPic.frame.origin.y, 80, self.videoPic.frame.size.height)];
            [self.btnPlay1 setFrame:CGRectMake(self.btnPlay1.frame.origin.x, self.btnPlay1.frame.origin.y, 32, self.btnPlay1.frame.size.height)];
            [self.labelv1 setFrame:CGRectMake(self.labelv1.frame.origin.x, self.labelv1.frame.origin.y, 80, self.labelv1.frame.size.height)];
        }
        [self refreshSVContentsize];
    }
}

#pragma mark - UITextView Delegate
- (void)textViewDidChange:(UITextView *)textView
{
    NSInteger number = [textView.text length];
    if (number > 30)
    {
        [SVProgressHUD showInfoWithStatus:@"最多可输入30位"];
        textView.text    = [textView.text substringToIndex:30];
        number           = 30;
    }
}

#pragma mark - Upload Media
/**
 *  上传音频
 *
 *  @param strHid
 */
- (void)upLoadMP3:(NSString *)strHid
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[utils getAppUploadMeidaUrl],UploadPIcError]];
    _request   = [ASIFormDataRequest requestWithURL:url];
    for (NSString *filestr in self.arrVoiceUrl)
    {
        [_request setFile:filestr forKey:@"audioFile"];
    }
    
    [_request setPostValue:strHid forKey:@"logId"];
    [_request setPostValue:[utils getlogName] forKey:@"userAccout"];
    [_request buildPostBody];
    [_request setDelegate:self];
    [_request setTimeOutSeconds:30];
    [_request startAsynchronous];
}


/**
 *  上传视频
 *
 *  @param strHid
 *  @param pathUrl
 */
- (void)upLoadMP4:(NSString *)strHid urlStr:(NSString *)pathUrl
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[utils getAppUploadMeidaUrl],UploadPIcError]];
    
    _request   = [ASIFormDataRequest requestWithURL:url];
    [_request setFile:pathUrl forKey:@"videoFile"];
    [_request setPostValue:strHid forKey:@"logId"];
    [_request setPostValue:[utils getlogName] forKey:@"userAccout"];
    [_request buildPostBody];
    [_request setDelegate:self];
    [_request setShowAccurateProgress:YES];
    _request.shouldAttemptPersistentConnection=NO;
    [_request setTimeOutSeconds:30];
    [_request startAsynchronous];
}

/**
 *  上传照片
 *
 *  @param strHid
 */
- (void)upLoadPic:(NSString *)strHid
{
    NSURL *url = [NSURL URLWithString:[[NSString stringWithFormat:@"%@%@",[utils getAppUploadMeidaUrl],UploadPIcError] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];// 编码转换
    
    _request   = [ASIFormDataRequest requestWithURL:url];
    [_request setRequestMethod:@"POST"];
    [_request setPostFormat:ASIMultipartFormDataPostFormat];
    [_request setStringEncoding:NSUTF8StringEncoding];
    [_request setPostValue:strHid forKey:@"logId"];
    [_request setPostValue:[utils getlogName] forKey:@"userAccout"];
    
    for (UIImage *eImage in self.arrPicUrl)
    {
        int x                   = arc4random() % 100;
        int y                   = arc4random() % 100;
        NSData *imageData       = UIImageJPEGRepresentation(eImage,100);
        NSString *photoName     = [NSString stringWithFormat:@"%zd-%zd.jpg",x,y];
        NSString *photoDescribe = @" ";
        //照片content
        [_request setPostValue:photoDescribe forKey:@"pictureFile"];
        [_request addData:imageData withFileName:photoName andContentType:@"image/jpeg" forKey:@"pictureFile"];
    }
    
    _request.shouldAttemptPersistentConnection = NO;
    [_request setDelegate:self];
    [_request setDidFailSelector:@selector(responseFailed)];
    [_request setDidFinishSelector:@selector(responseComplete)];
    [_request setTimeOutSeconds:30];
    [_request startSynchronous];
}

#pragma mark - ASIHttpRequest Delegate
/**
 *  图片上传成功
 */
- (void)responseComplete
{
    //    NSLog(@"图片上传成功......");
    [SVProgressHUD showSuccessWithStatus:@"修改成功"];
    
    [self performSelector:@selector(toPopVC) withObject:nil afterDelay:0.5f];
}

/**
 *  图片上传失败
 */
- (void)responseFailed
{
    [SVProgressHUD showErrorWithStatus:@"上传失败,请检查网络是否正常"];
}


/**
 *  上传完音频后删除本地的录音文件
 */
- (void)deleteTempMp3File
{
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSString *FileFullPath = [self.arrVoiceUrl objectAtIndex:0];
    BOOL bRet              = [fileMgr fileExistsAtPath:FileFullPath];
    if (bRet)
    {
        NSError *err;
        if ([fileMgr removeItemAtPath:FileFullPath error:&err])
        {
            //            NSLog(@"删除录音文件成功");
        }else{
            //            NSLog(@"删除录音文件失败");
        }
    }
}

#pragma mark - Private Method
/**
 *  监听删除录音
 *
 *  @param text
 */
- (void)deleteVoice:(NSNotification *)text
{
    [self.btnvoice setHidden:YES];
    [self.arrVoiceUrl removeAllObjects];
    [self.viewViedo setSize:CGSizeMake(self.viewViedo.frame.size.width, 0)];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"DeleteVoice" object:nil];
    [self refreshSVContentsize];
}


- (void)refreshVedioAction:(NSNotification *)text
{
    NSString *strdel1    = [text.userInfo objectForKey:@"vediourl1"];
    NSString *strdel2    = [text.userInfo objectForKey:@"vediourl2"];
    NSString *strdel3    = [text.userInfo objectForKey:@"vediourl3"];
    // 给一个数组容器装三个字符串
    NSArray *arr         = [NSArray arrayWithObjects:strdel1, strdel2, strdel3, nil];
    // 这个数组里面装的是需要移除的url对应的字符串
    NSMutableArray *arr1 = [NSMutableArray array];
    for (int i = 0;i < arr.count;i++)
    {
        if ([arr[i] integerValue] == 0)
        {
            [arr1 addObject:arr[i]];
        }
    }
    // 逻辑判断
    if (arr1.count == 3)
    {
        [self.arrVideoUrl removeAllObjects];
    }
    if (arr1.count == 2)
    {
        if ([arr1 containsObject:strdel1] && [arr1 containsObject:strdel2])
        {
            [self.arrVideoUrl removeObjectAtIndex:0];
            [self.arrVideoUrl removeObjectAtIndex:0];
        }else if ([arr1 containsObject:strdel1] && [arr1 containsObject:strdel3])
        {
            [self.arrVideoUrl removeObjectAtIndex:0];
            [self.arrVideoUrl removeObjectAtIndex:1];
        }else
        {
            [self.arrVideoUrl removeObjectAtIndex:1];
            [self.arrVideoUrl removeObjectAtIndex:1];
        }
    }
    
    if (arr1.count == 1)
    {
        if ([arr1 containsObject:strdel1])
        {
            [self.arrVideoUrl removeObjectAtIndex:0];
        }else if ([arr1 containsObject:strdel2])
        {
            [self.arrVideoUrl removeObjectAtIndex:1];
        }else
        {
            [self.arrVideoUrl removeObjectAtIndex:2];
        }
    }
    
    if([self.arrVideoUrl count] == 0)
    {
        [self.viewViedo setHidden:YES];
        [self.videoPic setImage:nil];
        [self.labelv1 setHidden:YES];
        [self.btnPlay1 setHidden:YES];
        [self.videoPic2 setImage:nil];
        [self.labelv2 setHidden:YES];
        [self.btnPlay2 setHidden:YES];
        [self.videoPic3 setImage:nil];
        [self.labelv3 setHidden:YES];
        [self.btnPlay3 setHidden:YES];
    }
    
    if([self.arrVideoUrl count] == 1)
    {
        [self.viewViedo setHidden:NO];
        [self.videoPic setImage:[self getImage:[self.arrVideoUrl objectAtIndex:0]]];
        [self.labelv1 setHidden:NO];
        [self.btnPlay1 setHidden:NO];
        [self.videoPic2 setFrame:CGRectMake(self.videoPic2.frame.origin.x, self.videoPic2.frame.origin.y, 0, self.videoPic2.frame.size.height)];
        [self.btnPlay2 setFrame:CGRectMake(self.btnPlay2.frame.origin.x, self.btnPlay2.frame.origin.y, 0, self.btnPlay2.frame.size.height)];
        [self.labelv2 setFrame:CGRectMake(self.labelv2.frame.origin.x, self.labelv2.frame.origin.y, 0, self.labelv2.frame.size.height)];
        [self.videoPic3 setFrame:CGRectMake(self.videoPic3.frame.origin.x, self.videoPic3.frame.origin.y, 0, self.videoPic3.frame.size.height)];
        [self.btnPlay3 setFrame:CGRectMake(self.btnPlay3.frame.origin.x, self.btnPlay3.frame.origin.y, 0, self.btnPlay3.frame.size.height)];
        [self.labelv3 setFrame:CGRectMake(self.labelv3.frame.origin.x, self.labelv3.frame.origin.y, 0, self.labelv3.frame.size.height)];
    }
    
    if([self.arrVideoUrl count] == 2)
    {
        [self.viewViedo setHidden:NO];
        [self.videoPic setImage:[self getImage:[self.arrVideoUrl objectAtIndex:0]]];
        [self.labelv1 setHidden:NO];
        [self.btnPlay1 setHidden:NO];
        [self.viewViedo setHidden:NO];
        [self.videoPic2 setImage:[self getImage:[self.arrVideoUrl objectAtIndex:1]]];
        [self.labelv2 setHidden:NO];
        [self.btnPlay2 setHidden:NO];
        [self.videoPic3 setFrame:CGRectMake(self.videoPic3.frame.origin.x, self.videoPic3.frame.origin.y, 0, self.videoPic3.frame.size.height)];
        [self.btnPlay3 setFrame:CGRectMake(self.btnPlay3.frame.origin.x, self.btnPlay3.frame.origin.y, 0, self.btnPlay3.frame.size.height)];
        [self.labelv3 setFrame:CGRectMake(self.labelv3.frame.origin.x, self.labelv3.frame.origin.y, 0, self.labelv3.frame.size.height)];
    }
    
    if([self.arrVideoUrl count] == 3)
    {
        [self.viewViedo setHidden:NO];
        [self.videoPic setImage:[self getImage:[self.arrVideoUrl objectAtIndex:0]]];
        [self.labelv1 setHidden:NO];
        [self.btnPlay1 setHidden:NO];
        [self.viewViedo setHidden:NO];
        [self.videoPic2 setImage:[self getImage:[self.arrVideoUrl objectAtIndex:1]]];
        [self.labelv2 setHidden:NO];
        [self.btnPlay2 setHidden:NO];
        [self.viewViedo setHidden:NO];
        [self.videoPic3 setImage:[self getImage:[self.arrVideoUrl objectAtIndex:2]]];
        [self.labelv3 setHidden:NO];
        [self.btnPlay3 setHidden:NO];
    }
    
    [self refreshSVContentsize];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RefreshVedioAction" object:nil];
}

/**
 *  刷新声音图标
 *
 *  @param text
 */
- (void)refreshVoiceIcon:(NSNotification *)text
{
    [self.btnvoice setHidden:NO];
    
    NSString *strVoiceFile = [text.userInfo objectForKey:@"VoiceUrl"];
    [self.arrVoiceUrl addObject:strVoiceFile];
    
    if([self.arrVideoUrl count] == 0)
    {
        [self.viewViedo setSize:CGSizeMake(self.viewViedo.frame.size.width,0)];
    }else
    {
        [self.viewViedo setSize:CGSizeMake(self.viewViedo.frame.size.width,90)];
    }
    
    [self refreshSVContentsize];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RefreshVoiceIcon" object:nil];
}

/**
 *  刷新scrollview的高度
 */
- (void)refreshSVContentsize
{
    NSInteger isPic   = 0;
    NSInteger isVedio = 0;
    NSInteger isVoice = 0;
    
    if ([self.assetsArray count] > 0)
    {
        isPic = 1;
    }
    
    if ([self.arrVideoUrl count] > 0)
    {
        isVedio = 1;
    }
    
    if ([self.arrVoiceUrl count] > 0)
    {
        isVoice = 1;
    }
    
    if (isPic + isVedio + isVoice >= 2)
    {
        if ([UIScreen mainScreen].bounds.size.height == 480)
        {
            [self.mysv setContentSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height + 120)];
        }else
        {
            [self.mysv setContentSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height + 35)];
        }
    }
}

#pragma mark GetStatus Connection Data
/**
 *  获取报警状态
 */
- (void)getStatus
{
    [self.arrTexts removeAllObjects];
    [self.arrIds removeAllObjects];
    
    [ErrorOrderApi apiWithErrorOrderStatus:self.arrIds arr2:self.arrTexts successBlock:^() {
    }];
}

/**
 *  点击选择状态方法
 *
 *  @param sender
 */
- (IBAction)chooseStatusAction:(id)sender
{
    [self.view endEditing:YES];
    KTActionSheet *actionSheet   = [[KTActionSheet alloc] initWithTitle:@"报警状态" itemTitles:[_arrTexts copy]];
    actionSheet.delegate         = self;
    actionSheet.tag              = 13;
    __weak typeof(self) weakSelf = self;
    [actionSheet didFinishSelectIndex:^(NSInteger index, NSString *title) {
        weakSelf.tfStatus.text = [NSString stringWithFormat:@"%@", title];
        self.strStatus         = [self.arrIds objectAtIndex:index];
    }];
}

#pragma mark Update Button  Action
- (IBAction)toUpdateAction:(id)sender
{
    if ( self.tfStatus.text== nil || [self.tfStatus.text isEqualToString:@""] || self.tvDesc.text == nil || [self.tvDesc.text isEqualToString:@""])
    {
        [SVProgressHUD showInfoWithStatus:@"请填写完整信息"];
    }else
    {
        [SVProgressHUD showWithStatus:@"正在修改报警工单,请稍等..." maskType:SVProgressHUDMaskTypeClear];
        [self updateOrder];
    }
}

/**
 *  修改报警工单
 */
- (void)updateOrder
{
    if (self.assetsArray.count>0)
    {
        for(JKAssets *jk in self.assetsArray)
        {
            //            NSString *str1 = [jk.assetPropertyURL absoluteString];
            ALAssetsLibrary   *lib = [[ALAssetsLibrary alloc] init];
            [lib assetForURL:jk.assetPropertyURL resultBlock:^(ALAsset *asset) {
                
                NSString *str1 = [jk.assetPropertyURL absoluteString];
                if([str1 rangeOfString:@"MOV"].location != NSNotFound)//如果是视频
                {
                    
                }else
                {
                    UIImage *imageIcon;
                    imageIcon       = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
                    //压图片质量
                    NSData *imgData = UIImageJPEGRepresentation(imageIcon,0.2);
                    imageIcon       = [UIImage imageWithData:imgData];
                    //去重照片
                    NSData *data1   = UIImagePNGRepresentation(imageIcon);
                    NSData *data2;
                    if(self.arrPicUrl.count > 0)
                    {
                        data2 = UIImagePNGRepresentation([self.arrPicUrl objectAtIndex:0]);
                    }
                    
                    if ([data1 isEqual:data2])
                    {
                        // NSLog(@"两个UIimage相同");
                    } else
                    {
                        // NSLog(@"两个UIImage不一样");
                        [self.arrPicUrl addObject:imageIcon];
                    }
                    if ( [self.arrPicUrl count] > 0)
                    {
                        [self.collectionView setFrame:CGRectMake(11,160, CGRectGetWidth(self.view.frame) - 22, 90)];
                    }
                }
            } failureBlock:^(NSError *error) {
                
            }];
        }
    }
    
    if([self.arrVideoUrl count] == 0 && [self.arrVoiceUrl count] == 0 && [self.arrPicUrl count] > 0)
    {
        self.requestNum = [self.arrPicUrl count] + [self.arrVideoUrl count] + [self.arrVoiceUrl count];
    }
    if([self.arrVideoUrl count] > 0 || [self.arrVoiceUrl count] > 0){
        self.requestNum = [self.arrVideoUrl count] + [self.arrVoiceUrl count];
    }
    
    //创建JSON
    NSDictionary *dictonary = [[NSMutableDictionary alloc] init];
    [dictonary setValue:self.strOrderID forKey:@"orderId"];
    [dictonary setValue:[utils getlogName] forKey:@"userAccnt"];
    [dictonary setValue:self.strStatus forKey:@"status"];
    [dictonary setValue:self.tvDesc.text forKey:@"dealDesc"];
    
    //请求
    [YNRequest YNPost:LBS_UpdateAlarmOrder parameters:dictonary success:^(NSDictionary *dic) {
        NSString *codeStr     = [dic objectForKey:@"rcode"];
        NSArray *arr          = [dic objectForKey:@"rows"];
        NSString *msgStr      = [dic objectForKey:@"rmessage"];
        if ([codeStr isEqualToString:@"0x0000"])
        {
            if (self.requestNum > 0)
            {
                if (self.arrPicUrl != nil && ![self.arrPicUrl isKindOfClass:[NSNull class]] && self.arrPicUrl.count != 0)
                {
                    [self upLoadPic:[arr objectAtIndex:0]];
                }
                if (self.arrVideoUrl != nil && ![self.arrVideoUrl isKindOfClass:[NSNull class]] && self.arrVideoUrl.count != 0)
                {
                    for (NSString *filestr in self.arrVideoUrl)
                    {
                        [self upLoadMP4:[arr objectAtIndex:0] urlStr:filestr];
                    }
                }
                if (self.arrVoiceUrl != nil && ![self.arrVoiceUrl isKindOfClass:[NSNull class]] && self.arrVoiceUrl.count != 0)
                {
                    [self upLoadMP3:[arr objectAtIndex:0]];
                }
            }else
            {
                if (self.arrPicUrl != nil && ![self.arrPicUrl isKindOfClass:[NSNull class]] && self.arrPicUrl.count != 0)
                {
                    [self upLoadPic:[arr objectAtIndex:0]];
                }else
                {
                    [SVProgressHUD showSuccessWithStatus:@"修改成功"];
                    [self performSelector:@selector(toPopVC) withObject:nil afterDelay:0.5f];
                }
            }
            
        }else{
            if ([codeStr isEqualToString:@"0x0016"])
            {
                //                [SVProgressHUD showErrorWithStatus:codeAuthMsg];
            }else{
                [SVProgressHUD showErrorWithStatus:msgStr];
            }
        }
    } fail:^{
        [SVProgressHUD showInfoWithStatus:@"网络异常,请检查网络"];
    }];
}

#pragma mark Show Camera View
- (IBAction)showPicAction:(id)sender
{
    JKImagePickerController *imagePickerController = [[JKImagePickerController alloc] init];
    imagePickerController.delegate                 = self;
    imagePickerController.showsCancelButton        = YES;
    imagePickerController.allowsMultipleSelection  = YES;
    imagePickerController.minimumNumberOfSelection = 0;
    imagePickerController.maximumNumberOfSelection = 6;
    imagePickerController.selectedAssetArray       = self.assetsArray;
    
    UINavigationController *navigationController   = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
    
    [self presentViewController:navigationController animated:YES completion:NULL];
}

/**
 *  提示限制视频个数
 *
 *  @param sender
 */
- (IBAction)showVedioAction:(id)sender
{
    if ([self.arrVideoUrl count] < 3)
    {
        _isVideo          = YES;
        _isVideoModelType = YES;
        [self presentViewController:self.imagePicker animated:YES completion:nil];
    }else
    {
        [SVProgressHUD showInfoWithStatus:@"最多上传三段视频"];
    }
}

#pragma mark Show Video View
/**
 *  播放视频1
 *
 *  @param sender
 */
- (IBAction)play1Vedio:(id)sender
{
    YNVedioPlayerVC *apvc = [[YNVedioPlayerVC alloc]init];
    apvc.urlVedio    = [self.arrVideoUrl objectAtIndex:0];
    apvc.tag         = 0;
    apvc.arrPhoto    = self.arrVideoUrl;
    
    [self presentViewController:apvc animated:YES completion:nil];
}

/**
 *  播放视频2
 *
 *  @param sender
 */
- (IBAction)play2Vedio:(id)sender
{
    YNVedioPlayerVC *apvc = [[YNVedioPlayerVC alloc]init];
    apvc.urlVedio2   = [self.arrVideoUrl objectAtIndex:1];
    apvc.tag         = 1;
    apvc.arrPhoto    = self.arrVideoUrl;
    
    [self presentViewController:apvc animated:YES completion:nil];
}

/**
 *  播放视频3
 *
 *  @param sender
 */
- (IBAction)play3Vedio:(id)sender
{
    YNVedioPlayerVC *apvc = [[YNVedioPlayerVC alloc]init];
    apvc.urlVedio3   = [self.arrVideoUrl objectAtIndex:2];
    apvc.tag         = 2;
    apvc.arrPhoto    = self.arrVideoUrl;
    
    [self presentViewController:apvc animated:YES completion:nil];
}

/**
 *  播放音频
 *
 *  @param sender
 */
- (IBAction)playMusic:(id)sender
{
    YNVoicePlayVC *playVC = [[YNVoicePlayVC alloc] init];
    playVC.voiceURL     = [self.arrVoiceUrl objectAtIndex:0];
    
    [self.navigationController pushViewController:playVC animated:YES];
}

/**
 *  视频缩略图
 *
 *  @param videoURL
 *
 *  @return
 */
- (UIImage *)getImage:(NSString *)videoURL
{
    AVURLAsset *asset                  = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:videoURL] options:nil];
    AVAssetImageGenerator *gen         = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    
    CMTime time      = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error   = nil;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *thumb   = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    
    return thumb;
}

#pragma mark Push Or Pop ViewController
/**
 *  跳转到录音vc
 *
 *  @param sender
 */
- (IBAction)toRecordVoiceAction:(id)sender
{
    YNVoiceRecordVC *rvvc =[[YNVoiceRecordVC alloc]init];
    
    [self.navigationController pushViewController:rvvc animated:YES];
}

/**
 *  跳转到上一级页面
 */
- (void)toPopVC
{
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"RefreshOrderInfoList" object:nil userInfo:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
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
