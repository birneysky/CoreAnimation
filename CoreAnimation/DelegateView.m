//
//  DelegateView.m
//  CoreAnimation
//
//  Created by birneysky on 16/7/7.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import "DelegateView.h"

@implementation DelegateView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self.layer setNeedsDisplay];
        [self.layer setContentsScale:[[UIScreen mainScreen] scale]];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self.layer setNeedsDisplay];
        [self.layer setContentsScale:[[UIScreen mainScreen] scale]];
    }
    return self;
}


- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
{
    UIGraphicsPushContext(ctx);
    
    [[UIColor redColor] set];
    UIRectFill(layer.bounds);
    
    UIFont* font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    UIColor* color = [UIColor blackColor];
    
    
    NSMutableParagraphStyle* style = [[NSMutableParagraphStyle alloc] init];
    [style setAlignment:NSTextAlignmentCenter];
    
    NSDictionary* atrribs = @{NSFontAttributeName: font,
                              NSForegroundColorAttributeName: color,
                              NSParagraphStyleAttributeName: style};
    
    NSAttributedString* text = [[NSAttributedString alloc] initWithString:@"Push the Limits" attributes:atrribs];
    NSLog(@"bouns %@, inset %@",NSStringFromCGRect(layer.bounds),NSStringFromCGRect(CGRectInset(layer.bounds, 10, 20)));
    [text drawInRect:CGRectInset(layer.bounds, 10, 20)];
    
    UIGraphicsPopContext();
}

@end
