//
//  JHStoreSnapShootDetailView.h
//  TTjianbao
//
//  Created by jiangchao on 2021/2/23.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHStoreSnapShootViewModel.h"
#import "JHStoreDetailHeaderView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHStoreSnapShootDetailView : UIView
@property (nonatomic, strong) JHStoreSnapShootViewModel *viewModel;
@property (nonatomic, strong) RACSubject *scrollSubject;
/// 表头
@property (nonatomic, strong) JHStoreDetailHeaderView *headerView;
/// 商品ID
@property (nonatomic, copy) NSString *productId;
- (void)scrollToTop;
- (void)scrollToSpec;
- (void)viewDidAppear;
@end

NS_ASSUME_NONNULL_END
