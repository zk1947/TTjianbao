//
//  JHGoodsCollecitonCell.h
//  TTjianbao
//
//  Created by apple on 2019/12/16.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@class JHGoodsInfoMode;

@interface JHGoodsCollecitonCell : UICollectionViewCell

@property (nonatomic, strong) JHGoodsInfoMode *goodsInfo;
@property (nonatomic, assign) NSInteger cellHeight;


@end

NS_ASSUME_NONNULL_END
