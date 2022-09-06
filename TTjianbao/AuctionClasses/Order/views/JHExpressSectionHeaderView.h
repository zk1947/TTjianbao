//
//  JHExpressSectionHeaderView.h
//  TTjianbao
//
//  Created by jiangchao on 2021/2/26.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseView.h"
#import "JHBaseListView.h"
#import "UIView+CornerRadius.h"
#import "ExpressMode.h"
#import "JHOrderExpressViewMode.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHExpressSectionHeaderView : JHBaseTableViewHeaderFooterView
@property (nonatomic, assign)  JHExpressSectionType  cellType;
@property (nonatomic, strong)  ExpressVo*platSendExpressVo;//平台发货物流信息
@end

NS_ASSUME_NONNULL_END
