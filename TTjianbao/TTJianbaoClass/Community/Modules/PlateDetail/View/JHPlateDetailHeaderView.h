//
//  JHPlateDetailHeaderView.h
//  TTjianbao
//
//  Created by wangjianios on 2020/9/8.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class JHPlateDetailModel;

@interface JHPlateDetailHeaderView : UIView

@property (nonatomic, assign) BOOL isRequestLoading;

@property (nonatomic, strong) JHPlateDetailModel *model;
@property (nonatomic, copy) NSString *pageFrom;


@property (nonatomic, weak) UIButton *focusButton;
///板块ID
@property (nonatomic, copy) NSString *plateId;


///简介 点击 isPlateOwner yes:是版主 no：不是版主
@property (nonatomic, copy) void(^briefBlock)(BOOL isPlateOwner);

///滚动下拉放大
- (void)updateImageHeight:(float)height;

- (void)showLoading;

- (void)dismissLoading;

+ (CGFloat)imageViewHeight;

- (CGFloat)headerViewHeight;

@end

NS_ASSUME_NONNULL_END
