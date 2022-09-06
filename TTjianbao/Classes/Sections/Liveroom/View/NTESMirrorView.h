//
//  NTESMirrorView.h
//  TTjianbao
//
//  Created by Simon Blue on 2017/5/18.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NTESMirrorViewDelegate <NSObject>

- (void)onPreviewMirror:(BOOL)isOn;

- (void)onCodeMirror:(BOOL)isOn;

- (void)onMirrorCancelButtonPressed;

- (void)onMirrorConfirmButtonPressedWithPreviewMirror:(BOOL)isPreviewMirrorOn CodeMirror:(BOOL)isCodeMirrorOn;

@end


@interface NTESMirrorView : UIControl

@property (nonatomic,weak) id<NTESMirrorViewDelegate> delegate;

@property (nonatomic) BOOL isPreviewMirrorOn;

@property (nonatomic) BOOL isCodeMirrirOn;

- (void)setMirrorDisabled;

- (void)resetMirror;

- (void)show;

- (void)dismiss;

@end
