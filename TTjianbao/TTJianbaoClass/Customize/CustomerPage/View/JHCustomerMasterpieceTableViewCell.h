//
//  JHCustomerMasterpieceTableViewCell.h
//  TTjianbao
//  定制2期，代表作cell
//  Created by user on 2020/10/23.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHCustomerMasterpieceTableViewCell : UITableViewCell
@property (nonatomic, copy) void(^masterActionBlock)(NSInteger index);
- (void)setViewModel:(id)viewModel;
@end

NS_ASSUME_NONNULL_END
