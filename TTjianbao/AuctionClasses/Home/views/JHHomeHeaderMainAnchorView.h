//
//  JHHomeHeaderMainAnchorView.h
//  TTjianbao
//
//  Created by jiangchao on 2019/4/15.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHLiveRoomMode.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHHomeHeaderMainAnchorView : UIControl
@property(nonatomic,strong) JHLiveRoomMode* liveRoomMode;
@property (nonatomic, strong) JHActionBlock selectedCell;
@property (nonatomic, strong) UIView *content;
@property(nonatomic, strong)void(^clickButton)(UIButton* button,JHLiveRoomMode * mode);

- (void)refreshThemeView:(BOOL)isActiveTheme;
@end

NS_ASSUME_NONNULL_END
