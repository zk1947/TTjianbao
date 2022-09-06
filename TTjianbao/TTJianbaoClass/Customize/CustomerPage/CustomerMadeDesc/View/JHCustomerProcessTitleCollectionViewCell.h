//
//  JHCustomerProcessTitleCollectionViewCell.h
//  TTjianbao
//
//  Created by user on 2020/10/28.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^customerProcessTitleAddCommentInfoActionBlock) (void);
typedef void (^customerProcessTitleOrderByActionBlock) (BOOL isOrderByYes);

@interface JHCustomerProcessTitleCollectionViewCell : UICollectionViewCell
@property (nonatomic, copy) customerProcessTitleAddCommentInfoActionBlock addBlock;
@property (nonatomic, copy) customerProcessTitleOrderByActionBlock orderByBlock;
- (void)setViewModel:(BOOL)viewModel;
- (void)setOrderStatus:(BOOL)isOrderByYes;
@end

NS_ASSUME_NONNULL_END
