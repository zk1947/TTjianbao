//
//  JHCommMenuCell.h
//  TTjianbao
//
//  Created by jiangchao on 2020/10/30.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHCommMenuCell : UITableViewCell
@property (nonatomic, strong) NSString *titleString;
- (void)showBottomLine:(BOOL)isShow;
@end

NS_ASSUME_NONNULL_END
