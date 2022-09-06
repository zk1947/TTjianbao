//
//  JHFlashSendOrderInputView.h
//  TTjianbao
//
//  Created by user on 2021/9/27.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHPopBaseView.h"
#import "ChannelMode.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, JHFlashSendOrderStyle) {
    JHFlashSendOrderStyle_NormalOrder = 777, /// 常规单
    JHFlashSendOrderStyle_ProcessOrder,      /// 加工单
    JHFlashSendOrderStyle_WelfareOrder,      /// 福利单
};


@interface JHFlashSendOrderInputView : JHPopBaseView
@property (nonatomic,   copy) NSString              *anchorId;
@property (nonatomic, assign) JHFlashSendOrderStyle  flashStyle;
@property (nonatomic,   copy) JHActionBlock          clickImage;
@property (nonatomic,   copy) JHActionBlock          clickClose;
@property (nonatomic,   copy) JHActionBlock          auctionUploadFinish;

- (void)showImageViewAction:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
