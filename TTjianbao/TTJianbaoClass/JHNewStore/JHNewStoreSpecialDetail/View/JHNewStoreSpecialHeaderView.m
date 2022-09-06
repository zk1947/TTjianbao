//
//  JHNewStoreSpecialHeaderView.m
//  TTjianbao
//
//  Created by liuhai on 2021/2/20.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#define newStoreSpacialHeaderHeight  186+UI.topSafeAreaHeight

#import "JHNewStoreSpecialHeaderView.h"
#import <UIImage+webP.h>
#import "JHNewStoreSpecialDescLabel.h"
#import "JHDetailAgreementView.h"
#import "JHNewStoreSpecialUserBrowseView.h"
#import "JHWebViewController.h"
#import "JHAnimatedImageView.h"

@interface JHNewStoreSpecialHeaderView ()<JHNewStoreSpecialDescLabelDelegate>
@property (nonatomic, strong) JHAnimatedImageView *topImageView;
@property (nonatomic, strong) UILabel *specialNameLabel;
@property (nonatomic, strong) UILabel *specialTagLabel;
@property (nonatomic, strong) JHNewStoreSpecialDescLabel *specialDescLabel;
@property (nonatomic, strong) UILabel *foreShowSaleLabel;
@property (nonatomic, strong) JHDetailAgreementView *detailAgreementView;
@property (nonatomic, strong) JHNewStoreSpecialUserBrowseView *userBrowseView;
@property (nonatomic, strong) JHNewStoreSpecialModel *speModel;
@end

@implementation JHNewStoreSpecialHeaderView
- (void)dealloc {

}
- (instancetype)init {
    self = [super init];
    if (self) {
        [self addSelfSubViews];
        self.backgroundColor = UIColor.whiteColor;
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSelfSubViews];
        self.backgroundColor = UIColor.whiteColor;
    }
    return self;
}

- (void)addSelfSubViews{
    
    self.topImageView = [[JHAnimatedImageView alloc] init];
    self.topImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.topImageView.clipsToBounds = YES;
    [self addSubview:self.topImageView];
    [self.topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.offset(0);
        make.top.offset(0);
        make.height.mas_equalTo(newStoreSpacialHeaderHeight);
    }];

    self.foreShowSaleLabel = [UILabel jh_labelWithFont:14 textColor:UIColor.whiteColor textAlignment:NSTextAlignmentCenter addToSuperView:self];
    [self.foreShowSaleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15+UI.topSafeAreaHeight);
        make.left.mas_equalTo(50);
        make.right.mas_equalTo(-50);
    }];
    self.foreShowSaleLabel.hidden = YES;
    
    UIView *backView = [UIView jh_viewWithColor:HEXCOLORA(0x000000, 0.4) addToSuperview:self];
    backView.layer.cornerRadius = 5;
    backView.clipsToBounds = YES;
    [self addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.height.mas_offset(106);
        make.bottom.equalTo(self.topImageView).offset(-29);
    }];
    
    self.specialNameLabel = [UILabel jh_labelWithBoldFont:20 textColor:UIColor.whiteColor textAlignment:NSTextAlignmentCenter addToSuperView:backView];
    self.specialNameLabel.numberOfLines = 0;
    [self.specialNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView).offset(12);
        make.right.equalTo(backView).offset(-12);
        make.top.mas_equalTo(10);
        make.height.mas_equalTo(60);
    }];

    UIImageView *spaceLineImgView = [UIImageView jh_imageViewWithImage:@"newStore_specalSpaceLine" addToSuperview:backView];
    [spaceLineImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView).offset(12);
        make.right.equalTo(backView).offset(-12);
        make.bottom.equalTo(backView).offset(-32);
        make.height.mas_equalTo(0.5);
    }];
     
    self.specialTagLabel = [UILabel jh_labelWithFont:11 textColor:UIColor.whiteColor textAlignment:NSTextAlignmentCenter addToSuperView:backView];
    self.specialTagLabel.numberOfLines = 1;
    self.specialTagLabel.adjustsFontSizeToFitWidth = YES;
    self.specialTagLabel.minimumScaleFactor = 10;  //最小字体
    [self.specialTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(20);
        make.bottom.equalTo(backView).offset(-5);
    }];
    
    UIView *bottomRoundView = [UIView jh_viewWithColor:UIColor.whiteColor addToSuperview:self];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, ScreenW, 146) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.path = maskPath.CGPath;
    bottomRoundView.layer.mask = maskLayer;
    [bottomRoundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.mas_offset(146);
        make.top.mas_equalTo(self.topImageView.mas_bottom).offset(-17);
    }];
    
    //用户动画
    self.userBrowseView = [[JHNewStoreSpecialUserBrowseView alloc] init];
    
    [bottomRoundView addSubview:self.userBrowseView];
    self.userBrowseView.layer.cornerRadius = 5;
//    self.userBrowseView.clipsToBounds = YES;
    [self.userBrowseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(12);
        make.right.offset(-12);
        make.height.mas_offset(52);
        make.top.mas_equalTo(bottomRoundView.mas_top).offset(12);
    }];
    
    //专题描述
    self.specialDescLabel = [JHNewStoreSpecialDescLabel new];
    self.specialDescLabel.delegate = self;
    self.specialDescLabel.numberOfLines = 3;
    self.specialDescLabel.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width - 24;
    [self addSubview:self.specialDescLabel];
    [self.specialDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.userBrowseView.mas_bottom).offset(12);
        make.left.offset(12);
        make.right.offset(-12);
    }];
    
    self.detailAgreementView = [[JHDetailAgreementView alloc] init];
    UITapGestureRecognizer *agreeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userteach)];
    [self.detailAgreementView addGestureRecognizer:agreeTap];
    [self addSubview:self.detailAgreementView];
    [self.detailAgreementView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self);
        make.height.equalTo(@54);
    }];
}

- (void)updateImageHeight:(float)height{
    if(height >= 0)
    {
        [self.topImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(newStoreSpacialHeaderHeight + height);
            make.top.offset(-height);
        }];
    }
}
- (NSString *)getPreviewSaleDateText:(long)previewSaleDateText {
    NSDateFormatter *formatter =[[NSDateFormatter alloc]init];
    NSTimeZone *timeZone =[NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat:@"MM月dd日 HH:mm:ss"];
    NSDate * currentDate = [NSDate dateWithTimeIntervalSince1970:previewSaleDateText/1000.0];
    NSString * formDateStr = [formatter stringFromDate:currentDate];
    if (self.speModel.showType == 2) {//专场类型 0-新人 1-普通，2-拍卖，3-普通秒杀，4-大促秒杀",
        return [NSString stringWithFormat:@"%@ 开拍" ,formDateStr];
    }else{
        return [NSString stringWithFormat:@"%@ 开抢" ,formDateStr];
    }
    
}
- (void)resetHeaderViewWithModel:(JHNewStoreSpecialModel *)model{
    self.speModel = model;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ",model.title]];
    
    if (self.speModel.showType == 2) {//专场类型 0-新人 1-普通，2-拍卖，3-普通秒杀，4-大促秒杀",
        NSTextAttachment *attchment = [[NSTextAttachment alloc]init];
            attchment.bounds = CGRectMake(0, 0, 56, 17);//设置frame
        if (model.showStatus == 0) {//0 预告、1 热卖、2 结束、-1 未知
            attchment.image = [UIImage imageNamed:@"newStore_Auctionforeshow"];//
            NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:(NSTextAttachment *)(attchment)];
                [attributedString appendAttributedString:string];
        }else if(model.showStatus == 1){
            attchment.image = [UIImage imageNamed:@"newStore_AuctionhotSale"];//
            NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:(NSTextAttachment *)(attchment)];
                [attributedString appendAttributedString:string];
        }
    }else{
        NSTextAttachment *attchment = [[NSTextAttachment alloc]init];
            attchment.bounds = CGRectMake(0, 0, 32, 17);//设置frame
        if (model.showStatus == 0) {//0 预告、1 热卖、2 结束、-1 未知
            attchment.image = [UIImage imageNamed:@"newStore_foreshow"];//
            NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:(NSTextAttachment *)(attchment)];
                [attributedString appendAttributedString:string];
        }else if(model.showStatus == 1){
            attchment.image = [UIImage imageNamed:@"newStore_hotSale"];//
            NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:(NSTextAttachment *)(attchment)];
                [attributedString appendAttributedString:string];
        }
    }
    
    
    
    
    self.specialNameLabel.attributedText = attributedString;
    
    NSMutableString * tagStr = [NSMutableString new];
    for (int i=0; i<model.tags.count; i++) {
        NSString *temp = model.tags[i];
        if (i == model.tags.count-1) {
            [tagStr appendFormat:@"%@",temp];
        }else{
            [tagStr appendFormat:@"%@ · ",temp];
        }
    }
    self.specialTagLabel.text = tagStr;
    
    [self.topImageView jh_setImageWithUrl:model.coverImg];
    
    if (model.showStatus == 0) {//0 预告、1 热卖、2 结束、-1 未知
        self.foreShowSaleLabel.hidden = NO;
        self.foreShowSaleLabel.text = [self getPreviewSaleDateText:model.saleStartTime];
    }else if(model.showStatus == 1){
        self.foreShowSaleLabel.hidden = YES;
    }
    [self.specialDescLabel addSeeMoreButtonInLabel:model.showDesc];
}
- (void)resetHeaderViewWithUserModel:(JHNewStoreSpecialShowUser *)model{
    [self.userBrowseView resetHeaderViewWithUserModel:model];
}
- (void)userteach{
    if (self.speModel.showStatus == 0) {//0 预告、1 热卖、2 结束、-1 未知
        [JHAllStatistics jh_allStatisticsWithEventId:@"dbdhjyxxClick" params:@{@"store_from":@"预告专场"} type:JHStatisticsTypeSensors];
    }else if(self.speModel.showStatus == 1){
        [JHAllStatistics jh_allStatisticsWithEventId:@"dbdhjyxxClick" params:@{@"store_from":@"热卖专场"} type:JHStatisticsTypeSensors];
    }
    JHWebViewController *webVC = [JHWebViewController new];
    webVC.urlString = H5_BASE_STRING(@"/jianhuo/app/shop/check.html");
    [JHRootController.currentViewController.navigationController pushViewController:webVC animated:YES];
}

#pragma make JHNewStoreSpecialDescLabelDelegate
- (void)expandOrPackUp:(CGFloat)maxHeight{
    if (self.delegate && [self.delegate respondsToSelector:@selector(descExpandOrPackUp:)]) {
        [self.delegate descExpandOrPackUp:maxHeight];
    }
}
- (CGFloat)getDesclabelheight{
    return self.specialDescLabel.height;
}
- (void)resetSpecialDescLabelNumLine{
    self.specialDescLabel.numberOfLines = 3;
}
@end
