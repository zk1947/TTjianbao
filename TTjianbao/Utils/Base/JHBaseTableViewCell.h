//
//  JHBaseTableViewCell.h
//  TTjianbao
//
//  Created by yaoyao on 2019/11/30.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kCellThemeClearColor [UIColor clearColor]

typedef NS_ENUM(NSUInteger, JHCellThemeType) {
    JHCellThemeTypeDefault, //默认主题
    JHCellThemeTypeClearColor,  //半透明主题:用户回血直播间使用
};

NS_ASSUME_NONNULL_BEGIN

@interface JHBaseTableViewCell : UITableViewCell
@property (nonatomic, strong) id cellModel;
@property (nonatomic, strong) NSIndexPath *indexPath;

@end

NS_ASSUME_NONNULL_END
