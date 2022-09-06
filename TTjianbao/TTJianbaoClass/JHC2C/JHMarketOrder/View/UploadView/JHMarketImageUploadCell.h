//
//  JHMarketImageUploadCell.h
//  TTjianbao
//
//  Created by 王记伟 on 2021/5/24.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHMarketImageUploadCell : UICollectionViewCell
@property (nonatomic, copy) void(^cancelBlock)(void);
/** 图片*/
@property (nonatomic, strong) UIImageView *pictureImageView;
/** +号载体*/
@property (nonatomic, strong) UIView *plusView;
/** 张数*/
@property (nonatomic, strong) UILabel *plusLabel;
/** x号*/
@property (nonatomic, strong) UIButton *cancelButton;
@end

NS_ASSUME_NONNULL_END
