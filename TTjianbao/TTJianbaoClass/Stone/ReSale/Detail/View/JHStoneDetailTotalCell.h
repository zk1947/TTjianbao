//
//  JHStoneDetailTotalCell.h
//  TTjianbao
//
//  Created by apple on 2019/12/24.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHBaseListView.h"

NS_ASSUME_NONNULL_BEGIN

/// 原石回血 统计
@interface JHStoneDetailTotalCell : JHWBaseTableViewCell

-(void)setOriPrice:(CGFloat)oriPrice
       expectPrice:(CGFloat)expectPrice
       actualPrice:(CGFloat)actualPrice
         sendCount:(NSInteger)sendCount;

@end

@interface JHStoneDetailTotalView : UIView

@end

NS_ASSUME_NONNULL_END
