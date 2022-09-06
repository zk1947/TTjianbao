//
//  JHNewShopUserCommentViewController.h
//  TTjianbao
//
//  Created by haozhipeng on 2021/2/3.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXPagerView.h"
#import "JHNewShopDetailInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHNewShopUserCommentViewController : UIViewController<JXPagerViewListViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) JHNewShopDetailInfoModel *shopInfoModel;

@end

NS_ASSUME_NONNULL_END
