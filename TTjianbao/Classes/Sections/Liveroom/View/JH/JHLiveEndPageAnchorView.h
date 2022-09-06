//
//  JHLiveEndPageAnchorView.h
//  TTjianbao
//
//  Created by jiangchao on 2019/6/20.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ChannelMode;
//typedef void(^AnchorPressBlock)(ChannelMode * mode);
@interface JHLiveEndPageAnchorView : UIControl
//@property(strong,nonatomic)ChannelMode * mode;
//@property(strong,nonatomic)AnchorPressBlock block;
@property(nonatomic,strong) ChannelMode* liveRoomMode;
@property (nonatomic, strong) JHActionBlock selectedCell;
@property (nonatomic, strong) UIView *content;
@property(nonatomic, strong)void(^clickButton)(UIButton* button,ChannelMode * mode);
@end

NS_ASSUME_NONNULL_END
