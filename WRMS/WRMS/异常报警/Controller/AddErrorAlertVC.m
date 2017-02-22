//
//  AddEventManagementVC.m
//  LeftSlide
//
//  Created by zhujintao on 16/7/20.
//  Copyright © 2016年 eamon. All rights reserved.
//

#import "AddErrorAlertVC.h"
#import "YNVoicePlayVC.h"
#import "EventManagementApi.h"
#import "ThreeModel.h"
#import <AssetsLibrary/AssetsLibrary.h>

static NSString *kPhotoCellIdentifier = @"kPhotoCellIdentifier";
@interface AddErrorAlertVC ()<BMKGeoCodeSearchDelegate,UICollectionViewDataSource,UICollectionViewDelegate,JKImagePickerControllerDelegate,JKPhotoBrowserDelegate,UITextViewDelegate,UITextFieldDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    BMKGeoCodeSearch *_geoCodeSearch;
}
@property (nonatomic, strong) ASIFormDataRequest      *request;
/** 图片选择器*/
@property (strong,nonatomic ) UIImagePickerController *imagePicker;
/** 开启一个定时器用于刷新经纬度*/
@property (nonatomic, strong) NSTimer                 *myTimer;
/** 定义一个Bool值判断是否是第一次获取经纬度*/
@property (nonatomic, assign) BOOL                    isFirstLat;

@property (nonatomic,strong ) IBOutlet UIScrollView            *mySv;
/** 纬度传值*/
@property (weak, nonatomic  ) NSString                *strLatitude;
/** 经度传值*/
@property (weak, nonatomic  ) NSString                *strLontitude;
/** 地址传值*/
@property (weak, nonatomic  ) NSString                *strAddress;
/** 报警原因传值*/
@property (nonatomic,strong ) NSString                *StrEventReson;
@property (nonatomic, retain) UICollectionView        *collectionView;
@property (nonatomic, strong) NSMutableArray          *assetsArray;
@property (nonatomic,strong ) YNNavigationRightBtn    *rightBtn;
@property (weak, nonatomic) IBOutlet UITextField *tf_PointId;
@property (nonatomic,strong) IBOutlet UILabel *labelLine1;
@property (nonatomic,strong) IBOutlet UILabel *labelLine2;
@property (nonatomic,strong) IBOutlet UILabel *labelVoice;
@property (nonatomic,strong) IBOutlet UIButton *btnVoice;
@property (nonatomic,strong) IBOutlet UILabel *labelPhoto;
@property (nonatomic,strong) IBOutlet UIButton *btnPhoto;
@property (nonatomic,strong) IBOutlet UILabel *labelVedio;
@property (nonatomic,strong) IBOutlet UIButton *btnVedio;
 @end

@implementation AddErrorAlertVC
#pragma mark - life cycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"添加异常报警";
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
        backItem.title = @"";
        self.navigationItem.backBarButtonItem = backItem;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(refreshVoiceIcon:)
                                                     name:@"RefreshVoiceIcon" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(refreshVedioAction:)
                                                     name:@"RefreshVedioAction" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(addToArrVedio:) name:@"RecordVedio"
                                                   object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [self.labelLine1 setFrame:CGRectMake(kWidth/3, self.labelLine1.frame.origin.y, self.labelLine1.frame.size.width, self.labelLine1.frame.size.height)];
    [self.labelLine2 setFrame:CGRectMake(kWidth/3*2, self.labelLine2.frame.origin.y, self.labelLine2.frame.size.width, self.labelLine2.frame.size.height)];
    //语音
    [self.labelVoice setFrame:CGRectMake(self.labelLine1.frame.origin.x/2 - self.labelVoice.frame.size.width/2, self.labelVoice.origin.y, self.labelVoice.frame.size.width, self.labelVoice.frame.size.height)];
    [self.btnVoice setFrame:CGRectMake(self.labelLine1.frame.origin.x/2 - self.btnVoice.frame.size.width/2, self.btnVoice.frame.origin.y, self.btnVoice.frame.size.width, self.btnVoice.frame.size.height)];
    //拍照
    [self.labelPhoto setFrame:CGRectMake(kWidth/2 - self.labelPhoto.frame.size.width/2, self.labelPhoto.frame.origin.y, self.labelPhoto.frame.size.width, self.labelPhoto.frame.size.height)];
    [self.btnPhoto setFrame:CGRectMake(kWidth/2 - self.btnPhoto.frame.size.width/2, self.btnPhoto.frame.origin.y,self.btnPhoto.frame.size.width, self.btnPhoto.frame.size.height)];
    //视频
    [self.labelVedio setFrame:CGRectMake(self.labelLine2.frame.origin.x + kWidth/6 - self.labelVedio.frame.size.width/2, self.labelVedio.frame.origin.y, self.labelVedio.frame.size.width, self.labelVedio.frame.size.height)];
    [self.btnVedio setFrame:CGRectMake(self.labelLine2.frame.origin.x + kWidth/6 - self.btnVedio.frame.size.width/2, self.btnVedio.frame.origin.y,self.btnVedio.frame.size.width, self.btnVedio.frame.size.height)];
    
    [super viewDidLoad];
    //addBtn
    _rightBtn = [[YNNavigationRightBtn alloc]initWith:nil img:@"commit" contro:self];
    __weak typeof(self) weakSelf = self;
    _rightBtn.clickBlock = ^(){
        [weakSelf addErrorAlertAction];
    };
    // 程序进来便要设置contentSize
    if ([UIScreen mainScreen].bounds.size.height == 480) {
        
        [self.mySv setContentSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height + 100)];
    }else{
        [self.mySv setContentSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    }
    // 初始化地理编码类
    _geoCodeSearch = [[BMKGeoCodeSearch alloc] init];
    self.isFirstLat = YES;
    [self getLat];
    [self layoutSubViews];
    self.requestNum    = 0;
    self.requestFinshedNum = 0;
    self.addrTextView.delegate = self;
    
    self.arrType       = [[NSMutableArray alloc]init];
    self.arrLevel      = [[NSMutableArray alloc]init];
    self.arrID_Type    = [[NSMutableArray alloc]init];
    self.arrText_Type  = [[NSMutableArray alloc]init];
    self.arrID_Level   = [[NSMutableArray alloc]init];
    self.arrText_Level = [[NSMutableArray alloc]init];
    self.arrVideoUrl   = [[NSMutableArray alloc]init];//存放视频相对路径，方便上传时批量上传
    self.arrPicUrl     = [[NSMutableArray alloc]init];//存放照片
    self.arrVoiceUrl   = [[NSMutableArray alloc]init];//存放音频文件
    self.datasPic      = [[NSMutableArray alloc]init];
    self.arrLogId      = [[NSMutableArray alloc]init];
    
    _eventResonTextView.clearButtonMode=UITextFieldViewModeWhileEditing;
    _eventResonTextView.tag = 20001;
    _eventResonTextView.delegate = self ;
    
    [IQKeyboardManager sharedManager].shouldShowTextFieldPlaceholder=YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    
    //获取报警类型
    [self getAlertType];
    //获取报警等级
    [self getAlertLevel];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [SVProgressHUD dismiss];
    _geoCodeSearch.delegate = self ;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    _geoCodeSearch.delegate = nil;
    [self.request cancel];
    [self.myTimer invalidate];
}

/**
 *  在dealloc里移除通知
 *
 *  @return
 */
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RefreshVoiceIcon" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RefreshVedioAction" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RecordVedio" object:nil];
}

#pragma mark - TextField Delegate
/**
 *  限制textField的字数输入在4个字和11个字以内
 *
 *  @param textField textField
 */
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag == 20001) {
        NSInteger number = [textField.text length];
        if (number > 18) {
            [SVProgressHUD showInfoWithStatus:@"报警原因最多输入18个字"];
            textField.text    = [textField.text substringToIndex:18];
            number           = 18;
        }
    }
    
}

#pragma mark - BMKGeoCodeSearchDelegate
/**
 *返回反地理编码搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结果
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    //BMKReverseGeoCodeResult是编码的结果，包括地理位置，道路名称，uid，城市名等信息
    BMKAddressComponent *addressDetail = result.addressDetail;
    self.addrTextView.text = [NSString stringWithFormat:@"%@%@%@%@%@", addressDetail.province, addressDetail.city, addressDetail.district, addressDetail.streetName, addressDetail.streetNumber];
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
    
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        [self.collectionView reloadData];
        
    }];
    
}

- (void)imagePickerControllerDidCancel:(JKImagePickerController *)imagePicker
{
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)addToArrVedio:(NSNotification *)text {
    NSString *strdel1 = [text.userInfo objectForKey:@"vedioUrl"];
    [self.arrVideoUrl addObject:strdel1];
    
    if([self.arrPicUrl count] == 0 ){
        [self.collectionView setSize:CGSizeMake(self.collectionView.frame.size.width, 0)];
    }else{
        [self.collectionView setSize:CGSizeMake(self.collectionView.frame.size.width, 90)];
    }
    if([self.arrVideoUrl count] == 0){
        [self.viewViedo setSize:CGSizeMake(self.viewViedo.frame.size.width, 0)];
    }else{
        [self.viewViedo setSize:CGSizeMake(self.viewViedo.frame.size.width, 90)];
    }
    if([self.arrVideoUrl count] ==1){
        [self.viewViedo setHidden:NO];
        [self.videoPic setImage:[self getImage:[self.arrVideoUrl objectAtIndex:0]]];
        [self.videoPic setHidden:NO];
        [self.videoLbl setHidden:NO];
        [self.videoPlayBtn setHidden:NO];
        
        [self.videoPic setFrame:CGRectMake(self.videoPic.frame.origin.x, self.videoPic.frame.origin.y, 80, self.videoPic.frame.size.height)];
        [self.videoPlayBtn setFrame:CGRectMake(self.videoPlayBtn.frame.origin.x, self.videoPlayBtn.frame.origin.y, 32, self.videoPlayBtn.frame.size.height)];
        [self.videoLbl setFrame:CGRectMake(self.videoLbl.frame.origin.x, self.videoLbl.frame.origin.y, 80, self.videoLbl.frame.size.height)];
        
    }
    if([self.arrVideoUrl count] ==2){
        [self.viewViedo setHidden:NO];
        [self.videoPic2 setImage:[self getImage:[self.arrVideoUrl objectAtIndex:1]]];
        [self.videoPic2 setHidden:NO];
        [self.videoLbl2 setHidden:NO];
        [self.videoPlayBtn2 setHidden:NO];
        
        [self.videoPic2 setFrame:CGRectMake(self.videoPic2.frame.origin.x, self.videoPic2.frame.origin.y, 80, self.videoPic2.frame.size.height)];
        [self.videoPlayBtn2 setFrame:CGRectMake(self.videoPlayBtn2.frame.origin.x, self.videoPlayBtn2.frame.origin.y, 32, self.videoPlayBtn2.frame.size.height)];
        [self.videoLbl2 setFrame:CGRectMake(self.videoLbl2.frame.origin.x, self.videoLbl2.frame.origin.y, 80, self.videoLbl2.frame.size.height)];
        
        [self.videoPic setImage:[self getImage:[self.arrVideoUrl objectAtIndex:0]]];
        [self.videoPic setHidden:NO];
        [self.videoLbl setHidden:NO];
        [self.videoPlayBtn setHidden:NO];
        [self.videoPic setFrame:CGRectMake(self.videoPic.frame.origin.x, self.videoPic.frame.origin.y, 80, self.videoPic.frame.size.height)];
        [self.videoPlayBtn setFrame:CGRectMake(self.videoPlayBtn.frame.origin.x, self.videoPlayBtn.frame.origin.y, 32, self.videoPlayBtn.frame.size.height)];
        [self.videoLbl setFrame:CGRectMake(self.videoLbl.frame.origin.x, self.videoLbl.frame.origin.y, 80, self.videoLbl.frame.size.height)];
        
    }
    if([self.arrVideoUrl count] ==3){
        [self.viewViedo setHidden:NO];
        [self.videoPic3 setImage:[self getImage:[self.arrVideoUrl objectAtIndex:2]]];
        [self.videoPic3 setHidden:NO];
        [self.videoLbl3 setHidden:NO];
        [self.videoPlayBtn3 setHidden:NO];
        
        [self.videoPic3 setFrame:CGRectMake(self.videoPic3.frame.origin.x, self.videoPic3.frame.origin.y, 80, self.videoPic3.frame.size.height)];
        [self.videoPlayBtn3 setFrame:CGRectMake(self.videoPlayBtn3.frame.origin.x, self.videoPlayBtn3.frame.origin.y, 32, self.videoPlayBtn3.frame.size.height)];
        [self.videoLbl3 setFrame:CGRectMake(self.videoLbl3.frame.origin.x, self.videoLbl3.frame.origin.y, 80, self.videoLbl3.frame.size.height)];
        
        [self.videoPic2 setImage:[self getImage:[self.arrVideoUrl objectAtIndex:1]]];
        [self.videoPic2 setHidden:NO];
        [self.videoLbl2 setHidden:NO];
        [self.videoPlayBtn2 setHidden:NO];
        [self.videoPic2 setFrame:CGRectMake(self.videoPic2.frame.origin.x, self.videoPic2.frame.origin.y, 80, self.videoPic2.frame.size.height)];
        [self.videoPlayBtn2 setFrame:CGRectMake(self.videoPlayBtn2.frame.origin.x, self.videoPlayBtn2.frame.origin.y, 32, self.videoPlayBtn2.frame.size.height)];
        [self.videoLbl2 setFrame:CGRectMake(self.videoLbl2.frame.origin.x, self.videoLbl2.frame.origin.y, 80, self.videoLbl2.frame.size.height)];
        
        [self.videoPic setImage:[self getImage:[self.arrVideoUrl objectAtIndex:0]]];
        [self.videoPic setHidden:NO];
        [self.videoLbl setHidden:NO];
        [self.videoPlayBtn setHidden:NO];
        [self.videoPic setFrame:CGRectMake(self.videoPic.frame.origin.x, self.videoPic.frame.origin.y, 80, self.videoPic.frame.size.height)];
        [self.videoPlayBtn setFrame:CGRectMake(self.videoPlayBtn.frame.origin.x, self.videoPlayBtn.frame.origin.y, 32, self.videoPlayBtn.frame.size.height)];
        [self.videoLbl setFrame:CGRectMake(self.videoLbl.frame.origin.x, self.videoLbl.frame.origin.y, 80, self.videoLbl.frame.size.height)];
        
    }
    [self refreshSVContentsize];
}

// 删除录音
- (void)deleteVoice {
    
    [self.btnvoice setHidden:YES];
    [self.arrVoiceUrl removeAllObjects];
    [self.viewViedo setSize:CGSizeMake(self.viewViedo.frame.size.width, 0)];
    
    [self refreshSVContentsize];
}

-(void)refreshVedioAction:(NSNotification *)text {
    
    NSString *strdel1 = [text.userInfo objectForKey:@"vediourl1"];
    NSString *strdel2 = [text.userInfo objectForKey:@"vediourl2"];
    NSString *strdel3 = [text.userInfo objectForKey:@"vediourl3"];
    
    // 给一个数组容器装三个字符串
    NSArray *arr = [NSArray arrayWithObjects:strdel1, strdel2, strdel3, nil];
    
    // 这个数组里面装的是需要移除的url对应的字符串
    NSMutableArray *arr1 = [NSMutableArray array];
    for (int i = 0; i < arr.count; i++) {
        
        if ([arr[i] integerValue] == 0) {
            
            [arr1 addObject:arr[i]];
        }
    }
    // 逻辑判断
    if (arr1.count == 3) {
        [self.arrVideoUrl removeAllObjects];
    }
    if (arr1.count == 2){
        if ([arr1 containsObject:strdel1] && [arr1 containsObject:strdel2]) {
            [self.arrVideoUrl removeObjectAtIndex:0];
            [self.arrVideoUrl removeObjectAtIndex:0];
        }else if ([arr1 containsObject:strdel1] && [arr1 containsObject:strdel3]){
            [self.arrVideoUrl removeObjectAtIndex:0];
            [self.arrVideoUrl removeObjectAtIndex:1];
        }else{
            [self.arrVideoUrl removeObjectAtIndex:1];
            [self.arrVideoUrl removeObjectAtIndex:1];
        }
    }
    if (arr1.count == 1){
        if ([arr1 containsObject:strdel1]) {
            [self.arrVideoUrl removeObjectAtIndex:0];
        }else if ([arr1 containsObject:strdel2]){
            [self.arrVideoUrl removeObjectAtIndex:1];
        }else{
            [self.arrVideoUrl removeObjectAtIndex:2];
        }
    }
    if([self.arrVideoUrl count] == 0){
        [self.viewViedo setHidden:YES];
        
        [self.videoPic setImage:nil];
        [self.videoLbl setHidden:YES];
        [self.videoPlayBtn setHidden:YES];
        
        [self.videoPic2 setImage:nil];
        [self.videoLbl2 setHidden:YES];
        [self.videoPlayBtn2 setHidden:YES];
        
        [self.videoPic3 setImage:nil];
        [self.videoLbl3 setHidden:YES];
        [self.videoPlayBtn3 setHidden:YES];
        
    }
    if([self.arrVideoUrl count] ==1){
        [self.viewViedo setHidden:NO];
        
        [self.videoPic setImage:[self getImage:[self.arrVideoUrl objectAtIndex:0]]];
        [self.videoLbl setHidden:NO];
        [self.videoPlayBtn setHidden:NO];
        
        [self.videoPic2 setImage:nil];
        [self.videoLbl2 setHidden:YES];
        [self.videoPlayBtn2 setHidden:YES];
        
        [self.videoPic2 setFrame:CGRectMake(self.videoPic2.frame.origin.x, self.videoPic2.frame.origin.y, 0, self.videoPic2.frame.size.height)];
        [self.videoPlayBtn2 setFrame:CGRectMake(self.videoPlayBtn2.frame.origin.x, self.videoPlayBtn2.frame.origin.y, 0, self.videoPlayBtn2.frame.size.height)];
        [self.videoLbl2 setFrame:CGRectMake(self.videoLbl2.frame.origin.x, self.videoLbl2.frame.origin.y, 0, self.videoLbl2.frame.size.height)];
        
        [self.videoPic3 setFrame:CGRectMake(self.videoPic3.frame.origin.x, self.videoPic3.frame.origin.y, 0, self.videoPic3.frame.size.height)];
        [self.videoPlayBtn3 setFrame:CGRectMake(self.videoPlayBtn3.frame.origin.x, self.videoPlayBtn3.frame.origin.y, 0, self.videoPlayBtn3.frame.size.height)];
        [self.videoLbl3 setFrame:CGRectMake(self.videoLbl3.frame.origin.x, self.videoLbl3.frame.origin.y, 0, self.videoLbl3.frame.size.height)];
        
    }
    if([self.arrVideoUrl count] ==2){
        [self.viewViedo setHidden:NO];
        
        [self.videoPic setImage:[self getImage:[self.arrVideoUrl objectAtIndex:0]]];
        [self.videoLbl setHidden:NO];
        [self.videoPlayBtn setHidden:NO];
        
        [self.viewViedo setHidden:NO];
        [self.videoPic2 setImage:[self getImage:[self.arrVideoUrl objectAtIndex:1]]];
        [self.videoLbl2 setHidden:NO];
        [self.videoPlayBtn2 setHidden:NO];
        
        [self.videoPic3 setImage:nil];
        [self.videoLbl3 setHidden:YES];
        [self.videoPlayBtn3 setHidden:YES];
        
        [self.videoPic3 setFrame:CGRectMake(self.videoPic3.frame.origin.x, self.videoPic3.frame.origin.y, 0, self.videoPic3.frame.size.height)];
        [self.videoPlayBtn3 setFrame:CGRectMake(self.videoPlayBtn3.frame.origin.x, self.videoPlayBtn3.frame.origin.y, 0, self.videoPlayBtn3.frame.size.height)];
        [self.videoLbl3 setFrame:CGRectMake(self.videoLbl3.frame.origin.x, self.videoLbl3.frame.origin.y, 0, self.videoLbl3.frame.size.height)];
    }
    if([self.arrVideoUrl count] ==3){
        [self.viewViedo setHidden:NO];
        [self.videoPic setImage:[self getImage:[self.arrVideoUrl objectAtIndex:0]]];
        [self.videoLbl setHidden:NO];
        [self.videoPlayBtn setHidden:NO];
        
        [self.viewViedo setHidden:NO];
        [self.videoPic2 setImage:[self getImage:[self.arrVideoUrl objectAtIndex:1]]];
        [self.videoLbl2 setHidden:NO];
        [self.videoPlayBtn2 setHidden:NO];
        
        [self.viewViedo setHidden:NO];
        [self.videoPic3 setImage:[self getImage:[self.arrVideoUrl objectAtIndex:2]]];
        [self.videoLbl3 setHidden:NO];
        [self.videoPlayBtn3 setHidden:NO];
    }
    
    [self refreshSVContentsize];
}
//刷新声音图标
-(void)refreshVoiceIcon:(NSNotification *)text {
    
    [self.btnvoice setHidden:NO];
    NSString *strVoiceFile = [text.userInfo objectForKey:@"VoiceUrl"];
    [self.arrVoiceUrl addObject:strVoiceFile];
    if([self.arrVideoUrl count] == 0){
        [self.viewViedo setSize:CGSizeMake(self.viewViedo.frame.size.width, 0)];
    }else{
        [self.viewViedo setSize:CGSizeMake(self.viewViedo.frame.size.width, 90)];
    }
    
    [self refreshSVContentsize];
}

//刷新sv的高度
-(void)refreshSVContentsize {
    NSInteger isPic = 0;
    NSInteger isVedio = 0;
    NSInteger isVoice = 0;
    if ([self.assetsArray count] >0) {
        isPic = 1;
    }
    if ([self.arrVideoUrl count] >0) {
        isVedio = 1;
    }
    if ([self.arrVoiceUrl count] >0) {
        isVoice = 1;
    }
    // 布局
    if ([UIScreen mainScreen].bounds.size.height == 480)
    { // 屏幕为4s
        
        [self setLayoutOfScrollViewWith:@"4s"
                                  isPic:isPic
                                isVedio:isVedio
                                isVoice:isVoice];
        
        
    }else{ // 屏幕为4S以上
        
        [self setLayoutOfScrollViewWith:@"other"
                                  isPic:isPic
                                isVedio:isVedio
                                isVoice:isVoice];
    }
    
}

-(UIImagePickerController *)imagePicker{
    
    if( _isVideoModelType){//相机模式
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
            _imagePicker=[[UIImagePickerController alloc]init];
            _imagePicker.sourceType=UIImagePickerControllerSourceTypeCamera;//设置image picker的来源，这里设置为摄像头
            _imagePicker.cameraDevice=UIImagePickerControllerCameraDeviceRear;//设置使用哪个摄像头，这里设置为后置摄像头
            
            if (_isVideo) {//录视频
                
                //your code
                _imagePicker.mediaTypes=@[(NSString *)kUTTypeMovie];
                _imagePicker.videoQuality=UIImagePickerControllerQualityType640x480;
                _imagePicker.videoMaximumDuration = 10.0f;
                _imagePicker.cameraCaptureMode=UIImagePickerControllerCameraCaptureModeVideo;//设置摄像头模式（拍照，录制视频）
            }else{//拍照片
                _imagePicker.cameraCaptureMode=UIImagePickerControllerCameraCaptureModePhoto;
                _imagePicker.mediaTypes =  [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
            }
            
            _imagePicker.allowsEditing=YES;//允许编辑
            _imagePicker.delegate=self;//设置代理，检测操作
        }else{//相册模式
            _imagePicker=[[UIImagePickerController alloc]init];
            _imagePicker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;//设置image picker的来源，这里设置为相册
            
            
            if (_isVideo) {
                _imagePicker.mediaTypes=@[(NSString *)kUTTypeMovie];
                _imagePicker.mediaTypes =  [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
            }else{
                _imagePicker.mediaTypes =  [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
            }
            
            _imagePicker.allowsEditing=YES;//允许编辑
            _imagePicker.delegate=self;//设置代理，检测操作
        }
        
    }
    
    return _imagePicker;
}

//视频缩略图
- (UIImage *)getImage:(NSString *)videoURL {
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:videoURL] options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return thumb;
    
}
#pragma mark 视频拍摄
#pragma mark 拍摄 拍照
#pragma mark - UIImagePickerController代理方法
//完成
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {//如果是拍照
        UIImage *image;
        //如果允许编辑则获得编辑后的照片，否则获取原始照片
        if (self.imagePicker.allowsEditing) {
            image=[info objectForKey:UIImagePickerControllerEditedImage];//获取编辑后的照片
        }else{
            image=[info objectForKey:UIImagePickerControllerOriginalImage];//获取原始照片
        }
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);//保存到相簿
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextField Delegate
- (void)textViewDidChange:(UITextView *)textView {
    NSInteger number = [textView.text length];
    if (number > 30) {
        [SVProgressHUD showInfoWithStatus:@"最多可输入30位"];
        textView.text    = [textView.text substringToIndex:30];
        number           = 30;
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if([self.assetsArray count] == 0 ){
        [self.arrPicUrl removeAllObjects];
        [self.collectionView setSize:CGSizeMake(self.collectionView.frame.size.width, 0)];
    }else{
        [self.collectionView setSize:CGSizeMake(self.collectionView.frame.size.width, 90)];
    }
    [self refreshSVContentsize];
    return [self.assetsArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PhotoCell *cell = (PhotoCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kPhotoCellIdentifier forIndexPath:indexPath];
    
    cell.asset = [self.assetsArray objectAtIndex:[indexPath row]];
    ALAssetsLibrary   *lib = [[ALAssetsLibrary alloc] init];
    [lib assetForURL:cell.asset.assetPropertyURL resultBlock:^(ALAsset *asset) {
        
        NSString *str1 = [cell.asset.assetPropertyURL absoluteString];
        if([str1 rangeOfString:@"MOV"].location !=NSNotFound)//如果是视频
        {
            cell.labelContent.text = @"视频";
            [cell.labelContent setHidden:NO];
            NSString *urlStr=[cell.asset.assetPropertyURL path];
            //            self.tv_remark.text = urlStr;
        }else{
            cell.labelContent.text = @"";
            [cell.labelContent setHidden:YES];
        }
    } failureBlock:^(NSError *error) {
        
    }];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(80, 80);
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    JKImagePickerController *imagePickerController = [[JKImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.showsCancelButton = YES;
    imagePickerController.allowsMultipleSelection = YES;
    imagePickerController.minimumNumberOfSelection = 0;
    imagePickerController.maximumNumberOfSelection = 3;
    imagePickerController.selectedAssetArray = self.assetsArray;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
    [self presentViewController:navigationController animated:YES completion:NULL];
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 5.0;
        layout.minimumInteritemSpacing = 5.0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(11, 290, CGRectGetWidth(self.view.frame)-22, 90) collectionViewLayout:layout];
        //        _collectionView.backgroundColor = [UIColor grayColor];
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[PhotoCell class] forCellWithReuseIdentifier:kPhotoCellIdentifier];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [self.mySv addSubview:_collectionView];
    }
    return _collectionView;
}

#pragma mark - event responses
- (IBAction)choseType:(UIButton *)sender {
    [self.view endEditing:YES];
    for (ThreeModel *typeModel in self.arrType) {
        if (![self.arrID_Type containsObject:typeModel.strid]) {
            [self.arrID_Type addObject:typeModel.strid];
        }if (![self.arrText_Type containsObject:typeModel.strtext]) {
            [self.arrText_Type addObject:typeModel.strtext];
        }
    }
    KTActionSheet *actionSheet = [[KTActionSheet alloc]initWithTitle:@"请选择报警类型" itemTitles:self.arrText_Type];
    actionSheet.delegate = self ;
    actionSheet.tag = 23 ;
    __weak typeof(self) weakSelf = self;
    [actionSheet didFinishSelectIndex:^(NSInteger index, NSString *title) {
        weakSelf.tf_type.text     = [NSString stringWithFormat:@"%@",title];
        self.strType              = [self.arrID_Type objectAtIndex:index];
    }];
}

- (IBAction)eventLevelAction:(UIButton *)sender {
    [self.view endEditing:YES];
    for (ThreeModel *tmodel in self.arrLevel) {
        if (![self.arrID_Level containsObject:tmodel.strid]) {
            [self.arrID_Level addObject:tmodel.strid];
        }
        if(![self.arrText_Level containsObject:tmodel.strtext]){
            [self.arrText_Level addObject:tmodel.strtext];
        }
    }
    KTActionSheet *actionSheet = [[KTActionSheet alloc]initWithTitle:@"请选择报警等级" itemTitles:self.arrText_Level];
    actionSheet.delegate = self ;
    actionSheet.tag = 25;
    __weak typeof(self) weakSelf = self;
    [actionSheet didFinishSelectIndex:^(NSInteger index, NSString *title) {
        weakSelf.tf_level.text = [NSString stringWithFormat:@"%@", title];
        self.strLevel          = [self.arrID_Level objectAtIndex:index];
    }];
}


//显示拍照/本地相册
- (IBAction)showPicAction:(id)sender {
    JKImagePickerController *imagePickerController = [[JKImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.showsCancelButton = YES;
    imagePickerController.allowsMultipleSelection = YES;
    imagePickerController.minimumNumberOfSelection = 0;
    imagePickerController.maximumNumberOfSelection = 3;
    imagePickerController.selectedAssetArray = self.assetsArray;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
    [self presentViewController:navigationController animated:YES completion:NULL];
}

//跳转到录音
- (IBAction)updateVoiceAction:(UIButton *)sender {
    
    YNVoiceRecordVC *rvvc =[[YNVoiceRecordVC alloc]init];
    [self presentViewController:rvvc animated:YES completion:nil];
}

- (IBAction)showVedioAction:(id)sender {
    if ([self.arrVideoUrl count] < 3) {
        YNVedioRecordVC *rvc = [[YNVedioRecordVC alloc]init];
        [self presentViewController:rvc animated:YES completion:nil];
    }else{
        [SVProgressHUD showInfoWithStatus:@"最多可以上传三段视频"];
    }
}

//播放视频1
- (IBAction)play1Vedio:(id)sender {
    YNVedioPlayerVC *apvc =[[YNVedioPlayerVC alloc]init];
    apvc.urlVedio =  [self.arrVideoUrl objectAtIndex:0];
    apvc.tag = 0;
    apvc.arrPhoto = self.arrVideoUrl;
    [self presentViewController:apvc animated:YES completion:nil];
    //    [self.navigationController pushViewController:apvc animated:YES];
}

//播放视频2
- (IBAction)play2Vedio:(id)sender {
    YNVedioPlayerVC *apvc =[[YNVedioPlayerVC alloc]init];
    apvc.urlVedio2 =  [self.arrVideoUrl objectAtIndex:1];
    if ([[self.arrVideoUrl objectAtIndex:1] isEqualToString:@""]) {
        apvc.tag = 0;
    }else{
        apvc.tag = 1;
    }
    apvc.arrPhoto = self.arrVideoUrl;
    //    [self presentViewController:apvc animated:YES completion:nil];
    [self presentViewController:apvc animated:YES completion:nil];
}

//播放视频3
- (IBAction)play3Vedio:(id)sender {
    YNVedioPlayerVC *apvc =[[YNVedioPlayerVC alloc]init];
    apvc.urlVedio3 =[self.arrVideoUrl objectAtIndex:2];
    if ( [[self.arrVideoUrl objectAtIndex:2] isEqualToString:@""]) {
        apvc.tag = 1;
    }else{
        apvc.tag = 2;
    }
    apvc.arrPhoto = self.arrVideoUrl;
    //    [self presentViewController:apvc animated:YES completion:nil];
    [self presentViewController:apvc animated:YES completion:nil];
}

//播放声音文件
- (IBAction)playMusic:(id)sender {
    
    YNVoicePlayVC *voiceVC = [[YNVoicePlayVC alloc] init];
    voiceVC.deleteBlock = ^(){
        
        // 删除录音
        [self deleteVoice];
    };
    voiceVC.voiceURL = [self.arrVoiceUrl objectAtIndex:0];
    [self presentViewController:voiceVC animated:YES completion:nil];
}



//上传音频
- (void)upLoadMP3:(NSString *)strHid
{
    
    NSURL *url = [NSURL URLWithString:UploadMediaURL];
    
    _request = [ASIFormDataRequest requestWithURL:url];
    for (NSString *filestr in self.arrVoiceUrl) {
        [_request setFile:filestr forKey:@"audioFile"];
    }
    [_request setPostValue:strHid forKey:@"logId"];
    [_request setPostValue:[utils getlogName] forKey:@"userAccout"];
    [_request buildPostBody];
    [_request setDelegate:self];
    [_request setTimeOutSeconds:30];
    [_request startAsynchronous];
    
}


//上传视频
- (void)upLoadMP4:(NSString *)strHid urlStr:(NSString *)pathUrl
{
    NSURL *url = [NSURL URLWithString:UploadMediaURL];
    _request = [ASIFormDataRequest requestWithURL:url];
    [_request setFile:pathUrl forKey:@"videoFile"];
    [_request setPostValue:strHid forKey:@"logId"];
    [_request setPostValue:[utils getlogName] forKey:@"userAccout"];
    [_request buildPostBody];
    [_request setDelegate:self];
    [_request setShowAccurateProgress:YES];
    _request.shouldAttemptPersistentConnection=NO;
    [_request setDidFailSelector:@selector(responseFailed)];
    [_request setDidFinishSelector:@selector(responseComplete)];
    [_request setTimeOutSeconds:30];
    [_request startSynchronous];
}

//上传照片
- (void)upLoadPic:(NSString *)strHid{
    NSURL *url = [NSURL URLWithString:UploadMediaURL];
    _request = [ASIFormDataRequest requestWithURL:url];
    [_request setPostValue:strHid forKey:@"logId"];
    [_request setPostValue:[utils getlogName] forKey:@"userAccout"];
    
    for (UIImage *eImage in self.arrPicUrl)
    {
        int x = arc4random() % 100;
        int y = arc4random() % 100;
        NSData *imageData=UIImageJPEGRepresentation(eImage,100);
        NSString *photoName=[NSString stringWithFormat:@"%zd-%zd.jpg",x,y];
        NSString *photoDescribe=@" ";
        //照片content
        [_request setPostValue:photoDescribe forKey:@"pictureFile"];
        [_request addData:imageData withFileName:photoName andContentType:@"image/jpeg" forKey:@"pictureFile"];
    }
    [_request buildPostBody];
    _request.shouldAttemptPersistentConnection=NO;
    [_request setDelegate:self];
    [_request setDidFailSelector:@selector(responseFailed)];
    [_request setDidFinishSelector:@selector(responseComplete)];
    [_request setTimeOutSeconds:30];
    [_request startSynchronous];
}

// 删除录音文件
-(void)deleteTempMp3File {
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSString *FileFullPath = [self.arrVoiceUrl objectAtIndex:0];
    BOOL bRet = [fileMgr fileExistsAtPath:FileFullPath];
    if (bRet) {
        NSError *err;
        if ([fileMgr removeItemAtPath:FileFullPath error:&err]) {
            
            //            NSLog(@"删除录音文件成功");
        }else{
            //            NSLog(@"删除录音文件失败");
        }
    }
}

#pragma mark - Private Method
/**
 *  获取经纬度
 */
- (void)getLat {
    [YNLocation getMyLocation:self.strLatitude
                    lontitude:self.strLontitude
                       height:nil
                 successBlock:^(NSString *strLat, NSString *strLon, NSString *strHeight) {
                     
                     self.strLontitude = strLon;
                     self.strLatitude = strLat;
                     self.tf_latitude.text    = self.strLatitude;
                     self.tf_lontitude.text    = self.strLontitude;
                 }];
    //    NSLog(@"===========%@ %@",self.strLatitude,self.strLontitude);
    
    // 如果是第一次获取经纬度就反地理编码获取到地址信息
    if (self.isFirstLat == YES){
        // 在水位采集中，使用百度地图通过经纬度获取到地址
        CLLocationCoordinate2D coor2 = CLLocationCoordinate2DMake([self.strLatitude floatValue],[self.strLontitude floatValue]);
        
        //转换 google地图、soso地图、aliyun地图、mapabc地图和amap地图所用坐标至百度坐标
        NSDictionary* testdic2 = BMKConvertBaiduCoorFrom(coor2,BMK_COORDTYPE_COMMON);
        //转换GPS坐标至百度坐标(加密后的坐标)
        testdic2 = BMKConvertBaiduCoorFrom(coor2,BMK_COORDTYPE_GPS);
        //解密加密后的坐标字典
        coor2 = BMKCoorDictionaryDecode(testdic2);//转换后的百度坐标
        NSLog(@"END 转换之后：%f,%f",coor2.latitude,coor2.longitude);
        //初始化逆地理编码类
        BMKReverseGeoCodeOption *reverseGeoCodeOption= [[BMKReverseGeoCodeOption alloc] init];
        
        //需要逆地理编码的坐标位置
        reverseGeoCodeOption.reverseGeoPoint = coor2;
        [_geoCodeSearch reverseGeoCode:reverseGeoCodeOption];
        self.isFirstLat = NO;
    }
}

//获取控件内容
- (void)getAllLabelContent {
    self.strLatitude = self.tf_latitude.text;
    self.strLontitude = self.tf_lontitude.text;
    self.strAddress = self.addrTextView.text;
}
//获取报警类型
- (void)getAlertType {
    [EventManagementApi apiWithGetEventTypeDataWithArrType:self.arrType];
    
}
//获取报警等级
- (void)getAlertLevel {
    [EventManagementApi apiWithGetEventLevelWithLevelArr:self.arrLevel];
    
}

- (void)layoutSubViews {
    //三个大View的布局 照片，视频，音频
    
    self.collectionView.frame = CGRectMake(20, self.eventResonTextView.frame.origin.y + 70 , self.mySv.contentSize.width - 40, 0);
    self.viewViedo.frame = CGRectMake(20, self.collectionView.frame.origin.y + 110, self.mySv.contentSize.width - 40, 0);
    self.viewVoice.frame = CGRectMake(20, self.viewViedo.frame.origin.y + 70, self.mySv.contentSize.width - 40, 0);
    
    //处理视频中三个ImageView的位置
    self.videoPic.sd_layout
    .leftSpaceToView(self.viewViedo,0)
    .topSpaceToView(self.viewViedo,4)
    .heightIs(80)
    .widthIs(80);
    
    self.videoPic2.sd_layout
    .leftSpaceToView(self.videoPic,10)
    .topEqualToView(self.videoPic)
    .heightIs(80)
    .widthIs(80);
    
    self.videoPic3.sd_layout
    .leftSpaceToView(self.videoPic2,10)
    .topEqualToView(self.videoPic2)
    .heightIs(80)
    .widthIs(80);
    
    //处理视频中三个Btn的位置
    self.videoPlayBtn.sd_layout
    .leftSpaceToView(self.videoPic,-40-16)
    .topSpaceToView(self.videoPic,-40-16)
    .heightIs(32)
    .widthIs(32);
    
    self.videoPlayBtn2.sd_layout
    .leftSpaceToView(self.videoPic2,-40-16)
    .topEqualToView(self.videoPlayBtn)
    .heightIs(32)
    .widthIs(32);
    
    self.videoPlayBtn3.sd_layout
    .leftSpaceToView(self.videoPic3,-40-16)
    .topEqualToView(self.videoPlayBtn2)
    .heightIs(32)
    .widthIs(32);
    
    self.videoLbl.sd_layout
    .leftSpaceToView(self.videoPic,-80)
    .bottomSpaceToView(self.viewViedo,5)
    .heightIs(16)
    .widthIs(80);
    
    self.videoLbl2.sd_layout
    .leftSpaceToView(self.videoPic2,-80)
    .bottomEqualToView(self.videoLbl)
    .heightIs(16)
    .widthIs(80);
    
    self.videoLbl3.sd_layout
    .leftSpaceToView(self.videoPic3,-80)
    .bottomEqualToView(self.videoLbl2)
    .heightIs(16)
    .widthIs(80);
    
}

- (void)setLayoutOfScrollViewWith:(NSString *)str isPic:(NSInteger)isPic isVedio:(NSInteger)isVedio isVoice:(NSInteger)isVoice {
    
    if ([str isEqualToString:@"4s"])
    { // 如果手机是4s的
        if (isPic == 0 && isVedio == 0 && isVoice == 0)
        {
            self.collectionView.frame = CGRectMake(20, self.eventResonTextView.frame.origin.y + 70 , self.mySv.contentSize.width - 40, 0);
            self.viewViedo.frame      = CGRectMake(20, self.collectionView.frame.origin.y + self.collectionView.frame.size.height + 20, self.mySv.contentSize.width - 40, 0);
            self.viewVoice.frame      = CGRectMake(20, self.viewViedo.frame.origin.y + self.viewViedo.frame.size.height + 20, self.mySv.contentSize.width - 40, 0);
            self.mySv.contentSize     = CGSizeMake(self.mySv.frame.size.width, [UIScreen mainScreen].bounds.size.height - 126);
        }
        if (isPic == 0 && isVedio == 0 && isVoice == 1)
        {
            self.collectionView.frame = CGRectMake(20, self.eventResonTextView.frame.origin.y + 70 , self.mySv.contentSize.width - 40, 0);
            self.viewViedo.frame      = CGRectMake(20, self.collectionView.frame.origin.y + self.collectionView.frame.size.height, self.mySv.contentSize.width - 40, 0);
            self.viewVoice.frame      = CGRectMake(20, self.viewViedo.frame.origin.y + self.viewViedo.frame.size.height, self.mySv.contentSize.width - 40, 50);
            self.mySv.contentSize     = CGSizeMake(self.mySv.frame.size.width, [UIScreen mainScreen].bounds.size.height - 126);
        }
        if (isPic == 0 && isVedio == 1 && isVoice == 0)
        {
            self.collectionView.frame = CGRectMake(20, self.eventResonTextView.frame.origin.y + 70 , self.mySv.contentSize.width - 40, 0);
            self.viewViedo.frame      = CGRectMake(20, self.collectionView.frame.origin.y + self.collectionView.frame.size.height, self.mySv.contentSize.width - 40, 90);
            self.viewVoice.frame      = CGRectMake(20, self.viewViedo.frame.origin.y + self.viewViedo.frame.size.height + 20, self.mySv.contentSize.width - 40, 0);
            self.mySv.contentSize     = CGSizeMake(self.mySv.frame.size.width, [UIScreen mainScreen].bounds.size.height - 126);
        }
        if (isPic == 0 && isVedio == 1 && isVoice == 1)
        {
            self.collectionView.frame = CGRectMake(20, self.eventResonTextView.frame.origin.y + 70 , self.mySv.contentSize.width - 40, 0);
            self.viewViedo.frame      = CGRectMake(20, self.collectionView.frame.origin.y + self.collectionView.frame.size.height, self.mySv.contentSize.width - 40, 90);
            self.viewVoice.frame      = CGRectMake(20, self.viewViedo.frame.origin.y + self.viewViedo.frame.size.height + 20, self.mySv.contentSize.width - 40, 50);
            self.mySv.contentSize     = CGSizeMake(self.mySv.frame.size.width, [UIScreen mainScreen].bounds.size.height - 126);
        }
        if (isPic == 1 && isVedio == 0 && isVoice == 0)
        {
            self.collectionView.frame = CGRectMake(20, self.eventResonTextView.frame.origin.y + 70 , self.mySv.contentSize.width - 40, 90);
            self.viewViedo.frame      = CGRectMake(20, self.collectionView.frame.origin.y + self.collectionView.frame.size.height + 20, self.mySv.contentSize.width - 40, 0);
            self.viewVoice.frame      = CGRectMake(20, self.viewViedo.frame.origin.y + self.viewViedo.frame.size.height + 20, self.mySv.contentSize.width - 40, 0);
            self.mySv.contentSize     = CGSizeMake(self.mySv.frame.size.width, [UIScreen mainScreen].bounds.size.height - 126);
        }
        if (isPic == 1 && isVedio == 0 && isVoice == 1)
        {
            self.collectionView.frame = CGRectMake(20, self.eventResonTextView.frame.origin.y + 70 , self.mySv.contentSize.width - 40, 90);
            self.viewViedo.frame      = CGRectMake(20, self.collectionView.frame.origin.y + self.collectionView.frame.size.height + 20, self.mySv.contentSize.width - 40, 0);
            self.viewVoice.frame      = CGRectMake(20, self.viewViedo.frame.origin.y + self.viewViedo.frame.size.height, self.mySv.contentSize.width - 40, 50);
            self.mySv.contentSize     = CGSizeMake(self.mySv.frame.size.width, [UIScreen mainScreen].bounds.size.height + 70 - 126);
        }
        if (isPic == 1 && isVedio == 1 && isVoice == 0)
        {
            self.collectionView.frame = CGRectMake(20, self.eventResonTextView.frame.origin.y + 70 , self.mySv.contentSize.width - 40, 90);
            self.viewViedo.frame      = CGRectMake(20, self.collectionView.frame.origin.y + self.collectionView.frame.size.height + 20, self.mySv.contentSize.width - 40, 90);
            self.viewVoice.frame      = CGRectMake(20, self.viewViedo.frame.origin.y + self.viewViedo.frame.size.height + 20, self.mySv.contentSize.width - 40, 0);
            self.mySv.contentSize     = CGSizeMake(self.mySv.frame.size.width, [UIScreen mainScreen].bounds.size.height + 100 - 126);
        }
        if (isPic == 1 && isVedio == 1 && isVoice == 1)
        {
            self.collectionView.frame = CGRectMake(20, self.eventResonTextView.frame.origin.y + 70 , self.mySv.contentSize.width - 40, 90);
            self.viewViedo.frame      = CGRectMake(20, self.collectionView.frame.origin.y + self.collectionView.frame.size.height + 20, self.mySv.contentSize.width - 40, 90);
            self.viewVoice.frame      = CGRectMake(20, self.viewViedo.frame.origin.y + self.viewViedo.frame.size.height + 20, self.mySv.contentSize.width - 40, 50);
            self.mySv.contentSize     = CGSizeMake(self.mySv.frame.size.width, [UIScreen mainScreen].bounds.size.height + 190 - 126);
        }
    }else{ // 如果是其他的型号
        
        if (isPic == 0 && isVedio == 0 && isVoice == 0)
        {
            self.collectionView.frame = CGRectMake(20, self.eventResonTextView.frame.origin.y + 70 , self.mySv.contentSize.width - 40, 0);
            self.viewViedo.frame      = CGRectMake(20, self.collectionView.frame.origin.y + self.collectionView.frame.size.height + 20, self.mySv.contentSize.width - 40, 0);
            self.viewVoice.frame      = CGRectMake(20, self.viewViedo.frame.origin.y + self.viewViedo.frame.size.height + 20, self.mySv.contentSize.width - 40, 0);
            self.mySv.contentSize     = CGSizeMake(self.mySv.frame.size.width, [UIScreen mainScreen].bounds.size.height - 126);
        }
        if (isPic == 0 && isVedio == 0 && isVoice == 1)
        {
            self.collectionView.frame = CGRectMake(20, self.eventResonTextView.frame.origin.y + 70 , self.mySv.contentSize.width - 40, 0);
            self.viewViedo.frame      = CGRectMake(20, self.collectionView.frame.origin.y + self.collectionView.frame.size.height, self.mySv.contentSize.width - 40, 0);
            self.viewVoice.frame      = CGRectMake(20, self.viewViedo.frame.origin.y + self.viewViedo.frame.size.height, self.mySv.contentSize.width - 40, 50);
            self.mySv.contentSize     = CGSizeMake(self.mySv.frame.size.width, [UIScreen mainScreen].bounds.size.height - 126);
        }
        if (isPic == 0 && isVedio == 1 && isVoice == 0)
        {
            self.collectionView.frame = CGRectMake(20, self.eventResonTextView.frame.origin.y + 70 , self.mySv.contentSize.width - 40, 0);
            self.viewViedo.frame      = CGRectMake(20, self.collectionView.frame.origin.y + self.collectionView.frame.size.height, self.mySv.contentSize.width - 40, 90);
            self.viewVoice.frame      = CGRectMake(20, self.viewViedo.frame.origin.y + self.viewViedo.frame.size.height + 20, self.mySv.contentSize.width - 40, 0);
            self.mySv.contentSize     = CGSizeMake(self.mySv.frame.size.width, [UIScreen mainScreen].bounds.size.height - 126);
        }
        if (isPic == 0 && isVedio == 1 && isVoice == 1)
        {
            self.collectionView.frame = CGRectMake(20, self.eventResonTextView.frame.origin.y + 70 , self.mySv.contentSize.width - 40, 0);
            self.viewViedo.frame      = CGRectMake(20, self.collectionView.frame.origin.y + self.collectionView.frame.size.height, self.mySv.contentSize.width - 40, 90);
            self.viewVoice.frame      = CGRectMake(20, self.viewViedo.frame.origin.y + self.viewViedo.frame.size.height + 20, self.mySv.contentSize.width - 40, 50);
            self.mySv.contentSize     = CGSizeMake(self.mySv.frame.size.width, [UIScreen mainScreen].bounds.size.height + 50 - 126);
        }
        if (isPic == 1 && isVedio == 0 && isVoice == 0)
        {
            self.collectionView.frame = CGRectMake(20, self.eventResonTextView.frame.origin.y + 70 , self.mySv.contentSize.width - 40, 90);
            self.viewViedo.frame      = CGRectMake(20, self.collectionView.frame.origin.y + self.collectionView.frame.size.height + 20, self.mySv.contentSize.width - 40, 0);
            self.viewVoice.frame      = CGRectMake(20, self.viewViedo.frame.origin.y + self.viewViedo.frame.size.height + 20, self.mySv.contentSize.width - 40, 0);
            self.mySv.contentSize     = CGSizeMake(self.mySv.frame.size.width, [UIScreen mainScreen].bounds.size.height - 126);
        }
        if (isPic == 1 && isVedio == 0 && isVoice == 1)
        {
            self.collectionView.frame = CGRectMake(20, self.eventResonTextView.frame.origin.y + 70 , self.mySv.contentSize.width - 40, 90);
            self.viewViedo.frame      = CGRectMake(20, self.collectionView.frame.origin.y + self.collectionView.frame.size.height + 20, self.mySv.contentSize.width - 40, 0);
            self.viewVoice.frame      = CGRectMake(20, self.viewViedo.frame.origin.y + self.viewViedo.frame.size.height, self.mySv.contentSize.width - 40, 50);
            self.mySv.contentSize     = CGSizeMake(self.mySv.frame.size.width, [UIScreen mainScreen].bounds.size.height + 50 - 126);
        }
        if (isPic == 1 && isVedio == 1 && isVoice == 0)
        {
            self.collectionView.frame = CGRectMake(20, self.eventResonTextView.frame.origin.y + 70 , self.mySv.contentSize.width - 40, 90);
            self.viewViedo.frame      = CGRectMake(20, self.collectionView.frame.origin.y + self.collectionView.frame.size.height + 20, self.mySv.contentSize.width - 40, 90);
            self.viewVoice.frame      = CGRectMake(20, self.viewViedo.frame.origin.y + self.viewViedo.frame.size.height + 20, self.mySv.contentSize.width - 40, 0);
            self.mySv.contentSize     = CGSizeMake(self.mySv.frame.size.width, [UIScreen mainScreen].bounds.size.height + 90 - 126);
        }
        if (isPic == 1 && isVedio == 1 && isVoice == 1)
        {
            self.collectionView.frame = CGRectMake(20, self.eventResonTextView.frame.origin.y + 70 , self.mySv.contentSize.width - 40, 90);
            self.viewViedo.frame      = CGRectMake(20, self.collectionView.frame.origin.y + self.collectionView.frame.size.height + 20, self.mySv.contentSize.width - 40, 90);
            self.viewVoice.frame      = CGRectMake(20, self.viewViedo.frame.origin.y + self.viewViedo.frame.size.height + 20, self.mySv.contentSize.width - 40, 50);
            self.mySv.contentSize     = CGSizeMake(self.mySv.frame.size.width, [UIScreen mainScreen].bounds.size.height + 140 - 126);
        }
    }
}

//新增异常报警方法
- (void)addErrorAlertAction {
    
    if (self.assetsArray.count>0)
    {
        for(JKAssets *jk in self.assetsArray)
        {
            //            NSString *str1 = [jk.assetPropertyURL absoluteString];
            ALAssetsLibrary   *lib = [[ALAssetsLibrary alloc] init];
            [lib assetForURL:jk.assetPropertyURL resultBlock:^(ALAsset *asset) {
                NSLog(@"图片地址@%@：",jk.assetPropertyURL);
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
                        NSLog(@"两个UIimage相同");
                    } else
                    {
                        NSLog(@"两个UIImage不一样");
                        [self.arrPicUrl addObject:imageIcon];
                    }
                }
            } failureBlock:^(NSError *error) {
                
            }];
        }
    }
    
    NSString *lat = _tf_latitude.text;
    NSString *lon = _tf_lontitude.text;
    NSString *locStr = _addrTextView.text;
    NSString *eventReson = _eventResonTextView.text;
    NSString *pointId = _tf_PointId.text;
    
    if (lat ==nil||[lat isEqualToString:@""]||lon == nil||[lon isEqualToString:@""]||eventReson == nil||[eventReson isEqualToString:@""]|| locStr == nil||[locStr isEqualToString:@""]) {
        [SVProgressHUD showInfoWithStatus:@"请填写完整信息"];
    }else {
        [SVProgressHUD showWithStatus:@"正在新增报警,请稍等..." maskType:SVProgressHUDMaskTypeClear];
        self.requestNum =  [self.arrVideoUrl count] + [self.arrVoiceUrl count] + [self.assetsArray count];
        //创建JSON
        NSDictionary *dictonary = [[NSMutableDictionary alloc] init];
        [dictonary setValue:pointId forKey:@"pointId"];
        [dictonary setValue:self.strType forKey:@"alarmType"];
        [dictonary setValue:self.strLevel forKey:@"alarmLevelId"];
        [dictonary setValue:[utils getUnitID] forKey:@"unitId"];
        [dictonary setValue:lon forKey:@"longitude"];
        [dictonary setValue:locStr forKey:@"location"];
        [dictonary setValue:lat forKey:@"latitude"];
        [dictonary setValue:eventReson forKey:@"alarmReason"];
        [dictonary setValue:[utils getlogName] forKey:@"userAccnt"];
        
        NSString *value;
        BOOL isValidJSONObject =  [NSJSONSerialization isValidJSONObject:dictonary];
        if (isValidJSONObject) {
            /*
             第一个参数:OC对象 也就是我们dict
             第二个参数:
             NSJSONWritingPrettyPrinted 排版
             kNilOptions 什么也不做
             */
            NSData *data =  [NSJSONSerialization dataWithJSONObject:dictonary options:kNilOptions error:nil];
            //打印JSON数据
            value = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"%@",value);
        }
        
        NSMutableArray *params=[NSMutableArray array];
        
        [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:value,@"input", nil]];
        YNRequestWithArgs *args=[[YNRequestWithArgs alloc] init];
        args.methodName=LBS_CreateAlarmOrder;//要调用的webservice方法
        args.soapParams=params;//传递方法参数
        args.httpWay=ServiceHttpSoap1;
        args.soapHeader = [NSString stringWithFormat:@"<username>%@</username><authenticode>%@</authenticode>",[utils getlogName],[SecurityUtil encryptMD5String:[utils getAuthenCode]]];
        NSLog(@"参数%@",params);
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager HTTPRequestOperationWithArgs:args success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"xml:%@",operation.responseString);
            //处理xml
            NSString *theXML = operation.responseString;
            NSArray *array1 = [NSArray arrayWithObjects:@"return>",@"</",nil];
            NSArray *ziFuArray = [NSArray arrayWithObjects:array1,nil];
            for (NSArray *array in ziFuArray) {
                NSRange range = [theXML rangeOfString:[array objectAtIndex:0]];
                if(range.length>0)
                {
                    theXML = [theXML substringFromIndex:range.location+7];
                    range = [theXML rangeOfString:[array objectAtIndex:1]];
                    if(range.length>0)
                    {
                        theXML = [theXML substringToIndex:range.location+(range.length-2)];
                    }
                    break;
                }
                NSLog(@"%@",theXML);
            }
            
            //解析json
            NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:[theXML dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
            
            NSString *codeStr = [diction objectForKey:@"rcode"];
            NSString *msgStr      = [diction objectForKey:@"rmessage"];
            if ([codeStr isEqualToString:@"0x0000"]) {
                NSArray *arrRows= [diction objectForKey:@"rows"];
                if (self.requestNum > 0)
                {
                    if (self.arrPicUrl.count > 0)
                    {
                        [self upLoadPic:[arrRows objectAtIndex:0]];
                    }
                    if (self.arrVideoUrl.count > 0)
                    {
                        for (NSString *filestr in self.arrVideoUrl)
                        {
                            [self upLoadMP4:[arrRows objectAtIndex:0] urlStr:filestr];
                        }
                    }
                    if (self.arrVoiceUrl.count > 0)
                    {
                        [self upLoadMP3:[arrRows objectAtIndex:0]];
                    }
                }else{
                    
                    [SVProgressHUD showSuccessWithStatus:@"上传成功！"];
                    [self performSelector:@selector(toPopVC) withObject:nil afterDelay:0.5f];
                }
            }else{
                if ([codeStr isEqualToString:@"0x0016"])
                {
                    [SVProgressHUD showErrorWithStatus:@"网络连接超时请返回到主页面重新进入该页面"];
                }else{
                    [SVProgressHUD showErrorWithStatus:msgStr];
                }
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error:%@", error);
        }];
    }
}


#pragma mark - ASIHttpRequest
/**
 *  图片上传成功
 */
- (void)responseComplete
{
    [SVProgressHUD showSuccessWithStatus:@"上传成功"];
    
    [self performSelector:@selector(toPopVC) withObject:nil afterDelay:1.f];
}

/**
 *  图片上传失败
 */
- (void)responseFailed
{
    [SVProgressHUD showErrorWithStatus:@"上传失败,请检查网络是否正常"];
}

-(void)toPopVC{
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"RefreshWellErrorList" object:nil userInfo:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
