//
//  BoxTransformViewController.m
//  CoreAnimation
//
//  Created by birneysky on 16/7/25.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import "BoxTransformViewController.h"

@interface BoxTransformViewController ()

@property (nonatomic,strong) CATransformLayer* contentLayer;

@property (nonatomic,strong) CALayer* topLayer;
@property (nonatomic,strong) CALayer* bottomLayer;
@property (nonatomic,strong) CALayer* leftLayer;
@property (nonatomic,strong) CALayer* rightLayer;
@property (nonatomic,strong) CALayer* frontLayer;
@property (nonatomic,strong) CALayer* backLayer;

@end

static CATransform3D MakeSideRotation(CGFloat x, CGFloat y, CGFloat z)
{
    return CATransform3DMakeRotation(M_PI_2, x, y, z);
}

@implementation BoxTransformViewController

const CGFloat kBoxSize = 100.0;
const CGFloat kBoxPanScale = 1.0 / 100;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CATransformLayer* contentLayer = [CATransformLayer layer];
    contentLayer.frame = self.view.layer.bounds;
    CGSize size = contentLayer.bounds.size;
    contentLayer.transform = CATransform3DMakeTranslation(size.width / 2, size.height / 2, 0);
    [self.view.layer addSublayer:contentLayer];
    
    self.contentLayer = contentLayer;
    
    self.topLayer = [self layerAtX:0 y:-kBoxSize / 2 z:0 color:[UIColor redColor] transform:MakeSideRotation(1, 0, 0)];
    
    self.topLayer = [self layerAtX:0 y:-kBoxSize/2 z:0
                             color:[UIColor redColor]
                         transform:MakeSideRotation(1, 0, 0)];
    
    self.bottomLayer = [self layerAtX:0 y:kBoxSize/2 z:0
                                color:[UIColor greenColor]
                            transform:MakeSideRotation(1, 0, 0)];
    
    self.rightLayer = [self layerAtX:kBoxSize/2 y:0 z:0
                               color:[UIColor blueColor]
                           transform:MakeSideRotation(0, 1, 0)];
    
    self.leftLayer = [self layerAtX:-kBoxSize/2 y:0 z:0
                              color:[UIColor cyanColor]
                          transform:MakeSideRotation(0, 1, 0)];
    
    self.backLayer = [self layerAtX:0 y:0 z:-kBoxSize/2
                              color:[UIColor yellowColor]
                          transform:CATransform3DIdentity];
    
    self.frontLayer = [self layerAtX:0 y:0 z:kBoxSize/2
                               color:[UIColor magentaColor]
                           transform:CATransform3DIdentity];
    
    UIGestureRecognizer *g = [[UIPanGestureRecognizer alloc]
                              initWithTarget:self
                              action:@selector(pan:)];
    [self.view addGestureRecognizer:g];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - *** Gesture Action ***
- (void)pan:(UIPanGestureRecognizer *)recognizer {
    CGPoint translation = [recognizer translationInView:self.view];
    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DRotate(transform,
                                    kBoxPanScale * translation.x,
                                    0, 1, 0);
    transform = CATransform3DRotate(transform,
                                    -kBoxPanScale * translation.y,
                                    1, 0, 0);
    self.view.layer.sublayerTransform = transform;
}
#pragma mark - *** Helper ***

- (CALayer*) layerAtX:(CGFloat)x
                    y:(CGFloat)y
                    z:(CGFloat)z
                color:(UIColor*)color
            transform:(CATransform3D)transform
{
    CALayer* layer = [CALayer layer];
    layer.backgroundColor = color.CGColor;
    layer.bounds = CGRectMake(0, 0, kBoxSize, kBoxSize);
    layer.position = CGPointMake(x, y);
    layer.zPosition = z;
    layer.transform = transform;
    [self.contentLayer addSublayer:layer];
    
    return layer;
}

@end
