//
//  RouterTestViewController.m
//  MifiManager
//
//  Created by yanlei jin on 2018/3/21.
//  Copyright © 2018年 notion. All rights reserved.
//

#import "RouterTestViewController.h"

@interface RouterTestViewController ()
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UILabel *progressNumber;
@property (nonatomic, strong) UIView *progress;
@property (nonatomic, assign) CGFloat ratio;
@end

@implementation RouterTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = ColorWhite;
    
    [self loadMainView];
//    [self loadSelfNavi];
}

- (void)loadMainView{
    
    CGFloat viewHeight = (SCREEN_HEIGHT - HeightNanvi)*0.4;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, HeightNanvi, SCREEN_WIDTH, viewHeight)];
    [self.view addSubview:view];
    
    CGFloat imageWidth = SCREEN_WIDTH*0.8;
    CGFloat imageHeight = imageWidth;
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - imageWidth)/2, (viewHeight - imageHeight)/2, imageWidth, imageHeight)];
    image.image = [UIImage imageNamed:@"iconSIMBG"];
    [view addSubview:image];
    
    CGFloat imageSIMWidth = SCREEN_WIDTH*0.8/2;
    CGFloat imageSIMHeight = imageSIMWidth;
    UIImageView *imageSIM = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - imageSIMWidth)/2, (viewHeight - imageSIMHeight)/2, imageSIMWidth, imageSIMHeight)];
    imageSIM.image = [UIImage imageNamed:@"iconSIM"];
    [view addSubview:imageSIM];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, viewHeight - MarginY - HeightLabel*3, SCREEN_WIDTH, HeightLabel*3)];
    label.font = [UIFont systemFontOfSize:50];
    label.text = @"0%";
    label.textColor = ColorWhite;
//    label.backgroundColor = [UIColor redColor];
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
    _progressNumber = label;
    
    CGFloat progressHeight = 2;
    UIView *progress = [[UIView alloc] initWithFrame:CGRectMake(0, viewHeight - progressHeight, 0, progressHeight)];
    progress.backgroundColor = [UIColor greenColor];
    [view addSubview:progress];
    _progress = progress;
    
    CGFloat bottomHeight = SCREEN_HEIGHT- viewHeight - HeightNanvi;
    UIView *bottom = [[UIView alloc] initWithFrame:CGRectMake(0, VIEW_BOTTOM(view), SCREEN_WIDTH, bottomHeight)];
    bottom.backgroundColor = ColorWhite;
    [self.view addSubview:bottom];
    
    UILabel *labelTop = [[UILabel alloc] initWithFrame:CGRectMake( 0, 0.5*bottomHeight-HeightLabel, SCREEN_WIDTH, HeightLabel)];
//    labelTop.textColor = [UIColor blackColor];
    labelTop.font = [UIFont systemFontOfSize:18];
    labelTop.text = @"检测项目";
    labelTop.textAlignment = NSTextAlignmentCenter;
    [bottom addSubview:labelTop];
    
    UILabel *labelBottom = [[UILabel alloc] initWithFrame:CGRectMake( 0, VIEW_BOTTOM(labelTop)+MarginY, SCREEN_WIDTH, HeightLabel)];
    labelBottom.textColor = NormalGray;
    labelBottom.font = [UIFont systemFontOfSize:16];
    labelBottom.text = @"正在检测SIM卡";
    labelBottom.textAlignment = NSTextAlignmentCenter;
    [bottom addSubview:labelBottom];
    
    NSTimer*timer =  [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
    [timer fire];
    _timer = timer;
    
    _ratio = 0;
}

- (void)updateProgress{
    if (_ratio <= 99) {
        _ratio += 1;
        WeakSelf;
        dispatch_async(dispatch_get_main_queue(), ^(){
            weakSelf.progressNumber.text = [NSString stringWithFormat:@"%.0f%%",weakSelf.ratio];
            CGRect frame = weakSelf.progress.frame;
            frame.size.width = SCREEN_WIDTH/100*weakSelf.ratio;
            weakSelf.progress.frame = frame;
        });
    } else {
        [_timer invalidate];
    }
    
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
