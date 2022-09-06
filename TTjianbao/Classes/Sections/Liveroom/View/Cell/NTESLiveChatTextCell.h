//
//  NTESLiveChatTextCell.h
//  TTjianbao
//
//  Created by chris on 16/3/28.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NTESMessageModel.h"

extern CGFloat const avatarWidth;
extern CGFloat const spaceWidth;
extern CGFloat const oXspaceWidth;
extern CGFloat const spaceHeight;


@interface NTESLiveChatTextCell : UITableViewCell

- (void)refresh:(NTESMessageModel *)model;
@property (nonatomic, copy)JHActionBlock refreshCell;
@end


@class M80AttributedLabel;
/// 进入直播间独立出来
@interface NTESLiveChatTextCellView : UIView

//@property (nonatomic,strong) M80AttributedLabel *attributedLabel;
@property (nonatomic,strong) M80AttributedLabel *attributedLabel;

@property (nonatomic, strong) UIImageView *avatar;

@property (nonatomic, strong) UIImageView *backView;

- (void)refresh:(NTESMessageModel *)model;

@property (nonatomic, strong) NTESMessageModel *model;

@end
