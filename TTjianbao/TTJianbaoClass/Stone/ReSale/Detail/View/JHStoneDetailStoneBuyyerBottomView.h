//
//  JHStoneDetailStoneBuyyerBottomView.h
//  TTjianbao
//
//  Created by apple on 2019/12/28.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHStoneDetailStoneBuyyerBottomView : UIView

@property (nonatomic, strong) UIImageView *avatorView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *priceLabel;

@property (nonatomic, strong) UIButton *explainButton;

@property (nonatomic, copy) dispatch_block_t clickIntoLiveRoomBlock;

+(CGFloat)viewHeight;

@end

NS_ASSUME_NONNULL_END
