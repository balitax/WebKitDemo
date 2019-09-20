//
//  NSString+Json.m
//  CangDan
//
//  Created by BriceZH on 2018/9/7.
//  Copyright © 2018年 BriceZhao. All rights reserved.
//

#import "NSString+Json.h"

@implementation NSString (Json)

- (id)objectFromJSONString {
    
    NSError *error ;
    id jsonObj = [NSJSONSerialization JSONObjectWithData: [self dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
    if (error) {
        NSLog(@"Got an error: %@", error);
        return nil;
    }
    @try {
        if ([jsonObj isKindOfClass:[NSDictionary class]]) {
            jsonObj = [NSMutableDictionary dictionaryWithDictionary:jsonObj];
        }else if([jsonObj isKindOfClass:[NSArray class]])
            jsonObj = [NSArray arrayWithArray:jsonObj];
    }
    @catch (NSException *exception) {
        NSLog(@"error:%@",exception);
    }
    
    return jsonObj;
}

@end
