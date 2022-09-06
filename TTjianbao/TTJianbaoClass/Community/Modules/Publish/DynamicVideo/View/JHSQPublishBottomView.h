//
//  JHSQPublishBottomView.h
//  TTjianbao
//
//  Created by wangjianios on 2020/6/19.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface JHSQPublishBottomView : UIView

///   添加图片视频
@property (nonatomic, copy) dispatch_block_t addAlbumBlock;

@property (nonatomic, copy) dispatch_block_t callUsetListBlock;

/// 完成按钮
@property (nonatomic, copy) dispatch_block_t completePlateBlock;

@property (nonatomic, assign) BOOL hidePhotoButton;

@property (nonatomic, assign) BOOL showDoneButton;

@property (nonatomic, assign) BOOL hideCalluserButton;

/// 是否大于最大字数限制
@property (nonatomic, assign) BOOL isGreaterMaxWords;

@property (nonatomic, assign) NSInteger wordsNumber;

@property (nonatomic, copy)void (^keybordSwitchBlock)(BOOL showEmoji);
  
+ (CGSize)viewSize;

@end

NS_ASSUME_NONNULL_END
