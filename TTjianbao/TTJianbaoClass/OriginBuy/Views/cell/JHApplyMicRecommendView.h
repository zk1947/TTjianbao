//
//  JHApplyMicRecommendView.h
//  TTjianbao
//
//  Created by jiangchao on 2020/8/17.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHLiveRoomMode.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHApplyMicRecommendView : UIView
@property(nonatomic,strong) NSMutableArray<JHLiveRoomMode *> * dataModes;
@property(nonatomic,copy)JHActionBlock clickBlock;
@end

NS_ASSUME_NONNULL_END
