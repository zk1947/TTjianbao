//
//  JHMessage.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/5/11.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHMessage.h"
#import "JHAttributeStringTool.h"
#import "NSAttributedString+PPAddition.h"
#import "PPStickerDataManager.h"
#import "EmoticonHelper.h"
#import "NSAttributedString+YYText.h"
#import "JHChatCustomTipModel.h"

@implementation JHMessage

#pragma mark - Init
- (instancetype)initWithMessage : (NIMMessage *)message {
    self = [super init];
    if (self) {
        if (message.isReceivedMsg) {
            self.senderType = JHMessageSenderTypeOther;
        }else {
            self.senderType = JHMessageSenderTypeMe;
        }
        
        if (message.isBlackListed) {
            self.sendState = JHMessageSendStateBlack;
        }else {
            self.sendState = message.deliveryState;
        }
        
        self.isRemoteRead = message.isRemoteRead;
    
        self.message = message;
    }
    return self;
}

- (instancetype)initWithText : (NSString *)text {
    self = [super init];
    if (self) {
        NIMMessage *msg = [[NIMMessage alloc] init];
        msg.antiSpamOption = [self getTextAntiSpamOption];
        msg.text = text;
        self.message = msg;
        self.messageType = JHMessageTypeText;
    }
    return self;
}
- (instancetype)initWithImage : (UIImage *)image thumImage : (UIImage *)thumImage {
    self = [super init];
    if (self) {
        self.image = image;
        self.thumImage = thumImage;
        NIMMessage *msg = [[NIMMessage alloc] init];
        msg.antiSpamOption = [self getImageAntiSpamOption];
        NIMImageObject *object = [[NIMImageObject alloc] initWithImage:image];
        msg.messageObject = object;
        self.message = msg;
        self.messageType = JHMessageTypeImage;
    }
    return self;
}
- (instancetype)initWithAudioUrl : (NSString *)url duration : (NSInteger)duration{
    self = [super init];
    if (self) {
        self.messageType = JHMessageTypeAudio;
        self.mediaUrl = url;
        NIMMessage *msg = [[NIMMessage alloc] init];
        NIMAudioObject *object = [[NIMAudioObject alloc] initWithSourcePath:url];
        object.duration = duration;
        msg.messageObject = object;
        self.message = msg;
    }
    return self;
}
- (instancetype)initWithVideo : (NSString *)url thumImage : (UIImage *)thumImage {
    self = [super init];
    if (self) {
        self.messageType = JHMessageTypeVideo;
        self.thumImage = thumImage;
        self.image = thumImage;
        self.mediaUrl = url;
        NIMMessage *msg = [[NIMMessage alloc] init];
        msg.antiSpamOption = [self getVideoAntiSpamOption];
        NIMVideoObject *object = [[NIMVideoObject alloc] initWithSourcePath:url];
        msg.messageObject = object;
        self.message = msg;
    }
    return self;
}
/// 商品消息
- (instancetype)initWithGoods : (JHChatGoodsInfoModel *)goodsInfo {
    self = [super init];
    if (self) {
        self.messageType = JHMessageTypeGoods;
        JHChatCustomGoodsModel *goods = [[JHChatCustomGoodsModel alloc] init];
        goods.body = goodsInfo;
        NIMMessage *msg = [[NIMMessage alloc] init];
        msg.timestamp = [self getNowDateInterval];
        NIMCustomObject *object = [[NIMCustomObject alloc] init];
        object.attachment = goods;
        msg.messageObject = object;
        self.message = msg;
    }
    return self;
}
/// 订单消息
- (instancetype)initWithOrder : (JHChatOrderInfoModel *)orderInfo {
    self = [super init];
    if (self) {
        self.messageType = JHMessageTypeOrder;
        JHChatCustomOrderModel *order = [[JHChatCustomOrderModel alloc] init];
        order.body = orderInfo;
        NIMMessage *msg = [[NIMMessage alloc] init];
        NIMCustomObject *object = [[NIMCustomObject alloc] init];
        object.attachment = order;
        msg.messageObject = object;
        self.message = msg;
    }
    return self;
}
/// 优惠券消息
- (instancetype)initWithCoupon : (JHChatCouponInfoModel *)couponInfo {
    self = [super init];
    if (self) {
        self.messageType = JHMessageTypeCoupon;
        JHChatCustomCouponModel *coupon = [[JHChatCustomCouponModel alloc] init];
        coupon.body = couponInfo;
        NIMMessage *msg = [[NIMMessage alloc] init];
        NIMCustomObject *object = [[NIMCustomObject alloc] init];
        object.attachment = coupon;
        msg.messageObject = object;
        self.message = msg;
    }
    return self;
}
- (instancetype)initWithDate : (NSString *)date {
    self = [super init];
    if (self) {
        self.messageType = JHMessageTypeDate;
        JHChatCustomDateModel *dateModel = [[JHChatCustomDateModel alloc] init];
        JHChatCustomDateInfo *dateInfo = [[JHChatCustomDateInfo alloc] init];
        dateInfo.date = date;
        
        dateModel.body = dateInfo;
        
        NIMMessage *msg = [[NIMMessage alloc] init];
        NIMCustomObject *object = [[NIMCustomObject alloc] init];
        object.attachment = dateModel;
        msg.messageObject = object;
        
        NIMMessageSetting *setting = [self getMessageSetting];;
        msg.setting = setting;
        self.message = msg;
    }
    return self;
}
/// 自定义提示消息
- (instancetype)initCustomTipMessage : (NSString *)senderTip receiverTip : (NSString *)receiverTip type : (JHChatCustomTipType)type{
    self = [super init];
    if (self) {
        self.messageType = JHMessageTypeCustomTip;
        JHChatCustomTipModel *tipModel = [[JHChatCustomTipModel alloc] init];
        JHChatCustomTipInfo *tipInfo = [[JHChatCustomTipInfo alloc] init];
        tipInfo.type = type;
        tipInfo.senderTip = senderTip;
        tipInfo.receiverTip = receiverTip;
        tipModel.body = tipInfo;
        
        NIMMessage *msg = [[NIMMessage alloc] init];
        NIMCustomObject *object = [[NIMCustomObject alloc] init];
        object.attachment = tipModel;
        msg.messageObject = object;
        
        NIMMessageSetting *setting = [self getMessageSetting];;
        msg.setting = setting;
        self.message = msg;
    }
    return self;
}
/// 自定义提示消息
- (instancetype)initCustomTipApnsMessage : (NSString *)senderTip receiverTip : (NSString *)receiverTip type : (JHChatCustomTipType)type{
    self = [super init];
    if (self) {
        self.messageType = JHMessageTypeCustomTip;
        JHChatCustomTipModel *tipModel = [[JHChatCustomTipModel alloc] init];
        JHChatCustomTipInfo *tipInfo = [[JHChatCustomTipInfo alloc] init];
        tipInfo.type = type;
        tipInfo.senderTip = senderTip;
        tipInfo.receiverTip = receiverTip;
        tipModel.body = tipInfo;
        
        NIMMessage *msg = [[NIMMessage alloc] init];
        NIMCustomObject *object = [[NIMCustomObject alloc] init];
        object.attachment = tipModel;
        msg.messageObject = object;
        self.message = msg;
    }
    return self;
}
- (instancetype)initRevokeMessage : (NSString *)msg text : (NSString *)text isEdit : (BOOL)isEdit {
    self = [super init];
    if (self) {
        self.messageType = JHMessageTypeRevoke;
        self.isEdit = isEdit;
        NIMMessage *message = [[NIMMessage alloc] init];
        NIMTipObject *object = [[NIMTipObject alloc] init];
        message.text = msg;
        message.localExt = @{@"type" : @"revoke",
                         @"edit" : @(isEdit),
                         @"text" : text};
        message.messageObject = object;
        NIMMessageSetting *setting = [self getMessageSetting];
        
        message.setting = setting;
        self.message = message;
    }
    return self;
}
- (instancetype)initTipMessage : (NSString *)msg senderType :(JHMessageSenderType)senderType{
    self = [super init];
    if (self) {
        self.messageType = JHMessageTypeTip;
        
        NIMMessage *message = [[NIMMessage alloc] init];
        message.timestamp = [self getNowDateInterval];
        NIMTipObject *object = [[NIMTipObject alloc] init];
        message.text = msg;
        message.localExt = @{@"type" : @"Tip",
                             @"senderType" : @(senderType)
        };
        message.messageObject = object;
        NIMMessageSetting *setting = [self getMessageSetting];
        message.setting = setting;
        
        self.message = message;
    }
    return self;
}
#pragma mark - Private
- (NIMAntiSpamOption *)getTextAntiSpamOption {
    NIMAntiSpamOption *option = [[NIMAntiSpamOption alloc] init];
    option.yidunEnabled = true;
    option.businessId = @"b1749c53713e74f02fdb159e4266d9c7";
    return option;
}
- (NIMAntiSpamOption *)getImageAntiSpamOption {
    NIMAntiSpamOption *option = [[NIMAntiSpamOption alloc] init];
    option.yidunEnabled = true;
    option.businessId = @"fd69600b79d9b4b21147677057a1a958";
    return option;
}
- (NIMAntiSpamOption *)getVideoAntiSpamOption {
    NIMAntiSpamOption *option = [[NIMAntiSpamOption alloc] init];
    option.yidunEnabled = true;
    option.businessId = @"5d59218b73a4cac1e91247fdaf819540";
    return option;
}
- (void)setupMessageType {
    
    switch (self.message.messageType) {
        case NIMMessageTypeText:
            self.messageType = JHMessageTypeText;
            [self setupTextMessage];
            break;
        case NIMMessageTypeImage:
            self.messageType = JHMessageTypeImage;
            [self setupImageMessage];
            break;
        case NIMMessageTypeAudio:
            self.messageType = JHMessageTypeAudio;
            [self setupAudioMessage];
            break;
        case NIMMessageTypeVideo:
            self.messageType = JHMessageTypeVideo;
            [self setupVideoMessage];
            break;
        case NIMMessageTypeCustom:
            [self setupCustomMessage];
            break;
        case NIMMessageTypeTip:
            [self setupTipMessage];
            break;
        default:
            [self setupUnknownMessage];
            break;
    }
}
- (NIMMessageSetting *)getMessageSetting {
    NIMMessageSetting *setting = [[NIMMessageSetting alloc] init];
    setting.apnsEnabled        = false;
    setting.shouldBeCounted    = false;
    return setting;
}
- (void)setupUnknownMessage {
    self.messageType = JHMessageTypeUnknown;
    self.message.text = @"[暂不支持此消息，请更新APP版本后查看]";
    NSString *text = self.message.text;
    if (text.length <= 0) return;
    self.attText = [self getAttributedStringWithText:text];
    CGFloat textHeight = [self getAttTextHeightWithAtt:self.attText];
    self.height = textHeight + iconTop + contentBottomSpace + contentInset * 2;
}
#pragma mark - 设置-富文本-消息
- (void)setupTextMessage {
    NSString *text = self.message.text;
    if (text.length <= 0) return;
    self.attText = [self getAttributedStringWithText:text];
    CGFloat textHeight = [self getAttTextHeightWithAtt:self.attText];
    self.height = textHeight + iconTop + contentBottomSpace + contentInset * 2;
}
- (NSAttributedString *)getAttributedStringWithText : (NSString *)text {
    UIFont *font = [UIFont fontWithName:kFontNormal size:IMTextMessagefontSize];;

    NSMutableAttributedString *attributedComment = [[NSMutableAttributedString alloc] initWithString:text attributes:@{ NSFontAttributeName: font, NSForegroundColorAttributeName: HEXCOLOR(0x333333)}];

    NSMutableAttributedString *att = attributedComment ; // [self matchLinksWithText:attributedComment]; 暂时不支持超链接跳转
    // 匹配表情
    [PPStickerDataManager.sharedInstance replaceEmojiForAttributedStringYYText:att font:font];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [att addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:att.pp_rangeOfAll];
    [att addAttribute:NSFontAttributeName value:font range:att.pp_rangeOfAll];
    return att;
}
/// 匹配超链接 富文本
- (NSMutableAttributedString *)matchLinksWithText : (NSAttributedString *)text {
    if (text.length <= 0) return nil;
    NSMutableAttributedString *targetStr = [[NSMutableAttributedString alloc] initWithAttributedString:text];

    NSRegularExpression *expression = [EmoticonHelper regexURL];
    NSArray *arr = [expression matchesInString:text.string options:NSMatchingReportProgress range:text.rangeOfAll];
    
    for (NSTextCheckingResult *match in arr){
        @weakify(self)
        [targetStr setTextHighlightRange:match.range color:[UIColor blueColor] backgroundColor:[UIColor whiteColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            @strongify(self)
            NSString *link = [text.string substringWithRange:range];
            [self.clickLinksEvent sendNext:link];
        }];
    }
    return targetStr;
}
#pragma mark - 设置-语音-消息
- (void)setupAudioMessage {
    
    NIMAudioObject *audioObject = (NIMAudioObject *)self.message.messageObject;
    NSInteger duration = audioObject.duration / 1000;
    CGFloat minWidth = 60.f;
    CGFloat maxWidth = contentMaxWidth - minWidth;
    if (audioObject.path != nil) {
        self.mediaUrl = audioObject.path;
    }
    
    CGFloat step = contentMaxWidth / maxWidth;
    self.width = duration * step;
    if (self.width > maxWidth) {
        self.width = contentMaxWidth;
    }
    self.width = self.width + minWidth;
    self.height = 40.f + iconTop + contentBottomSpace;
}
#pragma mark - 设置-图片-消息
- (void)setupImageMessage {

    NIMImageObject *imageObject = (NIMImageObject *)self.message.messageObject;
    CGSize size = imageObject.size;
    if (size.height <= 0) {
        self.height = 0;
        return;
    }
//    if (imageObject.thumbPath != nil) {
//        self.thumUrl = imageObject.thumbPath;
//    }else if (imageObject.thumbUrl != nil) {
//        self.thumUrl = imageObject.thumbUrl;
//    }
    self.thumUrl = imageObject.thumbUrl ?: imageObject.thumbPath;
    if (imageObject.url != nil) {
        self.imageUrl = imageObject.url;
    }
    
    CGFloat height = 0;
    CGFloat scale = size.width / size.height;
    
    if (size.width > size.height) {
        self.width = 165.f;
    }else if (size.width < size.height){
        self.width = 106.f;
    }else {
        self.width = 106.f;
    }
    
    height = self.width / scale;
    
    self.height = height + iconTop + contentBottomSpace;
}
#pragma mark - 设置-视频-消息
- (void)setupVideoMessage {
    NIMVideoObject *videoObject = (NIMVideoObject *)self.message.messageObject;
    CGSize size = videoObject.coverSize;
    if (size.height <= 0) {
        size = self.thumImage.size;
    }
    if (size.height <= 0) {
        self.height = 0;
        return;
    }
    
    if (videoObject.coverUrl != nil) {
        self.thumUrl = videoObject.coverUrl;
    }
    
    if (videoObject.url != nil) {
        self.mediaUrl = videoObject.url;
    }
    
    CGFloat height = 0;
    CGFloat scale = size.width / size.height;
    
    if (size.width > size.height) {
        self.width = 165.f;
    }else if (size.width < size.height){
        self.width = 106.f;
    }else {
        self.width = 106.f;
    }
    
    height = self.width / scale;
    
    self.height = height + iconTop + contentBottomSpace;
}
#pragma mark - 设置-自定义-消息
- (void)setupCustomMessage {
    NIMCustomObject *object = (NIMCustomObject *)self.message.messageObject;
    if ([object.attachment isKindOfClass:[JHChatCustomOrderModel class]]) {
        JHChatCustomOrderModel *model = (JHChatCustomOrderModel *)object.attachment;
        self.orderInfo = model.body;
        [self setupOrderMessage];
    }else if ([object.attachment isKindOfClass:[JHChatCustomGoodsModel class]]) {
        JHChatCustomGoodsModel *model = (JHChatCustomGoodsModel *)object.attachment;
        self.goodsInfo = model.body;
        [self setupGoodsMessage];
    }else if ([object.attachment isKindOfClass:[JHChatCustomCouponModel class]]) {
        JHChatCustomCouponModel *model = (JHChatCustomCouponModel *)object.attachment;
        self.couponInfo = model.body;
        [self setupCouponMessage];
    }else if ([object.attachment isKindOfClass:[JHChatCustomDateModel class]]) {
        JHChatCustomDateModel *model = (JHChatCustomDateModel *)object.attachment;
        self.dateStr = model.body.date;
        [self setupDateMessage];
    }else if ([object.attachment isKindOfClass:[JHChatCustomTipModel class]]) {
        JHChatCustomTipModel *model = (JHChatCustomTipModel *)object.attachment;
        self.customTipInfo = model.body;
        [self setupCustomTipMessage];
    }
    
}
#pragma mark - 设置-Tip-消息-总
- (void)setupTipMessage {
    self.messageType = JHMessageTypeTip;
    self.sendState = JHMessageSendStateSuccess;
    NSDictionary *dic = self.message.localExt;
    if (dic == nil) return;
    NSString *type = dic[@"type"];
    if ([type isEqualToString:@"revoke"]) {
        [self setupRevokeMessage : dic];
    }else if ([type isEqualToString:@"Tip"]) {
        [self setupTipMessage : dic];
    }
}
#pragma mark - 设置-商品-消息
- (void)setupGoodsMessage {
    self.messageType = JHMessageTypeGoods;
    self.height = 86 + iconTop + contentBottomSpace;
}
#pragma mark - 设置-订单-消息
- (void)setupOrderMessage {
    self.messageType = JHMessageTypeOrder;
    self.height = 104 + iconTop + contentBottomSpace;
}
#pragma mark - 设置-优惠券-消息
- (void)setupCouponMessage {
    self.messageType = JHMessageTypeCoupon;
    self.height = 94 + iconTop + contentBottomSpace;
}
#pragma mark - 设置-日期-消息
- (void)setupDateMessage {
    self.messageType = JHMessageTypeDate;
    self.height = 32;
}
- (void)setupCustomTipMessage {
    self.messageType = JHMessageTypeCustomTip;
    
    if (self.customTipInfo.type == JHChatCustomTipTypeEvaluate) {
        self.height = 0.0f;
    }else {
        self.height = 32;
    }
}
#pragma mark - 设置-撤回-消息
- (void)setupRevokeMessage : (NSDictionary *)dic {
    self.isEdit = [dic[@"edit"] boolValue];
    if (self.isEdit) {
        self.isEdit = ([self getNowDateInterval] - self.message.timestamp) <= 3 * 60;
    }
    
    NSString *text = dic[@"text"];
    self.messageType = JHMessageTypeRevoke;
    if (text != nil) {
        self.attText = [[NSAttributedString alloc] initWithString:text];
    }
    
    self.height = 32;
}
#pragma mark - 设置-TIP-消息
- (void)setupTipMessage : (NSDictionary *)dic {
    NSInteger senderType = [dic[@"senderType"] integerValue];
    self.senderType = senderType;
    NSString *text = self.message.text;
    if (text.length <= 0) return;
    self.attText = [self getAttributedStringWithText:text];
    CGFloat textHeight = [self getAttTextHeightWithAtt:self.attText];
    self.height = textHeight + iconTop + contentBottomSpace + contentInset * 2;
}
- (void)getImageSizeWithUrl : (NSString *)url {
    
}
- (CGFloat)getAttTextHeightWithAtt : (NSAttributedString *)text {
    CGFloat width = contentMaxWidth - contentInset * 2;
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:CGSizeMake(width, MAXFLOAT) text: text];
    return layout.textBoundingSize.height;
}
// 设置高度 - 一般文本
- (CGFloat)getTextHeightWithText : (NSString *)text {
    
    CGFloat width = contentMaxWidth - contentInset * 2;
    CGFloat height = [text heightForFont:[UIFont fontWithName:kFontNormal size:msgLabelFontSize] width:width];
    return height;
}
- (NSTimeInterval)getNowDateInterval {
    NSDate *datenow = [NSDate date];//现在时间
    NSTimeInterval timeSp = [datenow timeIntervalSince1970];
    return timeSp;
}
- (void)setMessage:(NIMMessage *)message {
    _message = message;
    [self setupMessageType];
}
- (void)setUserInfo:(JHChatUserInfo *)userInfo {
    _userInfo = userInfo;
//    self.message.senderName = userInfo.nickName;
}
- (RACSubject *)clickLinksEvent {
    if (!_clickLinksEvent) {
        _clickLinksEvent = [RACSubject subject];
    }
    return _clickLinksEvent;
}


@end
