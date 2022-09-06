//
//  JHSendOrderView.h
//  TTjianbao
//
//  Created by yaoyao on 2019/1/23.
//  Copyright © 2019年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"

@class NTESMessageModel;

NS_ASSUME_NONNULL_BEGIN

@interface JHSendOrderView : BaseView

+ (JHSendOrderView *)sendOrderViewFirst;
+ (JHSendOrderView *)sendOrderViewSecond;
@property (nonatomic, strong) NTESMessageModel *model;
@property (nonatomic, copy) JHActionBlock clickImage;
@property (strong, nonatomic) JHSendOrderView *sendOrderSecond;
@property (copy, nonatomic) NSString *anchorId;
@property (copy, nonatomic) NSString *customerId;
@property (copy, nonatomic) NSString *roomId;
@property (copy, nonatomic, nullable) NSString *biddingId;
@property (assign, nonatomic) BOOL isLaughOrder;//哄场单
@property (assign, nonatomic) BOOL isAssistant;//助理
@property (assign, nonatomic) BOOL isAnction;//创建竞拍
@property (nonatomic, copy) JHActionBlock auctionUploadFinish;
@property (nonatomic, copy) JHActionBlock sendWish;
@property (strong, nonatomic) NSArray *tagArray;

- (IBAction)sendOrderAction:(id)sender;

- (void)showAlert;
- (void)showImageViewAction:(UIImage *)image;
- (void)setTagBtnWithArray:(NSArray *)array;
@end

NS_ASSUME_NONNULL_END
