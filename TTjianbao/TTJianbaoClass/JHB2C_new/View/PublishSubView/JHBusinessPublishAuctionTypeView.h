//
//  JHBusinessPublishAuctionTypeView.h
//  TTjianbao
//
//  Created by liuhai on 2021/8/25.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBusinessPublishBaseView.h"
#import "JHBusinessPubishNomalModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHBusinessPublishAuctionTypeView : JHBusinessPublishBaseView
@property(nonatomic, strong) JHBusinessPubishNomalModel * normalModel;
- (void)resetNetDataWithType:(NSInteger)type;
@end

NS_ASSUME_NONNULL_END
