//
//  NTESPresentShopView.h
//  TTjianbao
//
//  Created by chris on 16/3/29.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NTESPresent;
@protocol NTESPresentShopViewDelegate <NSObject>

- (void)didSelectPresent:(NTESPresent *)present;

@end

@interface NTESPresentShopView : UIControl

@property (nonatomic,weak) id<NTESPresentShopViewDelegate> delegate;

- (void)show;

- (void)dismiss;

@end
