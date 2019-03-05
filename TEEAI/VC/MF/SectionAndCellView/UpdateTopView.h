//
//  UpdateTopView.h
//  MifiManager
//
//  Created by notion on 2018/3/23.
//  Copyright © 2018年 notion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpdateTopView : UIView
- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles isHighlight:(BOOL)highlight;
- (void)updateWithTitles:(NSArray *)titles highlight:(BOOL)highlight;
@end
