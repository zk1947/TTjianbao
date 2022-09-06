//
//  JHFansTaskSectionHeaderView.h
//  TTjianbao
//
//  Created by jiangchao on 2021/3/16.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"
#import "JHBaseListView.h"
#import "UIView+CornerRadius.h"
#import "JHFansFreezView.h"
@class JHFansClubModel;
NS_ASSUME_NONNULL_BEGIN

@interface JHFansTaskSectionHeaderView : JHBaseTableViewHeaderFooterView
@property (nonatomic, strong) NSString * currentTime;

@property (nonatomic, strong) JHFansClubModel * fansClubModel;

@property(nonatomic, strong) JHFansFreezView * freezView;

@end

NS_ASSUME_NONNULL_END
