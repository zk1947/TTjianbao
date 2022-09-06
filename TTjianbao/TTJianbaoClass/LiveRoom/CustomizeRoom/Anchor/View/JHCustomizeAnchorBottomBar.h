//
//  JHCustomizeAnchorBottomBar.h
//  TTjianbao
//
//  Created by apple on 2020/9/14.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHDoteNumberLabel.h"
NS_ASSUME_NONNULL_BEGIN
@protocol JHCustomizeAnchorBottomBarDelegate <NSObject>

@optional

- (void)sceneAction:(UIButton *)sender;
- (void)customorderListAction:(UIButton *)sender;
- (void)queueListAction:(UIButton *)sender;
- (void)soundAction:(UIButton *)sender;
- (void)playOrPauseAction:(UIButton *)sender;
- (void)noticeAction:(UIButton *)sender;
- (void)customclickListBtnAction:(UIButton *)btn Trailing:(CGFloat)trailing;
- (void)sayWhatBtnAction:(UIButton *)sender;
- (void)onShanGouBtnAction;
@end
@interface JHCustomizeAnchorBottomBar : UIView
@property(nonatomic,weak)id <JHCustomizeAnchorBottomBarDelegate>delegate;
@property (nonatomic,strong)UIButton *pauseBtn;//暂停button
@property (nonatomic,strong) JHDoteNumberLabel *doteLabel;//队列num
@property (nonatomic,strong) JHDoteNumberLabel *orderdoteLabel;//新订单num
-(instancetype)initWithType:(NSInteger)type;//1主播  2助理
@property (nonatomic, strong) ChannelMode *channel;
@property (nonatomic, copy) NSString *shopwindowButtonNum;  //购物橱窗字符串
@property (nonatomic, strong) UIButton *shopwindowButton;
@end

NS_ASSUME_NONNULL_END
