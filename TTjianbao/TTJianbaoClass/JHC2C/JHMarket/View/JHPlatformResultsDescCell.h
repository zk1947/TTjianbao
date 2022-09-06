//
//  JHPlatformResultsDescCell.h
//  TTjianbao
//
//  Created by 张坤 on 2021/5/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHPlatformResultsDescCell : UITableViewCell

@property(strong,nonatomic) NSString * reasonText;
+(instancetype)cellWithTableView:(UITableView *)tableView;
+(CGFloat)cellHeight;

@end

NS_ASSUME_NONNULL_END
