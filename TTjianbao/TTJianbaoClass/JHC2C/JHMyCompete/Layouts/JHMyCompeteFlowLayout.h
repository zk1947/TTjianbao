//
//  JHMyCompeteFlowLayout.h
//  TTjianbao
//
//  Created by miao on 2021/6/10.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol JHMyCompeteFlowLayoutDelegate;

NS_ASSUME_NONNULL_BEGIN

@interface JHMyCompeteFlowLayout : UICollectionViewLayout

@property (nonatomic, weak)   id<JHMyCompeteFlowLayoutDelegate> delegate;
@property (nonatomic, assign) NSInteger columnCount;            // 每行多少个item 默认为 2
@property (nonatomic, assign) CGSize itemSpacing;           //item 行间距 列间距
@property (nonatomic, assign) CGFloat contentHeight;        //contenview的高度
@property (nonatomic, assign) UIEdgeInsets sectionInset;   // 

@end

NS_ASSUME_NONNULL_END
