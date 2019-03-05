//
//  NIControllerTool.m
//  MifiApp
//
//  Created by yueguangkai on 15/11/3.
//  Copyright (c) 2015年 yueguangkai. All rights reserved.
//

#import "NIControllerTool.h"
#import "MainViewController.h"
#import "LoginViewController.h"

@implementation NIControllerTool

/**
 *  choose rootview controller
 */
+ (void)chooseRootViewController
{
    NSString *versionKey = (__bridge NSString *)kCFBundleVersionKey;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *lastVersion = [defaults objectForKey:versionKey];
    
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[versionKey];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if ([currentVersion isEqualToString:lastVersion]) {
        [UIApplication sharedApplication].statusBarHidden = NO;
//        window.rootViewController = [[NITabBarViewController alloc] init];
        window.rootViewController = [[LoginViewController alloc] init];
    } else {
        window.rootViewController = [[MainViewController alloc] init];

        [defaults setObject:currentVersion forKey:versionKey];
        [defaults synchronize];
    }

}

@end
