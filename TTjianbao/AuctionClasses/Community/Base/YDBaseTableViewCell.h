//
//  YDBaseTableViewCell.h
//  TTjianbao
//
//  Created by wuyd on 2019/7/31.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTjianbaoBussiness.h"
#import "TTjianbaoHeader.h"
#import "YYControl.h"


NS_ASSUME_NONNULL_BEGIN

@interface YDBaseTableViewCell : UITableViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;

/*! 选中效果开关 */
@property (nonatomic, assign) BOOL selectionStyleEnabled;

@end

NS_ASSUME_NONNULL_END
