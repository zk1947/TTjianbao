//
//  JHMarketSpecialTableViewCell.h
//  TTjianbao
//
//  Created by zk on 2021/6/1.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHMarketSpecialTableViewCell : UITableViewCell

@property (nonatomic, copy) NSArray *categoryInfos;

- (CGFloat)getCollectionH;

@end

NS_ASSUME_NONNULL_END
