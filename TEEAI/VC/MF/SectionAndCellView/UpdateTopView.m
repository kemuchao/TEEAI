//
//  UpdateTopView.m
//  MifiManager
//
//  Created by notion on 2018/3/23.
//  Copyright © 2018年 notion. All rights reserved.
//
#define originLabelX 60/3
#import "UpdateTopView.h"
@interface UpdateTopView()
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, assign) BOOL highlight;
@property (nonatomic, strong) NSArray *labelArray;
@end
@implementation UpdateTopView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles isHighlight:(BOOL)highlight{
    self = [super initWithFrame:frame];
    self.titles = titles;
    self.highlight = highlight;
    [self loadMainView];
    return self;
}

- (void)loadMainView{
    UILabel *labelTop = [[UILabel alloc] initWithFrame:CGRectMake(originLabelX, HeightLabel*2, SCREEN_WIDTH - 2*originLabelX, HeightLabel)];
    labelTop.text = _titles[0];
    labelTop.textColor = [UIColor colorWithHexString:ColorBlueDeep];
    labelTop.font = FontRegular;
    [self addSubview:labelTop];
    
    UILabel *labelBottom = [[UILabel alloc] initWithFrame:CGRectMake(originLabelX,CGRectGetHeight(self.bounds) -HeightLabel*2 - 1, SCREEN_WIDTH - 2*originLabelX, HeightLabel)];
    labelBottom.text = _titles[1];
    labelBottom.textColor = _highlight ?ColorWhite:[UIColor colorWithHexString:ColorBlueDeep];
    labelBottom.font = FontRegular;
    [self addSubview:labelBottom];
    _labelArray = @[labelTop,labelBottom];
    [self setBottomLineWithOrginX:0];
}

- (void)updateWithTitles:(NSArray *)titles highlight:(BOOL)highlight{
    UILabel *labelTop = _labelArray[0];
    labelTop.text = titles[0];
    
    UILabel *labelBottom = _labelArray[1];
    labelBottom.text = titles[1];
    labelBottom.textColor = highlight ?ColorWhite:[UIColor colorWithHexString:ColorBlueDeep];
}

@end
