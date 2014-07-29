//
//  Answer.m
//  CleverBoy
//
//  Created by Renzhong Wei on 2014/07/26.
//  Copyright (c) 2014年 Apportable. All rights reserved.
//

#import "Answer.h"

static const double PERCENT = 0.3;

@implementation Answer {
    CCLabelTTF * _number;
    int number;
}

- (void) didLoadFromCCB {
    self.physicsBody.collisionType = @"answer";
    number = 0;
}

- (void)setupWithCenterValue:(int) value{
    CGSize size = [[CCDirector sharedDirector] viewSize];
    [self setAnchorPoint:ccp(0.5,0)];
    [self setPosition:ccp(random() % (int)size.width, (int)size.height)];
    
    number = [Answer generateNumber:value];
    
    _number.string = [Answer generateString:number];
}

- (int)number {
    return number;
}

+ (int)generateNumber:(int)center {
    if (center < 3) {
        return rand() % 6;
    }else if (center < 6) {
        return rand() % 10;
    } else {
        int value = center + rand() % (int)(center * 2 * PERCENT) - (int)(center * PERCENT);
        return value > 0 ? value : 0;
    }
}

+ (NSString *)generateString:(int)value {
    return [NSString stringWithFormat:@"%d", value];
}

@end
