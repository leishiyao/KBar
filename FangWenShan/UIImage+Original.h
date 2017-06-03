//
//  UIImage.h
//  AnYiAn
//
//  Created by Leis on 15/4/4.
//  Copyright (c) 2015年 Leis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage(original)

- (UIImage *) originalImage;
- (UIImage *) imageByScalingToSize:(CGSize)targetSize;

@end
