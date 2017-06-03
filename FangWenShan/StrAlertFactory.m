//
//  StrAlertFactory.m
//  AnYiAn
//
//  Created by Leis on 15/5/20.
//  Copyright (c) 2015年 Leis. All rights reserved.
//

#import "StrAlertFactory.h"
#import "MBProgressHUD.h"
@implementation StrAlertFactory

static MBProgressHUD *_textHUD = nil;
//+ (MBProgressHUD *) textHUD {
//
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        
//        
//    });
//    
//    return _textHUD;
//}

+ (void)showStr:(NSString *)str {
    if ( [[UIApplication sharedApplication] keyWindow] == nil ) {
        return;
    }
    if (_textHUD == nil) {
        _textHUD = [[MBProgressHUD alloc] initWithView:[[UIApplication sharedApplication] keyWindow]];
        _textHUD.removeFromSuperViewOnHide = YES;
        _textHUD.mode = MBProgressHUDModeText;
        _textHUD.margin = 10.f;
        _textHUD.labelFont = [UIFont systemFontOfSize:12];
    }

    [[[UIApplication sharedApplication] keyWindow] addSubview:_textHUD];
    [_textHUD show:YES];
    
    _textHUD.labelText = str;

    
    [_textHUD hide:YES afterDelay:1];
}
@end
