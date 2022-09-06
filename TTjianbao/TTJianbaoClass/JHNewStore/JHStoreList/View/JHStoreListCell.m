//
//  JHStoreListCell.m
//  TTjianbao
//
//  Created by zk on 2021/10/12.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHStoreListCell.h"
#import "UILabel+edgeInsets.h"

@interface JHStoreListCell ()

@property (nonatomic, strong) UIView *backView;

@property (nonatomic, strong) UIView *headColorView;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@property (nonatomic, strong) UIImageView *headImgv;
@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, strong) UIImageView *tagImgv;
@property (nonatomic, strong) UILabel *expLab;
@property (nonatomic, strong) UILabel *goBtn;

@property (nonatomic, strong) UIView *footView;
@property (nonatomic, strong) NSMutableArray *imgvsArr;
@property (nonatomic, strong) NSMutableArray *labsArr;

@end

@implementation JHStoreListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self setupUI];
        [self layoutUI];
    }
    return self;
}

- (void)setupUI{
    
    _backView = [[UIView alloc]init];
    _backView.backgroundColor = kColorFFF;
    [_backView jh_cornerRadius:8];
    [self.contentView addSubview:_backView];
    
    _headColorView = [[UIView alloc]init];
    [_backView addSubview:_headColorView];
    
    _headImgv = [[UIImageView alloc]init];
    [_headImgv jh_cornerRadius:20];
    _headImgv.image = JHImageNamed(@"totalHeader_bg");
    [_backView addSubview:_headImgv];

    _nameLab = [[UILabel alloc]init];
    _nameLab.text = @"新疆和田玉镶嵌工作室工…";
    _nameLab.textColor = kColor222;
    _nameLab.font = JHMediumFont(14);
    [_backView addSubview:_nameLab];

    _tagImgv = [[UIImageView alloc]init];
    _tagImgv.image = JHImageNamed(@"icon_auth_company");
    [_backView addSubview:_tagImgv];

    _expLab = [[UILabel alloc]init];
    _expLab.textColor = kColor666;
    _expLab.font = JHFont(11);
    _expLab.attributedText = [self changePartTxtColor:@"5.0综合评分 | 119430粉丝 | 99.98%好评度"];
    _expLab.adjustsFontSizeToFitWidth = YES;
    [_backView addSubview:_expLab];
    
    _goBtn = [UILabel new];
    _goBtn.text = @"进入店铺";
    _goBtn.font = [UIFont fontWithName:kFontNormal size:11];
    _goBtn.textColor = HEXCOLOR(0x333333);
    _goBtn.textAlignment = NSTextAlignmentCenter;
    _goBtn.layer.cornerRadius = 2;
    _goBtn.layer.borderColor = HEXCOLOR(0xffd70f).CGColor;
    _goBtn.layer.borderWidth = 0.5;
    _goBtn.clipsToBounds = YES;
    _goBtn.backgroundColor = HEXCOLOR(0xfffbee);
    [_backView addSubview:_goBtn];
    
    _footView = [[UIView alloc]init];
    [_backView addSubview:_footView];
    
    self.imgvsArr = [NSMutableArray array];
    self.labsArr = [NSMutableArray array];
    for (int index = 0; index < 3; index++) {
        
        UIImageView *goodsImgv = [UIImageView new];
        [goodsImgv jh_cornerRadius:5];
        goodsImgv.image = JHImageNamed(@"bg_shop_top");
        [_footView addSubview:goodsImgv];
        
        UILabel *priceLab = [UILabel new];
        priceLab.backgroundColor = HEXCOLORA(0x000000, 0.5);
        priceLab.text = @"￥123456";
        priceLab.font = JHFont(12);
        priceLab.textColor = HEXCOLOR(0xFFFFFF);
        priceLab.edgeInsets = UIEdgeInsetsMake(2.f, 5.f, 2.f, 6.f);
        [priceLab jh_cornerRadius:4];
        [goodsImgv addSubview:priceLab];
        
        [self.imgvsArr addObject:goodsImgv];
        [self.labsArr addObject:priceLab];
    }
}

- (void)layoutUI{
    
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@10);
        make.left.equalTo(@12);
        make.right.equalTo(@(-12));
        make.bottom.equalTo(@0);
    }];
    
    [_headColorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(@0);
        make.height.equalTo(@59);
    }];
    
    [_headImgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(@10);
        make.width.height.equalTo(@40);
    }];

    [_nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@10);
        make.left.equalTo(_headImgv.mas_right).offset(10);
        make.width.equalTo(@168);
        make.height.equalTo(@20);
    }];

    [_tagImgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameLab.mas_right).offset(5);
        make.width.equalTo(@42);
        make.height.equalTo(@13);
        make.centerY.equalTo(_nameLab);
    }];

    [_expLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nameLab.mas_bottom).offset(3);
        make.left.equalTo(_headImgv.mas_right).offset(10);
        make.right.equalTo(@(-80));
    }];
    
    [_goBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@17);
        make.right.equalTo(@-12);
        make.width.equalTo(@(55));
        make.height.equalTo(@(26));
    }];
    
    //添加渐变色
    [_headColorView layoutIfNeeded];
    [self addGradualColor:_headColorView];
    
    [_footView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headColorView.mas_bottom);
        make.left.right.bottom.equalTo(@0);
    }];
    
    [self.imgvsArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImageView *imgv = obj;
        [imgv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.left.equalTo(@(12+111*idx));
            make.width.height.equalTo(@104);
        }];
        
        UILabel *lab = self.labsArr[idx];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.equalTo(@0);
        }];
        
        //添加部分圆角
//        [lab layoutIfNeeded];
//        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:lab.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(4, 4)];
//        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//        maskLayer.frame = lab.bounds;
//        maskLayer.path = maskPath.CGPath;
//        lab.layer.mask = maskLayer;
    }];
    
}

- (void)setModel:(JHStoreListModel *)model{
    _model = model;
    //头像
    [_headImgv jhSetImageWithURL:[NSURL URLWithString:_model.shopLogoImg] placeholder:JHImageNamed(@"newStore_fenlei_hoderimage")];
    //店名
    _nameLab.text = _model.shopName;
    [_nameLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(_model.labW));
    }];
    //认证类别 authStatus 0:否 1:是
    //商家类型  sellerType 1:个人 2:企业 3:个体户
    _tagImgv.hidden = _model.authStatus == 1 ? NO:YES;
    _tagImgv.image = _model.sellerType == 2 ? JHImageNamed(@"icon_auth_company"):JHImageNamed(@"icon_auth_personal");
    //评分 comprehensiveScore 粉丝 followNum 好评度 orderGrades
    double resultNum = [_model.orderGrades doubleValue]*100;
    NSString *gradeStr = [NSString stringWithFormat:@"%@综合评分 | %ld粉丝 | %.2f%%好评度",_model.comprehensiveScore,_model.followNum,resultNum];
    _expLab.attributedText = [self changePartTxtColor:gradeStr];
    _expLab.adjustsFontSizeToFitWidth = YES;
    
    _footView.hidden = model.productList.count > 0 ? NO:YES;
    for (UIImageView *imgv in self.imgvsArr) {
        imgv.hidden = YES;
    }
    [_model.productList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        JHStoreItemModel *itemModel = obj;
        if (idx > 2) {
            *stop = YES;
            return;
        }
        UIImageView *imgv = self.imgvsArr[idx];
        imgv.hidden = NO;
        [imgv jhSetImageWithURL:[NSURL URLWithString:itemModel.coverImage.url] placeholder:JHImageNamed(@"newStore_fenlei_hoderimage")];
        
        UILabel *lab = self.labsArr[idx];
        lab.text = [NSString stringWithFormat:@"￥%@",itemModel.price];
    }];
}

#pragma mark - 渐变色
- (void)addGradualColor:(UIView *)view{
    if (!self.gradientLayer) {
        self.gradientLayer = [CAGradientLayer layer];
        self.gradientLayer.colors = @[(__bridge id)HEXCOLOR(0xFFFCEE).CGColor, (__bridge id)HEXCOLOR(0xFFFFFF).CGColor];
        self.gradientLayer.startPoint = CGPointMake(0, 0);
        self.gradientLayer.endPoint = CGPointMake(1.0, 1.0);
        self.gradientLayer.frame = view.bounds;
        [view.layer addSublayer:self.gradientLayer];
    }
}

#pragma mark - 改变部分文字颜色
- (NSMutableAttributedString *)changePartTxtColor:(NSString *)str{
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:str];
    NSString *temp = nil;
    for(int i =0; i < attrStr.length; i++) {
        temp = [str substringWithRange:NSMakeRange(i, 1)];
        if ([temp isEqualToString:@"|"]) {
            [attrStr addAttribute:NSForegroundColorAttributeName value:HEXCOLOR(0xDADADA) range:NSMakeRange(i, 1)];
        }
    }
    return attrStr;
}

@end
