//
//  JHRecycleSquareHomeCell.m
//  TTjianbao
//
//  Created by jingxuelong on 2021/3/25.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleSquareHomeCell.h"
#import "YYLabel.h"
#import "JHRecycleSquareHomeModel.h"
#import <SDWebImage.h>
#import "UILabel+edgeInsets.h"
#import "UIView+JHGradient.h"


@interface JHRecycleSquareHomeCell()
@property(nonatomic, strong) UIImageView * topImageView;
@property(nonatomic, strong) UILabel * desLbl;
@property(nonatomic, strong) UILabel * typeLbl;
@property(nonatomic, strong) UIView * readMaskView;
@property (nonatomic, strong) UIView *goodsTagView;
@property (nonatomic, strong) NSMutableArray *tagsArray;
@end

@implementation JHRecycleSquareHomeCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setItems];
    }
    return self;
}

- (void)setItems{
    self.contentView.backgroundColor = UIColor.whiteColor;
    self.contentView.layer.borderWidth = 0.5;
    self.contentView.layer.cornerRadius = 4;
    [self.contentView.layer setMasksToBounds:YES];
    self.contentView.layer.borderColor = HEXCOLOR(0xDDDDDD).CGColor;
    [self.contentView addSubview:self.topImageView];
    [self.contentView addSubview:self.desLbl];
    [self.contentView addSubview:self.typeLbl];
//    [self.topImageView addSubview:self.statusLbl];
    [self.topImageView addSubview:self.goodsTagView];
    
}

- (void)prepareForReuse{
    [super prepareForReuse];
    [self.readMaskView removeFromSuperview];
    self.readMaskView = nil;
}

- (void)refreshWithHomeSquareModel:(JHRecycleSquareHomeListModel *)model{
    [self.topImageView sd_setImageWithURL:[NSURL URLWithString:model.productImage.small] placeholderImage:[UIImage imageNamed:@"newStore_default_header_placeholder"]];
    self.typeLbl.text = model.showCategoryName;
    self.desLbl.text = model.showProductDesc;
    //标签
    if (!_tagsArray) {
        _tagsArray = [NSMutableArray arrayWithCapacity:0];
    }
    [_tagsArray removeAllObjects];
    if (model.source == 1) {
        [_tagsArray addObject:@"直播间"];
    }
    if (model.isHighQuality == 1) {
        [_tagsArray addObject:@"高货"];
    }
    [self.goodsTagView removeAllSubviews];
    UILabel *firstLabel;
    for (int i = 0; i < _tagsArray.count; i++) {
        UILabel *tagLabel = [[UILabel alloc] init];
        tagLabel.font = JHFont(12);
        tagLabel.textColor = UIColor.whiteColor;
        tagLabel.text = _tagsArray[i];
        [tagLabel jh_cornerRadius:2];
        tagLabel.edgeInsets = UIEdgeInsetsMake(1, 4, 1, 4);
        [tagLabel jh_setGradientBackgroundWithColors:@[HEXCOLOR(0xFF6E00),HEXCOLOR(0xFF0400)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
        [self.goodsTagView addSubview:tagLabel];
        [tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.goodsTagView);
            if (i == 0) {
                make.left.equalTo(self.goodsTagView).offset(6);
            }else {
                make.left.equalTo(firstLabel.mas_right).offset(6);
            }
        }];
        firstLabel = tagLabel;
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self layoutItems];
}

- (void)layoutItems{
    [self.topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(@0);
        make.height.mas_equalTo(self.width);
    }];
    [self.goodsTagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.height.mas_equalTo(16);
        make.bottom.equalTo(self.topImageView.mas_bottom).offset(-8);
    }];
    
    [self.typeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topImageView.mas_bottom).offset(9);
        make.left.right.equalTo(@0).inset(8);
    }];
    [self.desLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.typeLbl.mas_bottom).offset(6);
        make.left.right.equalTo(@0).inset(8);
    }];
//    [self.statusLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.bottom.equalTo(@0).inset(6);
//    }];
}

- (void)setHasRead{
    [self.readMaskView removeFromSuperview];
    UIView *view = [UIView new];
    view.backgroundColor = HEXCOLORA(0xeeeeee, 0.6);
    self.readMaskView = view;
    [self.contentView addSubview:self.readMaskView];
    [self.readMaskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
}

- (UIImageView *)topImageView{
    if (!_topImageView) {
        UIImageView *view = [UIImageView new];
        view.image = [UIImage imageNamed:@"newStore_default_header_placeholder"];
        view.contentMode = UIViewContentModeScaleAspectFill;
        view.layer.masksToBounds = YES;
        _topImageView = view;
    }
    return _topImageView;
}

- (UILabel *)desLbl{
    if (!_desLbl) {
        UILabel *label = [UILabel new];
        label.font = JHFont(12);
        label.textColor = HEXCOLOR(0x666666);
        label.numberOfLines = 2;
        _desLbl = label;
    }
    return _desLbl;
}

- (UILabel *)typeLbl{
    if (!_typeLbl) {
        UILabel *label = [UILabel new];
        label.font = JHMediumFont(14);
        label.textColor = HEXCOLOR(0x333333);
        label.numberOfLines = 1;
        _typeLbl = label;
    }
    return _typeLbl;
}
- (UIView *)goodsTagView{
    if (!_goodsTagView) {
        _goodsTagView = [[UIView alloc] init];
    }
    return _goodsTagView;
}


//- (YYLabel *)statusLbl{
//    if (!_statusLbl) {
//        YYLabel *label = [[YYLabel alloc] init];
//        label.font = JHFont(10);
//        label.textColor = HEXCOLOR(0x222222);
//        label.numberOfLines = 1;
//        label.text = @"鉴定直播间已鉴定";
//        label.backgroundColor = HEXCOLOR(0xF5D295);
//        label.textContainerInset = UIEdgeInsetsMake(4, 5, 4, 5);
//        label.layer.cornerRadius = 4;
//        _statusLbl = label;
//    }
//    return _statusLbl;
//}
//
@end
