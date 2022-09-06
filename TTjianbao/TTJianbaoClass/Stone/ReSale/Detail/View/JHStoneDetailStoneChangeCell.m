//
//  JHStoneDetailStoneChangeCell.m
//  TTjianbao
//
//  Created by apple on 2019/12/24.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//
#import "CStoneDetailModel.h"
#import "JHStoneDetailStoneChangeCell.h"
#import <GKPhotoBrowser/GKPhotoBrowser.h>
#import <AVKit/AVKit.h>
#import "TTjianbaoMarcoKeyword.h"

@interface JHStoneDetailStoneChangeImageView ()

@property (nonatomic, strong) UIImageView *iconView;

@property (nonatomic, copy) void(^imageClickBlock)(NSInteger tag);

@end

@implementation JHStoneDetailStoneChangeImageView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.clipsToBounds = YES;
        [self jh_cornerRadius:2];
        _iconView = [UIImageView jh_imageViewWithImage:@"icon_video_play" addToSuperview:self];
        [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(23, 23));
        }];
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageAction:)]];
    }
    return self;
}

-(void)imageAction:(UIGestureRecognizer *)sender
{
    UIView *view = sender.view;
    if (_imageClickBlock && view) {
        _imageClickBlock(view.tag);
    }
}

@end

@interface JHStoneDetailStoneChangeCell ()

@property (nonatomic, strong) UIView *topLineView;

@property (nonatomic, strong) UIButton *dotButton;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *numberLabel;

@property (nonatomic, strong) UILabel *descLabel;

@property (nonatomic, strong) UILabel *priceLabel;

@property (nonatomic, strong) NSMutableArray <JHStoneDetailStoneChangeImageView *> *imageViewArray;

@property (nonatomic, strong) UIButton *moreButton;

@end

@implementation JHStoneDetailStoneChangeCell

-(void)addSelfSubViews
{
    UIView *bottonLine = [UIView jh_viewWithColor:RGB(238, 238, 238) addToSuperview:self.contentView];
    [bottonLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(1.f);
        make.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(22.f);
        make.top.equalTo(self.contentView).offset(15.f);
    }];
    
    _topLineView = [UIView jh_viewWithColor:RGB(238, 238, 238) addToSuperview:self.contentView];
    [_topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.left.equalTo(bottonLine);
        make.top.equalTo(self.contentView);
        make.bottom.equalTo(bottonLine.mas_top);
    }];
    
    _dotButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_dotButton];
    [_dotButton setImage:[UIImage imageNamed:@"stone_detail_title_tip_icon_top"] forState:UIControlStateSelected];
    [_dotButton setImage:[UIImage imageNamed:@"stone_detail_title_tip_icon_bottom"] forState:UIControlStateNormal];
    [_dotButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(11, 11));
        make.left.equalTo(self.contentView).offset(17.f);
        make.top.equalTo(self.contentView).offset(5);
    }];
    
    _titleLabel = [UILabel jh_labelWithText:@"第123刀：切" font:14 textColor:UIColor.blackColor textAlignment:0 addToSuperView:self.contentView];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(37.f);
        make.right.equalTo(self.contentView).offset(-15.f);
        make.centerY.equalTo(self.dotButton);
        make.height.mas_equalTo(20.f);
    }];
    
    _numberLabel = [UILabel jh_labelWithText:@"编号：123" font:13 textColor:RGB(102, 102, 102) textAlignment:0 addToSuperView:self.contentView];
    [_numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(5.f);
        make.size.mas_equalTo(CGSizeMake(150, 18));
    }];
    
    _priceLabel = [UILabel jh_labelWithText:@"123.00" font:14 textColor:RGB(255, 66, 0) textAlignment:2 addToSuperView:self.contentView];
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-15);
        make.centerY.equalTo(self.numberLabel);
        make.size.mas_equalTo(CGSizeMake(150, 18));
    }];
    
    _descLabel = [UILabel jh_labelWithText:@"123sdsadasdsa123sdsadasdsa123sd" font:13 textColor:RGB(102, 102, 102) textAlignment:0 addToSuperView:self.contentView];
    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.titleLabel);
        make.top.equalTo(self.numberLabel.mas_bottom).offset(5.f);
        make.height.mas_equalTo(18.f);
    }];
    
    for (int i = 1000; i< 1003; i++) {
        
        JHStoneDetailStoneChangeImageView *imageView = [JHStoneDetailStoneChangeImageView new];
        imageView.tag = i;
        [self.contentView addSubview:imageView];
        @weakify(imageView);
        imageView.imageClickBlock = ^(NSInteger tag) {
            @strongify(imageView);
            [self showPhotoBrowserWithIndex:imageView.tag-1000];
        };
        [self.imageViewArray addObject:imageView];
    }
    
    [self.imageViewArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:6.f leadSpacing:37.f tailSpacing:15.f];
    [self.imageViewArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.descLabel.mas_bottom).offset(10.f);
        make.height.mas_equalTo((ScreenW - 59.f) / 3.0);
        make.bottom.equalTo(self.contentView).offset(-20);
    }];
    
    
    JHStoneDetailStoneChangeImageView *rightImageView = self.imageViewArray[2];
    _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightImageView addSubview:_moreButton];
    _moreButton.jh_imageName(@"stone_detail_image_icon").jh_backgroundColor(RGBA(0, 0, 0, 0.5)).jh_font([UIFont systemFontOfSize:12]).jh_titleColor(UIColor.whiteColor);
    _moreButton.titleEdgeInsets = UIEdgeInsetsMake(0, 2, 0, -2);
    _moreButton.imageEdgeInsets = UIEdgeInsetsMake(0, -2, 0, 2);
    [_moreButton jh_cornerRadius:8.5];
    [_moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(39.f, 17.f));
        make.bottom.equalTo(rightImageView).offset(-3.f);
        make.right.equalTo(rightImageView).offset(-3.f);
    }];
}

-(void)setModel:(CStoneChangeListData *)model
{
    _model = model;
    
//    NSString *price = [NSString stringWithFormat:@"%@元成交",@((NSInteger)_model.price)];
//    if(_model.price >= 10000)
//    {
//        price = [NSString stringWithFormat:@"%@万元成交",PRICE_FLOAT_TO_STRING(_model.price/10000.0)];
//    }
    
    NSString *price = [NSString stringWithFormat:@"￥%@成交",PRICE_FLOAT_TO_STRING(_model.price)];
    
    _numberLabel.text   = [NSString stringWithFormat:@"编号：%@",_model.goodsCode];
    _descLabel.text     = _model.goodsTitle;
    _priceLabel.text    = price;
    _dotButton.selected = _model.isTop;
    _topLineView.hidden = _model.isTop;
    _titleLabel.text    = (_model.processMode.length > 0) ? _model.processMode : @"初始原石";
    if(IS_ARRAY(self.model.attachmentList))
    {
        _moreButton.jh_title(NUMBRR_TO_STRING(@(self.model.attachmentList.count)));
    }
    
    
    for (int i = 0; i<3; i++) {
        JHStoneDetailStoneChangeImageView *imageView = self.imageViewArray[i];
        if (i < self.model.attachmentList.count) {
            imageView.hidden = NO;
            CAttachmentListData *imageModel = _model.attachmentList[i];
            [imageView jh_setImageWithUrl:imageModel.coverUrl];
            imageView.iconView.hidden = (imageModel.attachmentType != 2);
        }
        else
        {
            imageView.hidden = YES;
        }
    }
}

//查看大图
- (void)showPhotoBrowserWithIndex:(NSInteger)index {

    if (self.model.attachmentList.count <= index) {
        return;
    }
    CAttachmentListData *data = self.model.attachmentList[index];
    if (data.attachmentType == 2) {
        [self playerWithUrl:data.url];
        return;
    }
    
    NSMutableArray *photoList = [NSMutableArray new];
    [self.model.attachmentList enumerateObjectsUsingBlock:^(CAttachmentListData * _Nonnull data, NSUInteger idx, BOOL * _Nonnull stop) {
        GKPhoto *photo = [GKPhoto new];
        photo.url = [NSURL URLWithString:data.originUrl];
        UIImageView *view = (index <= self.imageViewArray.count) ? self.imageViewArray[index] : self.imageViewArray[0];
        photo.sourceImageView = view; //用同一个source
        [photoList addObject:photo];
    }];
    
    GKPhotoBrowser *browser = [GKPhotoBrowser photoBrowserWithPhotos:photoList currentIndex:index];
    browser.isStatusBarShow = YES; //开始时不隐藏状态栏，不然会有页面跳动问题
    browser.isScreenRotateDisabled = YES; //禁止横屏监测
    browser.showStyle = GKPhotoBrowserShowStyleNone;
    browser.hideStyle = GKPhotoBrowserHideStyleZoomScale;
    [browser showFromVC:self.viewController];
}

-(NSMutableArray<JHStoneDetailStoneChangeImageView *> *)imageViewArray
{
    if(!_imageViewArray){
        _imageViewArray = [NSMutableArray arrayWithCapacity:3];
    }
    return _imageViewArray;
}

-(void)playerWithUrl:(NSString *)urlStr
{
    NSURL *url = [NSURL URLWithString:urlStr];
    
    AVPlayerViewController *ctrl = [[AVPlayerViewController alloc] init];

    ctrl.player= [[AVPlayer alloc]initWithURL:url];
    
    [self.viewController presentViewController:ctrl animated:YES completion:nil];
}

@end
