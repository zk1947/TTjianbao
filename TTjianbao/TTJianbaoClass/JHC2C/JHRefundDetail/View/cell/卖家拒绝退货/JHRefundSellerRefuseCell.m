//
//  JHRefundSellerRefuseCell.m
//  TTjianbao
//
//  Created by hao on 2021/5/13.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#define kPerLineCount  3   //每行显示X张图

#import "JHRefundSellerRefuseCell.h"
#import "JHRefundDetailPhotosView.h"
#import "JHPhotoBrowserManager.h"

@interface JHRefundSellerRefuseCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UILabel *reasonText;
@property (nonatomic, strong) UILabel *reasonLabel;

@property (nonatomic, strong) UILabel *groundsText;
@property (nonatomic, strong) UILabel *groundsLabel;


@property (nonatomic, strong) UILabel *pictureText;
@property (nonatomic, strong) UIView *imagesView;
@property (nonatomic, strong) JHRefundDetailPhotosView *photosView;
@end

@implementation JHRefundSellerRefuseCell

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
    
    //拒绝原因
    [self.backView addSubview:self.reasonLabel];
    [self.reasonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.left.equalTo(self.backView).offset(72);
        make.right.equalTo(self.backView).offset(-8);
    }];
    [self.backView addSubview:self.reasonText];
    [self.reasonText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.reasonLabel);
        make.left.equalTo(self.backView).offset(10);
    }];
    
    //拒绝理由
    [self.backView addSubview:self.groundsLabel];
    [self.groundsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.reasonLabel.mas_bottom).offset(10);
        make.left.equalTo(self.reasonLabel);
        make.right.equalTo(self.backView).offset(-8);
    }];
    [self.backView addSubview:self.groundsText];
    [self.groundsText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.groundsLabel);
        make.left.equalTo(self.backView).offset(10);
    }];
    
    //申请凭证、图片
    [self.backView addSubview:self.imagesView];
    [self.imagesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.groundsLabel.mas_bottom).offset(10);
        make.left.equalTo(self.reasonLabel);
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
    if ([listModel.operationType intValue] == 2) {
        self.titleLabel.text = @"卖家拒绝退货";
    }else if ([listModel.operationType intValue] == 9){
        self.titleLabel.text = @"卖家收货后拒绝退款";
    }else if ([listModel.operationType intValue] == 14){
        self.titleLabel.text = @"卖家拒绝退款";
    }
    //拒绝原因
    self.reasonLabel.text = listModel.refuseReasonDesc;
    //拒绝理由
    self.groundsLabel.text = listModel.refuseDesc;
    
    
    [self.reasonLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.left.equalTo(self.backView).offset(72);
        make.right.equalTo(self.backView).offset(-8);
    }];
    [self.groundsLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.reasonLabel.mas_bottom).offset(10);
        make.left.equalTo(self.reasonLabel);
        make.right.equalTo(self.backView).offset(-8);
    }];
    [self.imagesView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(20);
    }];
    //拒绝理由有内容显示，没有不显示
    if (listModel.refuseDesc.length > 0) {
        self.groundsLabel.hidden = NO;
        self.groundsText.hidden = NO;
    }else{
        self.groundsLabel.hidden = YES;
        self.groundsText.hidden = YES;
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
        if (listModel.refuseDesc.length > 0) {
            [self.imagesView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.groundsLabel.mas_bottom).offset(10);
                make.left.equalTo(self.reasonLabel);
                make.right.equalTo(self.backView).offset(-10);
                make.height.mas_offset(imagesViewHeight);
                make.bottom.equalTo(self.backView).offset(-10);
            }];
        }else{
            [self.imagesView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.reasonLabel.mas_bottom).offset(10);
                make.left.equalTo(self.reasonLabel);
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
        
        if (listModel.refuseDesc.length > 0) {
            [self.groundsLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.reasonLabel.mas_bottom).offset(10);
                make.left.equalTo(self.reasonLabel);
                make.right.equalTo(self.backView).offset(-8);
                make.bottom.equalTo(self.backView).offset(-10);
            }];
        }else{
            [self.reasonLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
                make.left.equalTo(self.backView).offset(72);
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

- (UILabel *)reasonText{
    if (!_reasonText) {
        _reasonText = [[UILabel alloc] init];
        _reasonText.textColor = HEXCOLOR(0x999999);
        _reasonText.font = [UIFont fontWithName:kFontNormal size:13];
        _reasonText.text = @"拒绝原因";
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

- (UILabel *)groundsText{
    if (!_groundsText) {
        _groundsText = [[UILabel alloc] init];
        _groundsText.textColor = HEXCOLOR(0x999999);
        _groundsText.font = [UIFont fontWithName:kFontNormal size:13];
        _groundsText.text = @"拒绝理由";
    }
    return _groundsText;
}
- (UILabel *)groundsLabel{
    if (!_groundsLabel) {
        _groundsLabel = [[UILabel alloc] init];
        _groundsLabel.textColor = HEXCOLOR(0x333333);
        _groundsLabel.font = [UIFont fontWithName:kFontNormal size:13];
    }
    return _groundsLabel;
}
- (UILabel *)pictureText{
    if (!_pictureText) {
        _pictureText = [[UILabel alloc] init];
        _pictureText.textColor = HEXCOLOR(0x999999);
        _pictureText.font = [UIFont fontWithName:kFontNormal size:13];
        _pictureText.text = @"拒绝凭证";
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
