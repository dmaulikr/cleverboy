//
//  Utils.h
//  CleverBoy
//
//  Created by Renzhong Wei on 2014/07/26.
//  Copyright (c) 2014年 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject

+ (id) getValueByKey:(NSString *)key;

+ (BOOL) setValueByKey:(NSString *)keu andValue:(id)value;

+ (int) getIntValueBykey:(NSString *)key;

+ (BOOL) setIntValueByKey:(NSString *)key andValue:(int)value;

@end
