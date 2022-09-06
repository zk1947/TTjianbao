//
//  JHMessageSubListHeaderView.h
//  TTjianbao
//  Description:消息中心-sublist cell header-时间
//  Created by Jesse on 2020/3/2.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define kHeaderContentHeight 15
#define kHeaderHeight 25

@interface JHMessageSubListHeaderView : UITableViewHeaderFooterView

@property (nonatomic, strong) UIView* headerSubview;
@property (nonatomic, strong) UILabel*  headerSubviewTitle;

- (void)updateData:(NSString*)text section:(NSInteger)section;
@end

NS_ASSUME_NONNULL_END
