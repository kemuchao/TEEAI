//
//  NotionEnterGroup.m
//  MifiManager
//
//  Created by notion on 2018/3/21.
//  Copyright © 2018年 notion. All rights reserved.
//

#import "NotionEnterGroup.h"
#import <objc/runtime.h>
@interface NotionEnterGroup()
@property (nonatomic, strong) NSMutableArray *textEnterArray;

@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *placeholderArray;
@property (nonatomic, strong) NSArray *textArray;
@property (nonatomic, strong) NSArray *boardtypeArray;
@property (nonatomic, strong) NSArray *imageNormalArray;
@property (nonatomic, strong) NSArray *imageSelectedArray;

@property (nonatomic, strong) NSArray *UITypeArray;
@property (nonatomic, strong) NSArray *ControlTypeArray;
@end
@implementation NotionEnterGroup

static char Vertify;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame GroupTitle:(NSArray *)titleArray textValueArray:(NSArray *)textArray placeholderArray:(NSArray  *)placeholderArray keyboardTypeArray:(NSArray*)boardtypeArray UITypeArray:(NSArray *)UITypeArray imageNormal:(NSArray *)imageNormalArray imageSelectdArray:(NSArray *)imageSelectedArray ControlTypeArray:(NSArray *)controlArray  withBlock:(EnterVertify)block{
    self = [super initWithFrame:frame];
    if (self) {
        //存储数组
        [self setTextEnterArray:[[NSMutableArray alloc] init]];
        //显示
        if(titleArray)[self setTitleArray:titleArray];
        if(textArray)[self setTextArray:textArray];
        if(placeholderArray)[self setPlaceholderArray:placeholderArray];
        [self setBoardtypeArray:boardtypeArray];
        if(imageNormalArray)[self setImageNormalArray:imageNormalArray];
        if(imageSelectedArray) [self setImageSelectedArray:imageSelectedArray];
        //样式和控制
        [self setUITypeArray:UITypeArray];
        [self setControlTypeArray:controlArray];
    }
    [self loadEnterGroup];
    objc_setAssociatedObject(self, &Vertify, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    return self;
}

- (void)loadEnterGroup{
    for (int i=0;i<_titleArray.count;i++) {
        CGFloat height = CGRectGetHeight(self.bounds)/_titleArray.count;
        CGFloat width = CGRectGetWidth(self.bounds);
        NSString *title = nil;
        if(_titleArray) title = _titleArray[i];
        NSString *placeholder = nil;
        if(_placeholderArray) placeholder = _placeholderArray[i];
        NSString *text = nil;
        if(_textArray) text = _textArray[i];
        UIImage *imageNormal = nil;
        if(_imageNormalArray) imageNormal = _imageNormalArray[i];
        UIImage *imageSelected = nil;
        if (_imageSelectedArray) imageSelected = _imageSelectedArray[i];
        
        UIKeyboardType type = UIKeyboardTypeDefault;
        if (_boardtypeArray) type = [_boardtypeArray[i] integerValue];
        EnterUIType UIType = [_UITypeArray[i] integerValue];
        EnterControlType controlType = [_ControlTypeArray[i] integerValue];
        
        NotionEnterView *enterView = [[NotionEnterView alloc] initWithFrame:CGRectMake(0, height*i, width, height) title:title placeHolder:placeholder text:text keyboadrType:type imageNormal:imageNormal imageSelected:imageSelected UIType:UIType controlType:controlType];
        [enterView setBackgroundColor:NormalGrayLight];
        [self addSubview:enterView];
        [_textEnterArray addObject:enterView];
        
        if (i < _titleArray.count - 1) {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, height*(i+1)-1, width, 1)];
            line.backgroundColor = NormalGray;
            [self addSubview:line];
        }
    }
    self.layer.borderColor = NormalGray.CGColor;
    self.layer.borderWidth = BorderWidth;
    self.layer.cornerRadius = BorderCircle;
    self.clipsToBounds = YES;
}
/**
 获取标题数组

 @return 标题数组
 */
- (NSArray *)getTitles{
    NSMutableArray *titles = [NSMutableArray array];
    for (NotionEnterView *textField in _textEnterArray) {
        [titles addObject:[textField getText]];
    }
    return (NSArray *)titles;
}

- (NSArray *)getEnterTextField{
    NSMutableArray *textFields = [NSMutableArray array];
    for (NotionEnterView *textField in _textEnterArray) {
        [textFields addObject:[textField getTextField]];
    }
    return (NSArray *)textFields;
}
@end
