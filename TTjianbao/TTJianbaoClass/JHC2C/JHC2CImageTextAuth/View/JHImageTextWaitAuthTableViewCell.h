//
//  JHImageTextWaitAuthTableViewCell.h
//  TTjianbao
//
//  Created by zk on 2021/6/9.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHImageTextWaitAuthModel.h"

@protocol AuthTableViewCellDelegate <NSObject>

- (void)gotoAuth:(JHImageTextWaitAuthListItemModel *_Nullable)model;

@end

NS_ASSUME_NONNULL_BEGIN

@interface JHImageTextWaitAuthTableViewCell : UITableViewCell

@property (nonatomic, strong) JHImageTextWaitAuthListItemModel *model;

@property (nonatomic, weak) id authDelegate;

@end

NS_ASSUME_NONNULL_END
