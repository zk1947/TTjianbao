//
//  JHSQModel.m
//  TTjianbao
//
//  Created by wuyd on 2020/6/12.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHSQModel.h"
#import "NSString+Emotion.h"
#import "JHTextLinePositionModifier.h"
#import "NSObject+JHCdURLFileSize.h"
#import "JHAttributeStringTool.h"
#import "JHSQUploadManager.h"
#import "PPStickerDataManager.h"

#define kContentPaddingTop (0.5)  //文本与其他元素间留白

@implementation JHSQModel

//返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"list" : @"data"};
}
// 返回容器类中的所需要存放的数据类型 (以 Class 或 Class Name 的形式)。
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list" : [JHPostData class]
    };
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _list = [NSMutableArray new];
        _videoUrls = [NSMutableArray new];
    }
    return self;
}

- (NSString *)toPostListUrl {
    self.page = self.willLoadMore ? self.page+1 : 1;
    NSString *lastId = _list.count > 0 ? _list.lastObject.item_id : @"0";
    lastId = self.willLoadMore ? lastId : @"0";
    NSString *url = [NSString stringWithFormat:COMMUNITY_FILE_BASE_STRING(@"/v2/content/recommendList?last_id=%@&page=%ld"),
                     lastId, (long)self.page];
    return url;
}
- (NSString *)toCollectPostListUrl {
    self.page = self.willLoadMore ? self.page+1 : 1;
    NSString *lastId = _list.count > 0 ? _list.lastObject.uniq_id : @"0";
    lastId = self.willLoadMore ? lastId : @"0";
    NSString *url = [NSString stringWithFormat:COMMUNITY_FILE_BASE_STRING(@"/auth/v1/bbs/section/post/collection_list?last_id=%@&page=%ld"),
                     lastId, (long)self.page];
    
    return url;
}

- (void)configModel:(JHSQModel *)model QueryWord:(NSString *)queryword {
    [self configModel:model hideComment:NO queryword:queryword];
}
- (void)configModel:(JHSQModel *)model {
    [self configModel:model hideComment:NO queryword:nil];
}

/// 收藏页面正在用的方法，别再删除了
- (void)configModel:(JHSQModel *)model hideComment:(BOOL)hideComment {
    [self configModel:model hideComment:hideComment queryword:nil];
}
- (void)configModel:(JHSQModel *)model hideComment:(BOOL)hideComment queryword:(NSString *)queryword {
    if (!model) return;
    if (model.list.count <= 0) return;
    
    NSMutableArray *videoUrlArray = [NSMutableArray new];
    for (JHPostData *data in model.list) {
        data.hideComment = hideComment;
        if(queryword) {
            data.queryWord = queryword;
        }
        //配置帖子内容
        //BOOL hasImage = data.images_thumb.count > 0;
        BOOL isNormal = data.item_type == JHPostItemTypePost;
        //动态&短视频内容为空时，赋默认值
        if (data.item_type == JHPostItemTypeDynamic ||
            data.item_type == JHPostItemTypeVideo ||
            data.item_type == JHPostItemTypeAppraisalVideo) {
            if (![data.content isNotBlank]) {
                data.content = @"分享内容";
            }
        }
        [data configPostContent:data.content isNormal:isNormal];
        
        //配置视频url
        if (data.item_type == JHPostItemTypeVideo) {
            [videoUrlArray addObject:[NSURL URLWithString:data.video_info.url]];
        } else {
            [videoUrlArray addObject:@""];
        }
    }
    
    if (self.willLoadMore) {
        [_list addObjectsFromArray:model.list];
        [_videoUrls addObjectsFromArray:videoUrlArray];
    } else {
        _list = [NSMutableArray arrayWithArray:model.list];
        _videoUrls = [NSMutableArray arrayWithArray:videoUrlArray];
    }
    
    self.canLoadMore = model.list.count > 0;
}

@end


#pragma mark -
#pragma mark - 帖子数据
@implementation JHPostData

- (id)valueForUndefinedKey:(NSString *)key {
    
    NSLog(@"key ;;; %@", key);
    return key;
    
}


//JHPostDetailModel


// 返回容器类中的所需要存放的数据类型 (以 Class 或 Class Name 的形式)。
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"publisher" : [JHPublisher class],
             @"video_info" : [JHVideoInfo class],
             @"plate_info" : [JHPlateInfo class],
             @"share_info" : [JHShareInfo class],
             @"hot_comments" : [JHCommentData class]
    };
}

- (void)setShare_num:(NSInteger)share_num {
    _share_num = share_num;
    if (_share_num >= 10000 && _share_num < 100000) {
        _shareString = [NSString stringWithFormat:@"%.1fw", (float)_share_num / 10000];
    }
    else if (_share_num >= 100000) {
        _shareString = [NSString stringWithFormat:@"%ldw", (long)_share_num / 10000];
    }
    else {
        _shareString = @(_share_num).stringValue;
    }
}

- (void)setLike_num:(NSInteger)like_num {
    _like_num = like_num;
    if (like_num >= 10000 && like_num < 100000) {
        _likeString = [NSString stringWithFormat:@"%.1fw", (float)like_num / 10000];
    }
    else if (like_num >= 100000) {
        _likeString = [NSString stringWithFormat:@"%ldw", (long)like_num / 10000];
    }
    else {
        _likeString = @(like_num).stringValue;
    }
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _images_thumb = [NSMutableArray new];
        _images_origin = [NSMutableArray new];
        _topics = [NSMutableArray new];
        _hot_comments = [NSMutableArray new];
    }
    return self;
}

- (NSMutableAttributedString *)contentAttributedString {
    if (_contentAttributedString.length > 0) {
        return _contentAttributedString;
    }
    NSMutableAttributedString *contentAttr = [[NSMutableAttributedString alloc] initWithString:@""];
    if (self.resource_data.count > 0) {
        contentAttr =[JHAttributeStringTool getMoreParagraphAttributeStringWithArray:self.resource_data normalColor:kColor999 font:[UIFont fontWithName:kFontNormal size:15] logoSize:CGSizeMake(12, 12)];
    }else if(self.content.length > 0){
        contentAttr = [[NSMutableAttributedString alloc] initWithString:self.content];
        [contentAttr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:kFontNormal size:15],
                               NSForegroundColorAttributeName:kColor999
        } range:NSMakeRange(0, [[contentAttr string] length])];
    }
    [PPStickerDataManager.sharedInstance replaceEmojiForAttributedString_yyLabel:contentAttr font:[UIFont fontWithName:kFontNormal size:15]];
    ///计算文字高度
    _contentAttributedString = contentAttr;
    return contentAttr;
}
/** 首页列表用的*/
- (NSMutableAttributedString *)postContentAttrText{
    if (_postContentAttrText.length > 0) {
        return _postContentAttrText;
    }
    UIFont *font = [UIFont fontWithName:kFontNormal size:16];
    NSMutableAttributedString *postContentAttrText = [[NSMutableAttributedString alloc] initWithString:@""];
    if (self.resource_data.count != 0) {
        postContentAttrText =[JHAttributeStringTool getMoreParagraphAttributeStringWithArray:self.resource_data normalColor:kColor333 font:[UIFont fontWithName:kFontNormal size:16] logoSize:CGSizeMake(12, 12)];
    }else if(self.content.length > 0){
        NSDictionary *attrs = @{NSForegroundColorAttributeName:kColor333,
                                NSFontAttributeName:[UIFont fontWithName:kFontNormal size:16]};
        postContentAttrText = [[NSMutableAttributedString alloc] initWithString:self.content attributes:attrs];
    }else{
        _contentHeight = 0;
        return nil;
    }
  
    if ((self.item_type == JHPostItemTypeDynamic || self.item_type == JHPostItemTypeVideo) && (self.content_level == 1)) {
        YYAnimatedImageView *linkLogo= [[YYAnimatedImageView alloc] initWithImage:[UIImage imageNamed:@"sq_icon_essence"]];
        linkLogo.frame = CGRectMake(0, 0, 31, 14);
        // attchmentSize 修改，可以处理内边距
        NSMutableAttributedString *attachText= [NSMutableAttributedString attachmentStringWithContent:linkLogo contentMode:UIViewContentModeScaleAspectFit attachmentSize:linkLogo.frame.size alignToFont:[UIFont fontWithName:kFontNormal size:16] alignment:YYTextVerticalAlignmentCenter];
        //插入到开头
        [postContentAttrText insertAttributedString:attachText atIndex:0];
    }
    
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:CGSizeMake(kScreenWidth-20, CGFLOAT_MAX) text:postContentAttrText];
    _contentHeight = layout.textBoundingSize.height;
    
    CGFloat maxHeight = ceil(font.lineHeight * 3);
    if (_contentHeight > maxHeight) {
        _contentHeight = maxHeight;
    }
    [PPStickerDataManager.sharedInstance replaceEmojiForAttributedString_yyLabel:postContentAttrText font:font];
    _postContentAttrText = postContentAttrText;
    return postContentAttrText;
}

- (void)configPostContent:(NSString *)content isNormal:(BOOL)isNormal {
    content = [content stringByTrim];
    if (![content isNotBlank]) {
        _contentHeight = 0;
        _contentAttrText = nil;
        return;
    }
    
    UIFont *font = [UIFont fontWithName:kFontNormal size:16];
    _contentAttrText = [[NSMutableAttributedString alloc] initWithString:content];
    _contentAttrText.font = font;
    _contentAttrText.color = kColor333;

    BOOL isEssence = (self.content_level == 1);
    
    UIImage *image = nil;
    if (!isNormal && isEssence == 1) {
        image = [UIImage imageNamed:@"sq_icon_essence"];
    }
    else if (self.item_type == JHPostItemTypeAppraisalVideo) {
        image = [UIImage imageNamed:(self.video_appraise_result==1) ? @"icon_user_info_appraise_true" : @"icon_user_info_appraise_false"];
        [_contentAttrText insertString:@" " atIndex:0];
    }
    
    if (image) {
        NSAttributedString *icon = [NSAttributedString attachmentStringWithContent:image
                                                                       contentMode:UIViewContentModeCenter
                                                                    attachmentSize:CGSizeMake(image.size.width, image.size.height)
                                                                       alignToFont:font
                                                                         alignment:YYTextVerticalAlignmentCenter];
        [_contentAttrText insertAttributedString:icon atIndex:0];
    }
        
  
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:CGSizeMake(kScreenWidth-20, CGFLOAT_MAX) text:_contentAttrText];
    _contentHeight = layout.textBoundingSize.height;
    
    CGFloat maxHeight = ceil(font.lineHeight * 3);
    if (_contentHeight > maxHeight) {
        _contentHeight = maxHeight;
    }
}

- (void)setImage:(NSString *)image {
    _image = [image stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

- (void)setImages_thumb:(NSMutableArray<NSString *> *)images_thumb {
    NSMutableArray *urls = [NSMutableArray new];
    [images_thumb enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *url = [obj stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [urls addObject:url];
    }];
    _images_thumb = urls.mutableCopy;
}

- (void)setImages_origin:(NSMutableArray<NSString *> *)images_origin {
    
    NSMutableArray *urls = [NSMutableArray new];
    [images_origin enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *url = [obj stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [urls addObject:url];
    }];
    _images_origin = urls.mutableCopy;
}

+ (NSArray *)mj_ignoredPropertyNames {
    return @[@"textLayout",@"localPost"];
}

@end


#pragma mark -
#pragma mark - 版块数据
@implementation JHPlateInfo
// 返回容器类中的所需要存放的数据类型 (以 Class 或 Class Name 的形式)。
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"owner" : [JHOwnerInfo class],
             @"owners" : [JHOwnerInfo class]
    };
}
//返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"ID" : @"id"};
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID" : @"id"};
}
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"owners" : [JHOwnerInfo class]};
}
- (void)setImage:(NSString *)image {
    _image = [image stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

@end


#pragma mark -
#pragma mark - 版主信息 <完>
@implementation JHOwnerInfo

@end


#pragma mark -
#pragma mark - 短视频信息
@implementation JHVideoInfo
- (void)setUrl:(NSString *)url {
    NSString *newUrl = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#^{}\"[]|\\<> "].invertedSet];
    _url = newUrl;
}

- (void)setImage:(NSString *)image {
    _image = [image stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}
- (void)setDuration:(NSString *)duration {
    NSInteger time = duration.integerValue; //总毫秒数
    NSInteger mm = time/1000/60;
    NSInteger ss = (time/1000)%60;
    _duration = [NSString stringWithFormat:@"%02ld:%02ld", (long)mm, (long)ss];
}

+ (NSArray *)mj_ignoredPropertyNames {
    return @[@"coverImage"];
}
@end


#pragma mark -
#pragma mark - 评论数据
@implementation JHCommentData
- (instancetype)init {
    self = [super init];
    if (self) {
        _reply_list = [NSMutableArray new];
        _comment_images = [NSMutableArray new];
        _comment_images_thumb = [NSMutableArray new];
        _comment_images_medium = [NSMutableArray new];
    }
    return self;
}
- (NSMutableAttributedString *)contentAttributedString {
    if (_contentAttributedString.length > 0) {
        return _contentAttributedString;
    }
    UIFont *fontName = [UIFont fontWithName:kFontMedium size:14];
    UIFont *fontContent = [UIFont fontWithName:kFontNormal size:14];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] init];
    attr.font = fontContent;
    attr.color = kColor666;
    
    NSString * mentionName = nil;
    if (self.mention && [self.mention.user_id integerValue] > 0) {
        mentionName = [NSString stringWithFormat:@"@%@：", self.mention.user_name];
    }
    NSString *colon = ![mentionName isNotBlank] ? @"：" : @"";
    NSString *userName = [NSString stringWithFormat:@"@%@%@", self.publisher.user_name, colon];
    
    NSDictionary *fontAttr = @{NSFontAttributeName:fontContent};
    NSDictionary *nameAttri = @{NSFontAttributeName:fontName, NSForegroundColorAttributeName:kColor666};
    [attr appendAttributedString:[[NSAttributedString alloc] initWithString:userName attributes:nameAttri]];
    if ([mentionName isNotBlank]) {
        [attr appendAttributedString:[[NSAttributedString alloc] initWithString:@" 回复 " attributes:fontAttr]];
        [attr appendAttributedString:[[NSAttributedString alloc] initWithString:mentionName attributes:nameAttri]];
    }
    
    NSMutableAttributedString *contentAttributedString = [[NSMutableAttributedString alloc] initWithString:@""];
    if (self.content_ad.count > 0) {
        contentAttributedString =[JHAttributeStringTool getMoreParagraphAttributeStringWithArray:self.content_ad normalColor:kColor666 font:fontContent logoSize:CGSizeMake(12, 12)];
    }else if(self.content.length > 0){
        NSDictionary *attrs = @{NSForegroundColorAttributeName:kColor666,
                                        NSFontAttributeName:fontContent};
        contentAttributedString = [[NSMutableAttributedString alloc] initWithString:self.content attributes:attrs];
    }else if (self.comment_images_thumb.count > 0) {
        contentAttributedString = [[NSMutableAttributedString alloc] initWithString:@"图片评论" attributes:fontAttr];
    }
    [attr appendAttributedString:contentAttributedString];
    //@用户名字体
    [attr addAttribute:NSFontAttributeName value:fontName
                 range:NSMakeRange(0, userName.length)];
    if ([mentionName isNotBlank]) {
        ///被回复的用户名字字体
        [attr addAttribute:NSFontAttributeName value:fontName
                     range:NSMakeRange(userName.length + 4, mentionName.length)];
    }
    
    ///计算文字高度
    YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake((ScreenW - 35), MAXFLOAT)];
    YYTextLayout *textLayout = [YYTextLayout layoutWithContainer:container text:attr];
    _textLayout = textLayout;
    [PPStickerDataManager.sharedInstance replaceEmojiForAttributedString_yyLabel:attr font:fontContent];
    _contentAttributedString = attr;
    return attr;
}

+ (NSArray *)mj_ignoredPropertyNames {
    return @[@"textLayout"];
}

@end


#pragma mark -
#pragma mark - 发布者信息
@implementation JHPublisher

//返回一个 Dict，将 Model 属性名映射到 JSON 的 Key。
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"levelInfo" : @"level_icons"};
}

// 返回容器类中的所需要存放的数据类型 (以 Class 或 Class Name 的形式)。
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"levelInfo" : [JHLevelInfo class]};
}

///mj_objectWithKeyValues
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"levelInfo" : @"level_icons"};
}


- (instancetype)init {
    self = [super init];
    if (self) {
        _levelIcons = [NSMutableArray new];
    }
    return self;
}

- (void)setAvatar:(NSString *)avatar {
    //url中文转码
    _avatar = [avatar stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

- (void)setLevelInfo:(JHLevelInfo *)levelInfo {
    _levelInfo = levelInfo;
    [_levelIcons removeAllObjects];
    
    if ([levelInfo.role_icon isNotBlank]) {
        [_levelIcons addObject:levelInfo.role_icon];
    }
    if ([levelInfo.title_level_icon isNotBlank]) {
        [_levelIcons addObject:levelInfo.title_level_icon];
    }
    if ([levelInfo.game_level_icon isNotBlank]) {
        [_levelIcons addObject:levelInfo.game_level_icon];
    }
    if ([levelInfo.plate_icon isNotBlank]) {
        [_levelIcons addObject:levelInfo.plate_icon];
    }
    if ([levelInfo.consume_tag_icon isNotBlank]) {
        [_levelIcons addObject:levelInfo.consume_tag_icon];
    }
}

- (void)setUser_name:(NSString *)user_name {
    _user_name = user_name;
    ///计算昵称的宽度
    CGFloat width = [_user_name widthForFont:[UIFont fontWithName:kFontMedium size:18]];
    _nameWidth = width+20;
}

/// 回收版本增加
- (BOOL)hasOpenLiving {
    if (_role == 2||_role == 4||_role == 6||_role == 7||_role == 9){
    if (self.businessLines.count > 0 && [self.businessLines containsObject:living]) {
        ///包含直播的字段
        return YES;
       }
    }
    return NO;
}

- (BOOL)hasOpenRecyle {
    if (_role == 2||_role == 4||_role == 6||_role == 7||_role == 9){
    if (self.businessLines.count > 0 && [self.businessLines containsObject:recycle]){
        ///包含回收的字段
        return YES;
       }
     }
    return NO;
}
- (BOOL)hasOpenExcellent {
    if (_role == 2||_role == 4||_role == 6||_role == 7||_role == 9){
    if (self.businessLines.count > 0 && [self.businessLines containsObject:excellent]) {
        ///包含优店的字段
        return YES;
      }
    }
    return NO;
}
/// 是否是 普通用户
- (BOOL)blRole_default {
    if (_role == 0) {
        return YES;
    }
    return NO;
}

/// 是否是 鉴定主播
- (BOOL)blRole_appraiseAnchor {
    if (_role == 1) {
        return YES;
    }
    return NO;
}
/// 是否是 社区商户
- (BOOL)blRole_communityShop {
    if (_role == 4) {
        return YES;
    }
    return NO;
}

/// 是否是 马甲
- (BOOL)blRole_maJia {
    if (_role == 5) {
        return YES;
    }
    return NO;
}

/// 是否是 社区商户+卖货商户
- (BOOL)blRole_communityAndSaleAnchor {
    if (_role == 6) {
        return YES;
    }
    return NO;
}

/// 是否是 普通卖场主播
- (BOOL)blRole_saleAnchor {
    if (self.hasOpenLiving && self.liveType == 0) {
        return YES;
    }
    return NO;
}
/// 是否是 回血主播
- (BOOL)blRole_restoreAnchor {
    
    if (self.hasOpenLiving && self.liveType == 1) {
        return YES;
    }
    return NO;
}
/// 是否是 定制主播
- (BOOL)blRole_customize {
    if (self.hasOpenLiving&&self.liveType == 2) {
        return YES;
    }
    return NO;
}

/// 是否是 回收主播
- (BOOL)blRole_recycle {
    if (self.hasOpenLiving&&self.liveType == 3) {
        return YES;
    }
    return NO;
}
/// 是否是 普通卖场主播助理
- (BOOL)blRole_saleAnchorAssistant {
    if (_role == 3) {
        return YES;
    }
    return NO;
}
/// 是否是 回血主播助理
- (BOOL)blRole_restoreAssistant {
    if (_role == 8) {
        return YES;
    }
    return NO;
}
/// 是否是 定制主播助理
- (BOOL)blRole_customizeAssistant {
    if (_role == 10) {
        return YES;
    }
    return NO;
}
/// 是否是 回收主播助理
- (BOOL)blRole_recycleAssistant {
    if (_role == 12) {
        return YES;
    }
    return NO;
}



@end


#pragma mark -
#pragma mark - 话题信息
@implementation JHTopicInfo
//返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"ID" : @"id"};
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID" : @"id"};
}

@end


#pragma mark -
#pragma mark - 用户各种等级图标信息（任务等级、游戏等级、角色、版主、土豪等）
@implementation JHLevelInfo

- (void)setTitle_level_icon:(NSString *)title_level_icon {
    _title_level_icon = [title_level_icon stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

- (void)setGame_level_icon:(NSString *)game_level_icon {
    _game_level_icon = [game_level_icon stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

- (void)setRole_icon:(NSString *)role_icon {
    _role_icon = [role_icon stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

- (void)setConsume_tag_icon:(NSString *)consume_tag_icon {
    _consume_tag_icon = [consume_tag_icon stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

- (void)setPlate_icon:(NSString *)plate_icon {
    _plate_icon = [plate_icon stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}


@end

@implementation JHCommentModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _hasPicture = NO;
        _commentAttrString = nil;
        _contentAttri = nil;
        _publisherAttri = nil;
        _mentionAttri = nil;
    }
    return self;
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"reply_list" : [JHCommentModel class]
    };
}

- (NSMutableAttributedString *)replyCommentAttrString{
    if (_replyCommentAttrString.length > 0) {
        return _replyCommentAttrString;
    }
    _replyCommentAttrString = [[NSMutableAttributedString alloc] initWithString:@""];
    [_replyCommentAttrString appendAttributedString:_contentAttri.length?_contentAttri:[[NSAttributedString alloc] initWithString:_content attributes:@{NSFontAttributeName:[UIFont fontWithName:kFontNormal size:15.f], NSForegroundColorAttributeName:kColor666}]];
    
    [PPStickerDataManager.sharedInstance replaceEmojiForAttributedString_yyLabel:_replyCommentAttrString font:[UIFont fontWithName:kFontNormal size:15.f]];
    
    if (_hasPicture) {
        [_replyCommentAttrString appendAttributedString:[[NSAttributedString alloc] initWithString:@"  "]];
        YYAnimatedImageView *icon = [[YYAnimatedImageView alloc] initWithImage:[UIImage imageNamed:@"icon_pic_blue"]];
        icon.frame = CGRectMake(0, 0, 16, 15);
        NSMutableAttributedString *attachText = [NSMutableAttributedString attachmentStringWithContent:icon contentMode:UIViewContentModeScaleAspectFit attachmentSize:icon.frame.size alignToFont:_replyCommentAttrString.font alignment:YYTextVerticalAlignmentCenter];
        [_replyCommentAttrString appendAttributedString:attachText];
        NSString *seePic = @" 查看图片";
        [_replyCommentAttrString appendAttributedString: [[NSAttributedString alloc] initWithString:seePic]];
        [_replyCommentAttrString addAttribute:NSFontAttributeName
                             value:[UIFont fontWithName:kFontNormal size:15.f]
                             range:[[_replyCommentAttrString string] rangeOfString:seePic]];

        @weakify(self);
        [_replyCommentAttrString setTextHighlightRange:[[_replyCommentAttrString string] rangeOfString:seePic]
                                      color:HEXCOLOR(0x408FFE)
                            backgroundColor:[UIColor clearColor]
                                  tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            @strongify(self);
            if (self.seePicBlock) {
                self.seePicBlock();
            }
        }];
    }
    ///计算文字高度
    YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake((ScreenW - 40), MAXFLOAT)];
    YYTextLayout *textLayout = [YYTextLayout layoutWithContainer:container text:_replyCommentAttrString];
    
    _textLayout = textLayout;
    return _replyCommentAttrString;
}

- (NSMutableAttributedString *)commentAttrString {
    if (_commentAttrString.length > 0) {
        return _commentAttrString;
    }
    _commentAttrString = [[NSMutableAttributedString alloc] initWithString:@""];
    if (self.mentionAttri.length > 0) {
        [_commentAttrString appendAttributedString:self.mentionAttri];
    }
    [_commentAttrString appendAttributedString:_contentAttri.length?_contentAttri:[[NSAttributedString alloc] initWithString:_content attributes:@{NSFontAttributeName:[UIFont fontWithName:kFontNormal size:15.f], NSForegroundColorAttributeName:kColor333}]];
    
    [PPStickerDataManager.sharedInstance replaceEmojiForAttributedString_yyLabel:_commentAttrString font:[UIFont fontWithName:kFontNormal size:15.f]];
    ///计算文字高度
    YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake((ScreenW - 30 - 20), MAXFLOAT)];
    YYTextLayout *textLayout = [YYTextLayout layoutWithContainer:container text:_commentAttrString];
    _textLayout = textLayout;
    return _commentAttrString;
}
/** 主评论用到了*/
- (NSMutableAttributedString *)contentAttri {
    if (_contentAttri && _contentAttri.length > 0) {
        return _contentAttri;
    }
    else {
        NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:_content attributes:@{NSFontAttributeName:[UIFont fontWithName:kFontNormal size:14.f]}];
        if (content && content.length > 0) {
            [PPStickerDataManager.sharedInstance replaceEmojiForAttributedString_yyLabel:content font:[UIFont fontWithName:kFontNormal size:14.f]];
        }
        
        YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake((ScreenW - 127), MAXFLOAT)];
        YYTextLayout *textLayout = [YYTextLayout layoutWithContainer:container text:content];
        _textLayout = textLayout;
        _contentAttri = content;
        return content;
    }
}


- (NSMutableAttributedString *)mentionAttri {
    ///如果是回复的回复 需要 拼接回复xxx
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:@""];
    if (_mention && _comment_level == JHCommentTypeReplyToReply) {
        NSMutableAttributedString *mentionName = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@", _mention.user_name]];
        NSRange nameRange = NSMakeRange(0, _mention.user_name.length+1);
        [mentionName addAttribute:NSFontAttributeName value:[UIFont fontWithName:kFontMedium size:15.f] range:nameRange];
        [mentionName addAttribute:NSForegroundColorAttributeName value:kColor333 range:nameRange];
        ///回复主评论
        NSDictionary *attrs = @{NSForegroundColorAttributeName:kColor333,
                                NSFontAttributeName:[UIFont fontWithName:kFontNormal size:15]};
        [content appendAttributedString:[[NSAttributedString alloc] initWithString:@"回复" attributes:attrs]];
        [content appendAttributedString:mentionName];
        [content appendAttributedString:[[NSAttributedString alloc] initWithString:@"：" attributes:attrs]];
    }
    
    [PPStickerDataManager.sharedInstance replaceEmojiForAttributedString_yyLabel:content font:[UIFont fontWithName:kFontNormal size:15.f]];
    _mentionAttri = content;
    
    return _mentionAttri;
}

//- (void)setMention:(JHPublisher *)mention {
//    _mention = mention;
//
//    NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:@""];
//    if (mention) {
//        NSMutableAttributedString *mentionName = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@", mention.user_name]];
//        NSRange nameRange = NSMakeRange(0, mention.user_name.length+1);
//        [mentionName addAttribute:NSFontAttributeName value:[UIFont fontWithName:kFontMedium size:15.f] range:nameRange];
//        [mentionName addAttribute:NSForegroundColorAttributeName value:kColor333 range:nameRange];
//        ///回复主评论
//        NSDictionary *attrs = @{NSForegroundColorAttributeName:kColor333,
//                                NSFontAttributeName:[UIFont fontWithName:kFontNormal size:15]};
//        [content appendAttributedString:[[NSAttributedString alloc] initWithString:@"回复" attributes:attrs]];
//        [content appendAttributedString:mentionName];
//        [content appendAttributedString:[[NSAttributedString alloc] initWithString:@"：" attributes:attrs]];
//    }
//    [PPStickerDataManager.sharedInstance replaceEmojiForAttributedString_yyLabel:content font:[UIFont fontWithName:kFontNormal size:15.f]];
//    _mentionAttri = content;
//}

- (void)setContent_ad:(NSArray *)content_ad {
    _content_ad = content_ad;
    NSMutableAttributedString *contentAttri = [[NSMutableAttributedString alloc] initWithString:@""];
    if (content_ad.count != 0) {
        contentAttri = [JHAttributeStringTool getMoreParagraphAttributeStringWithArray:_content_ad
                                                                           normalColor:kColor333
                                                                                  font:[UIFont fontWithName:kFontNormal size:15.f]
                                                                              logoSize:CGSizeMake(12, 12)];
    }else if(self.content.length > 0){
        NSDictionary *attrs = @{NSForegroundColorAttributeName:kColor333,
                                NSFontAttributeName:[UIFont fontWithName:kFontNormal size:15.f]};
        contentAttri = [[NSMutableAttributedString alloc] initWithString:self.content attributes:attrs];
    }else{
        return;
    }
    
    [PPStickerDataManager.sharedInstance replaceEmojiForAttributedString_yyLabel:contentAttri font:[UIFont fontWithName:kFontNormal size:15.f]];
    ///计算文字高度
    YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake((ScreenW - 127), MAXFLOAT)];
    YYTextLayout *textLayout = [YYTextLayout layoutWithContainer:container text:contentAttri];
    _textLayout = textLayout;
    _contentAttri = contentAttri;
}

- (void)setComment_images_thumb:(NSArray<NSString *> *)comment_images_thumb {
    _comment_images_thumb = comment_images_thumb;
    _hasPicture = (comment_images_thumb && comment_images_thumb.count > 0)
    ? YES : NO;
}

@end
