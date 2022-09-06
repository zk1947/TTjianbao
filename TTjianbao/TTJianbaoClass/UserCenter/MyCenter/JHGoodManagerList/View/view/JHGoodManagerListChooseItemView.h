//
//  JHGoodManagerListChooseItemView.h
//  TTjianbao
//
//  Created by user on 2021/8/2.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHGoodManagerListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHGoodManagerListChooseItemView : UIView
@property (nonatomic, assign) BOOL isAuction;
- (void)setviewModel:(NSArray<JHGoodManagerListTabChooseModel *> *)viewModel;
@end

NS_ASSUME_NONNULL_END
