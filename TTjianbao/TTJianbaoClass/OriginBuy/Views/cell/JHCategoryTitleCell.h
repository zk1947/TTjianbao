//
//  JHCategoryTitleCell.h
//  TTjianbao
//
//  Created by apple on 2020/7/29.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JHMallCateViewModel;
NS_ASSUME_NONNULL_BEGIN

@interface JHCategoryTitleCell : UICollectionViewCell
@property(nonatomic,strong,readonly)UILabel *titleLabel;
-(void)setTitleWithVm:(JHMallCateViewModel *)vm;
-(void)updateTitleLabel:(BOOL)isSelected;

@end

NS_ASSUME_NONNULL_END
