//
//  BaseViewController.h
//  MifiManager
//
//  Created by notion on 2018/3/20.
//  Copyright © 2018年 notion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIHttpUtil.h"
#import "GDataXMLNode.h"
#import <MBProgressHUD/MBProgressHUD.h>

#import "LoginStatus.h"



@class ButtonContent;
@interface BaseViewController : UIViewController

#pragma mark MBProgressHUD 相关
@property (nonatomic, strong) MBProgressHUD * mbProgress;
@property (nonatomic, strong) UIAlertController *alert;

-(void)goBack;//返回
-(void)topMoreClick;
//-(void)initRightButtonImage:(UIImage*)image;
#pragma mark - 界面切换处理
- (void)appOut;
- (void)appIn;
- (void)needToRefresh;


/**
 设置右侧点击按钮

 @param title 按钮标题
 */
//- (void)setRightBarWithTitle:(NSString *)title;
/**
 显示进度条
 */
-(void)mbShowLoading;
-(void)mbShowLoadingText:(NSString*)loadingText;
-(void)mbShowLoadingProgress:(NSString*)loadingText;
-(void)mbShowLoadingProgressSec:(NSString*)loadingText;

/**
 弹出提示
 
 @param str 提示信息
 */
-(void)mbShowToast:(NSString*)str;
-(void)mbShowCustom:(UIView*)view withText:(NSString*)text;
-(void)mbDismissDelayTime:(NSTimeInterval)time;
/**
 隐藏进度条
 */
-(void)mbDismiss;

- (void)loadSelfNavi;

- (void)loadSubViewLayer:(UIView *)subView;
- (void)loadSubViewLayer:(UIView *)subView withBorderCircle:(CGFloat)borderCircle borderColor:(UIColor *)borderColor;

/**
 处理多大小颜色字符

 @param text 字符
 @param length 待处理长度
 @param mainFont 主字体
 @param mainColor 主颜色
 @param assFont 次字体
 @param assColor 次颜色
 @return 处理后字符
 */
- (NSMutableAttributedString *)dealTrailText:(NSString *)text WithLength:(NSInteger)length MainFont:(UIFont *)mainFont mainColor:(UIColor *)mainColor AssFont:(UIFont*)assFont assColor:(UIColor *)assColor;

/**
 大小

 @param X X
 @param Y Y
 @param Width Width
 @param Height Height
 @return Frame
 */
- (CGRect)dealGetFrameWithX:(CGFloat)X Y:(CGFloat)Y Width:(CGFloat)Width Height:(CGFloat)Height;

/**
 buton
 
 @param title title
 @param color text color
 @param bgColor bg color
 @param font title font
 @param frame frme
 @return button
 */
- (ButtonContent *)dealGetButtonWithTitle:(NSString *)title color:(UIColor *)color bgColor:(UIColor *)bgColor font:(UIFont *)font frame:(CGRect)frame image:(UIImage *)image;
/**
 buton

 @param title title
 @param color text color
 @param bgColor bg color
 @param font title font
 @param frame frme
 @return button
 */
- (UIButton *)dealSetButtonWithTitle:(NSString *)title color:(UIColor *)color bgColor:(UIColor *)bgColor font:(UIFont *)font frame:(CGRect)frame image:(UIImage *)image;
/**
 label

 @param text text
 @param color text color
 @param bgColor bg color
 @param font text font
 @param textAlign text alignment
 @param frame frame
 @return label
 */
- (UILabel *)dealSetLabelWithTitle:(NSString *)text color:(UIColor *)color bgColor:(UIColor *)bgColor font:(UIFont *)font textAlign:(NSTextAlignment)textAlign frame:(CGRect)frame;

/**
 tableview

 @param cellHeight cell height
 @param frame frame
 @param bgColor bg color
 @param delegate delegate
 @return tableview
 */
- (UITableView *)dealSetTableViewWithCellHeight:(CGFloat)cellHeight frame:(CGRect)frame bgColor:(UIColor *)bgColor delegate:(id)delegate;
/**
 处理textFiled 添加前标和后缀
 
 @param field 输入框
 @param title 标题
 @param imageArray 图片
 @param secureText 是否为密码输入符
 @param selected 是否显示密码
 */
- (void)dealSetTextField:(UITextField *)field title:(NSString *)title imageArray:(NSArray<UIImage *> *)imageArray secureText:(BOOL)secureText selected:(BOOL)selected;
/**得到字符高度*/
/**
 针对label，获取所示高度

 @param text 字符串
 @param width label 宽度
 @param font label 字号
 @return 高度
 */
- (CGFloat)getText:(NSString *)text HeightWithWidth:(CGFloat)width andFont:(UIFont *)font;
- (CGFloat)getText:(NSString *)text WidthWithHeight:(CGFloat)height andFont:(UIFont *)font;
/**
 获取当前网络状态
 */
//- (void)getNetStateBlock:(void(^)(AFNetworkReachabilityStatus netState))Block;

/**
 检测是否需要重新登录

 @param response 检测字符串
 */
- (BOOL)checkLoginWithOperationResponse:(NSString *)response;
#pragma mark - 弹框及网络处理

/**
 隐藏弹框
 */
- (void)dealHideAlert;
/**
 显示需要链接到MIFI
 */
- (void)showWIFIAlert;

/**
 显示需要重新登录
 */
- (void)showNeedLoginAlert;
/**
 状态修改后需要重新登录
 */
- (void)showNeedRelogin;
/**
 返回根视图
 */
- (void)dealGotoRoot;
///**
// 是否与MIFI连接
//
// @return 监听网络
// */
//- (BOOL)isConnectToWiFi;
/**
 处理网络切换问题
 
 */
- (void)dealNetChange;
/**
 跳转到WIFI设置界面
 */
- (void)jumpToNetSetting;
/**
 设置控制器背景图片
 
 @param connectStatus 是否连接MIFI
 */
- (void)dealSetBGViewWithConnectStatus:(BOOL)connectStatus;

/**
 获取当前网络状态

 @param Block <#Block description#>
 */
- (void)getNetStateBlock:(void(^)(AFNetworkReachabilityStatus netState))Block;

/**
 获取当前网络类型

 @return <#return value description#>
 */
- (NSString *)getNetType;
@end
