//
//  JHCustomerOpusViewController.h
//  TTjianbao
//
//  Created by user on 2020/10/26.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXPagerView.h"
#import "JHLiveRoomModel.h"
#import "JHBaseViewExtController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHCustomerOpusViewController : JHBaseViewExtController <JXPagerViewListViewDelegate>
@property (nonatomic, strong) JHLiveRoomModel *roomModel;
@end

NS_ASSUME_NONNULL_END
