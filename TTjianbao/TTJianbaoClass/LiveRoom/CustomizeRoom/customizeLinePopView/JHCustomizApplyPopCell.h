//
//  JHCustomizApplyPopCell.h
//  TTjianbao
//
//  Created by apple on 2020/10/26.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JHCustomizePopModel;
NS_ASSUME_NONNULL_BEGIN

@interface JHCustomizApplyPopCell : UITableViewCell
@property (nonatomic, copy) void (^completeBlock)(void);
- (void)setCellDataModel:(JHCustomizePopModel *)goodsModel andIndexPath:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
