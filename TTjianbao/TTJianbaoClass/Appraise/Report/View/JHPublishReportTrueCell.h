//
//  JHPublishReportTrueCell.h
//  TTjianbao
//
//  Created by wangjianios on 2021/3/3.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBaseListView.h"

NS_ASSUME_NONNULL_BEGIN

@class JHReportCatePropertyModel;

@interface JHPublishReportTrueCell : JHWBaseTableViewCell

///输入估价
@property (nonatomic, weak) UITextField *priceTf;

@property (nonatomic, copy) void (^priceBlock) (NSString *price);

@property (nonatomic, strong) NSMutableArray <JHReportCatePropertyModel *> *subCateArray;
@end

NS_ASSUME_NONNULL_END
