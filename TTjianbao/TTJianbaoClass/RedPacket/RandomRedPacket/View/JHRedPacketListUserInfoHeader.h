//
//  JHRedPacketListUserInfoHeader.h
//  TTjianbao
//
//  Created by apple on 2020/1/9.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHBaseListView.h"
NS_ASSUME_NONNULL_BEGIN
/// 红包弹层用户信息头
@interface JHRedPacketListUserInfoHeader : JHBaseTableViewHeaderFooterView

@property (nonatomic, strong) UIImageView *avatorView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *descLabel;

@property (nonatomic, strong) UIView *bgViewBottom;

@end

NS_ASSUME_NONNULL_END
