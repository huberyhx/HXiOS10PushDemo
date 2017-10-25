//
//  NotificationViewController.m
//  NotiContentExtension
//
//  Created by hubery on 2017/10/25.
//  Copyright © 2017年 hubery. All rights reserved.
//

#import "NotificationViewController.h"
#import <UserNotifications/UserNotifications.h>
#import <UserNotificationsUI/UserNotificationsUI.h>

@interface NotificationViewController () <UNNotificationContentExtension>

@property IBOutlet UILabel *label;

@end

@implementation NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any required interface initialization here.
}

- (void)didReceiveNotification:(UNNotification *)notification {
    NSLog(@"didReceiveNotification");
    //一些列自定义展示试图
    self.label.text = notification.request.content.body;
}

@end
