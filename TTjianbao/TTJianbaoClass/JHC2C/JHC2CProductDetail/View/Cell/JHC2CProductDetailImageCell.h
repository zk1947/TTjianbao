//
//  JHC2CProductDetailImageCell.h
//  TTjianbao
//
//  Created by jingxuelong on 2021/5/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class JHC2CProoductDetailModel;

@interface JHC2CProductDetailImageCell : UITableViewCell
@property(nonatomic, strong) JHC2CProoductDetailModel * model;

@property(nonatomic, strong) UIImageView * videoView;
@property(nonatomic, strong) NSString * videoUrl;

@property(nonatomic, copy) void (^playVideo)(JHC2CProductDetailImageCell* cell);

@property(nonatomic, copy) void (^playVideoOut)(JHC2CProductDetailImageCell* cell);

@end

NS_ASSUME_NONNULL_END
