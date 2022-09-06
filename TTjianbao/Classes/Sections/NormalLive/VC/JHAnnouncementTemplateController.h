//
//  JHPublishAnnouncementController.h
//  TTjianbao
//
//  Created by Donto on 2020/7/3.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHBaseViewExtController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHAnnouncementTemplateController : JHBaseViewExtController

@property (nonatomic, copy) void(^selectedTemplateCompletion)(NSString *content, UIImage *annoucementImage);

@end

NS_ASSUME_NONNULL_END
