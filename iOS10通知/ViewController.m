//
//  ViewController.m
//  iOS10本地通知
//
//  Created by hubery on 2017/10/24.
//  Copyright © 2017年 hubery. All rights reserved.
//

#import "ViewController.h"
#import <UserNotifications/UserNotifications.h>

@interface ViewController ()<UNUserNotificationCenterDelegate>
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)pushNotifacation:(UIButton *)sender {
    UNMutableNotificationContent *notiContent = [[UNMutableNotificationContent alloc]init];
    [self registerLocalNotifacation:notiContent withIdentifer:@"localIdentifer"];
}

- (IBAction)pushImageNotifacation:(UIButton *)sender {
    NSString *imageFile = [[NSBundle mainBundle]pathForResource:@"sport" ofType:@"jpg"];
    UNNotificationAttachment *image = [UNNotificationAttachment attachmentWithIdentifier:@"image" URL:[NSURL fileURLWithPath:imageFile] options:nil error:nil];
    UNMutableNotificationContent *notiContent = [[UNMutableNotificationContent alloc]init];
    notiContent.attachments = @[image];
    [self registerLocalNotifacation:notiContent withIdentifer:@"localIdentiferImage"];
}

- (IBAction)pushInteractionNotifacation:(UIButton *)sender {
    UNMutableNotificationContent *notiContent = [[UNMutableNotificationContent alloc]init];
    notiContent.categoryIdentifier = @"localCategory";
    [self registerLocalNotifacation:notiContent withIdentifer:@"IlocalIdentiferAction"];
}

- (void)registerLocalNotifacation:(UNMutableNotificationContent *)content withIdentifer:(NSString *)str {
    content.title = @"iOS10本地通知";
    content.subtitle = @"扶我起来";
    content.body = @"我要写代码";
    content.badge = @1;
    content.userInfo = @{@"content" : @"我是userInfo"};
    UNNotificationSound *sound = [UNNotificationSound soundNamed:@"caodi.m4a"];
    content.sound = sound;
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:2.0 repeats:NO];
    NSString *identifer = str;
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifer content:content trigger:trigger];
    [[UNUserNotificationCenter currentNotificationCenter]addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (!error) {
            NSLog(@"发送成功");
        }
    }];
}
@end
