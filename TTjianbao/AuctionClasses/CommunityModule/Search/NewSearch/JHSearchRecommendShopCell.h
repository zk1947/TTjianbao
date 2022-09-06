//
//  JHSearchRecommendShopCell.h
//  TTjianbao
//
//  Created by liuhai on 2021/10/25.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHSearchRecommendModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHSearchRecommendShopCell : UITableViewCell
- (void)resetCellModel:(JHSearchRecommendShopdModel *)model andindex:(NSInteger)row;
@end

NS_ASSUME_NONNULL_END
