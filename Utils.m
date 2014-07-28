//
//  Utils.m
//  CleverBoy
//
//  Created by Renzhong Wei on 2014/07/26.
//  Copyright (c) 2014年 Apportable. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+ (id) getValueByKey:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] stringForKey:key];
}

+ (BOOL) setValueByKey:(NSString *)key andValue:(id)value {
    id oldValue =
    [[NSUserDefaults standardUserDefaults] stringForKey:key];
    if ([value isEqual:oldValue]) {
        return YES;
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
        return [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (int) getIntValueBykey:(NSString *)key {
    id value = [Utils getValueByKey:key];
    if (value == nil) {
        return 0;
    } else {
        return [value intValue];
    }
}

+ (BOOL) setIntValueByKey:(NSString *)key andValue:(int)value {
    id nsValue = [NSNumber numberWithInt:value];
    
    return [Utils setValueByKey:key andValue:nsValue];
}

@end
