//
//  UIViewController+YYBRouter.h
//  YYBRouter
//
//  Created by Aokura on 2018/9/5.
//  Copyright © 2018年 UnderTree,Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (YYBRouter)

+ (BOOL)yybrouter_searchClass:(Class)aClass hasProperty:(NSString *)property;

- (id)yybrouter_assignValues:(NSDictionary *)valuesParams;

@end
