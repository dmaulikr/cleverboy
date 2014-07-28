//
//  GameScene.m
//  CleverBoy
//
//  Created by Renzhong Wei on 2014/07/26.
//  Copyright (c) 2014年 Apportable. All rights reserved.
//

#import "GameScene.h"
#import "Answer.h"
#import "Utils.h"
#import "Configure.h"

static NSString * BEST_SCORE_KEY = @"BEST_SCORE_KEY";

@implementation GameScene {
    // numbers to show
    CCLabelTTF * _num1;
    CCLabelTTF * _num2;
    CCLabelTTF * _num3;
    CCLabelTTF * _num4;
    CCLabelTTF * _gameOver;
    CCButton * _restart;
    CCButton * _quit;
    
    int levelFilter;
    int levelAddPoint;
    int levelThreshold;
    int num1, num2, num3, num4, correctAnswer;
    
    // score to show
    CCLabelTTF * _score;
    int score;
    
    // best score to show
    CCLabelTTF * _bestScore;
    int bestScore;
    int originBestScore;
    
    // level
    CCLabelTTF * _level;
    int level;
    
    // physical node
    CCPhysicsNode * _physicsNode;
    CCSprite* _ground;
    
    // balls
    NSMutableArray *_numbers;
    
    // time
    NSTimeInterval sinceTime;
    
    BOOL gameOver;
}

- (void) didLoadFromCCB {
    NSLog(@"game scene load success");
    self.userInteractionEnabled = TRUE;
    _gameOver.visible = NO;
    _restart.visible = NO;
    _restart.enabled = NO;
    _quit.visible = NO;
    _quit.enabled = NO;
    _bestScore.visible = NO;
    
    // set best score
    //[Utils setIntValueByKey:BEST_SCORE_KEY andValue:0];
    
    bestScore = [Utils getIntValueBykey:BEST_SCORE_KEY];
    originBestScore = bestScore;
    [self updateBestScore:bestScore];
    [self updateScore:0];
    [self updateLevel:1];


    [self updateNumberByLevel:level];
    
    // for collision
    _physicsNode.collisionDelegate = self;
    [_ground.physicsBody setCollisionType:@"ground"];
    //reset time
    sinceTime = 0;
    
    _numbers = [NSMutableArray array];
    
    gameOver = NO;
}

- (void) update: (CCTime)delta {
    if (gameOver) return;
    
    sinceTime += delta;
    
    if (sinceTime > 0.5f) {
        [self addAnswerObject];
        sinceTime = 0;
    }
}


- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    NSLog(@"Received a touch: %d", [_numbers count]);
    CGPoint location = [touch locationInNode:self];
    
    for (Answer *station in _numbers)
    {
        if (CGRectContainsPoint(station.boundingBox, location) && [station number] == correctAnswer)
        {
            [self generateEffect:@"CorrectEffect" position:station.position];
            score = score + levelAddPoint;
            [self updateScore:score];
            if (score > bestScore) {
                [self updateBestScore:score];
            }
            if (score > levelThreshold) {
                [self upgrade];
            }
            [self updateNumberByLevel:level];
            
            [_numbers removeObject:station];
            [station removeFromParent];
            break;
        } else if (CGRectContainsPoint(station.boundingBox, location)) {
            [self generateEffect:@"FailEffect" position:station.position];
            score = score - levelAddPoint;
            [self updateScore:score];
            
            [self updateNumberByLevel:level];
            [_numbers removeObject:station];
            [station removeFromParent];
            break;
        }
    }
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair answer:(Answer *)answer ground:(CCNode *)ground {
    if ([answer number] == correctAnswer) {
        [self generateEffect:@"FailEffect" position:answer.position];
        [self updateScore:score - 1];
        [self updateNumberByLevel:level];
    }
    
    [_numbers removeObject:answer];
    [answer removeFromParent];
    return TRUE;
}

//// private

- (void) addAnswerObject {
    Answer *newAnswer = (Answer *)[CCBReader load:@"Answer" ];
    
    [newAnswer setupWithCenterValue:correctAnswer];

    [_physicsNode addChild:newAnswer];
    [_numbers addObject:newAnswer];
}

- (void) updateScore:(int)uscore {
    score = uscore;
    
    _score.string = [NSString stringWithFormat:@"Score: %d", score];
    
    if (score < 0) {
        [self setGameOver];
        return;
    }

}

- (void) updateBestScore:(int)best_score {
    bestScore = best_score;
    
    // update user pref
    [Utils setIntValueByKey:BEST_SCORE_KEY andValue:bestScore];
    
    _bestScore.string = [NSString stringWithFormat:@"Best Updated: %d", bestScore];
}

- (void) updateNumberByLevel:(int)level {
    if (gameOver == YES) return;
    num1 = random() % levelFilter;
    num2 = random() % levelFilter;
    num3 = random() % levelFilter;
    num4 = random() % levelFilter;
    
    correctAnswer = num1 + num2 + num3 + num4;
    
    _num1.string = [NSString stringWithFormat:@"%d", num1];
    _num2.string = [NSString stringWithFormat:@"%d", num2];
    _num3.string = [NSString stringWithFormat:@"%d", num3];
    _num4.string = [NSString stringWithFormat:@"%d", num4];
}

- (void)updateLevel:(int)newLevel {
    level = newLevel;
    levelFilter = [Configure getNumberByLevel:level];
    levelThreshold = 2 * levelFilter;
    levelAddPoint = [Configure getNumberByLevel:level - 1];
    
    _level.string = [NSString stringWithFormat:@"Level %d", level];
}

- (void)upgrade {
    [self updateLevel:level + 1];
}

- (void)generateEffect:(NSString *)type position:(CGPoint)position {
    CCParticleSystem *explosion = (CCParticleSystem *)[CCBReader load:type];
    explosion.autoRemoveOnFinish = YES;
    explosion.position = position;

    [_physicsNode addChild:explosion];
}

-  (void)setGameOver {
    gameOver = YES;
    
    _gameOver.visible = YES;
    _restart.visible = YES;
    _restart.enabled = YES;
    _quit.visible = YES;
    _quit.enabled = YES;
    if (originBestScore < bestScore) {
        _bestScore.visible = YES;
    }
    self.userInteractionEnabled = NO;
}

- (void)restart {
    CCScene *scene = [CCBReader loadAsScene:@"GameScene"];
    [[CCDirector sharedDirector] replaceScene:scene];
}


- (void)quit {
    [[CCDirector sharedDirector] end];
}
@end
