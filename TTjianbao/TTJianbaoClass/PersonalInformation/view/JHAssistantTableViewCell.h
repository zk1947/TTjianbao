//
//  JHAssistantTableViewCell.h
//  TTjianbao
//
//  Created by yaoyao on 2019/1/28.
//  Copyright © 2019年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHAssistantModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHAssistantTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;

@property (weak, nonatomic) IBOutlet UILabel *nickLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (nonatomic, strong) JHAssistantModel *model;
@end

NS_ASSUME_NONNULL_END
