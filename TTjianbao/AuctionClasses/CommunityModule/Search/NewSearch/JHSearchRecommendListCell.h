//
//  JHSearchRecommendListCell.h
//  TTjianbao
//
//  Created by liuhai on 2021/10/25.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHSearchRecommendModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHSearchRecommendListCell : UITableViewCell
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withModel:(JHSearchRecommendModel *)model;

@property(nonatomic, copy) NSString *fromStr;
@end

NS_ASSUME_NONNULL_END
