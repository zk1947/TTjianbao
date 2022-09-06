//
//  NTESLiveChatTextCell.m
//  TTjianbao
//
//  Created by chris on 16/3/28.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import "NTESLiveChatTextCell.h"
#import "M80AttributedLabel.h"
#import "UIView+NTES.h"
#import "NIMAvatarImageView.h"
#import "JHSystemMsgAttachment.h"
#import "NTESLiveManager.h"
#import "TTjianbaoHeader.h"
#import "NSString+Common.h"
#import "JHWebImage.h"

CGFloat const avatarWidth = 30;
CGFloat const spaceWidth = 5;
CGFloat const oXspaceWidth = 15;
CGFloat const spaceHeight = 3.5;

@implementation NTESLiveChatTextCellView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.backView];
        [self addSubview:self.avatar];
        [self addSubview:self.attributedLabel];
    }
    return self;
}

- (void)refresh:(NTESMessageModel *)model
{
    self.model = model;
    self.avatar.width = avatarWidth;
    self.backView.left = avatarWidth+oXspaceWidth+(avatarWidth>0.0?spaceWidth:0);
    if (model.message.messageType == NIMMessageTypeCustom) {
        NIMCustomObject *object = (NIMCustomObject *)model.message.messageObject;
        JHSystemMsgAttachment<NIMCustomAttachment> *attachment = (JHSystemMsgAttachment<NIMCustomAttachment> *)object.attachment;
        
        if (attachment.type == JHSystemMsgTypeNotification) {
            if (!attachment.avatar || attachment.avatar.length == 0) {
                self.avatar.width = 0;
                self.backView.left = oXspaceWidth;

            }

        }
        
    }else if (model.message.messageType == NIMMessageTypeNotification){
        NIMNotificationObject *object = (NIMNotificationObject *)model.message.messageObject;
        if (object.notificationType == NIMNotificationTypeChatroom) {
            NIMChatroomNotificationContent *content = (NIMChatroomNotificationContent *)object.content;
            
            switch (content.eventType) {
                case NIMChatroomEventTypeAddMuteTemporarily:
                case NIMChatroomEventTypeRemoveMuteTemporarily:
                    self.avatar.width = 0;
                    self.backView.left = oXspaceWidth;
                    
                    break;
                    
                default:
                    break;
            }
            
        }
        
    }
    [self.attributedLabel setText:@""];
    [self.attributedLabel setAttributedText:nil];
    
    BOOL isSpecialRole = NO;

    if (model.isBeMuted) {
        UIImage *image = [UIImage imageNamed:@"img_bemute_logo"];
        if (image) {
            [self.attributedLabel appendImage:image maxSize:CGSizeMake(47,17) margin:UIEdgeInsetsMake(0, 0, 0, 0) alignment:M80ImageAlignmentCenter];
            [self.attributedLabel appendText:@" "];
        }
        
    }
    
    if (model.type == 1) {
        [self.attributedLabel appendImage:[UIImage imageNamed:@"img_appraiser_logo"] maxSize:CGSizeMake(55,17) margin:UIEdgeInsetsMake(0, 0, 0, 0) alignment:M80ImageAlignmentCenter];
        [self.attributedLabel appendText:@" "];
        isSpecialRole = YES;
        
    } else {
        if (model.roomRole == JHRoomRoleAnchor) {
            UIImage *image = [UIImage imageNamed:@"img_anchor_logo"];
            if (image) {
                [self.attributedLabel appendImage:image maxSize:CGSizeMake(44,17) margin:UIEdgeInsetsMake(0, 0, 0, 0) alignment:M80ImageAlignmentCenter];
                [self.attributedLabel appendText:@" "];
            }
            isSpecialRole = YES;
            
        }
    }
    
    if (model.roomRole == JHRoomRoleAssistant) {
        [self.attributedLabel appendImage:[UIImage imageNamed:@"img_assistant_logo"] maxSize:CGSizeMake(44,17) margin:UIEdgeInsetsMake(0, 0, 0, 0) alignment:M80ImageAlignmentCenter];
        [self.attributedLabel appendText:@" "];
        isSpecialRole = YES;

    }
    
    
    if (!isSpecialRole) {

        JH_WEAK(self)
        if (self.model.extModel.userTycoonLevel) {
            [self cacheImageWithURL:model.extModel.userTycoonLevelIcon image:model.extModel.userTycoonLevelImage size:CGSizeMake(44, 17) complete:^(UIImage *image, NSError *error) {
                JH_STRONG(self)
                if (image) {
                    self.model.extModel.userTycoonLevelImage = image;
                    [self refresh:self.model];
                }
                
            }];
        }
        
        [self cacheImageWithURL:model.userLevelUrl image:model.userLevelImage size:CGSizeMake(50, 17) complete:^(UIImage *image, NSError *error) {
            JH_STRONG(self)
            if (image) {
                self.model.userLevelImage = image;
                [self refresh:self.model];
            }
        }];
        
        //        model.userGameGradeImage = [UIImage imageNamed:[NSString stringWithFormat:@"img_game_grade_%d",(int)model.gameGrade]];
        
        [self cacheImageWithURL:model.userGameGradeUrl image:model.userGameGradeImage size:CGSizeMake(50, 17) complete:^(UIImage *image, NSError *error) {
            JH_STRONG(self)
            if (image) {
                self.model.userGameGradeImage = image;
                [self refresh:self.model];
            }
        }];
         
    }
    
//    NSString *title = model.userLevelName;
//    if (model.userLevelType>0) {
//
//        UIImageView * fansGradeImageView = [[UIImageView alloc]init];
//        fansGradeImageView.image = [[UIImage imageNamed:[NSString stringWithFormat:@"fans_list_grade%ld",model.userLevelType]] resizableImageWithCapInsets:UIEdgeInsetsMake(0,30,0,5)resizingMode:UIImageResizingModeStretch];
//        UILabel *fansGradeLabel = [[UILabel alloc]init];
//        fansGradeLabel.text = title;
//        fansGradeLabel.font = [UIFont fontWithName:kFontBoldPingFang size:10];
//        fansGradeLabel.textColor = kColorFFF;
//        fansGradeLabel.numberOfLines = 1;
//        fansGradeLabel.textAlignment = NSTextAlignmentRight;
//        fansGradeLabel.lineBreakMode = NSLineBreakByTruncatingTail;
//        [fansGradeImageView addSubview:fansGradeLabel];
//
//        NSDictionary *attribute =@{NSFontAttributeName: fansGradeLabel.font};
//        CGFloat titleW = [title boundingRectWithSize:CGSizeMake(100, 17) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size.width;
//        fansGradeImageView.size = CGSizeMake(titleW+28+5, 17);
//        [fansGradeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(fansGradeImageView);
//            make.right.equalTo(fansGradeImageView).offset(-5);
//            make.left.equalTo(fansGradeImageView).offset(28);
//        }];
//        [self.attributedLabel appendView:fansGradeImageView margin:UIEdgeInsetsZero alignment:M80ImageAlignmentCenter];
//        [self.attributedLabel appendText:@" "];
//    }
    JH_WEAK(self)
    if (model.levelImg) {
        
        CGSize size =  CGSizeMake(49, 17);
        if (model.userLevelName.length == 3) {
            size =  CGSizeMake(59, 17);
        }
        [self cacheImageWithURL:model.levelImg image:model.userLevelImg size:size complete:^(UIImage *image, NSError *error) {
            JH_STRONG(self)
            if (image) {
                self.model.userLevelImg = image;
                [self refresh:self.model];
            }
            
        }];
    }
    
    
    

//    [self.attributedLabel appendAttributedText:model.formatMessage];
    [model drawViewToLabel:self.attributedLabel];
//    [self.attributedLabel setAttributedText:model.formatMessage];
    if (!model.avatar || model.avatar.length == 0) {
        [self.avatar setImage:kDefaultAvatarImage];
    }else {
        [self.avatar jhSetImageWithURL:[NSURL URLWithString:model.avatar] placeholder:kDefaultAvatarImage];
    }
    
    self.backView.size = CGSizeMake(model.width+2*spaceWidth, model.height+2*spaceHeight);
    self.attributedLabel.frame = CGRectInset(self.backView.frame, 5, 5);
    self.attributedLabel.centerY = self.backView.centerY+0.5;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
//    CGRect rect = self.bounds;
//    rect.origin.x = oXspaceWidth+avatarWidth;
//    self.attributedLabel.frame =  ;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{

}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    
}

#pragma mark - Get
- (M80AttributedLabel *)attributedLabel
{
    if (!_attributedLabel) {
        _attributedLabel = [[M80AttributedLabel alloc] initWithFrame:CGRectMake(avatarWidth+oXspaceWidth+2*spaceWidth, spaceWidth, 0, 0)];
        _attributedLabel.numberOfLines = 0;
        _attributedLabel.font = Chatroom_Message_Font;
        _attributedLabel.backgroundColor = [UIColor clearColor];
        _attributedLabel.lineBreakMode = kCTLineBreakByCharWrapping;
        _attributedLabel.userInteractionEnabled = NO;
    }
    return _attributedLabel;
}


- (UIImageView *)avatar
{
    if (!_avatar) {
        _avatar = [[UIImageView alloc] initWithFrame:CGRectMake(oXspaceWidth, 0, avatarWidth, avatarWidth)];
        _avatar.layer.cornerRadius = avatarWidth/2.;
        _avatar.layer.masksToBounds = YES;
        _avatar.userInteractionEnabled = NO;
        
    }
    return _avatar;
}

- (UIImageView *)backView {
    if (!_backView) {
        _backView = [[UIImageView alloc] initWithFrame:CGRectMake(avatarWidth+oXspaceWidth+spaceWidth, 0, 0, 0)];
        _backView.backgroundColor = HEXCOLORA(0x000000, 0.35);
        _backView.layer.cornerRadius = 15;
        _backView.layer.masksToBounds = YES;

    }
    return _backView;
}

- (void)cacheImageWithURL:(NSString *)url image:(UIImage *)image size:(CGSize)size complete:(void (^)(UIImage *image, NSError *error))completed {
    if (![NSString isEmpty:url]) {
        if (!image) {
            NSString *key = [[SDWebImageManager sharedManager] cacheKeyForURL:[NSURL URLWithString:url]];

            image = [JHWebImage imageFromCacheForKey:key];
            NSLog(@"cache========%@",image);
        }
        if (image) {
            
            [self.attributedLabel appendImage:image maxSize:size margin:UIEdgeInsetsMake(0, 0, 0, 0) alignment:M80ImageAlignmentCenter];
            [self.attributedLabel appendText:@" "];
            
        } else {
            
            [self.attributedLabel appendImage:[UIImage imageWithColor:HEXCOLORA(0xffffff, 0.4) size:size] maxSize:size];
            [self.attributedLabel appendText:@" "];
            [JHWebImage downloadImageWithURL:[NSURL URLWithString:url] completed:^(UIImage * _Nullable img, NSError * _Nullable error) {
                    NSString *key = [[SDWebImageManager sharedManager] cacheKeyForURL:[NSURL URLWithString:url]];
                    [JHWebImage storeImage:img forKey:key completion:nil];
                    completed(img,error);
                }];
        }
    }
}

@end


@interface NTESLiveChatTextCell()

@property (nonatomic,strong) NTESLiveChatTextCellView *cellView;

@property (nonatomic, strong) NTESMessageModel *model;

@end

@implementation NTESLiveChatTextCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        _cellView = [NTESLiveChatTextCellView new];
        [self.contentView addSubview:_cellView];
        [_cellView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    return self;
}

-(void)refresh:(NTESMessageModel *)model
{
    [_cellView refresh:model];
}

@end
