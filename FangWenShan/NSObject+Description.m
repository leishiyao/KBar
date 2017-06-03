//
//  NSObject+Description.m
//  LSChart
//
//  Created by Leis on 15/11/24.
//
//

#import "NSObject+Description.h"
#import <objc/runtime.h>

@implementation NSObject (Description)


- (NSString *) stringByAddingTabForEachLine:(NSString *)str {
    
    return [NSString stringWithFormat:@"\t%@", [str stringByReplacingOccurrencesOfString:@"\n" withString:@"\n\t"]];
}

- (NSString *) descriptionForDic:(NSDictionary *)dic {
    NSMutableArray *arr = [NSMutableArray array];
    for (id key in [dic allKeys]) {
        NSString *strKey = [self valueHandler:key];
        NSString *strValue = [self valueHandler:dic[ key ]];
        [arr addObject:[NSString stringWithFormat:@"%@ = %@", strKey, strValue]];
    }
    NSString *dscp = [NSString stringWithFormat:@"{\n%@\n}", [self stringByAddingTabForEachLine:[arr componentsJoinedByString:@",\n"]]];
    return dscp;
}

- (NSString *) descriptionForArray:(NSArray *)array {
    NSMutableArray *arr = [NSMutableArray array];
    for (id value in array) {
        NSString *strValue = [self valueHandler:value];
        [arr addObject:[NSString stringWithFormat:@"%@",  strValue]];
    }
    NSString *dscp = [NSString stringWithFormat:@"{\n%@\n}", [self stringByAddingTabForEachLine:[arr componentsJoinedByString:@",\n"]]];
    return dscp;
}

- (NSString *) valueHandler:(id)value {
    if ([value isKindOfClass:[NSString class]]) {
        return value;
    } else if ([value isKindOfClass:[NSNumber class]]) {
        return [value stringValue];
    } else if ([value isKindOfClass:[NSDictionary class]]) {
        return [self descriptionForDic:value];
    } else if ([value isKindOfClass:[NSArray class]]) {
        return [self descriptionForArray:value];
    } else {
        if ([value respondsToSelector:@selector(properties_aps)]) {
            return [value valueHandler:[value properties_aps]];
        } else {
            return [value description];
        }
    }
}
/**
 *  返回某NSObject的所有有效属性值组成的Dictionary
 *
 *  @return 有效属性值组成的Dictionary
 */
- (NSDictionary *)properties_aps {
    NSMutableDictionary *props = [NSMutableDictionary dictionary];
    unsigned int outCount, i;
    
    Class class = [self class];
    
    while (class != [NSObject class]) {
        // 调用下面函数不包括superClass的属性
        objc_property_t *properties = class_copyPropertyList(class, &outCount);
        for (i = 0; i < outCount; i++) {
            objc_property_t property = properties[i];
            NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
            id propertyValue = [self valueForKey:(NSString *)propertyName];
            if (propertyValue) {
                [props setObject:[self valueHandler: propertyValue]  forKey:propertyName];
            }
            
        }
        free(properties);
        
        class = [class superclass];
    }
    return props;
}


- (NSString *)propertiesDescription {
    return [NSString stringWithFormat:@"%@", [self valueHandler:self]];
}


@end
