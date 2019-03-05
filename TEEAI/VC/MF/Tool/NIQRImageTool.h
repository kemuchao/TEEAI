//
//  NIQRImageTool.h
//  MifiManager
//
//  Created by notion on 2018/5/7.
//  Copyright © 2018年 notion. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NIQRImageTool : NSObject

/**
 根据内容生成二维码

 @param imageView 存放大小
 @param infoData 内容
 */
+ (void)setQRImageToImageView:(UIImageView *)imageView withInfo:(NSData *)infoData;
@end
