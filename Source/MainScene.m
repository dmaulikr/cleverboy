//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"
#import "Utils.h"

@implementation MainScene {
    CCLabelTTF* _score;
}

- (void) didLoadFromCCB {
    int bestScore = [Utils getIntValueBykey:@"BEST_SCORE_KEY"];
    _score.string = [NSString stringWithFormat:@"Self best: %d", bestScore];
}

- (void)startGame {
    CCScene *newScene = [CCBReader loadAsScene:@"GameScene"];
    [[CCDirector sharedDirector] replaceScene:newScene];
    return;
}

@end

