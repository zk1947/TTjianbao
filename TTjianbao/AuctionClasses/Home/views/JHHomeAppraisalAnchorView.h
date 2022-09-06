//
//  JHHomeAppraisalAnchorView.h
//  TTjianbao
//
//  Created by jiangchao on 2019/2/22.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHLiveRoomMode.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHHomeAppraisalAnchorView : UIControl
@property(nonatomic,strong) JHLiveRoomMode* liveRoomMode;
@property (nonatomic, strong) JHActionBlock selectedCell;
@property (nonatomic, strong) UIView *content;
@property(nonatomic, strong)void(^clickButton)(UIButton* button,JHLiveRoomMode * mode);
@end

NS_ASSUME_NONNULL_END
