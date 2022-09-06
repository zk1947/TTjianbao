//
//  JHOrderListTableViewCell.h
//  TTjianbao
//
//  Created by jiangchao on 2019/1/25.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderMode.h"

@protocol JHOrderListTableViewCellDelegate <NSObject>

@optional
-(void)buttonPress:(UIButton*)button withOrder:(OrderMode*)mode;
@end

@interface JHOrderListTableViewCell : UITableViewCell
@property(strong,nonatomic)OrderMode * orderMode;
@property(strong,nonatomic)NSString * orderRemainTime;
@property(weak,nonatomic)id<JHOrderListTableViewCellDelegate>delegate;
@end


