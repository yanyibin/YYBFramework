//
//  UIViewController+YYBRouter.m
//  YYBRouter
//
//  Created by Aokura on 2018/9/5.
//  Copyright © 2018年 UnderTree,Inc. All rights reserved.
//

#import "UIViewController+YYBRouter.h"
#import <objc/runtime.h>

@implementation UIViewController (YYBRouter)

+ (BOOL)yybrouter_searchClass:(Class)aClass hasProperty:(NSString *)property {
    if (aClass == nil) return NO;
    if (property == nil || property.length == 0) return NO;
    
    unsigned int outCount;
    objc_property_t * properties = class_copyPropertyList(aClass , &outCount);
    for (int i = 0; i < outCount; i++) {
        objc_property_t property_t = properties[i];
        NSString *key = [[NSString alloc] initWithCString:property_getName(property_t) encoding:NSUTF8StringEncoding];
        if ([key isEqualToString:property]) {
            free(properties);
            return YES;
        }
    }
    free(properties);
    return NO;
}

- (id)yybrouter_assignValues:(NSDictionary *)valuesParams {
    if (valuesParams.allKeys.count == 0) return self;
    for (NSString *key in valuesParams.allKeys) {
        if ([[self class] yybrouter_searchClass:[self class] hasProperty:key]) {
            [self setValue:valuesParams[key] forKey:key];
        }
    }
    return self;
}

@end
