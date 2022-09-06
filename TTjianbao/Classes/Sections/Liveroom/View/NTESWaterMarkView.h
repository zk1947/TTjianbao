//
//  NTESWaterMarkView.h
//  TTjianbao
//
//  Created by Simon Blue on 2017/5/19.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NTESLiveViewDefine.h"

@protocol NTESWaterMarkViewDelegate <NSObject>

- (void)onWaterMarkCancelButtonPressed;

- (void)onWaterMarkTypeSelected:(NTESWaterMarkType)type;

@end

@interface NTESWaterMarkView : UIControl

@property (nonatomic,weak) id<NTESWaterMarkViewDelegate> delegate;

- (void)show;

- (void)dismiss;

- (void)reset;

@end
