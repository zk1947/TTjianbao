//
//  JHPostDetailTextTableCell.h
//  TTjianbao
//
//  Created by lihui on 2020/8/27.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString * const kJHPostDetailTextIdentifer = @"JHPostDetailTextIdentifer";

@interface JHPostDetailTextTableCell : UITableViewCell
- (void)setContent:(NSString *)content isEssence:(BOOL)isEssence;
@end

NS_ASSUME_NONNULL_END
