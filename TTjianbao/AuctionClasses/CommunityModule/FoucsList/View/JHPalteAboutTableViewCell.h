//
//  JHPalteAboutTableViewCell.h
//  TTjianbao
//
//  Created by apple on 2020/9/7.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class JHPlateDetailModel;
@class JHPublisher;
@interface JHPalteAboutTableViewCell : UITableViewCell
-(void)setDataWithCell:(JHPlateDetailModel *)model;
@end
@interface JHPalteAboutDescTableViewCell : UITableViewCell
- (void)updateUI:(NSString *)str;
+ (CGSize)cellHeight:(NSString*)str;
@end
@interface JHPalteAboutModerTableViewCell : UITableViewCell
-(void)resetCellDataWithModel:(JHPublisher*)model;
@end
NS_ASSUME_NONNULL_END
