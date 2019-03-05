//
//  ResetView.m
//  MifiManager
//
//  Created by notion on 2018/4/9.
//  Copyright © 2018年 notion. All rights reserved.
//

#import "ResetView.h"
#import <objc/runtime.h>
@interface ResetView()
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) CGFloat ratio;
@end
//static char *ratioTag;
@implementation ResetView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    [self loadMainView];
    return self;
}

- (void)loadMainView{
    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, MarginY*2, SCREEN_WIDTH, HeightLabel)];
    labelTitle.text = @"正在重启";
    labelTitle.font = FontSfWithSize(16);
    labelTitle.textColor = ColorBlack;
    labelTitle.textAlignment = NSTextAlignmentCenter;
    [self addSubview:labelTitle];
    
    UILabel *labelContent = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(labelTitle.frame)+MarginY*2, SCREEN_WIDTH, HeightLabel)];
    labelContent.textColor = ColorBlack;
    labelContent.text = @"路由器正在重启，稍后会自动连接";
    labelContent.textAlignment = NSTextAlignmentCenter;
    labelContent.font = FontSfWithSize(15);
    [self addSubview:labelContent];
    
    UIProgressView *progress = [[UIProgressView alloc] initWithFrame:CGRectMake(MarginX, CGRectGetMaxY(labelContent.frame)+MarginY, SCREEN_WIDTH - MarginX*2, 1)];
    progress.tintColor = NormalBlue;
    progress.backgroundColor = NormalGrayLight;
    progress.progress = 0.5;
    [self addSubview:progress];
    _progress = progress;
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(MarginX, CGRectGetMaxY(progress.frame)+MarginY, SCREEN_WIDTH - MarginX*2, HeightButton *Ratio)];
    [button setTitle:@"退出应用" forState:UIControlStateNormal];
    [button setTitleColor:ColorBlack forState:UIControlStateNormal];
    [button setBackgroundColor:ColorWhite];
    [self addSubview:button];
    _button = button;
}

/**
 开始进度条
 */
- (void)start{
    NSTimer*timer =  [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
    [timer fire];
    _timer = timer;
    _ratio = 0;
}

- (void)updateProgress{
    WeakSelf;
    if (_ratio <= 25) {
        _ratio += 1;
        dispatch_async(dispatch_get_main_queue(), ^(){
            weakSelf.progress.progress = weakSelf.ratio/25;
        });
    } else {
        [_timer invalidate];
        if (weakSelf.block) {
            weakSelf.block();
        }
    }
    
}

@end
