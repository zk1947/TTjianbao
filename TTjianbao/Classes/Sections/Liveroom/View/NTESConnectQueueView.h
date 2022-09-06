//
//  NTESConnectQueueView.h
//  TTjianbao
//
//  Created by chris on 16/7/25.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NTESMicConnector;

@protocol NTESConnectQueueViewDelegate <NSObject>

- (void)onSelectMicConnector:(NTESMicConnector *)connector;

@end

@interface NTESConnectQueueView : UIControl

@property (nonatomic, weak) id<NTESConnectQueueViewDelegate> delegate;

- (void)refreshWithQueue:(NSArray<NTESMicConnector *> *)queue;

- (void)show;

- (void)dismiss;

@end
