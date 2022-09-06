//
//  JHRecycleMeAttentionCell.m
//  TTjianbao
//
//  Created by jingxuelong on 2021/3/25.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleMeAttentionCell.h"
#import "JHRecyleRowLabelView.h"
#import "JHRecycleMeAttentionModel.h"
#import <SDWebImage.h>


@interface JHRecycleMeAttentionCell()
@property(nonatomic, strong) UIView * backView;

@property(nonatomic, strong) UIImageView * iconImageView;
@property(nonatomic, strong) UILabel * titleLbl;
@property(nonatomic, strong) UILabel * desLbl;

@property(nonatomic, strong) UIView * readMaskView;

/** 小贴士*/
@property (nonatomic, strong) JHRecyleRowLabelView *arrowTipsLabel;

@end

@implementation JHRecycleMeAttentionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setItems];
        [self layoutItems];
    }
    return self;
}

- (void)setItems{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.backView];
    [self.backView addSubview:self.iconImageView];
    [self.backView addSubview:self.titleLbl];
    [self.backView addSubview:self.desLbl];
//    [self.backView addSubview:self.tipsView];
    
    [self.backView addSubview:self.arrowTipsLabel];

    
    self.backgroundColor = HEXCOLOR(0xF5F5F8);
}

- (void)layoutItems{
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(@0).inset(10);
        make.bottom.equalTo(@0);
        make.width.mas_equalTo(ScreenWidth - 20);
    }];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0).offset(12);
        make.left.equalTo(@0).offset(10);
        make.size.mas_equalTo(CGSizeMake(75, 75));
    }];
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView);
        make.left.equalTo(self.iconImageView.mas_right).inset(10);
        make.right.equalTo(@0).inset(10);
    }];
    [self.desLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLbl.mas_bottom).offset(6);
        make.left.equalTo(self.titleLbl);
        make.right.equalTo(@0).inset(10);
    }];
    [self.arrowTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView.mas_bottom).offset(3);
        make.left.bottom.right.equalTo(@0).inset(10);
    }];

}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)prepareForReuse{
    [super prepareForReuse];
    [self.readMaskView removeFromSuperview];
    self.readMaskView = nil;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self layoutItems];
    for (UIControl *control in self.subviews) {
        if (![control isMemberOfClass:NSClassFromString(@"UITableViewCellEditControl")]){
            continue;
        }
        for (UIView *subView in control.subviews) {
            if (![subView isKindOfClass: [UIImageView class]]) {
                continue;
            }
            UIImageView *imageView = (UIImageView *)subView;
            imageView.bounds = CGRectMake(0, 0, 20, 20);
            if (self.selected) {
                imageView.image = [UIImage imageNamed:@"icon_draft_edit_selected"];
            } else {
                imageView.image = [UIImage imageNamed:@"recycle_me_attention_unsel"];
            }
        }
    }
}

- (void)refreshWithHomeSquareModel:(JHRecycleMeAttentionListModel *)model{
    NSString *url = @"";
    if (model.images.count) {url = model.images.firstObject.medium;}
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"jh_newStore_type_defaulticon"]];
    self.titleLbl.text = model.categoryName;
    self.desLbl.text = model.productDesc;
    self.arrowTipsLabel.tipsLabel.text = model.tips;
    [self refershStatus:model.productStatus];
}

- (void)refershStatus:(NSInteger)productStatus{
    self.arrowTipsLabel.tipsbackColor = productStatus == 0 ? HEXCOLORA(0xffd70f, 0.1) : HEXCOLOR(0xEEEEEE);
    self.titleLbl.textColor = productStatus == 0 ?  HEXCOLOR(0x333333) : HEXCOLOR(0x999999);
    self.arrowTipsLabel.tipsLabel.textColor = productStatus == 0 ?  HEXCOLOR(0x666666) : HEXCOLOR(0x999999);
    if (productStatus != 0) {
        UIView *view = [UIView new];
        view.backgroundColor = HEXCOLORA(0xeeeeee, 0.6);
        self.readMaskView = view;
        [self.iconImageView addSubview:self.readMaskView];
        [self.readMaskView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(@0);
        }];
    }
}

#pragma mark -- <set and get>

- (UIView *)backView{
    if (!_backView) {
        UIView *view = [UIView new];
        view.backgroundColor = UIColor.whiteColor;
        view.layer.cornerRadius = 8;
        _backView = view;
    }
    return _backView;
}

- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        UIImageView *view = [UIImageView new];
        view.image = [UIImage imageNamed:@"jh_newStore_type_defaulticon"];
        view.contentMode = UIViewContentModeScaleAspectFill;
        view.layer.masksToBounds = YES;
        view.layer.cornerRadius = 4;
        _iconImageView = view;
    }
    return _iconImageView;
}

- (UILabel *)titleLbl{
    if (!_titleLbl) {
        UILabel *label = [UILabel new];
        label.font = JHMediumFont(13);
        label.textColor = HEXCOLOR(0x333333);
        label.text = @"回收分类:银圆";
        _titleLbl = label;
    }
    return _titleLbl;
}

- (UILabel *)desLbl{
    if (!_desLbl) {
        UILabel *label = [UILabel new];
        label.font = JHFont(12);
        label.textColor = HEXCOLOR(0x999999);
        label.numberOfLines = 2;
        label.text = @"回收说明：品牌也远不是强调名称，标志，符号或者商标。它融合了一系列定义其形象的";
        _desLbl = label;
    }
    return _desLbl;
}

- (JHRecyleRowLabelView *)arrowTipsLabel {
    if (_arrowTipsLabel == nil) {
        _arrowTipsLabel = [[JHRecyleRowLabelView alloc] init];
        [_arrowTipsLabel drawArrowWithPoint:22];
    }
    return _arrowTipsLabel;
}

@end
