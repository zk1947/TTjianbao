//
//  JHCommBubbleTipView.h
//  TTjianbao
//
//  Created by jiangchao on 2020/12/5.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHCommBubbleTipView : UIView
@property (nonatomic, strong) UILabel *titleLabel;
@property(nonatomic,strong)UIImageView *bgImageView;
@property(nonatomic,copy)JHFinishBlock  clickHandle;
-(void)creatSendOrderBubble;
-(void)creatTTCustomizeBubble;
-(void)creatSellMarketBubble;
@end

NS_ASSUME_NONNULL_END
