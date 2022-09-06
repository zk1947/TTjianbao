//
//  JHCustomizeStuffDetailCell.h
//  TTjianbao
//
//  Created by jiangchao on 2020/12/15.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHMeterialsCategoryModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHCustomizeStuffDetailCell : UICollectionViewCell
@property (nonatomic, strong) JHMeterialsCategoryModel * stuffModel;
@property (nonatomic, copy) JHActionBlock buttonClickBlock;
@end

NS_ASSUME_NONNULL_END
