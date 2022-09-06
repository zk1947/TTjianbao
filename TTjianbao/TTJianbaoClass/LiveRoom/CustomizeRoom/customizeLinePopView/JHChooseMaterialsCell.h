//
//  JHChooseMaterialsCell.h
//  TTjianbao
//
//  Created by apple on 2020/11/3.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class JHMeterialsCategoryModel;
@interface JHChooseMaterialsCell : UICollectionViewCell
- (void)setRecordModel:(JHMeterialsCategoryModel *)model andNullTitle:(NSString *)title andprocess:(NSString *)process;
@end

NS_ASSUME_NONNULL_END
