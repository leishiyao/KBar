//
//  UILabel+APIClient.h
//  WeComfort
//
//  Created by Leis on 15/12/24.
//
//

#import <UIKit/UIKit.h>

@interface UILabel(APIClient)

+ (CGSize) calculateRectWith:(NSString*)text FontSize:(CGFloat)fontSize MaxSize:(CGSize)maxSize;
@end
