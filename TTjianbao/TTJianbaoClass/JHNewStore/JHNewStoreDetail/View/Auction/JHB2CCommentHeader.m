//
//  JHB2CCommentHeader.m
//  TTjianbao
//
//  Created by jingxuelong on 2021/7/29.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHB2CCommentHeader.h"
#import "UIButton+ImageTitleSpacing.h"

#pragma mark -- tag 视图
///tag 视图
@interface JHB2CCommentTagView : UIView

@property(nonatomic, strong) UIView * backView;

@property(nonatomic, strong) NSMutableArray <UILabel*>* tagArr;

@end

@implementation JHB2CCommentTagView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setItems];
        [self layoutItems];
    }
    return self;
}

- (void)setItems{
    [self addSubview:self.backView];
}

- (void)layoutItems{
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
}


/// 刷新tag
/// @param arr 字符串数组
- (void)refreshTagsWithArr:(NSArray<NSString*>*)arr{
    [self.tagArr  enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    
    [self.tagArr removeAllObjects];
    UIView *lastView = nil;
    for (int i = 0; i< arr.count; i++) {
        NSString *text  = arr[i];
        UILabel *tag = [UILabel new];
        tag.font = JHFont(12);
        tag.textColor = HEXCOLOR(0xFFA319);
        tag.text = text;
        tag.textAlignment = NSTextAlignmentCenter;
        tag.layer.cornerRadius = 1;
        tag.layer.borderColor = HEXCOLOR(0xD8D8D8).CGColor;
        tag.layer.borderWidth = 0.5;
        [self.tagArr addObject:tag];
        [self.backView addSubview:tag];
        CGFloat orignX = lastView ? CGRectGetMaxX(lastView.frame) + 4 : 12;
        CGFloat orignY = lastView ? lastView.mj_y : 0;
        CGFloat width = [self getWidthWithSting:text];
        //是否需要换行
        if (orignX + width + 12 > kScreenWidth) {
            orignX = 12;
            orignY = CGRectGetMaxY(lastView.frame) + 6;
        }
        tag.frame = CGRectMake(orignX, orignY, width, 21);
        lastView = tag;
    }
    [self.backView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
        if (lastView) {
            make.bottom.equalTo(lastView).offset(6);
        }
    }];
    
}

- (CGFloat)getWidthWithSting:(NSString*)text{
    CGFloat width = [text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 0)
                       options:NSStringDrawingUsesLineFragmentOrigin
                    attributes:@{NSFontAttributeName : JHFont(12)}
                       context:nil].size.width;
    return  width  + 8;
}

- (NSMutableArray<UILabel *> *)tagArr{
    if (!_tagArr) {
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
        _tagArr = arr;
    }
    return _tagArr;
}

- (UIView *)backView{
    if (!_backView) {
        UIView *view = [UIView new];
        _backView = view;
    }
    return _backView;
}

@end

#pragma mark -- header 视图
///header 视图
@interface JHB2CCommentHeader()
@property(nonatomic, strong) UIView * backView;

@property(nonatomic, strong) UILabel * titleLbl;

@property(nonatomic, strong) JHB2CCommentTagView * tagView;

@property(nonatomic, strong) UILabel * desLbl;

@property(nonatomic, strong) UIButton * moreBtn;

@end

@implementation JHB2CCommentHeader


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setItems];
        [self layoutItems];
    }
    return self;
}

- (void)setItems{
    [self.contentView addSubview:self.backView];
    [self.backView addSubview:self.titleLbl];
    [self.backView addSubview:self.desLbl];
    [self.backView addSubview:self.moreBtn];
    [self.backView addSubview:self.tagView];
}

- (void)layoutItems{
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0).offset(19);
        make.left.equalTo(@0).offset(12);
    }];
    
    [self.desLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLbl);
        make.left.equalTo(self.titleLbl.mas_right).offset(3);
    }];

    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLbl).offset(2);
        make.width.mas_equalTo(70.f);
        make.height.mas_equalTo(20.f);
        make.right.equalTo(@0).offset(-12);
    }];
    [self.tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLbl.mas_bottom).offset(15);
        make.left.right.bottom.equalTo(@0);
    }];

}

- (void)setViewModel:(JHB2CCommentHeaderViewModel *)viewModel{
    _viewModel = viewModel;
    [self.tagView refreshTagsWithArr:viewModel.tagArr];
    self.desLbl.attributedText = viewModel.countAndHaoPingAttStr;
}


- (UIView *)backView{
    if (!_backView) {
        UIView *view = [UIView new];
        view.backgroundColor = HEXCOLOR(0xffffff);
        _backView = view;
    }
    return _backView;
}


- (UILabel *)titleLbl{
    if (!_titleLbl) {
        UILabel *label = [UILabel new];
        label.font = JHMediumFont(14);
        label.textColor = HEXCOLOR(0x222222);
        label.text = @"用户评价";
        _titleLbl = label;
    }
    return _titleLbl;
}
- (UILabel *)desLbl{
    if (!_desLbl) {
        UILabel *label = [UILabel new];
        _desLbl = label;
    }
    return _desLbl;
}

- (UIButton *)moreBtn{
    if (!_moreBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"查看全部" forState:UIControlStateNormal];
        btn.titleLabel.font = JHFont(13);
        [btn setTitleColor:HEXCOLOR(0x999999) forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"c2c_up_arrow"] forState:UIControlStateNormal];
        [btn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:10];
        @weakify(self);
        [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            [self.viewModel.moreBtnAction sendNext:nil];
        }];
        _moreBtn = btn;
    }
    return _moreBtn;
}

- (JHB2CCommentTagView *)tagView{
    if (!_tagView) {
        JHB2CCommentTagView *view = [JHB2CCommentTagView new];
        _tagView = view;
    }
    return _tagView;
}

@end
