//
//  CALayer+ZBAnimation.m
//  CoreAnimation
//
//  Created by birneysky on 16/7/23.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import "CALayer+ZBAnimation.h"

@implementation CALayer (ZBAnimation)

- (void)setValue:(id)value
      forKeyPath:(NSString *)keyPath
        duration:(CFTimeInterval)duration
           delay:(CFTimeInterval)delay
{
    [CATransaction begin];
    
    [CATransaction setDisableActions:YES];
    
    [self setValue:value forKeyPath:keyPath];
    
    CABasicAnimation* anim = [CABasicAnimation animationWithKeyPath:keyPath];
    anim.duration = duration;
    anim.beginTime = CACurrentMediaTime() + delay;
    anim.fillMode = kCAFillModeBoth;
    anim.fromValue = [[self presentationLayer] valueForKey:keyPath];
    anim.toValue = value;
    [self addAnimation:anim forKey:keyPath];
    
    [CATransaction commit];
}

@end
