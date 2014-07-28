//
//  Configure.m
//  CleverBoy
//
//  Created by Renzhong Wei on 2014/07/26.
//  Copyright (c) 2014年 Apportable. All rights reserved.
//

#import "Configure.h"

@implementation Configure

+ (int)getNumberByLevel:(int)level {
    if (level == 0) return 1;
    if (level == 1) return 2;
    if (level == 2) return 3;
    
    int pre = 2;
    int next = 3;
    for (int i = 2; i < level; i++) {
        int temp = next;
        next = pre + next;
        pre = temp;
    }
    return next;
}

@end
