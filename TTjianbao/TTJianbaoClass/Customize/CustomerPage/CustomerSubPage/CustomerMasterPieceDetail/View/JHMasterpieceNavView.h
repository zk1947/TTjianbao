//
//  JHMasterpieceNavView.h
//  TTjianbao
//
//  Created by user on 2020/10/27.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, JHMasterpieceNavViewButtonStyle) {
    JHMasterpieceNavViewButtonStyle_Back,           /* 返回 */
    JHMasterpieceNavViewButtonStyle_Share,          /* 分享 */
    JHMasterpieceNavViewButtonStyle_Delete,         /* 删除 */
};

typedef void (^masterpieceNavButtonClickBlock) (JHMasterpieceNavViewButtonStyle style);
@interface JHMasterpieceNavView : UIView
@property (nonatomic, assign) BOOL isAnchor; /// 是否是主播
- (void)masterpieceNavViewBtnAction:(masterpieceNavButtonClickBlock)clickBlock;
- (void)reloadMPMessage:(UIImage *)image name:(NSString *)name subName:(NSString *)subName;
@end

NS_ASSUME_NONNULL_END
