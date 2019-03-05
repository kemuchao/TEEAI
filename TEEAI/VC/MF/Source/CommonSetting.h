//
//  CommonSetting.h
//  MifiManager
//
//  Created by yanlei jin on 2018/3/20.
//  Copyright © 2018年 notion. All rights reserved.
//

#ifndef CommonSetting_h
#define CommonSetting_h

#define ValidCommon @"^[A-Za-z0-9]{4,10}+$"
#define ValidFailCommonError @"失败"
#define ValidFailUnequal @"失败"
#define NotifyRefreshName @"Refresh"
#define NotifyNetChangeName @"netChange"
#define NotifyPINChange @"pin_change"
#define NotifyPackageChange @"pack_change"
#define NotifyBecomeActive @"active"

#define NotifyLoginSuccess @"loginSuccess"

#define NetKeyChangeNet @"netChange"
#define NetValueLost @"netLost"
#define NetValueCommonNet @"netCommon"
#define NetValueMIFINet @"netMIFI"

//NWMode 设置
#define NWModeCommon @"4G/3G/2G"
#define NWModeCommonINT 1
#define NWMode4G @"4G"
#define NWMode4GINT 2
#define NWMode4G3G @"4G/3G"
#define NWMode4G3GINT 3
#define NWMode3G2G @"3G/2G"
#define NWMode3G2GINT 4
#define NWMode3G @"3G"
#define NWMode3GINT 5
#define NWMode2G @"2G"
#define NWMode2GINT 6
#define NWModeForbid @"网络被禁止"
#define NWModeForbidINT 7
#define NWModeAuto @"自动连接"


#define NWStatisticsTimeForbid @"无网络"
#define NWStatisticsTimeForbidInt 0
#define NWStatisticsTimeMonth @"月"
#define NWStatisticsTimeMonthInt 1
#define NWStatisticsMonthName @"月"
#define NWStatisticsTimeUnlimited @"不限"
#define NWStatisticsTimeUnlimitedInt 3
#define NWStatisticsUnlimitedName @"total_available_unlimit"

#define NWStatisticsUpperRangeNone @"无限制"
#define NWStatisticsUpperRange10 @"剩余10%"
#define NWStatisticsUpperRange20 @"剩余20%"
#define NWStatisticsUpperRange30 @"剩余30%"
#define NWStatisticsUpperRange40 @"剩余40%"

//
#define IPType0 @"IPv4v6"
#define IPType1 @"IPv4"
#define IPType2 @"IPv6"
//
#define AuthType0 @"NONE"
#define AuthType1 @"PAP"
#define AuthType2 @"CHAP"

#define NotifiNameComom @"notifiName"

#define FontSfWithSize(s) [UIFont systemFontOfSize:s]
#define FontSyWithSize(s) [UIFont systemFontOfSize:s]
//UI 统一字体大小
#define FontSuperLarge FontSfWithSize(25)
#define FontLarge FontSfWithSize(20)
#define FontRegular FontSfWithSize(16)
#define FontNormal FontSfWithSize(14)
#define FontDetail FontSfWithSize(12)
#define FontSmall FontSfWithSize(11)

#define ColorWithAlpha(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
#define Color(r,g,b)  ColorWithAlpha(r,g,b,1.0)
#define WhiteAlpha(a) [UIColor colorWithWhite:1 alpha:a]

#define NormalGrayLight Color(247,247,247)
//#define NormalGrayLight [UIColor colorWithWhite:0.5 alpha:0.1]
#define NormalBlue Color(12,48,104)
#define NormalGray Color(203,203,203)

#define ColorWhite [UIColor whiteColor]
#define ColorRed   [UIColor redColor]
#define ColorBlack [UIColor blackColor]
#define ColorGreen [UIColor greenColor]
#define ColorClear [UIColor clearColor]
//UI设置颜色
#define ColorBlueDeep @"#132e50"
#define ColorGreenLight @"#6ae9d7"
#define ColorBlueNormal @"#436693"
#define ColorBlueLight @"abbcd1"
#define ColorBlank @"#ffffff"


#define WidthLabel 80
#define WidthButton 30

#define HeightHeader 230
#define HeightImage  80
#define HeightImageSmall 30
#define HeightEnter  50
#define HeightButton 40
#define HeightTextField 30
#define HeightLabel  21
#define HeightCell   60
#define HeightCellLarge 70
#define HeightCellLargest 80
#define MarginX      14
#define MarginY      10
#define MarginButtonX 113/3

#define iPhoneX (SCREEN_WIDTH == 812.0f || SCREEN_HEIGHT == 896.0f)

#define AdaptNaviHeight      (iPhoneX ? 24 : 0) //状态栏高度

#define AdaptTabHeight       (iPhoneX ? 34 : 0) //Tab bar 圆角部分高度

#define NAVIHEIGHT           (iPhoneX ? 88 : 64) //导航

#define TABBARHEIGHT         (iPhoneX ? 83 : 49) // 分栏


#define BorderWidth  1
#define BorderCircle 8
#define BorderColorGreen ColorGreen

#define IMAGE(name) [UIImage imageNamed:name]
#define BUTTON_HIDE [UIImage imageNamed:@"buttonHide"]
#define BUTTON_SHOW [UIImage imageNamed:@"buttonShow"]

#define Localized(string) NSLocalizedString(string, nil)
#endif /* CommonSetting_h */
