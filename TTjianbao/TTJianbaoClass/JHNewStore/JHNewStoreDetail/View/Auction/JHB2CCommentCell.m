//
//  JHB2CCommentCell.m
//  TTjianbao
//
//  Created by jingxuelong on 2021/7/29.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHB2CCommentCell.h"

#pragma mark -- 顶部信息视图
///顶部信息视图
@interface JHB2CCommentTopInfoVIew : UIView

@property(nonatomic, strong) UIView * backView;
@property(nonatomic, strong) UIImageView * iconImageView;
@property(nonatomic, strong) UILabel * nameLbl;
@property(nonatomic, strong) UILabel * timeLbl;

@property(nonatomic, strong) NSMutableArray<UIImageView*> * starImageViewArr;

@end

@implementation JHB2CCommentTopInfoVIew

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setItems];
        [self layoutItems];
    }
    return self;
}

- (void)setItems{
    [self addSubview:self.backView];
    [self.backView addSubview:self.iconImageView];
    [self.backView addSubview:self.nameLbl];
    [self.backView addSubview:self.timeLbl];
    //最大星星数
    for (int i = 0; i < 5; i++) {
        UIImageView *star = [UIImageView new];
        star.hidden = YES;
        star.image = [UIImage imageNamed:@"newStore_star_yellow_icon"];
        [self.backView addSubview:star];
        [self.starImageViewArr addObject:star];
    }
}

- (void)layoutItems{
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(@0);
        make.left.equalTo(@0).offset(12);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView);
        make.left.equalTo(self.iconImageView.mas_right).offset(8);
        make.width.mas_lessThanOrEqualTo(120);
    }];
    [self.timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(@0);
        make.right.equalTo(@0).offset(-12);
    }];
    UIView *lastView = nil;
    for (int i = 0; i < 5; i++) {
        UIImageView *star = self.starImageViewArr[i];
        [star mas_makeConstraints:^(MASConstraintMaker *make) {
            if (lastView) {
                make.left.equalTo(lastView.mas_right).offset(4);
            }else{
                make.left.equalTo(self.nameLbl);
            }
            make.size.mas_equalTo(CGSizeMake(10, 10));
            make.bottom.equalTo(@0).offset(-12);
        }];
        lastView = star;
    }
}

- (void)rereshStarWithCount:(NSInteger)count{
    if (count<=5 && count > 0) {
        for (int i = 0; i < 5; i++) {
            UIImageView *star = self.starImageViewArr[i];
            star.hidden = count < i + 1;
        }
    }
}


#pragma mark -- <set and get>

- (UIView *)backView{
    if (!_backView) {
        UIView *view = [UIView new];
        view.backgroundColor = UIColor.whiteColor;
        _backView = view;
    }
    return _backView;
}
- (UILabel *)nameLbl{
    if (!_nameLbl) {
        UILabel *label = [UILabel new];
        label.font = JHMediumFont(15);
        label.textColor = HEXCOLOR(0x222222);
        _nameLbl = label;
    }
    return _nameLbl;
}

- (UILabel *)timeLbl{
    if (!_timeLbl) {
        UILabel *label = [UILabel new];
        label.font = JHMediumFont(12);
        label.textColor = HEXCOLOR(0x999999);
        _timeLbl = label;
    }
    return _timeLbl;
}
- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        UIImageView *view = [UIImageView new];
        view.layer.cornerRadius = 20;
        view.layer.masksToBounds = YES;
        _iconImageView = view;
        _iconImageView.image = kDefaultAvatarImage;
    }
    return _iconImageView;
}

- (NSMutableArray<UIImageView*> *)starImageViewArr{
    if (!_starImageViewArr) {
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
        _starImageViewArr = arr;
    }
    return _starImageViewArr;
}

@end


#pragma mark -- des 描述 视图
///des 描述 视图
@interface JHB2CCommentDesView : UIView

@property(nonatomic, strong) UIView * backView;
@property(nonatomic, strong) YYLabel * desLbl;
@property(nonatomic) BOOL  openFold;
@property(nonatomic, copy) NSString*  fullStr;
@end

@implementation JHB2CCommentDesView
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
    [self.backView addSubview:self.desLbl];

}

- (void)layoutItems{
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    [self.desLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.left.equalTo(@0).offset(12);
        make.right.equalTo(@0).offset(-12);
        make.bottom.equalTo(@0).offset(-10);
    }];
}

- (void)refershWithStr:(NSString*)str andOpenFold:(BOOL)onpenFold{
    self.fullStr = str;
    [self setDesLblAttStringOpenFold:onpenFold];
    
}

- (void)setDesLblAttStringOpenFold:(BOOL)openFold{
    NSString* str = self.fullStr;
    self.openFold = openFold;
    CGFloat wide = kScreenWidth - 24.f;
    CGFloat height = [str boundingRectWithSize:CGSizeMake(wide, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin
                                    attributes:@{NSFontAttributeName : JHFont(14)}
                      context:nil].size.height;
    if (height <= 40) {
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:str
                                                                                attributes:@{NSFontAttributeName : JHFont(14),NSForegroundColorAttributeName : HEXCOLOR(0x222222)}];
        self.desLbl.attributedText = att;

    }else{
        if (!openFold) {
            str = [self getRightLengthOfString:str];
            NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:str
                                                                                    attributes:@{NSFontAttributeName : JHFont(14),NSForegroundColorAttributeName : HEXCOLOR(0x222222)}];
            @weakify(self);
            [att setTextHighlightRange:NSMakeRange(str.length - 2, 2) color:HEXCOLOR(0x2F66A0) backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                @strongify(self);
                [self openFoldStatusChange];
            }];
            self.desLbl.attributedText = att;

        }else{
            NSString* str = self.fullStr;
//            NSString* str = [self.fullStr stringByAppendingString:@"收起"];
            NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:str
                                                                                    attributes:@{NSFontAttributeName : JHFont(14),NSForegroundColorAttributeName : HEXCOLOR(0x222222)}];
//            [att setTextHighlightRange:NSMakeRange(str.length - 2, 2) color:HEXCOLOR(0x007AFF) backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
//                [self foldBtnActionWithSender:self.foldBtn];
//            }];
            self.desLbl.attributedText = att;
        }

    }
}

- (void)openFoldStatusChange{
    self.openFold  = !self.openFold;
}

- (NSString*)getRightLengthOfString:(NSString*)str{
    NSString *appStr = @"... 展开";
    NSUInteger index = MIN(80, str.length);
    NSString* newStr;
    CGFloat wide = kScreenWidth - 24.f;
    CGFloat height = 50;
    while (height > 40) {
        index -= 2;
        newStr = [str substringToIndex:index];
        newStr = [newStr stringByAppendingString:appStr];
        height = [newStr boundingRectWithSize:CGSizeMake(wide, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:@{NSFontAttributeName : JHFont(14)}
                          context:nil].size.height;
    }
    return newStr;
}

- (UIView *)backView{
    if (!_backView) {
        UIView *view = [UIView new];
        _backView = view;
    }
    return _backView;
}
- (YYLabel *)desLbl{
    if (!_desLbl) {
        YYLabel *label = [YYLabel new];
        label.font = JHFont(14);
        label.textColor = HEXCOLOR(0x222222);
        label.numberOfLines = 0;
        label.preferredMaxLayoutWidth = kScreenWidth - 24.f;
        _desLbl = label;
    }
    return _desLbl;
}

@end


#pragma mark -- 商家回复des 描述 视图
///商家回复des 描述 视图
@interface JHB2CCommentShopReplyDesView : UIView

@property(nonatomic, strong) UIView * backView;
@property(nonatomic, strong) YYLabel * desLbl;
@property(nonatomic, strong) YYLabel * titleLbl;
@property(nonatomic) BOOL  openFold;
@property(nonatomic, copy) NSString*  fullStr;
@end

@implementation JHB2CCommentShopReplyDesView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setItems];
        [self layoutItems];
    }
    return self;
}

- (void)setItems{
    self.backgroundColor = UIColor.whiteColor;
    [self addSubview:self.backView];
    [self.backView addSubview:self.titleLbl];
    [self.backView addSubview:self.desLbl];

}

- (void)layoutItems{
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0).offset(8);
        make.left.equalTo(@0).offset(12);
        make.right.equalTo(@0).offset(-12);
//        make.height.equalTo(@100);
        make.bottom.equalTo(@0);

    }];
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0).offset(10);
        make.left.equalTo(@0).offset(12);
    }];

    [self.desLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0).offset(31);
        make.left.equalTo(@0).offset(12);
        make.right.equalTo(@0).offset(-12);
        make.bottom.equalTo(@0).offset(-10);
    }];
}

- (void)refershWithStr:(NSString*)str andOpenFold:(BOOL)onpenFold{
    self.fullStr = str;
    [self setDesLblAttStringOpenFold:onpenFold];
    
}

- (void)setDesLblAttStringOpenFold:(BOOL)openFold{
    NSString* str = self.fullStr;
    self.openFold = openFold;

    CGFloat wide = kScreenWidth - 48.f;
    CGFloat height = [str boundingRectWithSize:CGSizeMake(wide, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin
                                    attributes:@{NSFontAttributeName : JHFont(14)}
                      context:nil].size.height;
    if (height <= 40) {
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:str
                                                                                attributes:@{NSFontAttributeName : JHFont(14),NSForegroundColorAttributeName : HEXCOLOR(0x222222)}];
        self.desLbl.attributedText = att;
    }else{
        if (!openFold) {
            str = [self getRightLengthOfString:str];
            NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:str
                                                                                    attributes:@{NSFontAttributeName : JHFont(14),NSForegroundColorAttributeName : HEXCOLOR(0x222222)}];
            @weakify(self);
            [att setTextHighlightRange:NSMakeRange(str.length - 2, 2) color:HEXCOLOR(0x2F66A0) backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                @strongify(self);
                [self openFoldStatusChange];
            }];
            self.desLbl.attributedText = att;
        }else{
            NSString* str = self.fullStr;
//            NSString* str = [self.fullStr stringByAppendingString:@"收起"];
            NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:str
                                                                                    attributes:@{NSFontAttributeName : JHFont(14),NSForegroundColorAttributeName : HEXCOLOR(0x222222)}];
//            [att setTextHighlightRange:NSMakeRange(str.length - 2, 2) color:HEXCOLOR(0x007AFF) backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
//                [self foldBtnActionWithSender:self.foldBtn];
//            }];
            self.desLbl.attributedText = att;
        }

    }
}

- (void)openFoldStatusChange{
    self.openFold  = !self.openFold;
}

- (NSString*)getRightLengthOfString:(NSString*)str{
    NSString *appStr = @"... 展开";
    NSUInteger index = MIN(80, str.length);
    NSString* newStr;
    CGFloat wide = kScreenWidth - 48.f;
    CGFloat height = 50;
    while (height > 40) {
        index -= 2;
        newStr = [str substringToIndex:index];
        newStr = [newStr stringByAppendingString:appStr];
        height = [newStr boundingRectWithSize:CGSizeMake(wide, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:@{NSFontAttributeName : JHFont(14)}
                          context:nil].size.height;
    }
    return newStr;
}

- (UIView *)backView{
    if (!_backView) {
        UIView *view = [UIView new];
        view.backgroundColor = HEXCOLOR(0xFAFAFA);
        view.layer.cornerRadius = 4;
        _backView = view;
    }
    return _backView;
}
- (YYLabel *)desLbl{
    if (!_desLbl) {
        YYLabel *label = [YYLabel new];
        label.numberOfLines = 0;
        label.preferredMaxLayoutWidth = kScreenWidth - 48.f;
        _desLbl = label;
    }
    return _desLbl;
}
- (YYLabel *)titleLbl{
    if (!_titleLbl) {
        YYLabel *label = [YYLabel new];
        label.font = JHBoldFont(12);
        label.textColor = HEXCOLOR(0x666666);
        label.text = @"商家回复";
        _titleLbl = label;
    }
    return _titleLbl;
}

@end


#pragma mark -- 图片 视图
///图片 视图
@interface JHB2CCommentPictureView : UIView

@property(nonatomic, strong) UIView * backView;
@property(nonatomic, strong) NSMutableArray<UIImageView*> * imageViewArr;

@end

@implementation JHB2CCommentPictureView
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

/// 刷新图片
/// @param arr 字符串数组
- (void)refreshPictureWithArr:(NSArray<NSString *> *)arr{
    [self.imageViewArr  enumerateObjectsUsingBlock:^(UIImageView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    
    [self.imageViewArr removeAllObjects];
    if (arr.count) {
        CGFloat cellwide = floor((kScreenWidth - 24 - 24)/4.f);
        [self.backView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(@0);
            make.height.mas_equalTo(cellwide + 2.f);
        }];
        UIView *lastView = nil;
        for (int i = 0; i< MIN(arr.count, 4); i++) {
            NSString *url  = arr[i];
            UIImageView *imagePic = [UIImageView new];
            [imagePic jhSetImageWithURL:[NSURL URLWithString:url] placeholder:[UIImage imageNamed:@"newStore_default_placehold"]];
            imagePic.layer.cornerRadius = 4;
            imagePic.layer.masksToBounds = YES;
            [self.imageViewArr addObject:imagePic];
            [self.backView addSubview:imagePic];
            [imagePic mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(@0);
                make.size.mas_equalTo(CGSizeMake(cellwide, cellwide));
                if (lastView) {
                    make.left.equalTo(lastView.mas_right).offset(8);
                }else{
                    make.left.equalTo(@0).offset(12);
                }
            }];
            lastView = imagePic;
        }

    }else{
        [self.backView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(@0);
        }];
    }
}

- (NSMutableArray<UIImageView *> *)imageViewArr{
    if (!_imageViewArr) {
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
        _imageViewArr = arr;
    }
    return _imageViewArr;
}

- (UIView *)backView{
    if (!_backView) {
        UIView *view = [UIView new];
        _backView = view;
    }
    return _backView;
}

@end


#pragma mark -- 评论cell
///评论cell
@interface JHB2CCommentCell()
@property(nonatomic, strong) UIView * backView;
@property(nonatomic, strong) JHB2CCommentTopInfoVIew * topInfoView;
@property(nonatomic, strong) JHB2CCommentDesView * desView;
@property(nonatomic, strong) JHB2CCommentPictureView * pictureView;
@property(nonatomic, strong) JHB2CCommentShopReplyDesView * replyView;
@property(nonatomic, strong) UIView * lineView;
@property(nonatomic, strong) UIButton * delBtn;
@end

@implementation JHB2CCommentCell

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
        [self bindAction];
    }
    return self;
}

- (void)setItems{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.backView];
    [self.backView addSubview:self.topInfoView];
    [self.backView addSubview:self.desView];
    [self.backView addSubview:self.pictureView];
    [self.backView addSubview:self.lineView];
    [self.backView addSubview:self.delBtn];
}

- (void)layoutItems{
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    
    [self.topInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.equalTo(@0);
        make.height.mas_equalTo(60.f);
    }];

    [self.desView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(@0);
        make.top.equalTo(self.topInfoView.mas_bottom);
    }];

    [self.pictureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(@0);
        make.top.equalTo(self.desView.mas_bottom);
    }];
    [self.delBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pictureView.mas_bottom).offset(10);
        make.bottom.equalTo(@0).offset(-10);
        make.height.mas_equalTo(1.f);
        make.left.equalTo(@0).inset(12);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@0);
        make.height.mas_equalTo(0.5f);
        make.right.left.equalTo(@0).inset(12);
    }];

}
- (void)bindAction{
    
    @weakify(self);
    [RACObserve(self.desView, openFold) subscribeNext:^(NSNumber*  _Nullable x) {
        @strongify(self);
        [self refreshFoldStatu:x.boolValue];
    }];
    [RACObserve(self.replyView, openFold) subscribeNext:^(NSNumber*  _Nullable x) {
        @strongify(self);
        [self refreshShopReplyFoldStatu:x.boolValue];
    }];

}

- (void)setViewModel:(JHB2CCommentViewModel *)viewModel{
    _viewModel = viewModel;
    self.topInfoView.timeLbl.text = viewModel.dateTime;
    self.topInfoView.nameLbl.text = viewModel.name;
    [self.topInfoView rereshStarWithCount:viewModel.pass];
    [self.pictureView refreshPictureWithArr:viewModel.imageArr];
    [self.desView refershWithStr:viewModel.desString  andOpenFold:viewModel.openFold];
    [self.topInfoView.iconImageView jhSetImageWithURL:[NSURL URLWithString:viewModel.imgUrl] placeholder:kDefaultAvatarImage];
    User *user = [UserInfoRequestManager sharedInstance].user;
    BOOL canDel = [user.customerId isEqualToString:viewModel.commentMode.customerId];
    CGFloat delHeight = canDel ? 40.f : 1.f;
    CGFloat spc = canDel ? 1.f : 10.f;

    self.delBtn.hidden = !canDel;
    if (viewModel.hasShopReply) {
        [self.backView addSubview:self.replyView];
        [self.replyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.left.equalTo(@0);
            make.top.equalTo(self.pictureView.mas_bottom);
        }];
        [self.delBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.replyView.mas_bottom).offset(spc);
            make.bottom.equalTo(@0);
            make.height.mas_equalTo(delHeight);
            make.left.equalTo(@0).offset(12);
        }];
        [self.replyView refershWithStr:viewModel.desString  andOpenFold:viewModel.openFoldShopReply];
    }else if(_replyView){
        [self.replyView removeFromSuperview];
        [self.delBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.pictureView.mas_bottom).offset(spc);
            make.bottom.equalTo(@0);
            make.height.mas_equalTo(delHeight);
            make.left.equalTo(@0).offset(12);
        }];
    }

}
- (void)delComment:(UIButton*)sender{
    [self.viewModel delComment];
}

- (void)refreshFoldStatu:(BOOL)fold{
    if (fold != self.viewModel.openFold) {
        self.viewModel.openFold = fold;
        [self.viewModel.reloadCellSubject sendNext:RACTuplePack(@(self.viewModel.sectionIndex), @(self.viewModel.rowIndex))];
    }
}

- (void)refreshShopReplyFoldStatu:(BOOL)fold{
    if (fold != self.viewModel.openFoldShopReply) {
        self.viewModel.openFoldShopReply = fold;
        [self.viewModel.reloadCellSubject sendNext:RACTuplePack(@(self.viewModel.sectionIndex), @(self.viewModel.rowIndex))];
    }
}


- (JHB2CCommentTopInfoVIew *)topInfoView{
    if (!_topInfoView) {
        JHB2CCommentTopInfoVIew *view = [JHB2CCommentTopInfoVIew new];
        _topInfoView = view;
    }
    return _topInfoView;
}

- (JHB2CCommentDesView *)desView{
    if (!_desView) {
        JHB2CCommentDesView *view = [JHB2CCommentDesView new];
        _desView = view;
    }
    return _desView;
}
- (JHB2CCommentPictureView *)pictureView{
    if (!_pictureView) {
        JHB2CCommentPictureView *view = [JHB2CCommentPictureView new];
        _pictureView = view;
    }
    return _pictureView;
}
- (JHB2CCommentShopReplyDesView *)replyView{
    if (!_replyView) {
        JHB2CCommentShopReplyDesView *view = [JHB2CCommentShopReplyDesView new];
        _replyView = view;
    }
    return _replyView;
}
- (UIView *)backView{
    if (!_backView) {
        UIView *view = [UIView new];
        _backView = view;
    }
    return _backView;
}
- (UIView *)lineView{
    if (!_lineView) {
        UIView *view = [UIView new];
        view.backgroundColor = HEXCOLOR(0xE6E6E6);
        _lineView = view;
    }
    return _lineView;
}
- (UIButton *)delBtn{
    if (!_delBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"删除评论" forState:UIControlStateNormal];
        [btn setTitleColor:HEXCOLOR(0x666666) forState:UIControlStateNormal];
        btn.titleLabel.font = JHFont(12);
        [btn addTarget:self action:@selector(delComment:) forControlEvents:UIControlEventTouchUpInside];
        _delBtn = btn;
    }
    return _delBtn;
}
@end



