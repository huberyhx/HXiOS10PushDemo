//
//  AppDelegate.m
//  iOS10通知
//
//  Created by hubery on 2017/10/24.
//  Copyright © 2017年 hubery. All rights reserved.
//

#import "AppDelegate.h"
#import <UserNotifications/UserNotifications.h>
//eaebe99a 97e8aeca 3fe6a7fb 069cbf4f be4d70bb 363cd8e3 52551bd6 2d1d690d
@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center setNotificationCategories:[self createNotificationCategoryActions]];
    // 必须写代理，不然无法监听通知的接收与点击
    center.delegate = self;
    //判断当前注册状态
    [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        if (settings.authorizationStatus==UNAuthorizationStatusNotDetermined) {
            [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound) completionHandler:^(BOOL granted, NSError * _Nullable error) {
                if (granted) {
                    [[UIApplication sharedApplication] registerForRemoteNotifications];
                }
            }];
        }
    }];
    return YES;
}

-(NSSet *)createNotificationCategoryActions{
    //注册远程通知用到的Action
    //进入app按钮
    UNNotificationAction * remoteAction = [UNNotificationAction actionWithIdentifier:@"remoteAction" title:@"处理远程通知" options:UNNotificationActionOptionForeground];
    //回复文本按钮
    UNTextInputNotificationAction * remoteText = [UNTextInputNotificationAction actionWithIdentifier:@"remoteText" title:@"远程文本" options:UNNotificationActionOptionNone];
    //取消按钮
    UNNotificationAction *remoteCancel = [UNNotificationAction actionWithIdentifier:@"remoteCancel" title:@"取消" options:UNNotificationActionOptionDestructive];
    //将这些action带入category
    UNNotificationCategory *remoteCategory = [UNNotificationCategory categoryWithIdentifier:@"remoteCategory" actions:@[remoteAction,remoteText,remoteCancel] intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
    
    //注册本地通知用到的Action
    //进入app按钮
    UNNotificationAction * localAction = [UNNotificationAction actionWithIdentifier:@"localAction" title:@"处理本地通知" options:UNNotificationActionOptionForeground];
    ///回复文本按钮
    UNTextInputNotificationAction * localText = [UNTextInputNotificationAction actionWithIdentifier:@"localText" title:@"本地文本" options:UNNotificationActionOptionNone];
    //取消按钮
    UNNotificationAction *localCancel = [UNNotificationAction actionWithIdentifier:@"localCancel" title:@"取消" options:UNNotificationActionOptionDestructive];
    //将这些action带入category
    UNNotificationCategory *localCategory = [UNNotificationCategory categoryWithIdentifier:@"localCategory" actions:@[localAction,localText,localCancel] intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
    
    return [NSSet setWithObjects:remoteCategory,localCategory,nil];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"%@",deviceToken);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"注册远程失败");
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    NSLog(@"收到了通知");
    completionHandler(UIBackgroundFetchResultNewData);
}

//用户与通知进行交互后的response，比如说用户直接点开通知打开App、用户点击通知的按钮或者进行输入文本框的文本
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler{
    NSLog(@"执行didReceiveNotificationResponse");
    UNNotificationRequest *request = response.notification.request; // 原始请求
    NSDictionary * userInfo = request.content.userInfo;//userInfo数据
    UNNotificationContent *content = request.content; // 原始内容
    NSString *title = content.title;  // 标题
    NSString *subtitle = content.subtitle;  // 副标题
    NSNumber *badge = content.badge;  // 角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;
    NSLog(@"----------------------------------------华丽丽的分割线----------------------------------------");
    NSLog(@"%@",content);
    NSLog(@"----------------------------------------华丽丽的分割线----------------------------------------");
    //在此，可判断response的种类和request的触发器是什么，可根据远程通知和本地通知分别处理，再根据action进行后续回调
    if ([request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {//远程通知
        //可根据actionIdentifier来做业务逻辑
        if ([response isKindOfClass:[UNTextInputNotificationResponse class]]) {
            UNTextInputNotificationResponse * textResponse = (UNTextInputNotificationResponse*)response;
            NSString * text = textResponse.userText;
            NSLog(@"回复内容 : %@",text);
        }else{
            if ([response.actionIdentifier isEqualToString:@"remoteAction"]) {
                NSLog(@"点击了处理远程通知按钮");
            }
        }
    }else {//本地通知
        //可根据actionIdentifier来做业务逻辑
        if ([response isKindOfClass:[UNTextInputNotificationResponse class]]) {
            UNTextInputNotificationResponse * textResponse = (UNTextInputNotificationResponse*)response;
            NSString * text = textResponse.userText;
            NSLog(@"回复内容 : %@",text);
        }else{
            if ([response.actionIdentifier isEqualToString:@"localAction"]) {
                NSLog(@"点击了处理本地通知按钮");
            }
        }
    }
    completionHandler();
}

//app在前台的时候,收到了通知
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    NSLog(@"执行willPresentNotificaiton");
    
    UNNotificationRequest *request = notification.request; // 原始请求
    NSDictionary * userInfo = notification.request.content.userInfo;//userInfo数据
    UNNotificationContent *content = request.content; // 原始内容
    NSString *title = content.title;  // 标题
    NSString *subtitle = content.subtitle;  // 副标题
    NSNumber *badge = content.badge;  // 角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 指定的声音
    NSLog(@"----------------------------------------华丽丽的分割线----------------------------------------");
    NSLog(@"%@",content);
    NSLog(@"----------------------------------------华丽丽的分割线----------------------------------------");
    /** 根据触发器类型 来判断通知类型 */
    if ([request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //远程通知处理
        NSLog(@"收到远程通知");
    }else if ([request.trigger isKindOfClass:[UNTimeIntervalNotificationTrigger class]]) {
        //时间间隔触发器通知处理
        NSLog(@"收到本地通知");
    }else if ([request.trigger isKindOfClass:[UNCalendarNotificationTrigger class]]) {
        //日历触发器通知处理
        NSLog(@"收到本地通知");
    }else if ([request.trigger isKindOfClass:[UNLocationNotificationTrigger class]]) {
        //位置触发器通知处理
        NSLog(@"收到本地通知");
    }
    /** 如果不想按照系统的方式展示通知,可以不传入UNNotificationPresentationOptionAlert,自定义弹窗 */
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert);
}
@end
