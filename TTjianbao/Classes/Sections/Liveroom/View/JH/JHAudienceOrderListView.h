//
//  JHAudienceOrderListView.h
//  TTjianbao
//
//  Created by jiang on 2019/7/8.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"
#import "NTESMicConnector.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHAudienceOrderListView :BaseView
- (void)loadData:(NTESMicConnector*)mode;
- (void)show;
@end

NS_ASSUME_NONNULL_END
