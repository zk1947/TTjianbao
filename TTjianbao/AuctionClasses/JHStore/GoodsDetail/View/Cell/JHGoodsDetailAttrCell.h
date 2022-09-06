//
//  JHGoodsDetailAttrCell.h
//  TTjianbao
//
//  Created by wuyd on 2019/11/27.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//  商品参数信息Cell
//

#import "YDBaseTableViewCell.h"
//#import "TTjianbaoBussiness.h"
#import "TTjianbaoHeader.h"
#import "CGoodsDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

static NSString *const kCellId_GoodsDetailAttrCell = @"JHGoodsDetailAttrCellIdentifier";

@interface JHGoodsDetailAttrCell : UICollectionViewCell

@property (nonatomic, strong) CGoodsAttrData *attrData;

+ (CGFloat)cellHeight;

@end

NS_ASSUME_NONNULL_END
