//
//  UIView+Genie.h
//  BCGenieEffect
//
//  Created by Bartosz Ciechanowski on 23.12.2012.
//  Copyright (c) 2012 Bartosz Ciechanowski. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, BCRectEdge) {
    BCRectEdgeTop    = 0,
    BCRectEdgeLeft   = 1,
    BCRectEdgeBottom = 2,
    BCRectEdgeRight  = 3
};

@interface UIView (Genie)

/*
 * After the animation has completed the view's transform will be changed to match the destination's rect, i.e.
 * view's transform (and thus the frame) will change, however the bounds and center will *not* change.
 */

- (void)genieInTransitionWithDuration:(NSTimeInterval)duration
                      destinationRect:(CGRect)destRect
                      destinationEdge:(BCRectEdge)destEdge
                           completion:(void (^)())completion;



/*
 * After the animation has completed the view's transform will be changed to CGAffineTransformIdentity.
 */

- (void)genieOutTransitionWithDuration:(NSTimeInterval)duration
                             startRect:(CGRect)startRect
                             startEdge:(BCRectEdge)startEdge
                            completion:(void (^)())completion;

@end

/*
 
 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
     UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(ScreenW - 30, ScreenH - 130, 30, 30)];
     [self.view addSubview:bottomView];
     bottomView.backgroundColor = UIColor.blackColor;
     
     UIView *animalView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 400)];
     [self.view addSubview:animalView];
     animalView.backgroundColor = UIColor.redColor;
     [animalView genieInTransitionWithDuration:0.4 destinationRect:bottomView.frame destinationEdge:BCRectEdgeTop completion:^{
         NSLog(@"🔥");
     }];
 });
 */
