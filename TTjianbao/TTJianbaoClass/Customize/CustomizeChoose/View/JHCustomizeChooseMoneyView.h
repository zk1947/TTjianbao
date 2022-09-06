//
//  JHCustomizeChooseMoneyView.h
//  TTjianbao
//
//  Created by user on 2020/11/23.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHCustomizeChooseMoneyView : UIView
@property (nonatomic, copy) void(^showAllActionBlock)(BOOL needShowAll, CGFloat height);
- (void)setViewModel:(id)viewModel;
@end

NS_ASSUME_NONNULL_END
