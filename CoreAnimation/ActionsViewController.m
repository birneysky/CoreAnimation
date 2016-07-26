//
//  ActionsViewController.m
//  CoreAnimation
//
//  Created by birneysky on 16/7/26.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import "ActionsViewController.h"
#import "CircleLayer.h"

@interface ActionsViewController ()

@end

@implementation ActionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CircleLayer *circleLayer = [CircleLayer new];
    circleLayer.radius = 20;
    circleLayer.frame = self.view.bounds;
    [self.view.layer addSublayer:circleLayer];
    
    CABasicAnimation *anim = [CABasicAnimation
                              animationWithKeyPath:@"position"];
    anim.duration = 2;
    NSMutableDictionary *actions = [NSMutableDictionary
                                    dictionaryWithDictionary:
                                    [circleLayer actions]];
    actions[@"position"] = anim;
    
    CABasicAnimation *fadeAnim = [CABasicAnimation
                                  animationWithKeyPath:@"opacity"];
    fadeAnim.fromValue = @0.4;
    fadeAnim.toValue = @1.0;
    
    CABasicAnimation *growAnim = [CABasicAnimation
                                  animationWithKeyPath:
                                  @"transform.scale"];
    growAnim.fromValue = @0.8;
    growAnim.toValue = @1.0;
    
    CAAnimationGroup *groupAnim = [CAAnimationGroup animation];
    groupAnim.animations = @[fadeAnim, growAnim];
    
    actions[kCAOnOrderIn] = groupAnim;
    
    circleLayer.actions = actions;
    
    UIGestureRecognizer *g = [[UITapGestureRecognizer alloc]
                              initWithTarget:self
                              action:@selector(tap:)];
    [self.view addGestureRecognizer:g];
}

- (void)tap:(UIGestureRecognizer *)recognizer {
    //NSArray* subLayers = self.view.layer.sublayers;
    CircleLayer *circleLayer =
    (CircleLayer*)(self.view.layer.sublayers)[2];
    //circleLayer.position = CGPointMake(100, 100);
    [CATransaction setAnimationDuration:0.25];
    if (circleLayer.radius > self.view.bounds.size.width / 2) {
        circleLayer.radius -= 50;
    }
    else if(circleLayer.radius < 50){
        circleLayer.radius += 50;
    }
    else{
        circleLayer.radius += 50;
    }
    
}

@end
