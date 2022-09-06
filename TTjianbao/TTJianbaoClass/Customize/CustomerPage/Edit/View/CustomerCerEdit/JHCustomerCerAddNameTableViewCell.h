//
//  JHCustomerCerAddNameTableViewCell.h
//  TTjianbao
//
//  Created by user on 2020/10/29.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^JHCustomerCerAddNameBlock) (NSString *str);
@interface JHCustomerCerAddNameTableViewCell : UITableViewCell
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic,   copy) JHCustomerCerAddNameBlock addNameBlock;
@end

NS_ASSUME_NONNULL_END
