//
//  CALayer+ZBAnimation.h
//  CoreAnimation
//
//  Created by birneysky on 16/7/23.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CALayer (ZBAnimation)

- (void)setValue:(id)value
      forKeyPath:(NSString *)keyPath
        duration:(CFTimeInterval)duration
           delay:(CFTimeInterval)delay;
@end
