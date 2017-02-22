//
//  AppDelegate.m
//  WRMS
//
//  Created by YangJingchao on 2016/8/15.
//  Copyright © 2016年 YangJingchao. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import <AdSupport/AdSupport.h>
#import "NTViewController.h"
#import "JPUSHService.h"
#import "MessageNotificationVC.h"

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@interface AppDelegate ()<BMKGeneralDelegate,CLLocationManagerDelegate, JPUSHRegisterDelegate>
@property (nonatomic,strong ) CLLocationManager       *locationmanager;
@end
BMKMapManager* _mapManager;
@implementation AppDelegate

#pragma mark 注册push服务.
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    //    NSLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    //    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", err);
}


#pragma mark - iOS7以下系统接收到推送消息
// 点击接收到的推送信息
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // 这里的监听通知只是在程序运行中（前台或后台），当程序退出后接收到通知进来后就不走这里了。
    [JPUSHService handleRemoteNotification:userInfo];
    
    self.isClickIcon = NO;
    MessageNotificationVC *messageVC = [[MessageNotificationVC alloc] init];
    // 添加一个状态，让其知道是从推送过来的
    messageVC.isJPush = YES;
    UINavigationController *na = [[UINavigationController alloc] initWithRootViewController:messageVC];
    [self.window.rootViewController presentViewController:na animated:YES completion:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"clickIconEnter" object:nil userInfo:nil];
}

#pragma mark - iOS7以上接收到推送消息
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
// 接收到推送的时候，在程序内部会弹出提示框, iOS7以上才会有
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    
    
    self.isClickIcon = NO;
    if (application.applicationState == UIApplicationStateActive)
    {
        // 程序当前正处于前台
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"新消息" message:userInfo[@"aps"][@"alert"] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sureAction=[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:sureAction];
        
        [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"acceptMessage" object:nil userInfo:nil];
    }
    else if (application.applicationState == UIApplicationStateInactive)
    {
        // 程序处于后台
        MessageNotificationVC *messageVC = [[MessageNotificationVC alloc] init];
        // 添加一个状态，让其知道是从推送过来的
        messageVC.isJPush = YES;
        UINavigationController *na = [[UINavigationController alloc] initWithRootViewController:messageVC];
        [self.window.rootViewController presentViewController:na animated:YES completion:nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"clickIconEnter" object:nil userInfo:nil];
    }
    
}
#endif


#pragma mark - 程序入口方法
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    //如不需要使用IDFA，advertisingIdentifier 可为nil
    [JPUSHService setupWithOption:launchOptions appKey:appKey
                          channel:channel
                 apsForProduction:isProduction
            advertisingIdentifier:advertisingId];
    //Required
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        JPUSHRegisterEntity *entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    }
    else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) { //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge|
             UIUserNotificationTypeSound|
             UIUserNotificationTypeAlert) categories:nil];
    }
    else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge|
             UIRemoteNotificationTypeSound|
             UIRemoteNotificationTypeAlert) categories:nil];
    }
    
    //Required
    // init Push(2.1.5版本的SDK新增的注册 法，改成可上报IDFA，如果没有使 IDFA直接传nil ) // 如需继续使 pushConfig.plist 件声明appKey等配置内容，请依旧使 [JPUSHService setupWithOption:launchOptions] 式初始化。
        [JPUSHService setupWithOption:launchOptions appKey:appKey
                                                    channel:channel
                                           apsForProduction:isProduction
                                      advertisingIdentifier:nil];
    //2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            NSLog(@"registrationID获取成功：%@",registrationID);
            [utils setJpushId:registrationID];
        }
        else{
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
    
    
    //开始定位
    CLLocationManager *locationManager;//定义Manager
    [locationManager startUpdatingLocation];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        [UIApplication sharedApplication].idleTimerDisabled = TRUE;
        self.locationmanager                 = [[CLLocationManager alloc] init];
        self.locationmanager.desiredAccuracy = kCLLocationAccuracyBest;
        [self.locationmanager requestWhenInUseAuthorization];     //NSLocationWhenInUseDescription
    }else{
        self.locationmanager                 = [[CLLocationManager alloc] init];
        self.locationmanager.desiredAccuracy = kCLLocationAccuracyBest;
        [self.locationmanager startUpdatingLocation];
    }
    
    // 要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];
    BOOL ret    = [_mapManager start:BaiduMapKey generalDelegate:self];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    NTViewController *ntvc =[[NTViewController alloc]init];
    self.window.rootViewController = ntvc;
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
    // 改变导航栏颜色和标题文字颜色
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithHexString:@"00c0f1"]];
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    // 设定程序刚进来第一次验证登录
    self.loginTimes = 0;
    // 设定程序刚进来是点击桌面图标进入
    self.isClickIcon = YES;
    // 监听网络连接状态
    [GLobalRealReachability startNotifier];
    
    // 当程序退出后，收到通知，通过下面的代码可以监听
    if (launchOptions) {
        
        NSDictionary * remoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        //这个判断是在程序没有运行的情况下收到通知，点击通知跳转页面
        if (remoteNotification) {
            
            NSLog(@"推送消息==== %@",remoteNotification);
            self.isClickIcon = NO;
            MessageNotificationVC *messageVC = [[MessageNotificationVC alloc] init];
            // 添加一个状态，让其知道是从推送过来的
            messageVC.isJPush = YES;
            UINavigationController *na = [[UINavigationController alloc] initWithRootViewController:messageVC];
            [self.window.rootViewController presentViewController:na animated:YES completion:nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"clickIconEnter" object:nil userInfo:nil];
        }
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [JPUSHService setBadge:0];
    // 程序进入后台，将此bool值设为yes
    self.isClickIcon = YES;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
    [JPUSHService setBadge:0];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    // 如果程序是通过点击桌面图标进入，则发送通知到首页
    if (self.isClickIcon == YES) {
        
        // 发送推送刷新信息图标和数据
        [[NSNotificationCenter defaultCenter] postNotificationName:@"clickIconEnter" object:nil userInfo:nil];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#pragma mark - JPush Delegate，iOS10以上的接收推送处理方法
// ios 10 support 处于前台时接收到通知
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    
    NSDictionary * userInfo = notification.request.content.userInfo;
    if ([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        
        // 添加各种需求。。。。。
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"新消息" message:userInfo[@"aps"][@"alert"] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sureAction=[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:sureAction];
        [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
        
        // 发送刷新消息图标的通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"acceptMessage" object:nil userInfo:nil];
    }
//    completionHandler(UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);;
    // 处于前台时，添加需求，一般是弹出alert跟用户进行交互，这时候completionHandler(UNNotificationPresentationOptionAlert)这句话就可以注释掉了，这句话是系统的alert，显示在app的顶部
}

// iOS 10 Support  点击处理事件
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        //推送打开
        if (userInfo)
        {
            // 取得 APNs 标准信息内容
            //            NSDictionary *aps = [userInfo valueForKey:@"aps"];
            //            NSString *content = [aps valueForKey:@"alert"]; //推送显示的内容
            //            NSInteger badge = [[aps valueForKey:@"badge"] integerValue]; //badge数量
            //            NSString *sound = [aps valueForKey:@"sound"]; //播放的声音
            
            // 添加各种需求。。。。。
            self.isClickIcon = NO;
            MessageNotificationVC *messageVC = [[MessageNotificationVC alloc] init];
            // 添加一个状态，让其知道是从推送过来的
            messageVC.isJPush = YES;
            UINavigationController *na = [[UINavigationController alloc] initWithRootViewController:messageVC];
            [self.window.rootViewController presentViewController:na animated:YES completion:nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"clickIconEnter" object:nil userInfo:nil];
        }
        completionHandler();  // 系统要求执行这个方法
    }
}
#endif

@end
