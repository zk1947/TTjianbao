//
//  JHProcessPicOrVideoCollectionViewCell.h
//  TTjianbao
//
//  Created by user on 2020/10/28.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHCustomerDescInProcessModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHProcessPicOrVideoCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *pictImageView;
@property (nonatomic, strong) JHCustomizeCommentPublishImgList *model;
- (void)setViewModel:(id)viewModel;
@end

NS_ASSUME_NONNULL_END
