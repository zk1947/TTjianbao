//
//  JHAnchorStyleListViewController.h
//  TTjianbao
//
//  Created by Donto on 2020/7/6.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JXCategoryListContainerView.h"
#import "JHAnchorStyleListViewCell.h"
#import "JHBaseViewExtController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHAnchorStyleListViewController : JHBaseViewExtController <JXCategoryListContentViewDelegate,JHAnchorStyleListViewCellDelegate>

@property (nonatomic, strong) NSArray <JHRecommendAppraiserListItem *>*dataSource;
@property (nonatomic, copy) JHActionBlock selectCellBlock;
//! 申请鉴定回调
@property (nonatomic, copy) JHActionBlock applyAuthenticateBlock;

@property (nonatomic, copy) JHActionBlock refreshBlock;

@property (nonatomic, assign) CGFloat height;

-(void)reloadData;

@end

NS_ASSUME_NONNULL_END
