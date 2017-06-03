//
//  UIImage.m
//  AnYiAn
//
//  Created by Leis on 15/4/4.
//  Copyright (c) 2015年 Leis. All rights reserved.
//

#import "UIImage+Original.h"

@implementation UIImage(original)

- (UIImage *) originalImage {
    if ([UIImage instancesRespondToSelector:@selector(imageWithRenderingMode:)]) {
        return [self imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    } else {
        return self;
    }
}

// 扩展UIImage,实现缩放功能。如果目标比例和原始比例不同，则会以目标尺寸为边框，将原图在边框中最大化显示
- (UIImage *)imageByScalingToSize:(CGSize)targetSize {
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if (widthFactor < heightFactor)
            scaleFactor = widthFactor;
        else
            scaleFactor = heightFactor;
        // 我加的条件，如果图片过小不用放大
        if (scaleFactor > 1.0) {
            scaleFactor = 1.0;
        }
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        // center the image
        if (widthFactor < heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        } else if (widthFactor > heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    // this is actually the interesting part:
    UIGraphicsBeginImageContext(targetSize);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    //    newImage = [[UIImage alloc] init];
    newImage = UIGraphicsGetImageFromCurrentImageContext() ;
    UIGraphicsEndImageContext();
    if(newImage == nil)
        NSLog(@"could not scale image");
    return newImage ;
}



@end
