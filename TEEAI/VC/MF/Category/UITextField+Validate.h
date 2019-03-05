//
//  UITextField+Validate.h
//  MifiManager
//
//  Created by notion on 2018/3/30.
//  Copyright © 2018年 notion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (Validate)<UITextFieldDelegate>
- (NSString *)validateWithMethod:(NSString *)method;
- (void)setTitle:(NSString *)title imageArray:(NSArray<UIImage *> *)imageArray secureText:(BOOL)secureText selected:(BOOL)selected;
@end
