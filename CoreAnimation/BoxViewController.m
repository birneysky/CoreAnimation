//
//  BoxViewController.m
//  CoreAnimation
//
//  Created by birneysky on 16/7/24.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import "BoxViewController.h"

@interface BoxViewController ()

@property (nonatomic,strong) CALayer* topLayer;
@property (nonatomic,strong) CALayer* bottomLayer;
@property (nonatomic,strong) CALayer* leftLayer;
@property (nonatomic,strong) CALayer* rightLayer;
@property (nonatomic,strong) CALayer* frontLayer;
@property (nonatomic,strong) CALayer* backLayer;

@end

@implementation BoxViewController

const CGFloat kSize = 100.0;
const CGFloat kPanScale = 1.0 / 100;

static CATransform3D MakePerspectiveTransform(){
    CATransform3D perspective = CATransform3DIdentity;
    perspective.m34 = -1.0 / 2000.;
    return perspective;
}

- (CALayer*) layerWithColor:(UIColor*)color
                  transform:(CATransform3D)transfrom
{
    CALayer* layer = [CALayer layer];
    layer.backgroundColor = [color CGColor];
    layer.bounds = CGRectMake(0, 0, kSize, kSize);
    layer.position = self.view.center;
    layer.transform = transfrom;
    [self.view.layer addSublayer:layer];
    return layer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CATransform3D transform;
    transform = CATransform3DMakeTranslation(0, -kSize / 2, 0);
    transform = CATransform3DRotate(transform, M_PI_2, 1.0, 0, 0);
    self.topLayer = [self layerWithColor:[UIColor redColor] transform:transform];
    
    transform = CATransform3DMakeTranslation(0, kSize / 2, 0);
    transform = CATransform3DRotate(transform, M_PI / 2, 1.01, 0, 0);
    self.bottomLayer = [self layerWithColor:[UIColor greenColor] transform:transform];
    
    transform = CATransform3DMakeTranslation(kSize / 2, 0, 0);
    transform = CATransform3DRotate(transform, M_PI_2, 0, 1, 0);
    self.rightLayer = [self layerWithColor:[UIColor blueColor] transform:transform];
    
    transform = CATransform3DMakeTranslation(-kSize / 2, 0, 0);
    transform = CATransform3DRotate(transform, M_PI_2, 0, 1, 0);
    self.leftLayer = [self layerWithColor:[UIColor cyanColor] transform:transform];
    
    transform = CATransform3DMakeTranslation(0, 0, -kSize / 2);
    transform = CATransform3DRotate(transform, M_PI_2, 0, 0, 0);
    self.backLayer = [self layerWithColor:[UIColor yellowColor] transform:transform];
    
    
    transform = CATransform3DMakeTranslation(0, 0, kSize / 2);
    transform = CATransform3DRotate(transform, M_PI_2, 0, 0, 0);
    self.frontLayer = [self layerWithColor:[UIColor magentaColor] transform:transform];
    
    self.view.layer.sublayerTransform = MakePerspectiveTransform();
    
    UIGestureRecognizer* gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self.view addGestureRecognizer:gesture];
    
}


- (void)pan:(UIPanGestureRecognizer*)recognizer{
    CGPoint translation = [recognizer translationInView:self.view];
    CATransform3D transform = MakePerspectiveTransform();
    transform = CATransform3DRotate(transform, kPanScale * translation.x, 0, 1, 0);
    transform = CATransform3DRotate(transform, -kPanScale * translation.y, 1, 0, 0);
    self.view.layer.sublayerTransform = transform;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
