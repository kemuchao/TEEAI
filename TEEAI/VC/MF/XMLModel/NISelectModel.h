//
//  NISelectModel.h
//  MifiManager
//
//  Created by notion on 2018/4/3.
//  Copyright © 2018年 notion. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NISelectModel : NSObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) id value;
+ (instancetype)setTitle:(NSString *)title value:(id)value;
//- (instancetype)initwithTitle:(NSString *)title V:(id)value;
@end
