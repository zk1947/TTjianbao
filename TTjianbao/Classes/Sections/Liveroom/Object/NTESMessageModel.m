//
//  NTESMessageModel.m
//  TTjianbao
//
//  Created by chris on 16/3/28.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import "NTESMessageModel.h"
#import "M80AttributedLabel.h"
#import "NTESUserUtil.h"
#import "JHSystemMsgAttachment.h"
#import "NTESCustomKeyDefine.h"
#import "TTjianbaoHeader.h"
#import "NSString+Common.h"
#import "PPStickerDataManager.h"
#import "PPSticker.h"
#import "PPUtil.h"

@implementation JHMessageExtModel

@end

@implementation NTESMessageModel

- (void)caculate:(CGFloat)width
{
    M80AttributedLabel *label = NTESCaculateLabel();
    [label setAttributedText:nil];
    [label setText:nil];
    
    BOOL isSpecialRole = NO;
    if (self.isBeMuted) {
        UIImage *image = [UIImage imageNamed:@"img_bemute_logo"];
        if (image) {
            [label appendImage:image maxSize:CGSizeMake(47,17)];
            [label appendText:@" "];
        }
    }
    
    if (self.type == 1) {
        [label appendImage:[UIImage imageNamed:@"img_appraiser_logo"] maxSize:CGSizeMake(55,17)];
        [label appendText:@" "];
        isSpecialRole = YES;

    } else {
        if (self.roomRole == JHRoomRoleAnchor) {
            UIImage *image = [UIImage imageNamed:@"img_anchor_logo"];
            if (image) {
                [label appendImage:image maxSize:CGSizeMake(44,17)];
                [label appendText:@" "];
            }
            isSpecialRole = YES;
          
        }
    }

    if (self.roomRole == JHRoomRoleAssistant) {
        [label appendImage:[UIImage imageNamed:@"img_assistant_logo"] maxSize:CGSizeMake(44,17)];
        [label appendText:@" "];
        isSpecialRole = YES;

    }

    if (!isSpecialRole){
        if (self.extModel.userTycoonLevel && ![NSString isEmpty:self.extModel.userTycoonLevelIcon]) {
            [label appendImage:[UIImage imageWithColor:HEXCOLOR(0xffffff)size:CGSizeMake(44,17)] maxSize:CGSizeMake(44,17) margin:UIEdgeInsetsMake(0, 0, 0, 0) alignment:M80ImageAlignmentCenter];
            [label appendText:@" "];
        }
        if (self.userLevelUrl) {
            [label appendImage:[UIImage imageWithColor:HEXCOLOR(0xffffff)size:CGSizeMake(42,17)] maxSize:CGSizeMake(42,17) margin:UIEdgeInsetsMake(0, 0, 0, 0) alignment:M80ImageAlignmentCenter];
            [label appendText:@" "];
        }
                   
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"img_game_grade_%d",(int)self.gameGrade]];
        if (image) {
            [label appendImage:image maxSize:CGSizeMake(50,17)];
            [label appendText:@" "];
        } else if (self.userGameGradeUrl) {
            [label appendImage:[UIImage imageWithColor:HEXCOLOR(0xffffff)size:CGSizeMake(50,17)] maxSize:CGSizeMake(50,17) margin:UIEdgeInsetsMake(0, 0, 0, 0) alignment:M80ImageAlignmentCenter];
            [label appendText:@" "];
        }else {

        }
    }
    
    if (self.levelImg) {
        
        CGSize size =  CGSizeMake(49, 17);
        if (self.userLevelName.length == 3) {
            size =  CGSizeMake(59, 17);
        }
        [label appendImage:[UIImage imageWithColor:HEXCOLOR(0xffffff)size:size] maxSize:size margin:UIEdgeInsetsMake(0, 0, 0, 0) alignment:M80ImageAlignmentCenter];
        [label appendText:@" "];
    }
    
//    NSString *title = self.userLevelName;
//    if (self.userLevelType>0) {
//
//        UIImageView * fansGradeImageView = [[UIImageView alloc]init];
//        fansGradeImageView.image = [[UIImage imageNamed:[NSString stringWithFormat:@"fans_list_grade%ld",self.userLevelType]] resizableImageWithCapInsets:UIEdgeInsetsMake(0,30,0,5)resizingMode:UIImageResizingModeStretch];
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
//        [label appendView:fansGradeImageView margin:UIEdgeInsetsZero alignment:M80ImageAlignmentCenter];
//        [label appendText:@" "];
//    }

    
//    [label appendAttributedText:self.formatMessage];
    [self drawViewToLabel:label];
    CGSize size = [label sizeThatFits:CGSizeMake(width, CGFLOAT_MAX)];
    self.height = size.height;
    self.width = size.width;
}
- (NSAttributedString *)formatMessage
{
    NSString *showMessage = [self showMessage];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:showMessage];
    NIMChatroom *room = [[NTESLiveManager sharedInstance] roomInfo:self.message.session.sessionId];
    
    BOOL isCreator = [room.creator isEqualToString:self.message.from];
    //主播昵称颜色 和 用户昵称颜色
    UIColor *nickColor = isCreator? HEXCOLOR(0xfaec55) : HEXCOLOR(0xC4F8AB);
    //购买过用户昵称颜色
    UIColor *boughtColor = HEXCOLOR(0xFF3939);
    //其他直播间购买过用户昵称颜色
    
    UIColor *boughtColorColor = HEXCOLOR(0xD285FF);
    //系统消息颜色
    UIColor *yellowColor = kGlobalThemeColor;
    //订单支付等消息颜色
    UIColor *orangeColor =  HEXCOLOR(0xff4200);
    //普通消息颜色
    UIColor *textColor = [UIColor whiteColor];
    
    if (![NSString isEmpty:self.extModel.userMsgColor]) {
        textColor = [UIColor colorWithHexString:self.extModel.userMsgColor];
    }
    if (self.message.messageType == NIMMessageTypeCustom) {//不用设置昵称
        NIMCustomObject *object = (NIMCustomObject *)self.message.messageObject;
        JHSystemMsgAttachment<NIMCustomAttachment> *attachment = (JHSystemMsgAttachment<NIMCustomAttachment> *)object.attachment;
        
        if (attachment.showStyle == 2) {
            [text setAttributes:@{NSForegroundColorAttributeName:orangeColor,NSFontAttributeName:Chatroom_Message_Font} range:self.textRange];

        }else if (attachment.showStyle == 1) {
            [text setAttributes:@{NSForegroundColorAttributeName:yellowColor,NSFontAttributeName:Chatroom_Message_Font} range:self.textRange];

        }else {
            [text setAttributes:@{NSForegroundColorAttributeName:yellowColor,NSFontAttributeName:Chatroom_Message_Font} range:self.textRange];
            if (attachment.type<=JHSystemMsgTypeEndAppraisal || attachment.type == JHSystemMsgTypePresent) {
                [text setAttributes:@{NSForegroundColorAttributeName:orangeColor,NSFontAttributeName:Chatroom_Message_Font} range:self.textRange];

            }
        }

    }else {
       
        [text setAttributes:@{NSForegroundColorAttributeName:textColor,NSFontAttributeName:Chatroom_Message_Font} range:self.textRange];
        
            if (self.bought && self.isAnchorRecv) {
                [text setAttributes:@{NSForegroundColorAttributeName:boughtColor,NSFontAttributeName:Chatroom_Message_Font} range:self.nickRange];
                
            }else if(self.boughtOther && self.isAnchorRecv){
                [text setAttributes:@{NSForegroundColorAttributeName:boughtColorColor,NSFontAttributeName:Chatroom_Message_Font} range:self.nickRange];
            }
            else {
                [text setAttributes:@{NSForegroundColorAttributeName:nickColor,NSFontAttributeName:Chatroom_Message_Font} range:self.nickRange];
                
            }

    }
    
    if (self.message.messageType == NIMMessageTypeNotification){
        NIMNotificationObject *object = (NIMNotificationObject *)self.message.messageObject;
        if (object.notificationType == NIMNotificationTypeChatroom) {
            NIMChatroomNotificationContent *content = (NIMChatroomNotificationContent *)object.content;
            [text setAttributes:@{NSForegroundColorAttributeName:yellowColor,NSFontAttributeName:Chatroom_Message_Font} range:self.textRange];

            switch (content.eventType) {
                case NIMChatroomEventTypeAddMuteTemporarily:
                case NIMChatroomEventTypeRemoveMuteTemporarily:
                    [text setAttributes:@{NSForegroundColorAttributeName:HEXCOLOR(0x32CD32),NSFontAttributeName:Chatroom_Message_Font} range:self.textRange];

                    break;
                case NIMChatroomEventTypeEnter:
                    [text setAttributes:@{NSForegroundColorAttributeName:yellowColor,NSFontAttributeName:Chatroom_Message_Font} range:self.nickRange];
                    [text setAttributes:@{NSForegroundColorAttributeName:yellowColor,NSFontAttributeName:Chatroom_Message_Font} range:self.textRange];


                    break;
                    
                default:
                    break;
            }
            
        }
        
    }
//
//    [PPStickerDataManager.sharedInstance replaceEmojiForAttributedString:text font:Chatroom_Message_Font];
    return text;
}
- (void)drawViewToLabel:(M80AttributedLabel *)label{
    NSAttributedString *text = self.formatMessage;
    NSArray<PPStickerMatchingResult *> *matchingResults = [PPStickerDataManager.sharedInstance matchingEmojiForString:text.string];

    if (matchingResults && matchingResults.count) {
      
        NSRange range = NSMakeRange(0, 0);
        for (int i = 0; i<matchingResults.count; i++) {
            PPStickerMatchingResult *result = matchingResults[i];
            NSRange currentRange = result.range;
            [label appendAttributedText:[text attributedSubstringFromRange:NSMakeRange(range.location, currentRange.location - range.location)]];
            [label appendImage:result.emojiImage maxSize:CGSizeMake(16, 16) margin:UIEdgeInsetsMake(1, 1.5, 1, 1.5) alignment:(M80ImageAlignmentCenter)];
            range.location = currentRange.location + currentRange.length;
        }
        if(range.location<text.length){
            [label appendAttributedText:[text attributedSubstringFromRange:NSMakeRange(range.location, text.length-range.location)]];
        }
    }else{
        [label appendAttributedText:text];
    }
        
}
- (NSRange)nickRange
{
    NSString *nickName = self.nick;//[NTESUserUtil showName:self.message.from withMessage:self.message];
    return NSMakeRange(0, nickName.length);
}

- (NSRange)textRange
{
    NSString *showMessage = [self showMessage];
    return NSMakeRange(showMessage.length - self.message.text.length, self.message.text.length);
}

- (NSString *)showMessage
{
    if (!self.message.text) {
        if (self.message.messageType == NIMMessageTypeCustom) {
            NIMCustomObject *object = (NIMCustomObject *)self.message.messageObject;
            JHSystemMsgAttachment<NIMCustomAttachment> *attachment = (JHSystemMsgAttachment<NIMCustomAttachment> *)object.attachment;
            self.message.text = attachment.content;

        }

    }
    if (self.message.messageType == NIMMessageTypeCustom) {
        NSString *showMessage = [NSString stringWithFormat:@"%@",self.message.text];
        return showMessage?:@"";

    } else {
        
        NSString *showMessage = [NSString stringWithFormat:@"%@ %@",self.nick,self.message.text];
        return showMessage?:@"";


    }
    
}

- (NSString *)customerId {
    if (!_customerId) {
        if ([self.message.messageExt isKindOfClass:[NIMMessageChatroomExtension class]]) {
            
            NIMMessageChatroomExtension *ext = self.message.messageExt;
            
            NSDictionary *dic = [ext.roomExt mj_JSONObject];
            if (dic) {
                _customerId = dic[@"customerId"];
            }
            NSLog(@"_customerId %@",dic);
            
        }
    }
    NSLog(@"_customerId%@",_customerId);
    return _customerId;
}

//- (BOOL)isAnchorRecv {
//    return [NTESLiveManager sharedInstance].role == NTESLiveRoleAnchor;
//}

- (NSInteger)bought {
    if ([self.message.messageExt isKindOfClass:[NIMMessageChatroomExtension class]]) {
        
        NIMMessageChatroomExtension *ext = self.message.messageExt;
        
        NSDictionary *dic = [ext.roomExt mj_JSONObject];
        if (dic) {
            _bought = [dic[@"bought"] integerValue];
        }
    }
    return _bought;
}
- (NSInteger)boughtOther{
    if ([self.message.messageExt isKindOfClass:[NIMMessageChatroomExtension class]]) {
        
        NIMMessageChatroomExtension *ext = self.message.messageExt;
        
        NSDictionary *dic = [ext.roomExt mj_JSONObject];
        if (dic) {
            _boughtOther = [dic[@"boughtOther"] integerValue];
        }
    }
    return _boughtOther;
}
- (NSInteger)type {
    _type = 0;
    if ([self.message.messageExt isKindOfClass:[NIMMessageChatroomExtension class]]) {
        
        NIMMessageChatroomExtension *ext = self.message.messageExt;
        
        NSDictionary *dic = [ext.roomExt mj_JSONObject];
        if (dic[@"type"]) {
            _type = [dic[@"type"] integerValue];
        }
    }
    return _type;
}

- (NSInteger)gameGrade {
    if ([self.message.messageExt isKindOfClass:[NIMMessageChatroomExtension class]]) {
        
        NIMMessageChatroomExtension *ext = self.message.messageExt;
        NSDictionary *dic = [ext.roomExt mj_JSONObject];
        if (dic){
            _gameGrade = [dic[@"gameGrade"] integerValue];
        }
    }
    return _gameGrade;
    
}

- (NSInteger)roomRole {
    if ([self.message.messageExt isKindOfClass:[NIMMessageChatroomExtension class]]) {
        
        NIMMessageChatroomExtension *ext = self.message.messageExt;
        NSDictionary *dic = [ext.roomExt mj_JSONObject];
        if (dic){
            _roomRole = [dic[@"roomRole"] integerValue];
        }
    }
    return _roomRole;
}



- (NSString *)nick {
    if (!_nick) {
        if (self.message.messageType == NIMMessageTypeCustom) {
            NIMCustomObject *object = (NIMCustomObject *)self.message.messageObject;
            JHSystemMsgAttachment<NIMCustomAttachment> *attachment = (JHSystemMsgAttachment<NIMCustomAttachment> *)object.attachment;
            _nick = attachment.nick;
            

            
        } else {
            NIMMessageChatroomExtension *ext = [self.message.messageExt isKindOfClass:[NIMMessageChatroomExtension class]] ?
            (NIMMessageChatroomExtension *)self.message.messageExt : nil;
            
            _nick = ext.roomNickname?:@"";
            
        }
    }
    
    return _nick;
}

- (NSString *)avatar {
    
    if (self.message.messageType == NIMMessageTypeCustom) {
        NIMCustomObject *object = (NIMCustomObject *)self.message.messageObject;
        JHSystemMsgAttachment<NIMCustomAttachment> *attachment = (JHSystemMsgAttachment<NIMCustomAttachment> *)object.attachment;
        _avatar = attachment.avatar;
        
    } else {
        NIMMessageChatroomExtension *ext = [self.message.messageExt isKindOfClass:[NIMMessageChatroomExtension class]] ?
        (NIMMessageChatroomExtension *)self.message.messageExt : nil;
        
        _avatar = ext.roomAvatar?:@"";
        
    }
    return _avatar;

}

M80AttributedLabel *NTESCaculateLabel()
{
    static M80AttributedLabel *label;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        label = [[M80AttributedLabel alloc] init];
        label.font = Chatroom_Message_Font;
        label.numberOfLines = 0;
        label.lineBreakMode = kCTLineBreakByCharWrapping;
    });
    return label;
}

- (BOOL)isBeMuted {
//    if (self.message.messageType == 0)
    if ([NTESLiveManager sharedInstance].role == NTESLiveRoleAnchor) {
        {
            if ([self.message.messageExt isKindOfClass:[NIMMessageChatroomExtension class]]) {
                NIMMessageChatroomExtension *ext = self.message.messageExt;
                NSDictionary *dic = [ext.roomExt mj_JSONObject];
                if (dic && dic[@"tempMuted"]){
                    _isBeMuted = [dic[@"tempMuted"] integerValue];
                }
            }
            return _isBeMuted;
            
        }
    }
    
    return _isBeMuted;
}

- (NSString *)userLevelUrl {

    if (!_userLevelUrl) {
        if ([self.message.messageExt isKindOfClass:[NIMMessageChatroomExtension class]]) {
            
            NIMMessageChatroomExtension *ext = self.message.messageExt;
            
            NSDictionary *dic = [ext.roomExt mj_JSONObject];
            if (dic) {
                _userLevelUrl = dic[@"userTitleLevelIcon"];
                if ([_userLevelUrl isEqualToString:@""]) {
                    _userLevelUrl = nil;
                }
            }
            
        }
    }
    return _userLevelUrl;
}

- (NSString *)userGameGradeUrl {

    if (!_userGameGradeUrl) {
        if ([self.message.messageExt isKindOfClass:[NIMMessageChatroomExtension class]]) {
            
            NIMMessageChatroomExtension *ext = self.message.messageExt;
            
            NSDictionary *dic = [ext.roomExt mj_JSONObject];
            if (dic) {
                _userGameGradeUrl = dic[@"gameGradeIcon"];
                if ([_userGameGradeUrl isEqualToString:@""]) {
                    _userGameGradeUrl = nil;
                }
            }
            
        }
    }
    return _userGameGradeUrl;
}

- (NSInteger)userTitleLevel {

    if (_userTitleLevel == 0) {
        if ([self.message.messageExt isKindOfClass:[NIMMessageChatroomExtension class]]) {
            
            NIMMessageChatroomExtension *ext = self.message.messageExt;
            
            NSDictionary *dic = [ext.roomExt mj_JSONObject];
            if (dic) {
                _userTitleLevel = [dic[@"userTitleLevel"] integerValue];
                
            }
            
        }
    }
    return _userTitleLevel;
}

- (NSInteger)userLevelType {

    if (_userLevelType == 0) {
        if ([self.message.messageExt isKindOfClass:[NIMMessageChatroomExtension class]]) {
            NIMMessageChatroomExtension *ext = self.message.messageExt;
            
            NSDictionary *dic = [ext.roomExt mj_JSONObject];
            if (dic) {
                _userLevelType = [dic[@"userLevelType"] integerValue];
                
            }
        }
    }
    return _userLevelType;
}

- (NSString *)userLevelName {

    if (!_userLevelName) {
        if ([self.message.messageExt isKindOfClass:[NIMMessageChatroomExtension class]]) {
            NIMMessageChatroomExtension *ext = self.message.messageExt;
            
            NSDictionary *dic = [ext.roomExt mj_JSONObject];
            if (dic) {
                _userLevelName = dic[@"userLevelName"];
                if ([_userLevelName isEqualToString:@""]) {
                    _userLevelName = nil;
                }
            }
        }
    }
    return _userLevelName;
}

- (NSString *)levelImg {

    if (!_levelImg) {
        if ([self.message.messageExt isKindOfClass:[NIMMessageChatroomExtension class]]) {
            NIMMessageChatroomExtension *ext = self.message.messageExt;
            
            NSDictionary *dic = [ext.roomExt mj_JSONObject];
            if (dic) {
                _levelImg = dic[@"levelImg"];
                if ([_levelImg isEqualToString:@""]) {
                    _levelImg = nil;
                }
            }
        }
    }
    return _levelImg;
}
- (void)setMessage:(NIMMessage *)message {
    _message = message;
    if ([message.messageExt isKindOfClass:[NIMMessageChatroomExtension class]]) {
        NIMMessageChatroomExtension *ext = self.message.messageExt;
        NSDictionary *dic = [ext.roomExt mj_JSONObject];
        self.extModel = [JHMessageExtModel mj_objectWithKeyValues:dic];
    }
}
@end
