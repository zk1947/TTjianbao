//
//  JHMsgSubListLikeCommentModel.m
//  TTjianbao
//
//  Created by jesee on 22/6/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHMsgSubListLikeCommentModel.h"
#import "JHAttributeStringTool.h"
#import "PPStickerDataManager.h"

@implementation JHMsgSubListArticlePublisherModel
///获取勋章 or level 信息
- (NSArray *)levelIcons
{
    NSMutableArray *tempArray = [NSMutableArray array];
    if (self.levelInfo == nil) {
        return tempArray;
    }
    ///设置勋章
    if ([self.levelInfo.role_icon isNotBlank]) {
        [tempArray addObject:self.levelInfo.role_icon];
    }
    if ([self.levelInfo.title_level_icon isNotBlank]) {
        [tempArray addObject:self.levelInfo.title_level_icon];
    }
    if ([self.levelInfo.game_level_icon isNotBlank]) {
        [tempArray addObject:self.levelInfo.game_level_icon];
    }
    if ([self.levelInfo.plate_icon isNotBlank]) {
        [tempArray addObject:self.levelInfo.plate_icon];
    }
    if ([self.levelInfo.cert_icon isNotBlank]) {
        [tempArray addObject:self.levelInfo.cert_icon];
    }
    if ([self.levelInfo.consume_tag_icon isNotBlank]) {
        [tempArray addObject:self.levelInfo.consume_tag_icon];
    }
    return [NSArray arrayWithArray:tempArray];
}


+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
        @"name" : @"user_name",
        @"roleIcon" : @"role_icon",
        @"levelInfo" : @"level_icons",
    };
}

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"levelInfo": [JHLevelInfo class]};
}

@end

@interface JHMsgSubListArticleModel ()
@property (nonatomic, strong) NSMutableAttributedString *authorNameAttri;
@property (nonatomic, strong) NSMutableAttributedString *contentAttri;
@end

@implementation JHMsgSubListArticleModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _hasPicture = NO;
        _commentAttrString = nil;
    }
    return self;
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"isLike" : @"is_like",
        @"commentId" : @"comment_id",
        @"commentNum" : @"comment_num",
        @"replyCount" : @"reply_count",
        @"itemId" : @"item_id",
        @"itemType" : @"item_type",
        @"likeNum" : @"like_num",
        @"sortTime" : @"sort_num",
        @"originImages" : @"images_origin",
        @"thumbImages" : @"images_thumb",
    };
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"publisher": [JHMsgSubListArticlePublisherModel class]};
}

- (NSMutableAttributedString *)commentAttrString {
    if (_commentAttrString.length > 0) {
        return _commentAttrString;
    }
    _commentAttrString = [[NSMutableAttributedString alloc] initWithString:@""];
    [_commentAttrString appendAttributedString:_authorNameAttri];
    NSMutableAttributedString *contentAttr = [[NSMutableAttributedString alloc] initWithString:@""];
    if (self.content_ad.count > 0) {
        contentAttr =[JHAttributeStringTool getMoreParagraphAttributeStringWithArray:self.content_ad normalColor:kColor999 font:[UIFont fontWithName:kFontNormal size:15] logoSize:CGSizeMake(12, 12)];
    }else if (self.content.length > 0){
        NSDictionary *attrs = @{NSForegroundColorAttributeName:kColor999,
                                       NSFontAttributeName:[UIFont fontWithName:kFontNormal size:15]};
        contentAttr = [[NSMutableAttributedString alloc] initWithString:self.content attributes:attrs];
    }else if (self.comment_images_thumb.count > 0) {
        contentAttr = [[NSMutableAttributedString alloc] initWithString:@"图片评论" attributes:@{NSFontAttributeName:[UIFont fontWithName:kFontNormal size:15]}];
    }
    
    [_commentAttrString appendAttributedString:contentAttr];
    
    if (_hasPicture) {
        [_commentAttrString appendAttributedString:[[NSAttributedString alloc] initWithString:@"  "]];
        YYAnimatedImageView *icon = [[YYAnimatedImageView alloc] initWithImage:[UIImage imageNamed:@"icon_pic_blue"]];
        icon.frame = CGRectMake(0, 0, 16, 15);
        NSMutableAttributedString *attachText = [NSMutableAttributedString attachmentStringWithContent:icon contentMode:UIViewContentModeScaleAspectFit attachmentSize:icon.frame.size alignToFont:_commentAttrString.font alignment:YYTextVerticalAlignmentCenter];
        [_commentAttrString appendAttributedString:attachText];
        NSString *seePic = @" 查看图片";
        [_commentAttrString appendAttributedString: [[NSAttributedString alloc] initWithString:seePic]];
        [_commentAttrString addAttribute:NSFontAttributeName
                             value:[UIFont fontWithName:kFontNormal size:15.f]
                             range:[[_commentAttrString string] rangeOfString:seePic]];

        @weakify(self);
        [_commentAttrString setTextHighlightRange:[[_commentAttrString string] rangeOfString:seePic]
                                      color:HEXCOLOR(0x408FFE)
                            backgroundColor:[UIColor clearColor]
                                  tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            @strongify(self);
            if (self.seePicBlock) {
                self.seePicBlock();
            }
        }];
    }
    [PPStickerDataManager.sharedInstance replaceEmojiForAttributedString_yyLabel:_commentAttrString font:[UIFont fontWithName:kFontNormal size:15]];
    ///计算文字高度
    YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake((ScreenW - 30 - 2*20), MAXFLOAT)];
    YYTextLayout *textLayout = [YYTextLayout layoutWithContainer:container text:_commentAttrString];
    _textLayout = textLayout;
    
    return _commentAttrString;
}

- (void)setPublisher:(JHMsgSubListArticlePublisherModel *)publisher {
    _publisher = publisher;
    
    NSMutableAttributedString *authorName = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"@%@：", _publisher.user_name]];
    NSRange nameRange = NSMakeRange(0, _publisher.user_name.length+2);
    [authorName addAttribute:NSFontAttributeName value:[UIFont fontWithName:kFontMedium size:15.f] range:nameRange];
    [authorName addAttribute:NSForegroundColorAttributeName value:kColor333 range:nameRange];

    _authorNameAttri = authorName;
}

- (NSMutableAttributedString *)contentAttributedString {
    if (_contentAttributedString.length > 0) {
        return _contentAttributedString;
    }
    NSMutableAttributedString *contentAttr = [[NSMutableAttributedString alloc] initWithString:@""];
    if (self.content_ad.count > 0) {
        contentAttr =[JHAttributeStringTool getMoreParagraphAttributeStringWithArray:self.content_ad normalColor:kColor333 font:[UIFont fontWithName:kFontNormal size:16] logoSize:CGSizeMake(12, 12)];
    }else if(self.resource_data.count > 0){
        contentAttr =[JHAttributeStringTool getMoreParagraphAttributeStringWithArray:self.resource_data normalColor:kColor333 font:[UIFont fontWithName:kFontNormal size:16] logoSize:CGSizeMake(12, 12)];
    }else if(self.content.length > 0){
        contentAttr = [[NSMutableAttributedString alloc] initWithString:self.content];
        [contentAttr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:kFontNormal size:16],
                               NSForegroundColorAttributeName:kColor333
        } range:NSMakeRange(0, [[contentAttr string] length])];
    }
    [PPStickerDataManager.sharedInstance replaceEmojiForAttributedString_yyLabel:contentAttr font:[UIFont fontWithName:kFontNormal size:16]];
    ///计算文字高度
    YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake((ScreenW - 30 - 20), MAXFLOAT)];
    YYTextLayout *textLayout = [YYTextLayout layoutWithContainer:container text:contentAttr];
    _mainTextLayout = textLayout;
    _contentAttributedString = contentAttr;
    return contentAttr;
}

- (void)setComment_images_thumb:(NSArray<NSString *> *)comment_images_thumb {
    _comment_images_thumb = comment_images_thumb;
    _hasPicture = (_comment_images_thumb.count > 0);
}

@end

@implementation JHMsgSubListLikeCommentModel

- (NSString *)createDate
{
    NSString* dateTime = [self convertFromTime:_article.sortTime];
    return dateTime;
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
        @"article" : @"main",
        @"articleContent" : @"content",
        @"replyArticle" : @"base_comment"
    };
}

- (NSString *)convertFromTime:(NSString *)timeStr
{
    long long time = [timeStr longLongValue];
    NSDate* date = [[NSDate alloc] initWithTimeIntervalSince1970:time/1000.0];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString* timeString = [formatter stringFromDate:date];
    return timeString;
}

@end

@implementation JHMsgSubListLikeCommentReqModel

- (instancetype)init
{
    if(self = [super init])
    {
        [self setRequestSourceType:JHRequestHostTypeSocial];
        self.last_id = @"0";
    }
    return self;
}

//需要token：http://172.17.214.82:8080/v2/user/history?type=1&user_id=1&last_id=0 //0 统计信息 1评论 2发过 3点赞
- (NSString *)uriPath
{
    return [NSString stringWithFormat:@"/auth/user/history/forme?type=%zd&last_id=%@", self.type, self.last_id];
}

@end

