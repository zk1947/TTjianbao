//
//  JHC2CClassMenuSubCollectionViewCell.h
//  TTjianbao
//
//  Created by hao on 2021/5/21.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class JHNewStoreTypeTableCellViewModel;

@interface JHC2CClassMenuSubCollectionViewCell : UICollectionViewCell
@property(nonatomic, strong) JHNewStoreTypeTableCellViewModel * viewModel;
@property (nonatomic, strong) UILabel *titleLabel;


@end

NS_ASSUME_NONNULL_END
