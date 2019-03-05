//
//  ShowWIFIViewController.m
//  MifiManager
//
//  Created by notion on 2018/6/19.
//  Copyright © 2018年 notion. All rights reserved.
//

#import "ShowWIFIViewController.h"
#import "UIButton+Event.h"
@interface ShowWIFIViewController ()

@end

@implementation ShowWIFIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initMainView];
//    [self resetNavigationBar];
//    [self setRightBarWithTitle:Localized(@"delete")];
    // Do any additional setup after loading the view.
}

- (void)initMainView{
//    self.view.backgroundColor = [UIColor colorWithRed:88/255.0 green:129/255.0 blue:192/255.0 alpha:1];
    
    UIImageView *bgimageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    bgimageView.image = [UIImage imageNamed:@"home_bg"];
    [self.view addSubview:bgimageView];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 149 * ksProWidth)/2, 155 * ksProWidth, 149 * ksProWidth, 75 * ksProWidth)];
    imageView.image = [UIImage imageNamed:@"noDevice"];
    [self.view addSubview:imageView];
    
    UILabel *label = [self dealSetLabelWithTitle:@"您没有连接到路由器" color:ColorWhite bgColor:ColorClear font:[UIFont systemFontOfSize:14] textAlign:NSTextAlignmentCenter frame:[self dealGetFrameWithX:MarginX Y:CGRectGetMaxY(imageView.frame) + 54 * ksProWidth Width:SCREEN_WIDTH - 2*MarginX Height:40]];
    
    [self.view addSubview:label];
    CGFloat buttonMarginX = MarginButtonX*Ratio;
    UIButton *buttonConfirm = [self dealSetButtonWithTitle:@"手动连接" color:[UIColor colorWithRed:89/255.0 green:129/255.0 blue:192/255.0 alpha:1] bgColor:ColorWhite font:[UIFont systemFontOfSize:19] frame:[self dealGetFrameWithX:buttonMarginX Y:SCREEN_HEIGHT - 48*ksProWidth - 30 * ksProWidth Width:SCREEN_WIDTH - 2*buttonMarginX Height:48*ksProWidth] image:nil];
    [buttonConfirm setLayerWithBorderWidth:0 BorderColor:BorderColorGreen CornerRadius:BorderCircle];
    [self.view addSubview:buttonConfirm];
    [buttonConfirm addEvent:^(UIButton *btn){
        //废弃 /* iOS7/8/9使用prefs:root=的时候不要忘记在URL type中添加一个prefs值 */
        float systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
        
        if (systemVersion >= 8.0 && systemVersion < 10.0) {  // iOS8.0 和 iOS9.0

            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }else if (systemVersion >= 10.0) {  // iOS10.0及以后
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

-(void)dealHideAlert {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
