//
//  JHGoodsDetailImgCell.h
//  TTjianbao
//
//  Created by wuyd on 2019/11/27.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//  显示参数列表下面的图片
//

#import "YDBaseTableViewCell.h"
//#import "TTjianbaoBussiness.h"
#import "TTjianbaoHeader.h"
#import "CGoodsDetailModel.h"
#import "UITapImageView.h"

NS_ASSUME_NONNULL_BEGIN

static NSString *const kCellId_GoodsDetailImgCell = @"JHGoodsDetailImgCellIdentifier";
static NSString *const kCellId_GoodsDetailBottomImgCell = @"JHGoodsDetailBottomImgCellIdentifier";

@interface JHGoodsDetailImgCell : UICollectionViewCell

/** 点击图片 */
@property (nonatomic, copy) void (^didClickImgBlock)(CGoodsImgInfo *imgInfo);

//@property (nonatomic, copy) void(^imgClickBlock)(UITapImageView *imgView, NSString *imgUrl);

@property (nonatomic, strong) CGoodsImgInfo *imgInfo;

@property (nonatomic, strong) UITapImageView *imgView;

@end

NS_ASSUME_NONNULL_END
