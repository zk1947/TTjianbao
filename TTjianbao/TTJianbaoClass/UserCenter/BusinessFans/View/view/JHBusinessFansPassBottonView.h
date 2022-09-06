//
//  JHBusinessFansPassBottonView.h
//  TTjianbao
//
//  Created by user on 2021/3/19.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHBusinessFansPassBottonView : UIView
@property (nonatomic, strong) UIButton         *nextButton;
@property (nonatomic,   copy) dispatch_block_t  clickBlock;
@property (nonatomic, assign) BOOL              isApplying;
- (void)setupViews;
@end



NS_ASSUME_NONNULL_END
