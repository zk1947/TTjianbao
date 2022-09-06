//
//  JHZeroAuctionHeadView.h
//  TTjianbao
//
//  Created by zk on 2021/11/3.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHZeroAuctionViewController.h"
#import "JHZeroAuctionRequestModel.h"
#import "JHZeroAuctionModel.h"


NS_ASSUME_NONNULL_BEGIN

typedef void(^ReloadUIBlock)(BOOL showTag);

typedef void(^HeadChooseBlock)(JHZeroAuctionRequestModel *model);

@interface JHZeroAuctionHeadView : UIView

@property (nonatomic, strong) JHZeroAuctionModel *headModel;

@property (nonatomic, copy) ReloadUIBlock reloadUIBlock;

@property (nonatomic, copy) HeadChooseBlock headChooseBlock;

@property (nonatomic, weak) JHZeroAuctionViewController *vc;

- (void)hiddenClassAlert;

@end

NS_ASSUME_NONNULL_END
