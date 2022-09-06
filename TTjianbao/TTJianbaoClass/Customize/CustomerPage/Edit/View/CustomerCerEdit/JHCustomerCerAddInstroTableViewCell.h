//
//  JHCustomerCerAddInstroTableViewCell.h
//  TTjianbao
//
//  Created by user on 2020/10/29.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHCustomerCerEditBusiness.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^JHCustomerCerAddInstroBlock) (NSString *str, JHCerEditCellStyle style);
@interface JHCustomerCerAddInstroTableViewCell : UITableViewCell
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic,   copy) JHCustomerCerAddInstroBlock addInstroBlock;
- (void)setViewModel:(id)viewModel;
@end

NS_ASSUME_NONNULL_END
