//
//  UIImageView+APIClient.m
//  WeComfort
//
//  Created by Leis on 15/12/15.
//
//

#import "UIImageView+APIClient.h"
#import "APIClient.h"
#import "UIImageView+WebCache.h"
//#import "UIImageView+HighlightedWebCache.h"

@implementation UIImageView (APIClient)

- (void)setImageWithUrlStr:(NSString *)urlStr placeHolder:(NSString *)namePlaceHolderImg {
    UIImage *placeHolderImg = nil;
    if (namePlaceHolderImg.length > 0) {
        placeHolderImg = [UIImage imageNamed:namePlaceHolderImg];
//    } else if(faceAware) {
//        placeHolderImg = [UIImage imageNamed:@"myAvatar"];
    }
    if ([urlStr isKindOfClass:[NSString class]] == NO || urlStr.length == 0) {
        self.image = placeHolderImg;
        return;
    }
    
    NSString *imgUrl;
    if (urlStr.length > 6 && [[urlStr substringToIndex:7] isEqualToString:@"http://"]) {
        imgUrl = urlStr;
    } else {
        if ([urlStr characterAtIndex:0] == '/') {
            urlStr = [urlStr stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@""];
        }
        imgUrl = [ImageServerBaseURLStr stringByAppendingString:urlStr];
    }
    
    
    
    NSURL *url = [NSURL URLWithString:imgUrl];
//    UIImageView __weak *weakSelf = self;
    [self sd_setImageWithURL:url placeholderImage:placeHolderImg completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        UIImageView __strong *strongSelf = weakSelf;

    }];
}

@end
