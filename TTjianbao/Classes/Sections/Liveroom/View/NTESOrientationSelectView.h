//
//  NTESOrientationSelectView.h
//  TTjianbao
//
//  Created by Simon Blue on 17/3/27.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NTESOrientationSelectViewDelegate <NSObject>

-(void)onHorizontalScreenButtonSelected;

-(void)onVerticalScreenButtonSelected;

-(BOOL)interactionDisabled;

@end

#import "BaseView.h"

@interface NTESOrientationSelectView : BaseView

@property (nonatomic,weak) id<NTESOrientationSelectViewDelegate> delegate;

@end
