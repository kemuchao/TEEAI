//
//  NISelectView.m
//  MifiManager
//
//  Created by notion on 2018/4/3.
//  Copyright © 2018年 notion. All rights reserved.
//

#import "NISelectView.h"
#import <objc/runtime.h>
#import "UIButton+Event.h"
@interface NISelectView()
@property (nonatomic, strong) NSMutableArray *cellArray;
@property (nonatomic, strong) NSArray *modelArray;
@property (nonatomic, assign) NSInteger selectIndex;
@end
@implementation NISelectView
static char SelectTag;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithData:(NSArray<NISelectModel *> *)modelArray preSelectIndex:(NSInteger)index andBlock:(SelectdBlock)block{
    CGFloat cellHeight = HeightCell*Ratio;
    CGRect frame = CGRectMake(0, SCREEN_HEIGHT - cellHeight*modelArray.count, SCREEN_WIDTH, cellHeight*modelArray.count);
    self = [super initWithFrame:frame];
     objc_setAssociatedObject(self, &SelectTag, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self setModelArray:modelArray];
    [self setCellArray:[NSMutableArray array]];
    [self setSelectIndex:index];
    [self loadMainView];
    return self;
}

- (void)loadMainView{
    
    for (int index=0;index<_modelArray.count;index++) {
        NISelectModel *model = _modelArray[index];
        CGRect cellFrame = CGRectMake(0, index*HeightCell*Ratio, SCREEN_WIDTH, HeightCell *Ratio);
        UIView *cell = [[UIView alloc] initWithFrame:cellFrame];
        cell.backgroundColor = index == _selectIndex ? NormalBlue:NormalGrayLight;
        [_cellArray addObject:cell];
        [self addSubview:cell];
        
        CGFloat marginX = MarginX/2;
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
        style.headIndent = 10.0f;
        style.firstLineHeadIndent = 10.0f;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(marginX, 0, SCREEN_WIDTH, HeightCell*Ratio)];
        label.attributedText = [[NSMutableAttributedString alloc] initWithString:model.title attributes:@{NSFontAttributeName:FontSyWithSize(18),NSForegroundColorAttributeName:ColorBlack,NSParagraphStyleAttributeName:style}];
        label.layer.borderColor = NormalGray.CGColor;
        label.layer.borderWidth = BorderWidth;
        label.clipsToBounds = YES;
        label.backgroundColor = ColorWhite;
        [cell addSubview:label];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:cell.bounds];
        [btn addEvent:^(UIButton *btn){
            [self dealSelectAtIndex:index];
        }];
        [cell addSubview:btn];
    }
}

- (void)dealSelectAtIndex:(NSInteger)index{
    for (UIView *cell in _cellArray) {
        NSInteger cellIndex = [_cellArray indexOfObject:cell];
        cell.backgroundColor = cellIndex == index ?NormalBlue:NormalGrayLight;
    }
    SelectdBlock block = objc_getAssociatedObject(self, &SelectTag);
    if (block) {
        block(_modelArray[index]);
    }
}

@end
