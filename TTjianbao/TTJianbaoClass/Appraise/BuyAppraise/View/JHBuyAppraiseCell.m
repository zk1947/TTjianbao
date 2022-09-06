//
//  JHBuyAppraiseCell.m
//  TTjianbao
//
//  Created by 王记伟 on 2020/12/16.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHBuyAppraiseCell.h"
#import "JHBuyTrueFalseView.h"
#import "JHSQPhotoView.h"
#import "JHBuyAppraiseModel.h"
#import "UIImageView+WebCache.h"
#import "JHPhotoBrowserManager.h"
#import "NSString+AttributedString.h"
#import "JHBuyAppraiseVideoController.h"

#import "JHHeaderPopView.h"
#import "MBProgressHUD.h"
#import "JHGrowingIO.h"
#import "PPStickerDataManager.h"

@interface JHBuyAppraiseCell()
/** 名字*/
@property (nonatomic, strong) UILabel *nameLabel;
/** 头像*/
@property (nonatomic, strong) UIImageView *iconImageView;
/** 时间*/
@property (nonatomic, strong) UILabel *timeLabel;
/** 价格*/
@property (nonatomic, strong) UILabel *priceLabel;
/** 真假视图*/
@property (nonatomic, strong) JHBuyTrueFalseView *trueFalseView;
/** 真假印戳*/
@property (nonatomic, strong) UIImageView *sealImageView;
/** 内容文字*/
@property (nonatomic, strong) YYLabel *contentLabel;
/** 图片视图*/
@property (nonatomic, strong) JHSQPhotoView *imagesView;
/** 分割线*/
@property (nonatomic, strong) UIView *lineView;

@end
@implementation JHBuyAppraiseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self configUI];
    }
    return self;
}

- (void)setModel:(JHBuyAppraiseModel *)model{
    _model = model;
    if ([model.showType isEqualToString:@"0"] && model.videoUrl.length > 0) {  //展示视频
        [self.imagesView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
        [self.videoImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(210);
        }];
        [self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.videoImageView.mas_bottom).offset(15);
        }];
        [self.videoImageView sd_setImageWithURL:[NSURL URLWithString:model.videoImgUrl.largePictureUrl] placeholderImage:kDefaultCoverImage];
    }else if([model.showType isEqualToString:@"1"] && model.pictureUrls.thumbsPictureUrls.count > 0){ //展示图片
        [self.imagesView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo([JHSQPhotoView viewHeight]);
        }];
        [self.videoImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
        [self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.videoImageView.mas_bottom).offset(15);
        }];
        self.imagesView.images = model.pictureUrls.thumbsPictureUrls;
    }else{
        [self.imagesView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
        [self.videoImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
        [self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.videoImageView.mas_bottom);
        }];
    }
    /** 更新真假视图ui*/
    /** 价格*/
    if ([model.appraiseType isEqualToString:@"0"]) {
        self.trueFalseView.isWorksTrue = true;
        [self.trueFalseView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.iconImageView.mas_bottom).offset(10);
            make.left.mas_equalTo(self.contentView.mas_left).offset(12);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-12);
            make.height.mas_equalTo(0);
        }];
        self.sealImageView.image = [UIImage imageNamed:@"appraisal_seal_true"];
        NSMutableArray *itemsArray = [NSMutableArray array];
        itemsArray[0] = @{@"string":@"成交价", @"color":HEXCOLOR(0x999999), @"font":[UIFont fontWithName:kFontNormal size:13]};
        itemsArray[1] = @{@"string":@" ¥ ", @"color":HEXCOLOR(0x333333), @"font":[UIFont fontWithName:kFontBoldDIN size:13]};
        itemsArray[2] = @{@"string":model.positive.amount, @"color":HEXCOLOR(0x222222), @"font":[UIFont fontWithName:kFontBoldDIN size:25]};
        self.priceLabel.attributedText = [NSString mergeStrings:itemsArray];
    }else{
        self.trueFalseView.isWorksTrue = false;
        [self.trueFalseView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.iconImageView.mas_bottom).offset(10);
            make.left.mas_equalTo(self.contentView.mas_left).offset(12);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-12);
        }];
        self.sealImageView.image = [UIImage imageNamed:@"appraisal_seal_false"];
        NSMutableArray *itemsArray = [NSMutableArray array];
        itemsArray[0] = @{@"string":[model.negative.handleType isEqualToString:@"0"] ? @"全退" : @"部分退", @"color":HEXCOLOR(0x999999), @"font":[UIFont fontWithName:kFontNormal size:13]};
        itemsArray[1] = @{@"string":@" ¥ ", @"color":HEXCOLOR(0x333333), @"font":[UIFont fontWithName:kFontBoldDIN size:13]};
        itemsArray[2] = @{@"string":model.negative.amount, @"color":HEXCOLOR(0x222222), @"font":[UIFont fontWithName:kFontBoldDIN size:25]};
        self.priceLabel.attributedText = [NSString mergeStrings:itemsArray];
    }
    self.trueFalseView.model = model;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.appraiser.appraiserHeader.thumbsPictureUrl] placeholderImage:kDefaultAvatarImage];
    self.nameLabel.text = model.appraiser.appraiserName;
    self.timeLabel.text = [JHBuyAppraiseCell updateTimeForRow:model.datetime];
    NSMutableAttributedString *contentAttString = [[NSMutableAttributedString alloc] initWithString:model.appraiseDesc];
    [contentAttString addAttributes:@{NSFontAttributeName:[UIFont fontWithName:kFontNormal size:14.], NSForegroundColorAttributeName:HEXCOLOR(0x222222)} range:NSMakeRange(0, [contentAttString string].length)];
    [PPStickerDataManager.sharedInstance replaceEmojiForAttributedString_yyLabel:contentAttString font:self.contentLabel.font];
    self.contentLabel.attributedText = contentAttString;
}

#pragma mark -- 事件处理
/** 点击视频*/
- (void)videoClickAction {
    if (self.enterDetailBlock) {
        self.enterDetailBlock(self.indexPath.row);
    }
//    JHBuyAppraiseVideoController *vc = [JHBuyAppraiseVideoController new];
//    vc.model = self.model;
//    [JHGrowingIO trackEventId:@"shopping_video" variables:@{@"appraisal_id":self.model.appraiser.appraiserId,@"shopping_id":self.model.shoppingId}];
//    [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
}
/** 点击头像*/
- (void)headerImageViewClickAction{
    [JHGrowingIO trackEventId:@"appraisal_user_in" variables:@{@"user_id": self.model.appraiser.appraiserId}];
    [self requestAppraiserInfoWithAppraiserId:self.model.appraiser.appraiserId];
}

/* 鉴定师信息 */
- (void)requestAppraiserInfoWithAppraiserId:(NSString *)appraiserId
{
    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    [parameters setValue:appraiserId forKey:@"appraiserId"];
    NSString *url = FILE_BASE_STRING(@"/anon/appraisal/shop/appraiser-info");
    [HttpRequestTool getWithURL:url Parameters:parameters successBlock:^(RequestModel * _Nullable respondObject)
    {
        [self showHeaderPopView:respondObject.data];
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
    } failureBlock:^(RequestModel * _Nullable respondObject)
    {
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
    }];
}
- (void)showHeaderPopView:(NSDictionary *)data
{
    if ([self isDictionary:data])
    {
        JHHeaderPopView *headerPopView = [[JHHeaderPopView alloc] initWithUserInfo:data];
        [headerPopView show];
    }
}
- (BOOL)isDictionary:(NSDictionary *)dic
{
   if (dic != nil && ![dic isKindOfClass:[NSNull class]] && ![dic isEqual:[NSNull null]])
   {
       return YES;
   }
   else
   {
       return NO;
   }
}

- (void)configUI{
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.priceLabel];
    [self.contentView addSubview:self.trueFalseView];
    [self.contentView addSubview:self.sealImageView];
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.imagesView];
    [self.contentView addSubview:self.videoImageView];
    [self.contentView addSubview:self.lineView];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(15);
        make.left.mas_equalTo(self.contentView.mas_left).offset(12);
        make.width.height.mas_equalTo(40);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iconImageView.mas_top);
        make.left.mas_equalTo(self.iconImageView.mas_right).offset(8);
        make.height.mas_equalTo(21);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameLabel.mas_bottom);
        make.left.mas_equalTo(self.nameLabel.mas_left);
        make.height.mas_equalTo(19);
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iconImageView.mas_top);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-12);
    }];
    [self.trueFalseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iconImageView.mas_bottom).offset(10);
        make.left.mas_equalTo(self.contentView.mas_left).offset(12);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-12);
        make.height.mas_equalTo(0);
    }];
    [self.sealImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.trueFalseView.mas_top).offset(-15);
        make.right.mas_equalTo(self.trueFalseView.mas_right).offset(6);
        make.width.height.mas_equalTo(60);
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.trueFalseView.mas_bottom).offset(0);
        make.left.mas_equalTo(self.contentView.mas_left).offset(12);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-12);
    }];
    [self.imagesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(self.contentView.mas_left).offset(2);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-2);
        make.height.mas_equalTo([JHSQPhotoView viewHeight]);
    }];
    [self.videoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.imagesView.mas_bottom);
        make.left.mas_equalTo(self.contentView.mas_left).offset(12);
        make.width.mas_equalTo(158);
        make.height.mas_equalTo(210);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.videoImageView.mas_bottom).offset(15);
        make.left.mas_equalTo(self.contentView.mas_left).offset(12);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-12);
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
}

- (UIImageView *)iconImageView{
    if (_iconImageView == nil) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.image = kDefaultAvatarImage;
        _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
        _iconImageView.layer.cornerRadius = 20;
        _iconImageView.clipsToBounds = YES;
        _iconImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *headerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerImageViewClickAction)];
        [_iconImageView addGestureRecognizer:headerTap];
    }
    return _iconImageView;
}

- (UILabel *)nameLabel{
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = HEXCOLOR(0x222222);
        _nameLabel.font = [UIFont fontWithName:kFontMedium size:15];
        _nameLabel.text = @"";
    }
    return _nameLabel;
}

- (UILabel *)timeLabel{
    if (_timeLabel == nil) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = HEXCOLOR(0x999999);
        _timeLabel.font = [UIFont fontWithName:kFontNormal size:13];
        _timeLabel.text = @"";
    }
    return _timeLabel;
}

- (UILabel *)priceLabel{
    if (_priceLabel == nil) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.textColor = HEXCOLOR(0x222222);
        _priceLabel.font = [UIFont fontWithName:kFontMedium size:15];
        _priceLabel.text = @"";
    }
    return _priceLabel;
}

- (JHBuyTrueFalseView *)trueFalseView{
    if (_trueFalseView == nil) {
        _trueFalseView = [[JHBuyTrueFalseView alloc] init];
        _trueFalseView.layer.cornerRadius = 4;
    }
    return _trueFalseView;
}

- (UIImageView *)sealImageView{
    if (_sealImageView == nil) {
        _sealImageView = [[UIImageView alloc] init];
        _sealImageView.image = kDefaultCoverImage;
    }
    return _sealImageView;
}

- (YYLabel *)contentLabel{
    if (_contentLabel == nil) {
        _contentLabel = [[YYLabel alloc] init];
        _contentLabel.text = @"";
        _contentLabel.font = [UIFont fontWithName:kFontNormal size:14];
        _contentLabel.textColor = HEXCOLOR(0x222222);
        _contentLabel.numberOfLines = 0;
        _contentLabel.textContainerInset = UIEdgeInsetsMake(10, 0, 0, 0);
        _contentLabel.preferredMaxLayoutWidth = kScreenWidth - 24;
    }
    return _contentLabel;
}

- (JHSQPhotoView *)imagesView{
    if (_imagesView == nil) {
        _imagesView = [[JHSQPhotoView alloc] init];
        _imagesView.backgroundColor = [UIColor whiteColor];
        _imagesView.clipsToBounds = YES;
        @weakify(self);
        _imagesView.clickPhotoBlock = ^(NSArray *sourceViews, NSInteger index) {
            @strongify(self);
            //浏览图片
            [JHPhotoBrowserManager showPhotoBrowserThumbImages:self.model.pictureUrls.thumbsPictureUrls mediumImages:self.model.pictureUrls.mediumPictureUrls origImages:self.model.pictureUrls.largePictureUrls sources:sourceViews currentIndex:index canPreviewOrigImage:YES showStyle:GKPhotoBrowserShowStyleZoom];
        };
    }
    return _imagesView;
}

- (UIImageView *)videoImageView{
    if (_videoImageView == nil) {
        _videoImageView = [[UIImageView alloc] init];
        _videoImageView.backgroundColor = [UIColor whiteColor];
        _videoImageView.contentMode = UIViewContentModeScaleAspectFill;
        _videoImageView.clipsToBounds = YES;
        _videoImageView.layer.cornerRadius = 4;
        _videoImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *videoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(videoClickAction)];
        [_videoImageView addGestureRecognizer:videoTap];
        
        UIImageView *playImageView = [[UIImageView alloc] init];
        playImageView.image = [UIImage imageNamed:@"appraisal_home_play"];
        [_videoImageView addSubview:playImageView];
        
        [playImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_videoImageView.mas_centerX);
            make.centerY.mas_equalTo(_videoImageView.mas_centerY);
            make.width.height.mas_equalTo(43);
        }];
        
    }
    return _videoImageView;
}

- (UIView *)lineView{
    if (_lineView == nil) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = HEXCOLOR(0xf5f5f8);
    }
    return _lineView;
}

/**
 * 将时间格式化为多久以前的显示格式
 * 0~≤1分钟，显示刚刚;
 * 1~≤60分钟，显示N分钟前；
 * 60~≤24小时，显示N小时前；
 * 24小时~≤3天，显示N天前；
 * 3天~≤1年时，显示月日：1月12日；
 * 大于1年时，显示年月日：2019年1月12日
 * 注意：时间不以自然年为标准，以倒推天数为准
 */
+ (NSString *)updateTimeForRow:(NSString *)createTimeString {
    // 获取当前时时间戳 1466386762.345715 十位整数 6位小数
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    // 创建歌曲时间戳(后台返回的时间 一般是13位数字)
    NSTimeInterval createTime = [createTimeString longLongValue]/1000;
    // 时间差
    NSTimeInterval time = currentTime - createTime;
    NSInteger sec = time/60;
    if (time<60) {
        return @"刚刚";
    }
    if (sec<60) {
        return [NSString stringWithFormat:@"%ld分钟前",(long)sec];
    }
    // 秒转小时
    NSInteger hours = time/3600;
    if (hours<24) {
        return [NSString stringWithFormat:@"%ld小时前",(long)hours];
    }
    //秒转天数
    NSInteger days = time/3600/24;
    if (days <= 365) {
        NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:createTimeString.doubleValue / 1000];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"MM-dd"];
        NSString*timeString=[formatter stringFromDate:date];
        return timeString;
    }
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:createTimeString.doubleValue / 1000];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString*timeString=[formatter stringFromDate:date];
    return timeString;
}

 

 


@end
