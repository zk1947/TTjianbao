//
//  JHOnlineListCollectionCell.h
//  TTjianbao
//
//  Created by lihui on 2020/12/18.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//
/// 在线鉴定首页 - 下面列表部分
#import <UIKit/UIKit.h>
#import "JHPostDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHOnlineListCollectionCell : UICollectionViewCell

@property (nonatomic, strong) JHPostDetailModel *postData;

+ (CGFloat)heightCellWithModel:(JHPostDetailModel *)model;


@end

NS_ASSUME_NONNULL_END
