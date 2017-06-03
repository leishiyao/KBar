//
//  UILabel+APIClient.m
//  WeComfort
//
//  Created by Leis on 15/12/24.
//
//

#import "NSString+Size.h"

@implementation NSString(Size)

- (CGSize)calculateSizeWithFontSize:(CGFloat)fontSize MaxSize:(CGSize)maxSize {
    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;

    NSDictionary* attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:fontSize],
                                 NSParagraphStyleAttributeName:paragraphStyle.copy};

    CGSize labelSize = [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
    
    labelSize.height = ceil(labelSize.height);
    labelSize.width = ceil(labelSize.width);

    return labelSize;
}

- (NSString *)unicodeToUTF8 {
    //张三  \u5f20\u4e09
    
    NSString *tempStr1 = [self stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData
                                                           mutabilityOption:NSPropertyListImmutable
                                                                     format:NULL
                                                           errorDescription:NULL];
    
    //  NSLog(@"Output = %@", returnStr);
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"\n"];
}

#pragma mark//汉字转 Unicode   张三 →  \u5f20\u4e09
-(NSString *) utf8ToUnicode:(NSString *)string{
    
    NSUInteger length = [string length];
    NSMutableString *s = [NSMutableString stringWithCapacity:0];
    for (int i = 0;i < length; i++){
        unichar _char = [string characterAtIndex:i];
        //判断是否为英文和数字
        if (_char <= '9' && _char >='0'){
            [s appendFormat:@"%@",[string substringWithRange:NSMakeRange(i,1)]];
        }else if(_char >='a' && _char <= 'z'){
            [s appendFormat:@"%@",[string substringWithRange:NSMakeRange(i,1)]];
        }else if(_char >='A' && _char <= 'Z')
        {
            [s appendFormat:@"%@",[string substringWithRange:NSMakeRange(i,1)]];
        }else{
            [s appendFormat:@"\\u%x",[string characterAtIndex:i]];
        }
    }
    return s;
}

@end
