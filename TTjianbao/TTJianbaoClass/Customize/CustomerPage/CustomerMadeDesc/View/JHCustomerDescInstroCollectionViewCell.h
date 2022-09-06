//
//  JHCustomerDescInstroCollectionViewCell.h
//  TTjianbao
//
//  Created by user on 2020/10/28.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHCustomerDescInstroCollectionViewCell : UICollectionViewCell
@property (nonatomic, copy) dispatch_block_t checkMainBtnActionBlock;
@property (nonatomic, copy) dispatch_block_t iconImgAcitonBlock;
- (void)setViewModel:(id)viewModel;
@end

NS_ASSUME_NONNULL_END
