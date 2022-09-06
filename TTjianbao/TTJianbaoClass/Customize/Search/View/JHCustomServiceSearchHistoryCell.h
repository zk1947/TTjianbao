//
//  JHJHCustomServiceSearchHistoryCell.h
//  TTjianbao
//
//  Created by wangjianios on 2020/9/24.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHBaseListView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHCustomServiceSearchHistoryCell : JHBaseCollectionViewCell


@property (nonatomic, weak) UILabel *wordLabel;

@end

@interface JHCustomServiceSearchHistoryHeader : JHBaseCollectionReusableView

@property (nonatomic, copy) dispatch_block_t deleteBlock;

@property (nonatomic, assign) BOOL contentHidden;

@end

@interface JHCustomServiceSearchHistoryFooter : JHBaseCollectionReusableView

@end

NS_ASSUME_NONNULL_END
