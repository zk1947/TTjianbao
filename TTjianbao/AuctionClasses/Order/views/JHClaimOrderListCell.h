//
//  JHClaimOrderListCell.h
//  TTjianbao
//
//  Created by yaoyao on 2019/2/25.
//  Copyright © 2019年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderMode.h"


NS_ASSUME_NONNULL_BEGIN

@interface JHClaimOrderListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *expressIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *buyerLabel;
@property (weak, nonatomic) IBOutlet UIImageView *coverImage;
@property (weak, nonatomic) IBOutlet UIImageView *selectedImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toLeadingWidth;

@property (strong, nonatomic)  OrderMode *model;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;

@end

NS_ASSUME_NONNULL_END
