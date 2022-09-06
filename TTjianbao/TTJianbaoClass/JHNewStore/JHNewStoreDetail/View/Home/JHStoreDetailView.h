//
//  JHStoreDetailView.h
//  TTjianbao
//
//  Created by 韩啸 on 2021/2/2.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//  Describe : 商品详情页（tableview）

#import <UIKit/UIKit.h>
#import "JHStoreDetailViewModel.h"
#import "JHStoreDetailHeaderView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHStoreDetailView : UIView
@property (nonatomic, strong) JHStoreDetailViewModel *viewModel;
@property (nonatomic, strong) RACSubject *scrollSubject;
/// 表头
@property (nonatomic, strong) JHStoreDetailHeaderView *headerView;
/// 商品ID
@property (nonatomic, copy) NSString *productId;

/// 缩略模式
@property(nonatomic) BOOL  shotScreen;

- (void)scrollToIndex:(NSUInteger)index  andTitle:(NSString*)title;

- (void)viewDidAppear;
@end

NS_ASSUME_NONNULL_END
