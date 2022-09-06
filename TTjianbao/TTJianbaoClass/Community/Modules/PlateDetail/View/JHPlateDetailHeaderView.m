//
//  JHPlateDetailHeaderView.m
//  TTjianbao
//
//  Created by wangjianios on 2020/9/8.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHPlateDetailHeaderView.h"
#import "JHPlateDetailModel.h"
#import "JHPlateDetailReqModel.h"
#import <UIImage+webP.h>
#import "JHGradientView.h"
#import "JHCollectionView.h"
#import "JHCollectionItemModel.h"
#import "JHSQManager.h"
#import "CommAlertView.h"
#import "JHRecycleUploadTypeSeleteViewController.h"
#import "JHWebViewController.h"
#import "JHRecycleSquareHomeViewController.h"

#define kPlateHeaderHeight  200.f
#define kBriefLabelHeight   62.f
#define kPostHeight         45.f
#define kPostMaxofLines     2

@interface JHPlateDetailHeaderView () <JHDetailCollectionDelegate>

@property (nonatomic, weak) UIImageView *plateImageView;

@property (nonatomic, weak) UILabel *plateNameLabel;

@property (nonatomic, weak) UILabel *plateDescLabel;

@property (nonatomic, weak) UIView *recyclingView; /// 钱币回收 大宗钱币回收 回收商 view
/// 版主
@property (nonatomic, weak) UIView *plateOwnerView;

///下拉刷新动画
@property (nonatomic, weak) UIImageView *pullLoadingView;

///简介
@property (nonatomic, weak) UILabel *briefLabel;


@property (nonatomic, weak) JHCollectionView *collectionView;

@end

@implementation JHPlateDetailHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSelfSubViews];
        self.backgroundColor = UIColor.whiteColor;
    }
    return self;
}

- (void)addSelfSubViews
{
    _plateImageView = [UIImageView jh_imageViewAddToSuperview:self];
    [_plateImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo([JHPlateDetailHeaderView imageViewHeight]);
        make.right.left.equalTo(self);
        make.bottom.equalTo(self.mas_top).offset([JHPlateDetailHeaderView imageViewHeight]);
    }];
    
    _recyclingView = [UIView jh_viewWithColor:UIColor.whiteColor addToSuperview:self];
    [_recyclingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(64.f);
        make.right.left.mas_equalTo(self);
        make.top.mas_equalTo(_plateImageView.mas_bottom).offset(1.f);
    }];
    
    JHGradientView *layer = [JHGradientView new];
    [layer setGradientColor:@[(__bridge id)RGBA(0,0,0,0).CGColor,(__bridge id)RGBA(0,0,0,0.2).CGColor] orientation:JHGradientOrientationVertical];
    [_plateImageView addSubview:layer];
    [layer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo([JHPlateDetailHeaderView imageViewHeight]);
        make.left.right.bottom.equalTo(self.plateImageView);
    }];
    
    _plateNameLabel = [UILabel jh_labelWithBoldFont:24 textColor:UIColor.whiteColor addToSuperView:self.plateImageView];
    [_plateNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.plateImageView).offset(15);
        make.bottom.equalTo(self.plateImageView).offset(-75);
        make.right.equalTo(self.plateImageView).offset(-100);
    }];
    
    _plateDescLabel = [UILabel jh_labelWithFont:12 textColor:UIColor.whiteColor addToSuperView:self.plateImageView];
    [_plateDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.plateNameLabel.mas_bottom).offset(15);
        make.left.equalTo(self.plateNameLabel);
        make.right.equalTo(self.plateImageView).offset(-15);
    }];
    
    JHGradientView *line = [JHGradientView new];
    [line setGradientColor:@[(__bridge id)RGB(254, 225, 0).CGColor,(__bridge id)RGB(255, 194, 66).CGColor] orientation:JHGradientOrientationHorizontal];
    [self addSubview:line];
    [line jh_cornerRadius:14];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.plateNameLabel);
        make.size.mas_equalTo(CGSizeMake(82, 28));
        make.right.equalTo(self.plateDescLabel);
    }];
    
    _focusButton = [UIButton jh_buttonWithTitle:@"关注" fontSize:14 textColor:RGB515151 target:self action:@selector(focusMethod:) addToSuperView:line];
    [_focusButton setTitleColor:RGB515151 forState:UIControlStateNormal];
    [_focusButton setBackgroundImage:[UIImage imageWithColor:UIColor.clearColor] forState:UIControlStateNormal];
    
    [_focusButton setTitle:@"已关注" forState:UIControlStateSelected];
    [_focusButton setTitleColor:kColor999 forState:UIControlStateSelected];
    [_focusButton setBackgroundImage:[UIImage imageWithColor:RGB(238, 238, 238)] forState:UIControlStateSelected];
    
    [_focusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(line);
    }];
    
    UILabel *ownerLabel = [UILabel jh_labelWithBoldText:@"版主" font:12 textColor:UIColor.whiteColor textAlignment:0 addToSuperView:self];
    [ownerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.plateImageView).offset(15);
        make.bottom.equalTo(self.plateImageView).offset(-16.5);
    }];
    
    _plateOwnerView = [UIView jh_viewWithColor:UIColor.clearColor addToSuperview:self];
    [_plateOwnerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ownerLabel.mas_right).offset(10);
        make.centerY.equalTo(ownerLabel);
        make.size.mas_equalTo(CGSizeMake(60, 20));
    }];
    @weakify(self);
    [_plateOwnerView jh_addTapGesture:^{
        @strongify(self);
        if(self.briefBlock)
        {
            self.briefBlock(YES);
        }
    }];
    
    [[UIView jh_viewWithColor:APP_BACKGROUND_COLOR addToSuperview:self] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(10);
    }];
}

- (void)addRecyclingSubView {

    UIButton *recyclingMoney = [UIButton jh_buttonWithTitle:@"卖钱币" fontSize:11 textColor:HEXCOLOR(0xFF333333) target:self action:@selector(recyclingMoneyAction:) addToSuperView:self.recyclingView];
    [recyclingMoney setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [recyclingMoney setImage:[UIImage imageNamed:@"shequ_recyclingMoney"] forState:UIControlStateNormal];
    recyclingMoney.backgroundColor = UIColor.whiteColor;
    recyclingMoney.titleLabel.font = JHMediumFont(11);
    
    recyclingMoney.layer.cornerRadius = 5;
    recyclingMoney.layer.shadowColor = HEXCOLORA(0x0D000000, 0.05).CGColor;
    recyclingMoney.layer.shadowOffset = CGSizeMake(0,1.5);
    recyclingMoney.layer.shadowOpacity = 1;
    recyclingMoney.layer.shadowRadius = 7.5;
    
    UIImageView *recyclingMoneyEsc = [UIImageView jh_imageViewWithImage:[UIImage imageNamed:@"icon_plate_small_sa"] addToSuperview:recyclingMoney];
    [recyclingMoney addSubview:recyclingMoneyEsc];
    
    
    UIButton *recyclingBigMoney = [UIButton jh_buttonWithTitle:@" 卖大宗钱币" fontSize:11 textColor:HEXCOLOR(0xFF333333) target:self action:@selector(recyclingBigMoneyAction:) addToSuperView:self.recyclingView];
    [recyclingBigMoney setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [recyclingBigMoney setImage:[UIImage imageNamed:@"shequ_myRecyclingButton"] forState:UIControlStateNormal];
    recyclingBigMoney.backgroundColor = UIColor.whiteColor;
    recyclingBigMoney.titleLabel.font = JHMediumFont(11);
    recyclingBigMoney.layer.cornerRadius = 5;
    recyclingBigMoney.layer.shadowColor = HEXCOLORA(0x0D000000, 0.05).CGColor;
    recyclingBigMoney.layer.shadowOffset = CGSizeMake(0,1.5);
    recyclingBigMoney.layer.shadowOpacity = 1;
    recyclingBigMoney.layer.shadowRadius = 7.5;
    
    UIImageView *recyclingBigMoneyEsc = [UIImageView jh_imageViewWithImage:[UIImage imageNamed:@"icon_plate_small_sa"] addToSuperview:recyclingBigMoney];
    [recyclingBigMoney addSubview:recyclingBigMoneyEsc];

    
    UIButton *myRecyclingButton = [UIButton jh_buttonWithTitle:@"成为回收商" fontSize:11 textColor:HEXCOLOR(0xFF333333) target:self action:@selector(myRecyclingAction:) addToSuperView:self.recyclingView];
    [myRecyclingButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [myRecyclingButton setImage:[UIImage imageNamed:@"shequ_recyclingBigMoney"] forState:UIControlStateNormal];
    myRecyclingButton.backgroundColor = UIColor.whiteColor;
    myRecyclingButton.titleLabel.font = JHMediumFont(11);
    myRecyclingButton.layer.cornerRadius = 5;
    myRecyclingButton.layer.shadowColor = HEXCOLORA(0x0D000000, 0.05).CGColor;
    myRecyclingButton.layer.shadowOffset = CGSizeMake(0,1.5);
    myRecyclingButton.layer.shadowOpacity = 1;
    myRecyclingButton.layer.shadowRadius = 7.5;
    
    UIImageView *myRecyclingButtonEsc = [UIImageView jh_imageViewWithImage:[UIImage imageNamed:@"icon_plate_small_sa"] addToSuperview:myRecyclingButton];
    [myRecyclingButton addSubview:myRecyclingButtonEsc];
    
    
    [self.recyclingView.subviews mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:12.f leadSpacing:10.f tailSpacing:12.f];
    
    [recyclingMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.recyclingView);
        make.height.mas_equalTo(recyclingBigMoney);
    }];
    [recyclingMoneyEsc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(recyclingMoney);
        make.left.equalTo(recyclingMoney.titleLabel.mas_right).offset(2.f);
    }];
    
    
    [recyclingBigMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.recyclingView);
        make.height.mas_equalTo(44.f);
    }];
    [recyclingBigMoneyEsc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(recyclingBigMoney);
        make.left.equalTo(recyclingBigMoney.titleLabel.mas_right).offset(2.f);
    }];
    
        
    [myRecyclingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.recyclingView);
        make.height.mas_equalTo(recyclingBigMoney);
    }];
    [myRecyclingButtonEsc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(myRecyclingButton);
        make.left.equalTo(myRecyclingButton.titleLabel.mas_right).offset(2.f);
    }];
    
}

#pragma -mark private method

- (void)recyclingMoneyAction:(UIButton *)btn {
    
    NSDictionary *par1 = @{
        @"section_type":@"general",
        @"section_name":@"coin",
        @"page_position":@"communityModule"
    };
    
    [JHAllStatistics jh_allStatisticsWithEventId:@"clickCoinRecycle"
                                          params:par1
                                            type:JHStatisticsTypeSensors];
    // 回收发布界面
    if (![JHRootController isLogin]) {
        [JHRootController presentLoginVCWithTarget:[JHRootController currentViewController] complete:^(BOOL result) { }];
    }else{
        JHRecycleUploadTypeSeleteViewController *releaseVC = [[JHRecycleUploadTypeSeleteViewController alloc] init];
        [JHRootController.currentViewController.navigationController pushViewController:releaseVC animated:YES];
    }
}

- (void)recyclingBigMoneyAction:(UIButton *)btn {
    NSDictionary *par1 = @{
        @"section_type":@"large",
        @"section_name":@"coin",
        @"section_id":NONNULL_STR(self.plateId),
        @"page_position":@"communityModule"
    };
    
    [JHAllStatistics jh_allStatisticsWithEventId:@"clickCoinRecycle"
                                          params:par1
                                            type:JHStatisticsTypeSensors];
    // 大宗钱币回收
    CommAlertView *alert = [[CommAlertView alloc] initWithTitle:@"收大宗钱币" andDesc:@"联系平台客服，为您提供大宗钱币（20个钱币以上）回收专属服务。" cancleBtnTitle:@"联系客服"];
            [alert addCloseBtn];
            [alert addBackGroundTap];
            [alert setDescTextAlignment:NSTextAlignmentCenter];
            [[UIApplication sharedApplication].keyWindow addSubview:alert];
            alert.cancleHandle = ^{
                [[JHQYChatManage shareInstance] showChatWithViewcontroller:[JHRootController currentViewController]];
            };
}

- (void)myRecyclingAction:(UIButton *)btn {
    NSDictionary *par1 = @{
        @"section_id":NONNULL_STR(self.plateId),
        @"section_name":@"coin",
        @"page_position":@"communityModule"
    };
    
    [JHAllStatistics jh_allStatisticsWithEventId:@"clickToBeRecycler"
                                          params:par1
                                            type:JHStatisticsTypeSensors];
    /// 已开通店铺的去回收广场
    User *user = [UserInfoRequestManager sharedInstance].user;
    if ([JHRootController isLogin] && user.blRole_recycleBusiness ) {
        JHRecycleSquareHomeViewController *vc = [[JHRecycleSquareHomeViewController alloc] init];
        [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
    } else {
        [JHRouterManager pushWebViewWithUrl:H5_BASE_STRING(@"/jianhuo/app/recycle/applyOpenShop.html") title:@"" controller:JHRootController];
    }
}

#pragma mark -------- JHDetailCollectionDelegate --------
///话题点击
- (void)clickCollectionItem:(JHCollectionItemModel *)item
{
    if(item && item.itemId)
    {
        ///340埋点 - 点击板块关联话题
        NSDictionary *params = @{@"topic_name":item.title,
                                 @"plate_id":self.model.ID,
                                 @"page_from":self.pageFrom
        };
        [JHGrowingIO trackEventId:JHTrackSQPlateTopicEnter variables:params];
        
        [JHRouterManager pushTopicDetailWithTopicId:item.itemId pageType:JHPageTypeSQPlateList];
    }
}

- (void)setModel:(JHPlateDetailModel *)model
{
    _model = model;
    if(model)
    {
        [_plateImageView jh_setImageWithUrl:_model.bg_image];
        _plateNameLabel.text = _model.name;
        _plateDescLabel.text = [NSString stringWithFormat:@"%@阅读·%@评论·%@篇内容",_model.scan_num, _model.comment_num, _model.content_num];
        _focusButton.selected = _model.is_follow;

        for (int i = 0; i < MIN(_model.owners.count, 3); i++) {
            JHPublisher *o = _model.owners[i];
            UIImageView *avatarView = [UIImageView jh_imageViewAddToSuperview:self.plateOwnerView];
            [avatarView jh_cornerRadius:10];
            [avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.plateOwnerView).offset(15 * i);
                make.centerY.equalTo(self.plateOwnerView);
                make.size.mas_equalTo(CGSizeMake(20, 20));
            }];
            [avatarView jh_setAvatorWithUrl:o.avatar];
        }
        @weakify(self);
        
        UIView *bottomView = self.plateImageView;

        if ([_model.ID isEqualToString:@"82"] &&
            [_model.name isEqualToString:@"钱币"]) {
            [self addRecyclingSubView];
            bottomView = self.recyclingView;
        }else {
            self.recyclingView.hidden = YES;
            [self.recyclingView removeFromSuperview];
        }
        
        if(IS_STRING(_model.desc) && _model.desc.length > 0)
        {
            _briefLabel = [UILabel jh_viewWithColor:UIColor.whiteColor addToSuperview:self];
            _briefLabel.numberOfLines = 2;
            [_briefLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(15);
                make.right.equalTo(self).offset(-30);
                make.top.equalTo(bottomView.mas_bottom);
                make.height.mas_equalTo(62);
            }];
            [_briefLabel jh_addTapGesture:^{
                @strongify(self);
                if(self.briefBlock)
                {
                    self.briefBlock(NO);
                }
            }];
            UIImageView *pushView = [UIImageView jh_imageViewWithImage:JHImageNamed(@"publish_tips_push") addToSuperview:self];
            [pushView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.mas_right).offset(-15);
                make.size.mas_equalTo(CGSizeMake(8, 8));
                make.centerY.equalTo(self.briefLabel);
            }];
            [[UIView jh_viewWithColor:APP_BACKGROUND_COLOR addToSuperview:self] mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self);
                make.height.mas_equalTo(1);
                make.bottom.equalTo(self.briefLabel);
            }];
            
            _briefLabel.attributedText = [self showAttributedString];
            bottomView = _briefLabel;
        }
        
        if(self.model.topic_list > 0)
        {
            UILabel *tipLabel = [UILabel jh_labelWithBoldText:@"关联话题" font:14 textColor:RGB515151 textAlignment:0 addToSuperView:self];
            [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(15);
                make.height.mas_equalTo(44);
                make.top.equalTo(bottomView.mas_bottom);
            }];
            
            //区分collection样式
            JHCollectionView *collectionView = [[JHCollectionView alloc] initWithFrame:CGRectZero type:JHDetailCollectionCellTypeImageTextScroll];
            collectionView.delegate = self;
            [collectionView makeLayout:CGSizeMake(67, 24) lineSpace:10 itemSpace:10];
            [self addSubview:collectionView];
            _collectionView = collectionView;
            [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(tipLabel.mas_right).offset(10);
                make.centerY.height.equalTo(tipLabel);
                make.right.equalTo(self);
            }];
            
            [[UIView jh_viewWithColor:APP_BACKGROUND_COLOR addToSuperview:self] mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self);
                make.height.mas_equalTo(1);
                make.bottom.equalTo(tipLabel);
            }];
            
            NSMutableArray *array = [NSMutableArray new];
            for (JHTopicInfo *m in _model.topic_list) {
                JHCollectionItemModel *o = [JHCollectionItemModel new];
                o.itemId = m.ID;
                o.title = m.name;
                [array addObject:o];
            }
            [self.collectionView updateData:array];
            
            bottomView = tipLabel;
        }
        
        for (int i = 0; i < MIN(_model.sign_list.count, kPostMaxofLines); i++) {
            UIView *listView = [self creatViewWithPostData:_model.sign_list[i]];
            [listView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self);
                make.height.mas_equalTo(kPostHeight);
                make.top.equalTo(bottomView.mas_bottom).offset(i * kPostHeight);
            }];
        }
    }
}

- (NSMutableAttributedString *)showAttributedString
{
    NSString *string = [NSString stringWithFormat:@"版块简介：%@", _model.desc];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string attributes: @{NSFontAttributeName:JHFont(14),NSForegroundColorAttributeName:RGB(102,102,102)}];
    [attributedString addAttributes:@{NSFontAttributeName: JHBoldFont(14), NSForegroundColorAttributeName:UIColor.blackColor} range:NSMakeRange(0,5)];
   return attributedString;
    
}
- (void)updateImageHeight:(float)height
{
    if(height >= 0)
    {
        [_plateImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo([JHPlateDetailHeaderView imageViewHeight] + height);
        }];
    }
}

- (void)focusMethod:(UIButton *)sender
{
    if(IS_LOGIN)
    {
        JHPlateDetailFocusReqModel *req = [JHPlateDetailFocusReqModel new];
        if(self.model.ID)
        {
            req.channel_id = self.model.ID.integerValue;
        }
        [JHTracking trackEvent:@"sectionOperate" property:@{@"section_id":self.model.ID,@"section_name":self.model.name,@"operation_type":(self.model.is_follow?@"取消关注":@"关注")}];
        if(self.model.is_follow)
        {
            [req setRequestPath:@"/auth/channel/followCancel"];
        }
        else
        {
            [req setRequestPath:@"/auth/channel/follow"];
        }
        
        [JH_REQUEST asynPost:req success:^(id respData) {
            self.model.is_follow = !self.model.is_follow;
            self.focusButton.selected = self.model.is_follow;
        } failure:^(NSString *errorMsg) {
            [SVProgressHUD showErrorWithStatus:errorMsg];
        }];
    }
}

+ (CGFloat)imageViewHeight
{
    return kPlateHeaderHeight;
}

- (CGFloat)headerViewHeight {
    
    CGFloat headerHeight = kPlateHeaderHeight;

    if(IS_STRING(self.model.desc) && self.model.desc.length > 0)
    {
        headerHeight += kBriefLabelHeight;
    }
    
    if(self.model.topic_list > 0)
    {
        headerHeight += kPostHeight;
    }
    
    headerHeight += MIN(_model.sign_list.count, 2) * kPostHeight;
    
    headerHeight += 9;
    [self layoutIfNeeded];
    return headerHeight + self.recyclingView.height;
}

- (void)showLoading
{
    if(!_pullLoadingView)
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"pull_loading" ofType:@"webp"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        UIImage *webpImage = [UIImage sd_imageWithWebPData:data];
        _pullLoadingView = [UIImageView jh_imageViewWithImage:webpImage addToSuperview:_plateImageView];
        [_pullLoadingView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.plateImageView);
            make.size.mas_equalTo(CGSizeMake(25, 25));
        }];
    }
}

-(void)dismissLoading
{
    self.isRequestLoading = NO;
    if(_pullLoadingView)
    {
        [_pullLoadingView removeFromSuperview];
        _pullLoadingView = nil;
    }
}

///创建置顶，公告帖子
- (UIView *)creatViewWithPostData:(JHPostData *)sender
{
    UIView *view = [UIView jh_viewWithColor:UIColor.whiteColor addToSuperview:self];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.mas_equalTo(45.f);
    }];
    @weakify(sender);
    @weakify(self);
    [view jh_addTapGesture:^{
        @strongify(sender);
        @strongify(self);
        ///340埋点 - 点击版块公告 置顶： 2 置顶 1 公告
        NSString *key = sender.content_style == 2 ? JHTrackSQPlateTopClick : JHTrackSQPlateNoticeClick;
        [JHGrowingIO trackEventId:key variables:@{@"plate_id":self.model.ID,
                                                  @"page_from":self.pageFrom}];
        [JHRouterManager pushPostDetailWithItemType:sender.item_type itemId:sender.item_id pageFrom:JHFromSQPlateDetail scrollComment:0];
    }];
    
    ///2置顶 3公告
    NSString *tip = sender.content_style == 2 ? @"置顶" : @"公告";
    UIColor *color = sender.content_style == 2 ? RGB(250, 85, 85) : RGB(64, 143, 254);
    NSString *content = @"";
    if(sender.title && sender.title.length > 0)
    {
        content = sender.title;
    }
    else
    {
        content = sender.content;
    }
    UILabel *label = [UILabel jh_labelWithText:tip font:9 textColor:UIColor.whiteColor textAlignment:1 addToSuperView:view];
    label.backgroundColor = color;
    [label jh_cornerRadius:4];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(15);
        make.size.mas_equalTo(CGSizeMake(24, 16));
        make.centerY.equalTo(view);
    }];
    
    UILabel *textLabel = [UILabel jh_labelWithText:content font:14 textColor:RGB515151 textAlignment:0 addToSuperView:view];
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label.mas_right).offset(10);
        make.right.equalTo(view).offset(-15);
        make.centerY.equalTo(view);
    }];
    
    [[UIView jh_viewWithColor:APP_BACKGROUND_COLOR addToSuperview:self] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view);
        make.left.equalTo(view).offset(54);
        make.height.mas_equalTo(1);
        make.bottom.equalTo(view);
    }];
    
    return view;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
