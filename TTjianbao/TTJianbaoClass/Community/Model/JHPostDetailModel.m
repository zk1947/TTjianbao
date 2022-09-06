//
//  JHPostDetailModel.m
//  TTjianbao
//
//  Created by lihui on 2020/8/20.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHAttributeStringTool.h"
#import "PPStickerDataManager.h"
#import "JHPostDetailModel.h"
#import "JHSQModel.h"
#import "NSString+Extension.h"

@implementation JHPostDetailModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"shopInfo" : @"store_info",
        @"videoInfo" : @"video_info",
        @"archorInfo" : @"anchor_info",
        @"shareInfo" : @"share_info",
        @"plateInfo" : @"plate_info",
        @"resourceData" : @"resource_data"
    };
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"comments" : [JHCommentModel class],
             @"labels" : [JHTallyInfo class],
             @"topics" : [JHTopicInfo class],
             @"resourceData" : [JHPostDetailResourceModel class]
             };
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _labels = [NSMutableArray new];
        _topics = [NSMutableArray new];
    }
    return self;
}

- (void)setVideo_url:(NSString *)video_url {
    //url中文转码
    _video_url = [video_url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

- (void)setContent:(NSString *)content {
    _content = [NSString removeHtmlWithString:content];
    // ↑去除HTML标签
    _content = [_content stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""]; // 去除nbsp
    if (self.item_type == JHPostItemTypeAppraisalVideo ||
        self.item_type == JHPostItemTypeVideo ||
        self.item_type == JHPostItemTypeDynamic) {
        if (![content isNotBlank]) {
            content = @"分享内容";
        }
    }
    [self configPostContent:_content];
}

- (NSMutableAttributedString *)postContentAttrText {
    if (_postContentAttrText.length > 0) {
        return _postContentAttrText;
    }
    
    NSMutableAttributedString *postContentAttrText = [[NSMutableAttributedString alloc] initWithString:@""];
    UIFont *font = [UIFont fontWithName:kFontNormal size:13];
    if (self.resource_data.count > 0) {
        postContentAttrText =[JHAttributeStringTool getMoreParagraphAttributeStringWithArray:self.resource_data normalColor:[UIColor whiteColor] font:[UIFont fontWithName:kFontNormal size:13] logoSize:CGSizeMake(12, 12)];
    }else if(self.content.length > 0){
        NSDictionary *attrs = @{NSForegroundColorAttributeName:[UIColor whiteColor],
                                NSFontAttributeName:[UIFont fontWithName:kFontNormal size:13]};
        postContentAttrText = [[NSMutableAttributedString alloc] initWithString:self.content attributes:attrs];
    }else{
        _contentHeight = 0;
        return nil;
    }
  
    if (self.content_level && (self.item_type == JHPostItemTypeDynamic || self.item_type == JHPostItemTypeVideo)) {
        YYAnimatedImageView *linkLogo= [[YYAnimatedImageView alloc] initWithImage:[UIImage imageNamed:@"sq_icon_essence"]];
        linkLogo.frame = CGRectMake(0, 0, 31, 14);
        // attchmentSize 修改，可以处理内边距
        NSMutableAttributedString *attachText= [NSMutableAttributedString attachmentStringWithContent:linkLogo contentMode:UIViewContentModeScaleAspectFit attachmentSize:linkLogo.frame.size alignToFont:[UIFont fontWithName:kFontNormal size:13] alignment:YYTextVerticalAlignmentCenter];
        //插入到开头
        [postContentAttrText insertAttributedString:attachText atIndex:0];
    }
    
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:CGSizeMake(kScreenWidth-80-15, CGFLOAT_MAX) text:postContentAttrText];
    _contentHeight = layout.textBoundingSize.height;
    
    CGFloat maxHeight = ceil(font.lineHeight * 3);
    if (_contentHeight > maxHeight) {
        _contentHeight = maxHeight;
    }
    [PPStickerDataManager.sharedInstance replaceEmojiForAttributedString_yyLabel:postContentAttrText font:font];
    
    if (postContentAttrText.length == 0) {
        [self.content stringByTrim];
        [self.content stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
        postContentAttrText = [[NSMutableAttributedString alloc] initWithString:self.content attributes:@{NSFontAttributeName:font}];
    }
    return postContentAttrText;
}

//配置内容
- (void)configPostContent:(NSString *)content {
    content = [content stringByTrim];
    content = [[content componentsSeparatedByString:@"&nbsp;"] componentsJoinedByString:@""];
    if (![content isNotBlank]) {
        _contentHeight = 0;
        _showAll = NO;
        _contentAttrText = nil;
        return;
    }
    
    UIFont *titleFont = [UIFont fontWithName:kFontNormal size:15.0];
    _contentAttrText = [[NSMutableAttributedString alloc] initWithString:content];
    _contentAttrText.font = titleFont;
    _contentAttrText.color = kColorFFF;
    
    
    BOOL isEssence = (self.content_level == 1);
    BOOL isNormal = (self.item_type == JHPostItemTypePost);

    UIImage *image = nil;
    if (!isNormal && isEssence == 1) {
        image = [UIImage imageNamed:@"sq_icon_essence"];
    }
    
    if (image) {
        NSAttributedString *icon = [NSAttributedString attachmentStringWithContent:image
                                                                       contentMode:UIViewContentModeCenter
                                                                    attachmentSize:CGSizeMake(image.size.width, image.size.height)
                                                                       alignToFont:titleFont
                                                                         alignment:YYTextVerticalAlignmentCenter];
        [_contentAttrText insertAttributedString:icon atIndex:0];
    }
  
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:CGSizeMake(ScreenW - 80 - 15, MAXFLOAT) text:_contentAttrText];
    _contentHeight = layout.textBoundingSize.height;
    
    CGFloat maxHeight = ceil(titleFont.lineHeight * 3)+10;
    if (_contentHeight > maxHeight) {
        _contentHeight = maxHeight;
        _showAll = YES;
    }
}

- (void)setPublish_time:(NSString *)publish_time {
    _publish_time = publish_time;
    ///计算时间的宽度
    CGFloat width = [_publish_time widthForFont:[UIFont fontWithName:kFontNormal size:15]];
    _timeWidth = width;
}

- (void)setShare_num:(NSInteger)share_num {
    _share_num = share_num;
    if (_share_num >= 10000 && _share_num < 100000) {
        _shareString = [NSString stringWithFormat:@"%.1fw", (float)_share_num / 10000];
    }
    else if (_share_num >= 100000) {
        _shareString = [NSString stringWithFormat:@"%ldw", _share_num / 10000];
    }
    else {
        _shareString = @(_share_num).stringValue;
    }
}

@end

@implementation JHPostDetailResourceSubModel

- (void)mj_didConvertToObjectWithKeyValues:(NSDictionary *)keyValues {
    _attrArray = [_attrs mj_JSONObject];
}
@end

@implementation JHPostDetailResourceModel

- (void)mj_didConvertToObjectWithKeyValues:(NSDictionary *)keyValues {
    if(_data) {
        _dataModel = [JHPostDetailResourceSubModel mj_objectWithKeyValues:_data];
    }
}
@end

@implementation JHPostAnchorInfo
@end

@implementation JHTallyInfo
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"labelId" : @"id"};
}
@end

@implementation JHShopInfo
@end




