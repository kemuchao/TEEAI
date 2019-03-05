//
//  SystemCommon.h
//  MifiManager
//
//  Created by yanlei jin on 2018/3/20.
//  Copyright © 2018年 notion. All rights reserved.
//

#ifndef SystemCommon_h
#define SystemCommon_h

#define WeakSelf __weak typeof(self) weakSelf = self
/**
 *  获取iOS版本
 */
#define IOS_VERSION [UIDevice currentDevice].systemVersion
///*! 当前设备的屏幕宽度 */
#define SCREEN_WIDTH    ((([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) || ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)) ? [[UIScreen mainScreen] bounds].size.width : [[UIScreen mainScreen] bounds].size.height)

#define KSC_SCREEN_WIDTH_Pro    SCREEN_WIDTH/360


/*! 当前设备的屏幕高度 */
#define SCREEN_HEIGHT   ((([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) || ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)) ? [[UIScreen mainScreen] bounds].size.height : [[UIScreen mainScreen] bounds].size.width)

#define KSC_SCREEN_HEIGHT_Pro    SCREEN_HEIGHT/640

#define isPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

#define sendMessage(name,userinfo) \
({\
NSNotification *notifi = [[NSNotification alloc] initWithName:name object:nil userInfo:userinfo];\
[[NSNotificationCenter defaultCenter] postNotification:notifi];\
})

#define ksProWidth SCREEN_WIDTH/360
#define Ratio SCREEN_WIDTH/320
#ifdef DEBUG
#define NILog(...) NSLog(__VA_ARGS__)
#else
#define NILog(...)
#endif

#define HeightStateBar [[UIApplication sharedApplication] statusBarFrame].size.height
#define HeightNaviBar self.navigationController.navigationBar.frame.size.height
#define HeightNanvi HeightStateBar + HeightNaviBar
//取视图的X坐标
#define VIEW_X(view)        view.frame.origin.x
//取视图的Y坐标
#define VIEW_Y(view)        view.frame.origin.y
//取视图的宽
#define VIEW_WIDTH(view)    view.frame.size.width
//取视图的高
#define VIEW_HEIGHT(view)   view.frame.size.height
//取视图的最上面
#define VIEW_TOP(view)      view.frame.origin.y
//取视图的最左面
#define VIEW_LEFT(view)     view.frame.origin.x
//取视图的最下面
#define VIEW_BOTTOM(view)   view.frame.origin.y + view.frame.size.height
//取视图的最右面
#define VIEW_RIGHT(view)    view.frame.origin.x + view.frame.size.width


#endif /* SystemCommon_h */
