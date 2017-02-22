//
//  AddInspectionVC.m
//  LeftSlide
//
//  Created by YangJingchao on 2016/7/19.
//  Copyright © 2016年 eamon. All rights reserved.
//

#import "AddInspectionVC.h"
#import "SVProgressHUD.h"
#import "ThreeModel.h"
#import "PointTypeModel.h"


static NSString *kPhotoCellIdentifier = @"kPhotoCellIdentifier";
@interface AddInspectionVC () <BMKGeoCodeSearchDelegate,UITextViewDelegate,UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegate, JKImagePickerControllerDelegate,JKPhotoBrowserDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    BMKGeoCodeSearch *_geoCodeSearch;
}
@property (weak, nonatomic  ) IBOutlet UIScrollView *mySv;
@property (strong, nonatomic) IBOutlet UITextField  *tf_latitude;
@property (strong, nonatomic) IBOutlet UITextField  *tf_lontitude;
@property (strong, nonatomic) IBOutlet UITextView   *tv_remark;
@property (strong, nonatomic) IBOutlet UITextField  *tf_name;
@property (strong, nonatomic) IBOutlet UITextView   *tv_address;
@property (strong, nonatomic) IBOutlet UIButton     *btn_Commit;
@property (weak, nonatomic  ) IBOutlet UITextField  *tf_Unit;
@property (weak, nonatomic  ) IBOutlet UIButton     *btn_Unit;
@property (weak, nonatomic  ) IBOutlet UITextField  *tf_MchnId;
@property (weak, nonatomic  ) IBOutlet UITextField  *tf_mchnImei;
@property (weak, nonatomic  ) IBOutlet UITextField  *tf_Type;

/** 开启一个定时器用于刷新经纬度*/
@property (nonatomic, strong) NSTimer  *myTimer;
/** 定义一个Bool值判断是否是第一次获取经纬度*/
@property (nonatomic, assign) BOOL     isFirstLat;
@property (strong, nonatomic) NSString *strLatitude;
@property (strong, nonatomic) NSString *strLontitude;
@property (strong, nonatomic) NSString *strRemark;
@property (strong, nonatomic) NSString *strName;
@property (strong, nonatomic) NSString *strAddress;
@property (nonatomic,strong ) YNNavigationRightBtn *rightBtn;

@property (nonatomic,strong) NSMutableArray *arrType;
@property (nonatomic,strong) NSMutableArray *arrModel;
@property (nonatomic,strong) NSMutableArray *arrUnit;
@property (nonatomic,strong) NSMutableArray *arrID_Type;
@property (nonatomic,strong) NSMutableArray *arrText_Type;
@property (nonatomic,strong) NSMutableArray *arrID_Mode;
@property (nonatomic,strong) NSMutableArray *arrText_Mode;
@property (nonatomic,strong) NSMutableArray *arrID_Unit;
@property (nonatomic,strong) NSMutableArray *arrText_Unit;

@property (nonatomic,strong) NSString *strType;
@property (nonatomic,strong) NSString *strTypeName;
@property (nonatomic,strong) NSString *strModel;
@property (nonatomic,strong) NSString *strModelName;
@property (nonatomic,strong) NSString *strUnit;
@property (nonatomic,strong) NSString *strUnitName;

/** 发送照片的请求*/
@property (nonatomic, strong) ASIFormDataRequest      *request;
/** 图片选择器*/
@property (strong,nonatomic ) UIImagePickerController *imagePicker;

@property (nonatomic,strong) IBOutlet UILabel *labelPhoto;
@property (nonatomic,strong) IBOutlet UIButton *btnPhoto;

/** 照片取出后展示的collectionView*/
@property (nonatomic, retain) UICollectionView *collectionView;
/** 存放照片的数组*/
@property (nonatomic, strong) NSMutableArray *arrPicUrl;
/** 相册取照片后的数组*/
@property (nonatomic, strong) NSMutableArray *assetsArray;

@end

@implementation AddInspectionVC
#pragma mark - LifeCycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
        backItem.title = @"";
        self.navigationItem.backBarButtonItem = backItem;
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    _geoCodeSearch.delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.arrType      = [[NSMutableArray alloc]init];
    self.arrModel     = [[NSMutableArray alloc]init];
    self.arrUnit      = [[NSMutableArray alloc]init];
    self.arrID_Type   = [[NSMutableArray alloc]init];
    self.arrText_Type = [[NSMutableArray alloc]init];
    self.arrID_Mode   = [[NSMutableArray alloc]init];
    self.arrText_Mode = [[NSMutableArray alloc]init];
    self.arrID_Unit   = [[NSMutableArray alloc]init];
    self.arrText_Unit = [[NSMutableArray alloc]init];
    
    // 当没有添加照片的时候的contentsize
    self.mySv.contentSize = CGSizeMake(kWidth, self.tv_remark.frame.origin.y + 130);
    
    self.collectionView.frame = CGRectMake(20, self.tv_remark.frame.origin.y + 70 , self.mySv.contentSize.width - 40, 0);
    
    // 初始化照片数组
    self.arrPicUrl = [[NSMutableArray alloc] init];//存放照片
    
    //addBtn
    _rightBtn = [[YNNavigationRightBtn alloc]initWith:nil img:@"commit" contro:self];
    __weak typeof(self) weakSelf = self;
    _rightBtn.clickBlock = ^(){
        [weakSelf addInspecAction];
    };
    
    // 初始化地理编码类
    _geoCodeSearch = [[BMKGeoCodeSearch alloc] init];
    
    if([self.fromType isEqualToString:@"update"]) {
        
        [self getFromInfoVC];
        self.title = @"修改监测点";
        // 如果是修改检测点，则需要先下载图片，然后将图片数组赋值给assetsArray
    }else{
        [self getLat];
        self.title = @"采集监测点";
    }
    self.tf_MchnId.delegate = self;
    self.tf_MchnId.tag = 10001;
    
    self.tv_remark.delegate = self;
    self.tv_remark.tag = 300;
    
    self.tv_address.delegate = self;
    self.tv_address.tag = 400;
    
    self.tf_name.delegate = self;
    self.tf_name.tag = 500;
    if([self.fromType isEqualToString:@"update"]) {
        self.tf_Unit.text = self.pointModel.unitName;
        self.tf_Type.text = self.pointModel.pointTypeName;
        self.strUnit = self.pointModel.unitId;
        self.strType = self.pointModel.pointTypeId;
        self.tf_MchnId.text = self.pointModel.waterMchnId;
        self.tf_mchnImei.text = self.pointModel.codeImei;
        self.tv_remark.text = self.pointModel.remark;
    }else{
        [InspectionApi apiGetTypeDataWithArrType:self.arrType];
        [InspectionApi apiGetUnitWithArrUnit:self.arrUnit ArrID:self.arrID_Unit arrText:self.arrText_Unit isShowList:^{
            self.tf_Unit.text = [utils getUnitName];
            self.strUnit = [utils getUnitID];
        }];
    }
    
    // 拍照控件
    [self.labelPhoto setFrame:CGRectMake(kWidth/2 - self.labelPhoto.frame.size.width/2, self.labelPhoto.frame.origin.y, self.labelPhoto.frame.size.width, self.labelPhoto.frame.size.height)];
    [self.btnPhoto setFrame:CGRectMake(kWidth/2 - self.btnPhoto.frame.size.width/2, self.btnPhoto.frame.origin.y,self.btnPhoto.frame.size.width, self.btnPhoto.frame.size.height)];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    _geoCodeSearch.delegate = nil;
    [self.myTimer invalidate];
}

#pragma mark - JKImagePickerControllerDelegate
- (void)imagePickerController:(JKImagePickerController *)imagePicker didSelectAssets:(NSArray *)assets isSource:(BOOL)source {
    
    self.assetsArray = [NSMutableArray arrayWithArray:assets];
    
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        [self.collectionView reloadData];
    }];
}

- (void)imagePickerControllerDidCancel:(JKImagePickerController *)imagePicker {
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - UIImagePickerController Delegate
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
        
        cell.labelContent.text = @"";
        [cell.labelContent setHidden:YES];
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
    self.tv_address.text = [NSString stringWithFormat:@"%@%@%@%@%@", addressDetail.province, addressDetail.city, addressDetail.district, addressDetail.streetName, addressDetail.streetNumber];
}

#pragma mark - TextView Delegate
/**
 *  限制textView的字数输入在30字以内
 *
 *  @param textView textView
 */
-(void)textViewDidChange:(UITextView *)textView {
    NSInteger number = [textView.text length];
    if (number > 30) {
        [SVProgressHUD showInfoWithStatus:@"最多输入30个字"];
        textView.text    = [textView.text substringToIndex:30];
        number           = 30;
    }
}

#pragma mark - textField Delegate
/**
 *  限定textView最多可输入50字
 *
 *  @param textView UITextView
 */
- (void)textViewDidEndEditing:(UITextView *)textView {
    NSInteger number = [textView.text length];
    if (textView.tag == 300)
    {
        if (number > 30) {
            [SVProgressHUD showInfoWithStatus:@"备注最多可输入30个汉字"];
            self.tv_remark.text   = [textView.text substringToIndex:30];
            number           = 30;
        }
    }
    if (textView.tag == 400){
        if (number > 30) {
            [SVProgressHUD showInfoWithStatus:@"地址最多可输入30个汉字"];
            self.tv_address.text   = [textView.text substringToIndex:30];
            number           = 30;
        }
    }
}

/**
 *  限定textField最多可数如7个字和电话号码最多可输入11字
 *
 *  @param textField UITextField
 */
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.tag == 30001) {
        NSInteger number = [textField.text length];
        if (number != 11) {
            [SVProgressHUD showInfoWithStatus:@"dianhuahaoma"];
            if (number > 11)
            {
                textField.text   = [textField.text substringToIndex:11];
                number           = 11;
            }
        }
    }
    
    if (textField.tag == 500)
    {
        NSInteger number = [textField.text length];
        if (number > 7)
        {
            [SVProgressHUD showInfoWithStatus:@"名称最多输入7位"];
            textField.text = [textField.text substringToIndex:7];
        }
    }
    
    if (textField.tag == 10001)
    {
        [InspectionApi apiGetWellImeiWithTfID:self.tf_MchnId.text success:^(NSDictionary *myDic) {
            self.tf_mchnImei.text = [myDic objectForKey:@"codeImei"];
        } fail:^{
            self.tf_MchnId.text = nil;
            self.tf_mchnImei.text = nil;
        }];
    }
}

#pragma mark - Event Response
//选择单位
- (IBAction)choseUnit:(id)sender {
    
    for (ThreeModel *tmodel in self.arrUnit)
    {
        if (![self.arrID_Unit containsObject:tmodel.strid])
        {
            [self.arrID_Unit addObject:tmodel.strid];
        }
        if (![self.arrText_Unit containsObject:tmodel.strtext])
        {
            [self.arrText_Unit addObject:tmodel.strtext];
        }
        
    }
    
    //    NSLog(@"==%@",self.arrID_Unit);
    //如果当前负责单位在查询的单位列表里，则不显示列表，反则显示
    if ( [self.arrID_Unit containsObject:[utils getUnitID]])
    {
        self.tf_Unit.text = [utils getUnitName];
        self.strUnit     = [utils getUnitID];
    }else
    {
        KTActionSheet *actionSheet2 = [[KTActionSheet alloc] initWithTitle:@"负责单位" itemTitles:self.arrText_Unit];
        actionSheet2.delegate        = self;
        actionSheet2.tag             = 11;
        __weak typeof(self) weakSelf = self;
        [actionSheet2 didFinishSelectIndex:^(NSInteger index, NSString *title) {
            
            //            NSLog(@"block----%ld----%@", (long)index, title);
            weakSelf.tf_Unit.text = [NSString stringWithFormat:@"%@",title];
            self.strUnit         = [self.arrID_Unit objectAtIndex:index];
            self.strUnitName = [self.arrText_Unit objectAtIndex:index];
            [utils setCoverUnit:self.strUnitName cunit:self.strUnit];
        }];
    }
}

//获取类型
- (IBAction)choseType:(id)sender {
    
    for (PointTypeModel *tmodel in self.arrType)
    {
        if(![self.arrID_Type containsObject:tmodel.pointTypeId]){
            
            [self.arrID_Type addObject:tmodel.pointTypeId];
        }
        if (![self.arrText_Type containsObject:tmodel.pointTypeName])
        {
            [self.arrText_Type addObject:tmodel.pointTypeName];
        }
    }
    
    KTActionSheet *actionSheet   = [[KTActionSheet alloc] initWithTitle:@"监测点类型列表" itemTitles:self.arrText_Type];
    actionSheet.delegate         = self;
    actionSheet.tag              = 13;
    __weak typeof(self) weakSelf = self;
    [actionSheet didFinishSelectIndex:^(NSInteger index, NSString *title) {
        //        NSLog(@"block----%ld----%@", (long)index, title);
        weakSelf.tf_Type.text = [NSString stringWithFormat:@"%@", title];
        self.strType         = [self.arrID_Type objectAtIndex:index];
        self.strTypeName     = [self.arrText_Type objectAtIndex:index];
        [utils setCoverType:self.strTypeName ctypID:self.strType];
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

/**
 *  点击右上角添加检测点按钮
 */
- (void)addInspecAction {
    
    if (self.assetsArray.count>0)
    {
        for(JKAssets *jk in self.assetsArray)
        {
            //            NSString *str1 = [jk.assetPropertyURL absoluteString];
            ALAssetsLibrary   *lib = [[ALAssetsLibrary alloc] init];
            [lib assetForURL:jk.assetPropertyURL resultBlock:^(ALAsset *asset) {
                
                NSLog(@"图片地址@%@：",jk.assetPropertyURL);
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
            } failureBlock:^(NSError *error) {
                
            }];
        }
    }
    
    if ([self getAllLabelContent]) {
        
        NSMutableDictionary *mydic = [[NSMutableDictionary alloc]init];
        [mydic setValue:self.strName forKey:@"pointName"];
        [mydic setValue:self.strType forKey:@"pointTypeId"];
        [mydic setValue:self.strRemark forKey:@"remark"];
        [mydic setValue:self.strLontitude forKey:@"longitude"];
        [mydic setValue:self.strLatitude forKey:@"latitude"];
        [mydic setValue:@"0" forKey:@"altitude"];
        [mydic setValue:self.strAddress forKey:@"location"];
        [mydic setValue:[utils getlogName] forKey:@"userAccnt"];
        [mydic setValue:[utils getUnitID] forKey:@"unitId"];
        [mydic setValue:self.tf_MchnId.text forKey:@"waterMchnId"];
        [mydic setValue:self.tf_mchnImei.text forKey:@"codeImei"];
        
        NSLog(@"%@",mydic);
        if ([self.fromType isEqualToString:@"update"]) {
            [mydic setValue:self.pointModel.pointId forKey:@"pointId"];
            [mydic setValue:[utils getlogName] forKey:@"updateUserAccnt"];
        }
        
        if ([self.fromType isEqualToString:@"update"]) { // 修改监测点
            [SVProgressHUD showWithStatus:@"正在修改监测点,请稍等..." maskType:SVProgressHUDMaskTypeClear];
            [InspectionApi apiUpdateInspec:mydic
                                    arrPic:self.arrPicUrl
                                 uploadPic:^(NSString *str) {
                                     
                                     [self upLoadPic:str];
                                 } viewController:self];
        }else{ // 新增监测点
            [SVProgressHUD showWithStatus:@"正在添加监测点,请稍等..." maskType:SVProgressHUDMaskTypeClear];
            [InspectionApi apiAddInspec:mydic
                                 arrPic:self.arrPicUrl
                              uploadPic:^(NSString *str){
                                
                                 [self upLoadPic:str];
                              } viewController:self];
        }
    }else{
        [SVProgressHUD showInfoWithStatus:@"请填写完整信息"];
    }
}

#pragma mark - Private Method
/**
 *  每隔一段时间取经纬度
 *
 *  @param time NSTimer
 */
- (void)timeFired:(NSTimer *)time {
    
    [self getLat];
}

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
                     
                     //                     NSLog(@"===========%@",self.strLontitude);
                     // 在水位采集中，使用百度地图通过经纬度获取到地址
                     CLLocationCoordinate2D coor2 = CLLocationCoordinate2DMake([self.strLatitude floatValue],[self.strLontitude floatValue]);
                     
                     //转换 google地图、soso地图、aliyun地图、mapabc地图和amap地图所用坐标至百度坐标
                     NSDictionary* testdic2 = BMKConvertBaiduCoorFrom(coor2,BMK_COORDTYPE_COMMON);
                     //转换GPS坐标至百度坐标(加密后的坐标)
                     testdic2 = BMKConvertBaiduCoorFrom(coor2,BMK_COORDTYPE_GPS);
                     //解密加密后的坐标字典
                     coor2 = BMKCoorDictionaryDecode(testdic2);//转换后的百度坐标
                     //                         NSLog(@"END 转换之后：%f,%f",coor2.latitude,coor2.longitude);
                     //初始化逆地理编码类
                     BMKReverseGeoCodeOption *reverseGeoCodeOption= [[BMKReverseGeoCodeOption alloc] init];
                     
                     //需要逆地理编码的坐标位置
                     reverseGeoCodeOption.reverseGeoPoint = coor2;
                     [_geoCodeSearch reverseGeoCode:reverseGeoCodeOption];
                 }];
}

//从详情页面获取信息
- (void)getFromInfoVC {
    //    self.tv_remark.text = self.pointModel.descrip;
    self.tf_name.text = self.pointModel.pointName;
    self.tf_latitude.text = self.pointModel.latitude;
    self.tf_lontitude.text = self.pointModel.longitude;
    self.tv_address.text = self.pointModel.location;
    
}

//获取控件内容
- (BOOL)getAllLabelContent {
    
    self.strRemark = self.tv_remark.text;
    self.strName = self.tf_name.text;
    self.strLatitude = self.tf_latitude.text;
    self.strLontitude = self.tf_lontitude.text;
    self.strAddress = self.tv_address.text;
    NSLog(@"%@\n%@\n%@\n%@\n%@",self.strRemark,self.strName,self.strLatitude,self.strLontitude,self.strAddress);
    if (self.strName == nil || [self.strName isEqualToString:@""] || self.strLatitude == nil || [self.strLatitude isEqualToString:@""] || self.strLontitude == nil || [self.strLontitude isEqualToString:@""] || self.strAddress == nil || [self.strAddress isEqualToString:@""] || self.strRemark == nil || [self.strRemark isEqualToString:@""] ) {
        return NO;
    }else{
        return YES;
    }
}

/**
 *  刷新sv的高度
 */
-(void)refreshSVContentsize {
    
    NSInteger isPic = 0;
    if ([self.assetsArray count] >0) {
        isPic = 1;
    }
    [self setLayoutOfScrollViewWithIsPic:isPic];
}

/**
 *  根据是否有照片选定布局contentsize
 *
 *  @param isPic 是否有照片
 */
- (void)setLayoutOfScrollViewWithIsPic:(NSInteger)isPic {
    
    if (isPic == 1) {
        
        self.collectionView.frame = CGRectMake(20, self.tv_remark.frame.origin.y + 70 , self.mySv.contentSize.width - 40, 90);
        self.mySv.contentSize = CGSizeMake(kWidth, self.tv_remark.frame.origin.y + 220);
        // 让视图滚动到底部，显示照片
        CGRect frame = self.mySv.frame;
        frame.origin.y = frame.origin.y + self.tv_remark.frame.origin.y + 220 - kHeight;
        [self.mySv scrollRectToVisible:frame animated:NO];
    }else{
        
        self.collectionView.frame = CGRectMake(20, self.tv_remark.frame.origin.y + 70 , self.mySv.contentSize.width - 40, 0);
        self.mySv.contentSize = CGSizeMake(kWidth, self.tv_remark.frame.origin.y + 130);
    }
}

/**
 *  上传照片
 *
 *  @param strHid 服务器获取的字段值
 */
- (void)upLoadPic:(NSString *)strHid{
    
    NSURL *url = [NSURL URLWithString:UploadPicWithInspection];
    _request = [ASIFormDataRequest requestWithURL:url];
    [_request setPostValue:strHid forKey:@"pointId"];
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

#pragma mark - ASIHttpRequest
/**
 *  图片上传成功
 */
- (void)responseComplete
{
    
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
    if ([self.fromType isEqualToString:@"update"]) {
        
        [SVProgressHUD showSuccessWithStatus:@"修改成功"];
        NSInteger index = [[self.navigationController viewControllers]indexOfObject:self];
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index - 2] animated:YES];
    }else{
        
        [SVProgressHUD showSuccessWithStatus:@"新增成功"];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - getter
/**
 *  imagePicker的getter方法
 *
 *  @return imagePicker
 */
-(UIImagePickerController *)imagePicker{
    
    _imagePicker=[[UIImagePickerController alloc]init];
    _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;//设置image picker的来源，这里设置为相册
    
    _imagePicker.mediaTypes =  [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
    
    _imagePicker.allowsEditing=YES;//允许编辑
    _imagePicker.delegate = self;//设置代理，检测操作
    
    return _imagePicker;
}

/**
 *  collectionView的getter方法
 *
 *  @return collectionView
 */
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
