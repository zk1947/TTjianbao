//
//  JHMarketCommunityCollectionViewCell.m
//  TTjianbao
//
//  Created by zk on 2021/6/3.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHMarketCommunityCollectionViewCell.h"
#import "NSString+Common.h"
#import "NSString+Extension.h"

@interface JHMarketCommunityCollectionViewCell ()

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIImageView *iconImagv;
@property (nonatomic, strong) UILabel *titleLable1;

@property (nonatomic, strong) JHMarketCommunityNewsCell *cell1;
@property (nonatomic, strong) JHMarketCommunityNewsCell *cell2;
@property (nonatomic, strong) JHMarketCommunityNewsCell *cell3;

@property (nonatomic, strong) NSMutableArray *cellsArray;

@end

@implementation JHMarketCommunityCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        self.contentView.backgroundColor = kColorFFF;
        self.cellsArray = [NSMutableArray array];
        [self setupView];
    }
    return self;
}

- (void)setupView{
    _backView = [UIView new];
    [self.contentView addSubview:_backView];
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(48);
    }];
    [_backView layoutIfNeeded];
    [self addGradualColor:_backView];
    
    _iconImagv = [[UIImageView alloc]init];
    _iconImagv.image = JHImageNamed(@"c2c_market_community_icon");
    [self.contentView addSubview:_iconImagv];
    [_iconImagv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(11);
        make.width.mas_equalTo(18);
        make.height.mas_equalTo(18);
    }];
    
    _titleLable1 = [[UILabel alloc]init];
    _titleLable1.font = JHFont(15);
    _titleLable1.textColor = kColor222;
    _titleLable1.text = @"热门讨论";
    [self.contentView addSubview:_titleLable1];
    [_titleLable1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_iconImagv.mas_right).offset(5);
        make.top.mas_equalTo(10);
        make.height.mas_equalTo(20);
    }];

    _cell1 = [[JHMarketCommunityNewsCell alloc]init];
    _cell1.tag = 2021;
    [_cell1 addTarget:self action:@selector(cellControlAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_cell1];
    [_cell1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(48);
        make.width.mas_equalTo(self.width);
        make.height.mas_equalTo(40);
    }];
    
    _cell2 = [[JHMarketCommunityNewsCell alloc]init];
    _cell2.tag = 2022;
    [_cell2 addTarget:self action:@selector(cellControlAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_cell2];
    [_cell2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(_cell1.mas_bottom).offset(10);
        make.width.mas_equalTo(self.width);
        make.height.mas_equalTo(40);
    }];
    
    _cell3= [[JHMarketCommunityNewsCell alloc]init];
    _cell3.tag = 2023;
    [_cell3 addTarget:self action:@selector(cellControlAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_cell3];
    [_cell3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(_cell2.mas_bottom).offset(10);
        make.width.mas_equalTo(self.width);
        make.height.mas_equalTo(40);
    }];
    
    [self.cellsArray addObject:_cell1];
    [self.cellsArray addObject:_cell2];
    [self.cellsArray addObject:_cell3];
}

- (void)setHotListArray:(NSArray *)hotListArray{
    _hotListArray = hotListArray;
    for (int index = 0; index <self.cellsArray.count; index++) {
        JHMarketCommunityNewsCell *cell = self.cellsArray[index];
        if (_hotListArray.count > index) {
            cell.hidden = NO;
            JHMarketHomeHotTopItemModel *model = _hotListArray[index];
            cell.imageUrl = model.image;
            cell.contentString = model.title;
        }else{
            cell.hidden = YES;
        }
    }
}

- (void)cellControlAction:(JHMarketCommunityNewsCell *)cell{
    JHMarketHomeHotTopItemModel *postData = self.hotListArray[cell.tag - 2021];
    [JHRouterManager pushPostDetailWithItemType:[postData.item_type intValue] itemId:postData.item_id pageFrom:JHFromHotArticleList scrollComment:0];
//    [JHGrowingIO trackEventId:JHTrackSQHotTwitterEnter variables:@{@"item_id":postData.item_id}];
//    ///340埋点 - BI埋点
//    [[JHBuryPointOperator shareInstance] buryWithEtype:JHTrackSQHotTwitterEnter param:@{@"item_id":postData.item_id}];
}

- (void)addGradualColor:(UIView *)view{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)HEXCOLOR(0xFFEBE8).CGColor, (__bridge id)HEXCOLOR(0xFFFFFF).CGColor];
    gradientLayer.locations = @[@0.2, @0.9];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1.0);
    gradientLayer.frame = view.bounds;
    [view.layer addSublayer:gradientLayer];
}

@end

@implementation JHMarketCommunityNewsCell

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView{
    
    _newsImageView = [[UIImageView alloc]init];
    _newsImageView.userInteractionEnabled = YES;
    _newsImageView.contentMode = UIViewContentModeScaleAspectFill;
    [_newsImageView jh_cornerRadius:5];
    [self addSubview:_newsImageView];
    [_newsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(0);
        make.width.height.mas_equalTo(40);
    }];

    _contentLable = [[UILabel alloc]init];
    _contentLable.font = JHFont(12);//[UIFont systemFontOfSize:12];
    _contentLable.textColor = kColor333;
    _contentLable.numberOfLines = 2;
    [self addSubview:_contentLable];
    [_contentLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_newsImageView.mas_right).offset(8);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];
    
}

- (void)setImageUrl:(NSString *)imageUrl{
    _imageUrl = imageUrl;
    [_newsImageView jhSetImageWithURL:[NSURL URLWithString:_imageUrl] placeholder:JHImageNamed(@"newStore_default_avatar_placehold")];
}

- (void)setContentString:(NSString *)contentString{
    _contentString = contentString;
    _contentLable.text = _contentString;
}

@end
