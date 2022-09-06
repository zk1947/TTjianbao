//
//  JHEquityInfoCollectionViewCell.h
//  TTjianbao
//
//  Created by liuhai on 2021/3/22.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JHFansEquityInfoModel;
NS_ASSUME_NONNULL_BEGIN

@interface JHEquityInfoCollectionViewCell : UICollectionViewCell
- (void)resetCollectCell:(JHFansEquityInfoModel *)model andBgImage:(BOOL)isget;
@end

NS_ASSUME_NONNULL_END
