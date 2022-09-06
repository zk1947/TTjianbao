//
//  JHSQPublishVideoView.h
//  TTjianbao
//
//  Created by wangjianios on 2020/6/19.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHSQPublishVideoView : UIView

@property (nonatomic, weak) UIImageView *imageView;

@property (nonatomic, weak) UILabel *timeLabel;

@property (nonatomic, copy) dispatch_block_t videoClickBlock;

@property (nonatomic, copy) dispatch_block_t deleteActionBlock;

+ (CGSize)viewSize;

@end

NS_ASSUME_NONNULL_END
