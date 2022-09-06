//
//  JHStoneDetailStoneChangeCell.h
//  TTjianbao
//
//  Created by apple on 2019/12/24.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHBaseListView.h"
@class CStoneChangeListData;
NS_ASSUME_NONNULL_BEGIN

@interface JHStoneDetailStoneChangeCell : JHWBaseTableViewCell

@property (nonatomic, strong) CStoneChangeListData *model;

@end

@interface JHStoneDetailStoneChangeImageView : UIImageView

@end

NS_ASSUME_NONNULL_END
