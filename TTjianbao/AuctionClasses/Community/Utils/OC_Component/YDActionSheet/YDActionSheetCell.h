//
//  YDActionSheetCell.h
//  Cooking-Home
//
//  Created by Wuyd on 2019/6/29.
//  Copyright © 2019 Wuyd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString * _Nullable const kCellId_YDActionSheetCell = @"YDActionSheetCellIdentifier";

@interface YDActionSheetCell : UITableViewCell

@property (nonatomic, assign) BOOL isCancel;

- (void)setTitleStr:(NSString *)title isDestructive:(BOOL)isDestructive showTopLine:(BOOL)isShow;

@end

NS_ASSUME_NONNULL_END
