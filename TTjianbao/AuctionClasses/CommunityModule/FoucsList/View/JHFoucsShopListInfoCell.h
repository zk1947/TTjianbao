//
//  JHFoucsShopListInfoCell.h
//  TTjianbao
//
//  Created by apple on 2020/2/13.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHBaseListView.h"
#import "JHFoucsShopModel.h"

@class JHSellerInfo;
NS_ASSUME_NONNULL_BEGIN
/// 我关注的人信息
@interface JHFoucsShopListInfoCell : JHWBaseTableViewCell

@property (nonatomic, strong) JHFoucsShopInfo *model;

@end

NS_ASSUME_NONNULL_END
