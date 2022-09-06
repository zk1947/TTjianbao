//
//  NTESInteractSelectView.h
//  TTjianbao
//
//  Created by chris on 16/7/19.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NTESLiveViewDefine.h"

@protocol NTESInteractSelectDelegate <NSObject>

- (void)onSelectInteractType:(NIMNetCallMediaType)type;

@end

@interface NTESInteractSelectView : UIControl

@property (nonatomic, copy) NSArray<NSNumber *> *types;

@property (nonatomic, weak) id<NTESInteractSelectDelegate> delegate;

- (void)show;

- (void)dismiss;

@end
