//
//  CircleLayer.m
//  CoreAnimation
//
//  Created by birneysky on 16/7/26.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import "CircleLayer.h"
#import <UIKit/UIKit.h>

@implementation CircleLayer
@dynamic radius;

- (instancetype) init{
    if (self = [super init]) {
        [self setNeedsDisplay];
    }
    return self;
}

- (void) drawInContext:(CGContextRef)ctx
{
   CGContextSetFillColorWithColor(ctx, [UIColor redColor].CGColor);

    CGFloat radius = self.radius;
    CGRect rect;
    rect.size = CGSizeMake(radius, radius);
    
    rect.origin.x = (self.bounds.size.width - radius) / 2;
    rect.origin.y = (self.bounds.size.height - radius) / 2;
    CGContextAddEllipseInRect(ctx, rect);
    CGContextFillPath(ctx);
}

+ (BOOL)needsDisplayForKey:(NSString *)key
{
    if ([key isEqualToString:@"radius"]) {
        return YES;
    }
    return [super needsDisplayForKey:key];
}

- (id<CAAction>) actionForKey:(NSString *)key
{
    if ([self presentationLayer] != nil) {
        if ([key isEqualToString:@"radius"]) {
            CABasicAnimation* anim = [CABasicAnimation animationWithKeyPath:@"radius"];
            anim.fromValue = [self.presentationLayer valueForKey:@"radius"];
            return anim;
        }
    }
    return [super actionForKey:key];
}

@end
