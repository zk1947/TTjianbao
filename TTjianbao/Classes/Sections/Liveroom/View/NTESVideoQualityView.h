//
//  NTESVideoQualityView.h
//  TTjianbao
//
//  Created by Simon Blue on 2017/5/18.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NTESLiveViewDefine.h"


@protocol NTESVideoQualityViewDelegate <NSObject>

@optional

-(void)onVideoQualitySelected:(NTESLiveQuality)type;

-(void)onVideoQualityViewCancelButtonPressed;

@end

@interface NTESVideoQualityView : UIControl

@property (nonatomic,weak) id<NTESVideoQualityViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame quality:(NTESLiveQuality)quality;

- (void)show;

- (void)dismiss;

@end
