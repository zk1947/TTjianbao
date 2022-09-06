//
//  JHRecycleImageTemplateBaseCell.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/29.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHRecycleImageTemplateCellViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHRecycleImageTemplateBaseCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *bgimageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *deleteButton;


- (void)setupSelectedImageUI;
- (void)setupNomalImageUI;

- (void)didClickDeleteWithAction : (UIButton *)sender;
@end

NS_ASSUME_NONNULL_END
