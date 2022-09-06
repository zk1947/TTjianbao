//
//  JHIdentDetailsIntroduceCell.h
//  TTjianbao
//
//  Created by miao on 2021/6/18.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBaseListView.h"
@class JHIdentificationDetailsModel;

NS_ASSUME_NONNULL_BEGIN

@interface JHIdentDetailsIntroduceCell : JHWBaseTableViewCell

/// 设置数据
@property (nonatomic, strong) JHIdentificationDetailsModel *introduceModel;

@end

NS_ASSUME_NONNULL_END
