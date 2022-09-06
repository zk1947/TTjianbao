//
//  JHRefundBuyerApplyCell.m
//  TTjianbao
//
//  Created by hao on 2021/5/13.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#define kPerLineCount  3   //每行显示X张图

#import "JHRefundBuyerApplyCell.h"
#import "JHRefundDetailPhotosView.h"
#import "JHPhotoBrowserManager.h"


@interface JHRefundBuyerApplyCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UILabel *typeText;
@property (nonatomic, strong) UILabel *typeLabel;

@property (nonatomic, strong) UILabel *moneyText;
@property (nonatomic, strong) UILabel *moneyLabel;

@property (nonatomic, strong) UILabel *reasonText;
@property (nonatomic, strong) UILabel *reasonLabel;

@property (nonatomic, strong) UILabel *descriptionText;
@property (nonatomic, strong) UILabel *descriptionLabel;

@property (nonatomic, strong) UILabel *pictureText;
@property (nonatomic, strong) UIView *imagesView;
@property (nonatomic, strong) JHRefundDetailPhotosView *photosView;


@end

@implementation JHRefundBuyerApplyCell

#pragma mark - UI
- (void)setupViews{
    //标题
    [self.backView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.backView).offset(10);
    }];
    //时间
    [self.backView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel);
        make.right.equalTo(self.backView).offset(-10);
    }];
    
    //退款类型
    [self.backView addSubview:self.typeLabel];
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.left.equalTo(self.backView).offset(72);
        make.right.equalTo(self.backView).offset(-8);
    }];
    [self.backView addSubview:self.typeText];
    [self.typeText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.typeLabel);
        make.left.equalTo(self.backView).offset(10);
    }];
    
    //退款金额
    [self.backView addSubview:self.moneyLabel];
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.typeLabel.mas_bottom).offset(10);
        make.left.equalTo(self.typeLabel);
        make.right.equalTo(self.backView).offset(-8);
    }];
    [self.backView addSubview:self.moneyText];
    [self.moneyText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.moneyLabel);
        make.left.equalTo(self.backView).offset(10);
    }];
    
    //退款原因
    [self.backView addSubview:self.reasonLabel];
    [self.reasonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.moneyLabel.mas_bottom).offset(10);
        make.left.equalTo(self.moneyLabel);
        make.right.equalTo(self.backView).offset(-8);
    }];
    [self.backView addSubview:self.reasonText];
    [self.reasonText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.reasonLabel);
        make.left.equalTo(self.backView).offset(10);
    }];
    
    //退款描述
    [self.backView addSubview:self.descriptionLabel];
    [self.descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.reasonLabel.mas_bottom).offset(10);
        make.left.equalTo(self.reasonLabel);
        make.right.equalTo(self.backView).offset(-8);
    }];
    [self.backView addSubview:self.descriptionText];
    [self.descriptionText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.descriptionLabel);
        make.left.equalTo(self.backView).offset(10);
    }];
    
    //申请凭证、图片
    [self.backView addSubview:self.imagesView];
    [self.imagesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.descriptionLabel.mas_bottom).offset(10);
        make.left.equalTo(self.descriptionLabel);
        make.right.equalTo(self.backView).offset(-10);
        make.height.mas_offset(20);
        make.bottom.equalTo(self.backView).offset(-10);

    }];
    [self.backView addSubview:self.pictureText];
    [self.pictureText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imagesView);
        make.left.equalTo(self.backView).offset(10);
    }];
    
    
}
#pragma mark - LoadData
- (void)bindViewModel:(id)dataModel{
    JHRefundOperationListModel *listModel = dataModel;
    //时间
    self.timeLabel.text = [self timestampSwitchTime:[listModel.optTime integerValue]];
    //标题
    if ([listModel.operationType intValue] == 1) {//买家申请退货退款
        self.titleLabel.text = @"买家申请退货退款";
    }else if ([listModel.operationType intValue] == 10){//卖家取消交易
        self.titleLabel.text = @"卖家取消交易";
    }else if ([listModel.operationType intValue] == 11){//买家申请退款
        self.titleLabel.text = @"买家申请退款";
    }
    //退款类型
    self.typeLabel.text = listModel.refundTypeDesc;
    //退款金额
    self.moneyLabel.text = [NSString stringWithFormat:@"¥%@",listModel.refundAmt];
    //退款原因
    self.reasonLabel.text = listModel.refundReasonDesc;
    //退款描述
    self.descriptionLabel.text = listModel.refundDesc;

    [self.reasonLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.moneyLabel.mas_bottom).offset(10);
        make.left.equalTo(self.moneyLabel);
        make.right.equalTo(self.backView).offset(-8);
    }];
    [self.descriptionLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.reasonLabel.mas_bottom).offset(10);
        make.left.equalTo(self.reasonLabel);
        make.right.equalTo(self.backView).offset(-8);
    }];
    [self.imagesView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(20);
    }];
    //退款描述有内容显示，没有不显示
    if (listModel.refundDesc.length > 0) {
        self.descriptionLabel.hidden = NO;
        self.descriptionText.hidden = NO;
    }else{
        self.descriptionLabel.hidden = YES;
        self.descriptionText.hidden = YES;
    }
    //图片 有显示，没有不显示
    if (listModel.images.count > 0) {
        self.imagesView.hidden = NO;
        self.pictureText.hidden = NO;
        [self.imagesView removeAllSubviews];
        NSMutableArray *thumbImgArray = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray *mediumImgArray = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray *origImgArray = [NSMutableArray arrayWithCapacity:0];

        for (int i = 0; i < listModel.images.count; ++i) {
            JHRefundImagesModel *imgModel = listModel.images[i];
            [thumbImgArray addObject:imgModel.small];
            [mediumImgArray addObject:imgModel.medium];
            [origImgArray addObject:imgModel.origin];
        }
        CGFloat imageHeight = (kScreenWidth-20-72-20 - 10*(kPerLineCount-1))/kPerLineCount;
        CGFloat imagesViewHeight = thumbImgArray.count > 3 ? imageHeight*2+10 : imageHeight;
        if (listModel.refundDesc.length > 0) {
            [self.imagesView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.descriptionLabel.mas_bottom).offset(10);
                make.left.equalTo(self.descriptionLabel);
                make.right.equalTo(self.backView).offset(-10);
                make.height.mas_offset(imagesViewHeight);
                make.bottom.equalTo(self.backView).offset(-10);
            }];
        }else{
            [self.imagesView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.reasonLabel.mas_bottom).offset(10);
                make.left.equalTo(self.descriptionLabel);
                make.right.equalTo(self.backView).offset(-10);
                make.height.mas_offset(imagesViewHeight);
                make.bottom.equalTo(self.backView).offset(-10);
            }];
        }
        self.photosView = [[JHRefundDetailPhotosView alloc] initPhotosViewFrame:CGRectMake(0, 0, kScreenWidth-20-72-20, imagesViewHeight) withImageHeight:imageHeight clickPhotoBlock:^(NSArray * _Nonnull sourceViews, NSInteger index) {
            //浏览图片
            [JHPhotoBrowserManager showPhotoBrowserThumbImages:thumbImgArray mediumImages:mediumImgArray origImages:origImgArray sources:sourceViews currentIndex:index canPreviewOrigImage:YES showStyle:GKPhotoBrowserShowStyleZoom];
        }];
        self.photosView.images = thumbImgArray;
        [self.imagesView addSubview:self.photosView];
    }else{
        self.imagesView.hidden = YES;
        self.pictureText.hidden = YES;
        
        if (listModel.refundDesc.length > 0) {
            [self.descriptionLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.reasonLabel.mas_bottom).offset(10);
                make.left.equalTo(self.reasonLabel);
                make.right.equalTo(self.backView).offset(-8);
                make.bottom.equalTo(self.backView).offset(-10);
            }];
        }else{
            [self.reasonLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.moneyLabel.mas_bottom).offset(10);
                make.left.equalTo(self.moneyLabel);
                make.right.equalTo(self.backView).offset(-8);
                make.bottom.equalTo(self.backView).offset(-10);
            }];
        }

    }
}

#pragma mark - Action

#pragma mark - Delegate

#pragma mark - Lazy
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = HEXCOLOR(0x333333);
        _titleLabel.font = [UIFont fontWithName:kFontMedium size:15];
    }
    return _titleLabel;
}
- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = HEXCOLOR(0x999999);
        _timeLabel.font = [UIFont fontWithName:kFontNormal size:12];
    }
    return _timeLabel;
}
- (UILabel *)typeText{
    if (!_typeText) {
        _typeText = [[UILabel alloc] init];
        _typeText.textColor = HEXCOLOR(0x999999);
        _typeText.font = [UIFont fontWithName:kFontNormal size:13];
        _typeText.text = @"退款类型";
    }
    return _typeText;
}
- (UILabel *)typeLabel{
    if (!_typeLabel) {
        _typeLabel = [[UILabel alloc] init];
        _typeLabel.textColor = HEXCOLOR(0x333333);
        _typeLabel.font = [UIFont fontWithName:kFontNormal size:13];
    }
    return _typeLabel;
}

- (UILabel *)moneyText{
    if (!_moneyText) {
        _moneyText = [[UILabel alloc] init];
        _moneyText.textColor = HEXCOLOR(0x999999);
        _moneyText.font = [UIFont fontWithName:kFontNormal size:13];
        _moneyText.text = @"退款金额";
    }
    return _moneyText;
}
- (UILabel *)moneyLabel{
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.textColor = HEXCOLOR(0x333333);
        _moneyLabel.font = [UIFont fontWithName:kFontNormal size:13];
    }
    return _moneyLabel;
}

- (UILabel *)reasonText{
    if (!_reasonText) {
        _reasonText = [[UILabel alloc] init];
        _reasonText.textColor = HEXCOLOR(0x999999);
        _reasonText.font = [UIFont fontWithName:kFontNormal size:13];
        _reasonText.text = @"退款原因";
    }
    return _reasonText;
}
- (UILabel *)reasonLabel{
    if (!_reasonLabel) {
        _reasonLabel = [[UILabel alloc] init];
        _reasonLabel.textColor = HEXCOLOR(0x333333);
        _reasonLabel.font = [UIFont fontWithName:kFontNormal size:13];
    }
    return _reasonLabel;
}

- (UILabel *)descriptionText{
    if (!_descriptionText) {
        _descriptionText = [[UILabel alloc] init];
        _descriptionText.textColor = HEXCOLOR(0x999999);
        _descriptionText.font = [UIFont fontWithName:kFontNormal size:13];
        _descriptionText.text = @"退款描述";
    }
    return _descriptionText;
}
- (UILabel *)descriptionLabel{
    if (!_descriptionLabel) {
        _descriptionLabel = [[UILabel alloc] init];
        _descriptionLabel.textColor = HEXCOLOR(0x333333);
        _descriptionLabel.font = [UIFont fontWithName:kFontNormal size:13];
    }
    return _descriptionLabel;
}
- (UILabel *)pictureText{
    if (!_pictureText) {
        _pictureText = [[UILabel alloc] init];
        _pictureText.textColor = HEXCOLOR(0x999999);
        _pictureText.font = [UIFont fontWithName:kFontNormal size:13];
        _pictureText.text = @"申请凭证";
    }
    return _pictureText;
}
- (UIView *)imagesView{
    if (!_imagesView) {
        _imagesView = [[UIView alloc] init];
        _imagesView.backgroundColor = UIColor.clearColor;
    }
    return _imagesView;
}

@end
