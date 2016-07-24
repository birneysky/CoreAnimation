//
//  ViewController.m
//  CoreAnimation
//
//  Created by birneysky on 16/6/23.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import "ViewController.h"
#import "CALayer+ZBAnimation.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[CATransaction setAnimationDuration:2.0];
    CALayer* squareLayer = [CALayer layer];
    
    squareLayer.backgroundColor = [[UIColor redColor] CGColor];
    
    squareLayer.frame = CGRectMake(100, 100, 20, 20);
    [self.view.layer addSublayer:squareLayer];
    
    UIView* squareView = [UIView new];
    squareView.backgroundColor = [UIColor blueColor];
    squareView.frame = CGRectMake(200, 100, 20, 20);
    [self.view addSubview:squareView];
    
    //[CATransaction begin];
    //[CATransaction setDisableActions:YES];
    //squareLayer.opacity = 0;
    //CABasicAnimation* fade = [CABasicAnimation animationWithKeyPath:@"opacity"];
    //fade.duration = 2.0;
    //fade.fromValue = @1.0;
    //fade.toValue = @0.0;
    //[squareLayer addAnimation:fade forKey:@"fade"];
    //[CATransaction commit];
    
    [squareLayer setValue:@(0.0) forKeyPath:@"opacity" duration:3.0 delay:0];
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(drop:)]];
}

- (void) viewDidAppear:(BOOL)animated
{
    
}
#pragma mark - *** Gesture Selector ***

- (void)drop:(UIGestureRecognizer*)recognizer
{
    [CATransaction begin];
    //[CATransaction setDisableActions:YES];
    [CATransaction setAnimationDuration:3];
    
    NSArray* layers = self.view.layer.sublayers;
    CALayer* layer = [layers objectAtIndex:2];
    [layer setPosition:CGPointMake(200, 250)];
    
    [CATransaction commit];
    
    NSArray* views = self.view.subviews;
    
    UIView* view = [views objectAtIndex:2];
    [view setCenter: CGPointMake(100, 250)];
    
    
    
}


@end
