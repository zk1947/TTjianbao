//
//  JHB2CSubCollectionHeadView.m
//  TTjianbao
//
//  Created by zk on 2021/10/13.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHB2CSubCollectionHeadView.h"
#import "SDCycleScrollView.h"
#import "JHAnimatedImageView.h"

@interface JHB2CSubCollectionHeadView ()<SDCycleScrollViewDelegate>

@property (nonatomic, strong) UIView *itemView1;//轮播
@property (nonatomic, strong) SDCycleScrollView *sdScrView;//轮播

@property (nonatomic, strong) UIView *itemView2;//直播
@property (nonatomic, strong) UILabel *videoTitleLabel;
@property (nonatomic, strong) UIButton * moreBtn;
@property (nonatomic, strong) NSMutableArray *itemsArr;
@property (nonatomic, strong) NSMutableArray *imgvsArr;
@property (nonatomic, strong) NSMutableArray *labsArr;

@property (nonatomic, strong) UIView *itemView3;//分类头部
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton * allBtn;

@end

@implementation JHB2CSubCollectionHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.itemView1 = [UIView new];
    [self addSubview:self.itemView1];
    [self.itemView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(90);
    }];
    
    self.itemView2 = [UIView new];
    [self addSubview:self.itemView2];
    [self.itemView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.itemView1.mas_bottom);
        make.height.mas_equalTo(170);
    }];
    
    self.itemView3 = [UIView new];
    [self addSubview:self.itemView3];
    [self.itemView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.itemView2.mas_bottom);
        make.height.mas_equalTo(50);
    }];
    [self setupItem1];
    [self setupItem2];
    [self setupItem3];
}

- (void)setupItem1{
    //轮播
    self.sdScrView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(10, 10, self.width-22, 72) delegate:self placeholderImage:  kDefaultCoverImage];
    self.sdScrView.backgroundColor = [UIColor clearColor];
    self.sdScrView.layer.cornerRadius = 5.f;
    self.sdScrView.clipsToBounds = YES;
    self.sdScrView.autoScrollTimeInterval = 3;
    self.sdScrView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    self.sdScrView.hidesForSinglePage = YES;
    self.sdScrView.pageControlStyle = SDCycleScrollViewPageContolStyleJH;
    self.sdScrView.pageControlBottomOffset = -5;
    [self.itemView1 addSubview:self.sdScrView];
}

- (void)setupItem2{
    self.videoTitleLabel = [UILabel new];
    self.videoTitleLabel.text = @"直播推荐";
    self.videoTitleLabel.font = JHBoldFont(13);
    self.videoTitleLabel.textColor = HEXCOLOR(0x333333);
    [self.itemView2 addSubview:self.videoTitleLabel];
    
    [self.itemView2 addSubview:self.moreBtn];
    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@0);
        make.top.equalTo(@0);
        make.width.equalTo(@90);
    }];
    [self.videoTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.centerY.equalTo(self.moreBtn);
    }];
    
    self.itemsArr = [NSMutableArray array];
    self.imgvsArr = [NSMutableArray array];
    self.labsArr = [NSMutableArray array];
    for (int index = 0; index < 3; index++) {
        
        UIControl *ctrl = [UIControl new];
        ctrl.tag = 2021+index;
        [ctrl addTarget:self action:@selector(controlAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.itemView2 addSubview:ctrl];
        [ctrl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(10+90*index));
            make.top.equalTo(@45);
            make.width.equalTo(@80);
            make.height.equalTo(@120);
        }];
        
        UIImageView *liveImgv = [UIImageView new];
        [liveImgv jh_cornerRadius:5];
        liveImgv.image = JHImageNamed(@"bg_shop_top");
        [ctrl addSubview:liveImgv];
        [liveImgv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(@0);
            make.height.equalTo(@80);
        }];

        UIView *livingStatusView = [[UIView alloc] init];
        livingStatusView.backgroundColor = HEXCOLOR(0xffd70f);
        [livingStatusView jh_cornerRadius:1.5];
        [liveImgv addSubview:livingStatusView];
        [livingStatusView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(@8);
            make.size.mas_equalTo(CGSizeMake(14, 14));
        }];
        YYAnimatedImageView *playingImage=[[YYAnimatedImageView alloc]init];
        playingImage.contentMode = UIViewContentModeScaleAspectFit;
        playingImage.image = [YYImage imageNamed:@"mall_home_list_living.webp"];
        [livingStatusView addSubview:playingImage];
        [playingImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(livingStatusView);
            make.size.mas_equalTo(CGSizeMake(9, 9));
        }];
        

        UILabel *liveLab = [UILabel new];
        liveLab.text = @"四会翡翠成品源头工厂大ssss";
        liveLab.font = JHFont(13);
        liveLab.textColor = HEXCOLOR(0x666666);
        liveLab.numberOfLines = 2;
        [ctrl addSubview:liveLab];
        [liveLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(liveImgv.mas_bottom).offset(5);
            make.left.right.equalTo(@0);
        }];
        
        [self.itemsArr addObject:ctrl];
        [self.imgvsArr addObject:liveImgv];
        [self.labsArr addObject:liveLab];
    }
}

- (void)setupItem3{
    self.titleLabel = [UILabel new];
    self.titleLabel.font = JHBoldFont(13);
    self.titleLabel.textColor = HEXCOLOR(0x333333);
    [self.itemView3 addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.centerY.equalTo(@0);
    }];
    [self.itemView3 addSubview:self.allBtn];
    [self.allBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.top.right.equalTo(@0);
        make.width.equalTo(@90);
    }];
}

- (void)setModel:(JHNewStoreTypeRightSectionModel *)model{
    _model = model;
    
    //轮播数据
    self.itemView1.hidden = _model.operationList.count > 0 ? NO : YES;
    [self.itemView1 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(_model.operationList.count > 0 ? 90 : 0);
    }];
    if (_model.operationList.count > 0) {
        NSMutableArray *imgsArr = [NSMutableArray array];
        [_model.operationList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            JHNewStoreTypeRightScrollModel *model = obj;
            [imgsArr addObject:model.imageUrl];
        }];
        self.sdScrView.imageURLStringsGroup = imgsArr;
    }
    
    //直播数据
    self.itemView2.hidden = _model.liveList.count > 0 ? NO : YES;
    [self.itemView2 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(_model.liveList.count > 0 ? _model.liveHeight : 0);
    }];
    for (UIControl *ctrl in self.itemsArr) {
        ctrl.hidden = YES;
    }
    if (_model.liveList.count > 0) {
        [_model.liveList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            JHNewStoreTypeRightLiveModel *liveModel = obj;
            if (idx > 2) {
                *stop = YES;
                return;
            }
            UIControl *ctrl = self.itemsArr[idx];
            ctrl.hidden = NO;
            
            UIImageView *imgv = self.imgvsArr[idx];
            [imgv jhSetImageWithURL:[NSURL URLWithString:liveModel.smallCoverImg] placeholder:JHImageNamed(@"newStore_fenlei_hoderimage")];
        
            UILabel *lab = self.labsArr[idx];
            lab.text = liveModel.anchorName;
        }];
    }
    
    //二级分类头部
    self.titleLabel.text = _model.firstCateName;
}

#pragma mark - 轮播点击事件
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    if (self.headViewTouchEventBlock) {
        self.headViewTouchEventBlock(0,index);
    }
}
#pragma mark - 更多直播间点击事件
- (void)moreBtnAction{
    if (self.headViewTouchEventBlock) {
        self.headViewTouchEventBlock(1,0);
    }
}
#pragma mark - 直播间点击事件
- (void)controlAction:(UIControl *)ctrl{
    if (self.headViewTouchEventBlock) {
        self.headViewTouchEventBlock(2,ctrl.tag-2021);
    }
}
#pragma mark - 分类全部点击事件
- (void)allBtnAction{
    if (self.headViewTouchEventBlock) {
        self.headViewTouchEventBlock(3,0);
    }
}

- (UIButton *)allBtn{
    if (!_allBtn) {
        _allBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_allBtn addTarget:self action:@selector(allBtnAction) forControlEvents:UIControlEventTouchUpInside];
        UIImageView *arrowimageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jh_newStore_type_all_arrow"]];
        [_allBtn addSubview:arrowimageView];
        [arrowimageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_allBtn).offset(-9);
            make.centerY.equalTo(@0);
        }];
        UILabel *allLbl = [UILabel new];
        allLbl.font = JHFont(12);
        allLbl.textColor = HEXCOLOR(0x999999);
        allLbl.text = @"查看全部";
        [_allBtn addSubview:allLbl];
        [allLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(arrowimageView.mas_left);
            make.centerY.equalTo(@0);
        }];
    }
    return _allBtn;
}

- (UIButton *)moreBtn{
    if (!_moreBtn) {
        _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreBtn addTarget:self action:@selector(moreBtnAction) forControlEvents:UIControlEventTouchUpInside];
        UIImageView *arrowimageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jh_newStore_type_all_arrow"]];
        [_moreBtn addSubview:arrowimageView];
        [arrowimageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_moreBtn).offset(-9);
            make.centerY.equalTo(@0);
        }];
        UILabel *allLbl = [UILabel new];
        allLbl.font = JHFont(12);
        allLbl.textColor = HEXCOLOR(0x999999);
        allLbl.text = @"查看更多";
        [_moreBtn addSubview:allLbl];
        [allLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(arrowimageView.mas_left);
            make.centerY.equalTo(@0);
        }];
    }
    return _moreBtn;
}
@end

