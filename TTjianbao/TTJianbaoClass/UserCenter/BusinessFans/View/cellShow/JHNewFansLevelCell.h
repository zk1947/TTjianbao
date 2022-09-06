//
//  JHNewFansLevelCell.h
//  TTjianbao
//
//  Created by Paros on 2021/11/3.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, JHNewFansLevelCellType) {
    JHNewFansLevelCellType_Normal = 0,
    JHNewFansLevelCellType_Top,
    JHNewFansLevelCellType_NearBottom,
    JHNewFansLevelCellType_Bottom,
};
@interface JHNewFansLevelCell : UITableViewCell

@property(nonatomic) JHNewFansLevelCellType cellType;

- (void)refreshLeftText:(NSString*)left andRightText:(NSString*)right;

@end

NS_ASSUME_NONNULL_END
