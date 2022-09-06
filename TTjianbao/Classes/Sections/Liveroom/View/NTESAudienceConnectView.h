//
//  NTESAudienceConnectView.h
//  TTjianbao
//
//  Created by chris on 16/7/21.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NTESLiveViewDefine.h"

@protocol NTESAudienceConnectDelegate <NSObject>

- (void)onCancelConnect:(id)sender;

@end

@interface NTESAudienceConnectView : UIControl

@property (nonatomic, weak) id<NTESAudienceConnectDelegate> delegate;

@property (nonatomic, assign) NIMNetCallMediaType type;

@property (nonatomic, copy) NSString *roomId;

- (void)show;

- (void)dismiss;

@end
