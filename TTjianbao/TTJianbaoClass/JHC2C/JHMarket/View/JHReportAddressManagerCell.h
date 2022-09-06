//
//  JHReportAddressManagerCell.h
//  TTjianbao
//
//  Created by 张坤 on 2021/5/15.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdressMode.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHReportAddressManagerCell : UITableViewCell

@property(assign,nonatomic)NSInteger cellIndex;
@property(strong,nonatomic) AdressMode * adressMode;
//- (float)getAutoCellHeight;

NS_ASSUME_NONNULL_END

@end
