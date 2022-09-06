//
//  JHChatMediaView.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/5/13.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHChatMediaModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHChatMediaView : UIView
@property (nonatomic, strong) RACSubject<JHChatMediaModel *> *selectedSubject;
@property (nonatomic, strong) NSMutableArray<JHChatMediaModel *> *mediaList;
/// 设置多媒体项
- (void)setupMedias : (NSArray<JHChatMediaModel *> *)mediaList;

@end

NS_ASSUME_NONNULL_END
