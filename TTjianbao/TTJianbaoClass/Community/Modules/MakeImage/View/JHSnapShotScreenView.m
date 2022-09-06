//
//  JHSnapShotScreenView.m
//  TTjianbao
//
//  Created by wangjianios on 2021/3/6.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHSnapShotScreenView.h"
#import "UIButton+LXExpandBtn.h"
#import "JHPostDetailModel.h"
#import "JHSQMedalView.h"
#import "JHTextView.h"
#import "PPStickerDataManager.h"
#import "JHAttributeStringTool.h"
#import "JHSQApiManager.h"
@interface JHSnapShotScreenView ()

@property (nonatomic, strong) JHPostDetailModel *model;

@property (nonatomic, copy) void (^complete) (UIImage *image, UIView *currentView);

@end


@implementation JHSnapShotScreenView

+ (JHSnapShotScreenView *)makeImageWithModel:(JHPostDetailModel *)model complete:(nonnull void (^)(UIImage * _Nonnull, UIView * _Nonnull))complete {
    UIView *superView = JHKeyWindow;
    JHSnapShotScreenView *snapShotView = [JHSnapShotScreenView new];
    snapShotView.model = model;
    snapShotView.complete = complete;
    [superView addSubview:snapShotView];
    [snapShotView jh_cornerRadius:4];
    snapShotView.backgroundColor = UIColor.whiteColor;
    [snapShotView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.mas_right);
        make.top.equalTo(superView);
        make.width.mas_equalTo(ScreenW);
    }];
    return snapShotView;
}

- (void)setModel:(JHPostDetailModel *)model {
    
    _model = model;
    
    if([_model isKindOfClass:[JHPostDetailModel class]]) {
        [self drawImageWithModel];
    }
    else if([_model isKindOfClass:[JHPostData class]]) {
        
        [JHSQApiManager getPostDetailInfo:@(_model.item_type).stringValue itemId:_model.item_id block:^(JHPostDetailModel *detailModel, BOOL hasError) {
            NSLog(@"respObj:---- %@", detailModel);
            if (!hasError) {
                _model = detailModel;
                [self drawImageWithModel];
            }
            else {
                if(_complete) {
                    _complete(nil, self);
                }
            }
            
            
        }];
    }
}

- (void)drawImageWithModel {
    ///有网络
    BOOL isNetWork = [AFNetworkReachabilityManager sharedManager].isReachable;
    
    dispatch_group_t  group = dispatch_group_create();
    
    dispatch_group_enter(group);
    
    UIView *bottomView = nil;
    {
        UIView *view = [UIView jh_viewWithColor:RGB(247, 247, 247) addToSuperview:self];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self);
            make.height.mas_equalTo(127);
        }];
        
        UIImageView *imageView = [UIImageView jh_imageViewWithImage:@"common_slogan_center" addToSuperview:view];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(view).offset(15);
            make.centerX.equalTo(view);
            make.size.mas_equalTo(CGSizeMake(100, 97));
        }];
        bottomView = view;
    }
    
    ///标题
    if(self.model.title)
    {
        UILabel *titleLabel = [UILabel jh_labelWithFont:22 textColor:RGB515151 addToSuperView:self];
        titleLabel.numberOfLines = 0;
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(15);
            make.right.equalTo(self).offset(-15);
            make.top.equalTo(bottomView.mas_bottom).offset(16);
        }];
        UIFont *font = [UIFont fontWithName:kFontMedium size:22];
        NSMutableAttributedString *titleAttr = [[NSMutableAttributedString alloc] initWithString:self.model.title];
        titleAttr.font = font;
        titleAttr.color = kColor333;
       
        UIImage *image = nil;
        if (self.model.content_level == 1) {
           image = [UIImage imageNamed:@"sq_icon_essence"];
        }
        if (image) {
            NSTextAttachment *attach = [[NSTextAttachment alloc] init];
            attach.image = image; //精华帖
            attach.bounds = CGRectMake(0, 0, image.size.width, image.size.height);
            NSAttributedString *icon = [NSAttributedString attributedStringWithAttachment:attach];
            [titleAttr insertAttributedString:icon atIndex:0];
            [titleAttr insertAttributedString:[[NSAttributedString alloc] initWithString:@" "] atIndex:1];
        }
        titleLabel.attributedText = titleAttr;
        
        bottomView = titleLabel;
    }
    
    ///用户信息
    {
        UIImageView *authorIcon = [UIImageView jh_imageViewAddToSuperview:self];
        [authorIcon jh_cornerRadius:19.f];
        [authorIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(bottomView.mas_bottom).offset(15);
            make.left.equalTo(self).offset(15);
            make.size.mas_equalTo(CGSizeMake(38, 38));
        }];
        
        dispatch_group_enter(group);
        [authorIcon jhSetImageWithURL:[NSURL URLWithString:self.model.publisher.avatar] placeholder:kDefaultAvatarImage completed:^(UIImage * _Nullable image, NSError * _Nullable error) {
            dispatch_group_leave(group);
        }];
        
        
        UILabel *authorNameLabel = [[UILabel alloc] init];
        authorNameLabel.text = self.model.publisher.user_name;
        authorNameLabel.font = [UIFont fontWithName:kFontMedium size:13];
        authorNameLabel.textColor = HEXCOLOR(0x000000);
        [self addSubview:authorNameLabel];
        [authorNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(authorIcon).offset(2);
            make.left.equalTo(authorIcon.mas_right).offset(10);
            make.width.mas_lessThanOrEqualTo(200);
        }];
        
        JHSQMedalView *medalView = [[JHSQMedalView alloc] init];
        [self addSubview:medalView];
        medalView.tagArray = self.model.publisher.levelIcons;
        [medalView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(authorNameLabel.mas_right).offset(5);
            make.right.equalTo(self).offset(-140);
            make.centerY.equalTo(authorNameLabel);
            make.height.mas_equalTo(15.f);
        }];

        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.text = self.model.publish_time;;
        timeLabel.textColor = kColor999;
        timeLabel.font = [UIFont fontWithName:kFontNormal size:11];
        [self addSubview:timeLabel];
        
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(authorIcon);
            make.left.equalTo(authorNameLabel);
        }];
        
        NSString *shareString = self.model.share_count_int > 0 ? ([self.model.share_count isNotBlank] ? self.model.share_count : @(self.model.share_count_int).stringValue) : @"分享";
        NSString *commentString = self.model.comment_num > 0 ? @(self.model.comment_num).stringValue : @"评论";
        NSString *likeString = self.model.like_num_int > 0 ? self.model.like_num : @"赞";

        UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [shareBtn setTitle:@"分享" forState:UIControlStateNormal];
        [shareBtn setImage:[UIImage imageNamed:@"sq_toolbar_icon_share"] forState:UIControlStateNormal];
        shareBtn.titleLabel.font = [UIFont fontWithName:kFontNormal size:13];
        [shareBtn setTitleColor:kColor333 forState:UIControlStateNormal];
        [shareBtn layoutButtonWithEdgeInsetsStyle:LXButtonEdgeInsetsStyleLeft imageTitleSpace:5];
        [shareBtn setTitle:shareString forState:UIControlStateNormal];
        [self addSubview:shareBtn];
        
        UIButton *commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [commentBtn setTitle:@"评论" forState:UIControlStateNormal];
        [commentBtn setImage:[UIImage imageNamed:@"sq_toolbar_icon_comment"] forState:UIControlStateNormal];
        commentBtn.titleLabel.font = [UIFont fontWithName:kFontNormal size:13];
        [commentBtn setTitleColor:kColor333 forState:UIControlStateNormal];
        [commentBtn layoutButtonWithEdgeInsetsStyle:LXButtonEdgeInsetsStyleLeft imageTitleSpace:5];
        [commentBtn setTitle:commentString forState:UIControlStateNormal];
        [self addSubview:commentBtn];
        
        UIButton *likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [likeBtn setTitle:@"赞" forState:UIControlStateNormal];
        [likeBtn setImage:[UIImage imageNamed:@"sq_toolbar_icon_like_normal"] forState:UIControlStateNormal];
        [likeBtn setImage:[UIImage imageNamed:@"sq_toolbar_icon_like_selected"] forState:UIControlStateSelected];
        likeBtn.titleLabel.font = [UIFont fontWithName:kFontNormal size:13];
        [likeBtn setTitleColor:kColor333 forState:UIControlStateNormal];
        [likeBtn layoutButtonWithEdgeInsetsStyle:LXButtonEdgeInsetsStyleLeft imageTitleSpace:5];
        [likeBtn setTitle:likeString forState:UIControlStateNormal];
        [self addSubview:likeBtn];
        
        likeBtn.selected = self.model.is_like;
        [likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-15);
            make.height.mas_equalTo(36);
            make.centerY.equalTo(authorIcon);
        }];

        [commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.height.equalTo(likeBtn);
            make.right.equalTo(likeBtn.mas_left).offset(-15);
        }];

        [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.height.equalTo(likeBtn);
            make.right.equalTo(commentBtn.mas_left).offset(-15);
        }];
        
        

        
        bottomView = timeLabel;
    }
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.model.resourceData];
    if(isNetWork) {
        if(self.model.item_type == JHPostItemTypeVideo) {
            JHPostDetailResourceModel *m = [JHPostDetailResourceModel new];
            JHPostDetailResourceSubModel *m2 = [JHPostDetailResourceSubModel new];
            m.type = JHPostDetailResourceTypeVideo;
            m2.video_cover_url = self.model.videoInfo.image;
            m.dataModel = m2;
            [array insertObject:m atIndex:0];
        }
        else if((self.model.item_type == JHPostItemTypeDynamic) && IS_ARRAY(self.model.images_medium)) {
            for (NSString *url in self.model.images_medium) {
                JHPostDetailResourceModel *m = [JHPostDetailResourceModel new];
                JHPostDetailResourceSubModel *m2 = [JHPostDetailResourceSubModel new];
                m2.image_url = url;
                m.type = JHPostDetailResourceTypeImage;
                m.dataModel = m2;
                [array addObject:m];
            }
        }
    }
    
    ///正文
    {
        for (JHPostDetailResourceModel *m in array) {
            if(isNetWork) {
                UIView *view = [self creatWithModel:m bottomView:bottomView group:group];
                bottomView = view;
            }
            else {
                if(m.type == JHPostDetailResourceTypeText) {
                    UIView *view = [self creatWithModel:m bottomView:bottomView group:group];
                    bottomView = view;
                }
            }
        }
    }
    
    ///板块信息
    {
            
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = HEXCOLOR(0xF9FAF9);
        [self addSubview:bgView];
        [bgView jh_cornerRadius:8.f];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(15);
            make.right.equalTo(self).offset(-15);
            make.top.equalTo(bottomView.mas_bottom).offset(15);
            make.height.mas_equalTo(76);
        }];
                
            ///板块的图标
        UIImageView *plateImageView = [UIImageView jh_imageViewAddToSuperview:bgView];
        [plateImageView jh_cornerRadius:5];
        [plateImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bgView).offset(10);
            make.centerY.equalTo(bgView);
            make.size.mas_equalTo(CGSizeMake(56, 56));
        }];
        
        dispatch_group_enter(group);
        [plateImageView jhSetImageWithURL:[NSURL URLWithString:self.model.plateInfo.image] placeholder:kDefaultCoverImage completed:^(UIImage * _Nullable image, NSError * _Nullable error) {
            dispatch_group_leave(group);
        }];
        
            
        UILabel *plateNameLabel = [[UILabel alloc] init];
        plateNameLabel.text = self.model.plateInfo.name;
        plateNameLabel.font = [UIFont fontWithName:kFontMedium size:15];
        [bgView addSubview:plateNameLabel];
        [plateNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(plateImageView.mas_right).offset(10);
            make.top.equalTo(bgView).offset(19);
            make.width.mas_equalTo(16*11);
        }];
        

        UILabel *plateDetailLabel = [[UILabel alloc] init];
        plateDetailLabel.font = [UIFont fontWithName:kFontNormal size:11];
        plateDetailLabel.textColor = kColor999;
        [bgView addSubview:plateDetailLabel];
        [plateDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(plateNameLabel);
            make.bottom.equalTo(bgView).offset(-18);
            make.right.equalTo(plateNameLabel);
        }];
        NSString *str = [NSString stringWithFormat:@"%ld位宝友加入 · %ld篇内容", (long)self.model.plateInfo.join_num, (long)self.model.plateInfo.post_num];
        plateDetailLabel.text = str;
        
        bottomView = bgView;
    }
    
    /// 分享二维码
    {
        UIView *view = [UIView jh_viewWithColor:RGB(247, 247, 247) addToSuperview:self];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(bottomView.mas_bottom).offset(10);
            make.height.mas_equalTo(200);
        }];
        
        UIImageView *imageView = [UIImageView jh_imageViewWithImage:[self logoQrCode] addToSuperview:view];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(view);
            make.top.equalTo(view).offset(15);
            make.size.mas_equalTo(CGSizeMake(120, 120));
        }];
        
        NSString *str = @"宝友社区，分享你的文玩生活\n长按识别二维码 查看更多精彩内容";
            
        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:str];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 8.0; // 设置行间距
        [attributedStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attributedStr.length)];
            
        
        UILabel *label = [UILabel jh_labelWithText:@"" font:14 textColor:RGB153153153 textAlignment:1 addToSuperView:view];
        label.attributedText = attributedStr;
        label.numberOfLines = 2;
        label.textAlignment = NSTextAlignmentRight;
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imageView.mas_bottom).offset(10);
            make.centerX.equalTo(imageView);
        }];
        bottomView = view;
    }
    
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bottomView);
    }];
    
    dispatch_group_leave(group);
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self completeWaitMethod];
    });
}

- (void)completeWaitMethod {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self captureScreen];
    });
}

/// 获取截屏图片
- (void)captureScreen {
    
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0.0);
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();

    UIGraphicsEndImageContext();
    
    if(_complete) {
        _complete(screenshot, self);
    }
}

///生成二维码
- (UIImage *)logoQrCode{

    //二维码过滤器
    CIFilter *qrImageFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];


    //设置过滤器默认属性
    [qrImageFilter setDefaults];

    NSData *qrImageData = [self.model.shareInfo.url dataUsingEncoding:NSUTF8StringEncoding];

    [qrImageFilter setValue:qrImageData forKey:@"inputMessage"];

    //取出图片
    CIImage *qrImage = [qrImageFilter outputImage];


    //但是图片 发现有的小 (27,27),我们需要放大..我们进去CIImage 内部看属性
    qrImage = [qrImage imageByApplyingTransform:CGAffineTransformMakeScale(20, 20)];

    //转成 UI的 类型
    UIImage *qrUIImage = [UIImage imageWithCIImage:qrImage];

    //开启绘图,获取图形上下文  (上下文的大小,就是二维码的大小)
    UIGraphicsBeginImageContext(qrUIImage.size);

    //把二维码图片画上去. (这里是以,图形上下文,左上角为 (0,0)点)
    [qrUIImage drawInRect:CGRectMake(0, 0, qrUIImage.size.width, qrUIImage.size.height)];

    //再把小图片画上去
    UIImage *sImage = [UIImage imageNamed:@"common_app_icon"];

    CGFloat sImageW = 100;
    CGFloat sImageH= sImageW;
    CGFloat sImageX = (qrUIImage.size.width - sImageW) * 0.5;
    CGFloat sImgaeY = (qrUIImage.size.height - sImageH) * 0.5;

    [sImage drawInRect:CGRectMake(sImageX, sImgaeY, sImageW, sImageH)];

    //获取当前画得的这张图片
    UIImage *finalyImage = UIGraphicsGetImageFromCurrentImageContext();

    //关闭图形上下文
    UIGraphicsEndImageContext();

    return finalyImage;
}

- (UIView *)creatWithModel:(JHPostDetailResourceModel *)model bottomView:(UIView *)bottomView group:(dispatch_group_t)group {
    switch (model.type) {
        case JHPostDetailResourceTypeVideo:
        {
            UIImageView *imageView = [UIImageView jh_imageViewAddToSuperview:self];
            [imageView jh_cornerRadius:8];
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(15);
                make.right.equalTo(self).offset(-15);
                make.top.equalTo(bottomView.mas_bottom).offset(10);
                make.height.mas_equalTo(145);
            }];
            dispatch_group_enter(group);
            [imageView jhSetImageWithURL:[NSURL URLWithString:model.dataModel.video_cover_url] placeholder:kDefaultCoverImage completed:^(UIImage * _Nullable image, NSError * _Nullable error) {
                dispatch_group_leave(group);
            }];
            
            UIView *layerView = [UIView jh_viewWithColor:RGBA(0, 0, 0, 0.5) addToSuperview:imageView];
            [layerView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(imageView);
            }];
            
            UIImageView *imageView2 = [UIImageView jh_imageViewWithImage:@"icon_video_play" addToSuperview:layerView];
            [imageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(layerView);
                make.bottom.equalTo(layerView.mas_centerY);
                make.width.height.mas_equalTo(30);
            }];
            
            UILabel *label = [UILabel jh_labelWithText:@"扫描下方二维码，查看完整视频" font:15 textColor:UIColor.whiteColor textAlignment:1 addToSuperView:layerView];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(layerView);
                make.top.equalTo(imageView2.mas_bottom).offset(11);
            }];
            return imageView;
        }
            break;
            
        case JHPostDetailResourceTypeImage:
        {
            UIImageView *imageView = [UIImageView jh_imageViewAddToSuperview:self];
            [imageView jh_cornerRadius:8];
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(15);
                make.right.equalTo(self).offset(-15);
                make.top.equalTo(bottomView.mas_bottom).offset(10);
                make.height.mas_equalTo(100);
            }];
            dispatch_group_enter(group);
            @weakify(imageView);
            [imageView jhSetImageWithURL:[NSURL URLWithString:model.dataModel.image_url] placeholder:kDefaultCoverImage completed:^(UIImage * _Nullable image, NSError * _Nullable error) {
                if(image && image.size.width > 0)
                {
                    @strongify(imageView);
                    CGSize size = image.size;
                    CGFloat s = (size.height/size.width) * (ScreenW - 30.f);
                    [imageView
                     mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.height.mas_equalTo(s);
                    }];
                }
                dispatch_group_leave(group);
            }];
            return imageView;
        }
            break;
            
        case JHPostDetailResourceTypeText:
        {
            JHTextView *textView = [[JHTextView alloc] init];
            textView.font = [UIFont fontWithName:kFontNormal size:16];
            textView.translatesAutoresizingMaskIntoConstraints = NO;
            textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;//自适应高度
            [self addSubview:textView];
            [textView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(15);
                make.right.equalTo(self).offset(-15);
                make.top.equalTo(bottomView.mas_bottom).offset(10);
            }];
            
            NSString *arrayString = model.data[@"attrs"];
            NSArray *array = [NSArray array];
            if ([arrayString isNotBlank]) {
                NSData *jsonData = [model.data[@"attrs"] dataUsingEncoding:NSUTF8StringEncoding];
                   NSError *err;
               array = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
            }
            if (array.count > 0) {
                [self setContent:[JHAttributeStringTool getOneParagraphAttrForPostDetail:array normalColor:kColor333 font:[UIFont fontWithName:kFontNormal size:16] logoSize:CGSizeMake(12, 12)] isEssence:NO textView:textView];
            }else{
                NSString *str = [NSString stringWithFormat:@"%@", model.data[@"text"]];
                if (![str isNotBlank] || [str containsString:@"null"]) {
                    str = @"";
                }
                [self setContent:[[NSMutableAttributedString alloc] initWithString:str] isEssence:NO textView:textView];
            }
            return textView;
        }
            break;
            
        default:
            return [UIView new];
            break;
    }
    return [UIView new];
}


- (void)setContent:(NSMutableAttributedString *)content isEssence:(BOOL)isEssence textView:(JHTextView *)textView {
    NSMutableAttributedString *attri = content;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:6];//调整行间距
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    paragraphStyle.hyphenationFactor = 1.0;
    paragraphStyle.firstLineHeadIndent = 0.0;
    paragraphStyle.paragraphSpacingBefore = 0.0;
    paragraphStyle.headIndent = 0;
    paragraphStyle.tailIndent = 0;
    [attri addAttributes:@{NSParagraphStyleAttributeName:paragraphStyle,
                           NSFontAttributeName:[UIFont fontWithName:kFontNormal size:16]
    } range:NSMakeRange(0, [content length])];
    
    if (isEssence == 1) {
        NSTextAttachment *attach = [[NSTextAttachment alloc] init];
        attach.image = [UIImage imageNamed:@"sq_icon_essence"];
        attach.bounds = CGRectMake(0, 0, 31, 14);
        NSAttributedString *attachText = [NSAttributedString attributedStringWithAttachment:attach];
        //插入到开头
        [attri insertAttributedString:attachText atIndex:0];
    }
    
    [PPStickerDataManager.sharedInstance replaceEmojiForAttributedString:attri font:[UIFont fontWithName:kFontNormal size:16]];
        
    textView.attributedText = [JHAttributeStringTool markAtBlueForPostDetail:attri];
    CGFloat textHeight = [textView sizeThatFits:CGSizeMake(ScreenW-30, CGFLOAT_MAX)].height;
    
    [textView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(textHeight);
    }];
}

@end
