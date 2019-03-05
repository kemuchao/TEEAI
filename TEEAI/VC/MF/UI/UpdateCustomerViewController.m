//
//  UpdateCustomerViewController.m
//  MifiManager
//
//  Created by notion on 2018/3/23.
//  Copyright © 2018年 notion. All rights reserved.
//

#import "UpdateCustomerViewController.h"
#import "UpdateTopView.h"
#import "UpdateButton.h"
@interface UpdateCustomerViewController ()
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) UpdateTopView *topView;
@end

@implementation UpdateCustomerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ColorWhite;
    self.title = Localized(@"RouterSoftWareUpdate");
   
    [self loadMainView];
    // Do any additional setup after loading the view.
}

- (void)loadMainView{
    BOOL highlight = YES;
    UpdateTopView *viewTop = [[UpdateTopView alloc] initWithFrame:CGRectMake(0, HeightNanvi, SCREEN_WIDTH, HeightLabel*2 + HeightLabel*5) titles:@[@"当前版本：1.2.65",@"已是最新版本"] isHighlight:highlight];
    
    [self.view addSubview:viewTop];
    
    UIColor *borderColor = highlight?BorderColorGreen:ColorWhite;
    NSString *title = highlight?Localized(@"UpdateNone"):Localized(@"Update");
    UIColor *color = [UIColor colorWithHexString:ColorBlueDeep];
    UIColor *bgColor = highlight?ColorClear:ColorWhite;
    CGRect frame = [self dealGetFrameWithX:115/3 Y:SCREEN_HEIGHT - HeightButton-38/3 Width:SCREEN_WIDTH- (115/3)*2 Height:HeightButton];
    UIButton *button = [self dealSetButtonWithTitle:title color:color bgColor:bgColor font:FontRegular frame:frame image:nil];
    [button setLayerWithBorderWidth:BorderWidth BorderColor:borderColor CornerRadius:BorderCircle];
    button.userInteractionEnabled = !highlight;
    [button addEvent:^(UIButton *btn){
        
    }];
    [self.view addSubview:button];
    
    
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
