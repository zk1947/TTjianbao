//
//  JHConnetcMicDetailView.h
//  TTjianbao
//
//  Created by jiangchao on 2018/12/28.
//  Copyright © 2018 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NTESMicConnector.h"

@class ChannelMode;
@protocol JHConnetcMicDetailViewDelegate <NSObject>
@optional
- (void)refuseAppraisal:(NTESMicConnector *) connector;
- (void)onComplete;
@end
typedef void(^completeBlock)(NSString *string);
@interface JHConnetcMicDetailView : UIControl

@property (nonatomic, weak) id<JHConnetcMicDetailViewDelegate> delegate;

@property (nonatomic, assign) NIMNetCallMediaType type;

@property (nonatomic, copy) NSString *roomId;
@property (nonatomic, copy) ChannelMode * channel;
@property (nonatomic, copy) NTESMicConnector * connector;

- (instancetype)initWithFrame:(CGRect)frame anchorLiveType:(NSInteger)type;
- (void)show;
- (void)dismiss;


-(void)withCompleteClick:(completeBlock)block;

@end



