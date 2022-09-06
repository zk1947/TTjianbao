//
//  JHRecycleDetailViewController.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/16.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleDetailViewController.h"
#import "JHRecycleDetailBaseTableViewCell.h"
#import "JHRecycleTypeInfoTableViewCell.h"
#import "JHRecycleDesInfoTableViewCell.h"
#import "JHRecycleImageInfoTableViewCell.h"
#import "JHRecycleVideoInfoTableViewCell.h"
#import "CommAlertView.h"
#import "UIButton+ImageTitleSpacing.h"
#import "JHRecyclePublishButtonView.h"
#import "JHRecycleDetailViewModel.h"
#import "JHPlayerViewController.h"
#import "JHNormalControlView.h"
#import "JHRecycleDetailItemViewModel.h"
#import "JHRecyclePublishedModel.h"
#import "UIImage+JHColor.h"
#import <IQKeyboardManager.h>
#import "JHRecycleBidPopView.h"
#import "JHChatViewController.h"
#import "TTjianbao.h"
#import "JHRecycleDetailNoticeManager.h"
#import "JHReLayoutButton.h"
#import "JHPhotoBrowserManager.h"


@interface JHRecycleDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) CGFloat footerHeight;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) JHReLayoutButton *collectBtn;//收藏
@property (nonatomic, strong) JHReLayoutButton *chatButton;//收藏
@property (nonatomic, strong) UIButton *bidBtn;//出价
@property (nonatomic, strong) UIView *chatNoticeView; /// 聊天提示
@property (nonatomic, strong) JHRecyclePublishButtonView *buttonsView;
@property (nonatomic, strong) JHRecycleDetailViewModel *detailViewModel;
@property (nonatomic, strong) JHPlayerViewController *playerController;
@property (nonatomic, strong) JHNormalControlView *normalPlayerControlView;
@property (nonatomic, strong) JHRecycleVideoInfoTableViewCell *currentCell;/** 当前播放视频的cell*/
@end

@implementation JHRecycleDetailViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[JHRecycleDetailNoticeManager shared] loadRecycleDetailNotice];    
    self.title = @"回收详情";
    
    self.footerHeight = 44;
    if (self.identityType == 1) {//商家
        self.footerHeight = 60;
    }
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(UI.statusAndNavBarHeight, 0, self.footerHeight+UI.bottomSafeAreaHeight, 0));
    }];
    
    [self setupFooterView];
    
    [self loadData];
    
    [self configData];
}

#pragma mark - UI
- (void)setupFooterView{
    self.footerView = [UIView jh_viewWithColor:UIColor.whiteColor addToSuperview:self.view];
    [self.footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.bottom.equalTo(self.view);
        make.height.mas_equalTo(self.footerHeight + UI.bottomSafeAreaHeight);
    }];
    
    if (![JHRecycleDetailNoticeManager shared].hasNoticed) {
        self.chatNoticeView = [[UIView alloc] init];
        self.chatNoticeView.backgroundColor = HEXCOLOR(0xFFFAF2);
        [self.view addSubview:self.chatNoticeView];
        [self.chatNoticeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.footerView.mas_top);
            make.left.right.equalTo(self.view);
            make.height.mas_equalTo(29.f);
        }];
        
        UILabel *noticeLabel  = [[UILabel alloc] init];
        noticeLabel.textColor = HEXCOLOR(0xFF6A00);
        noticeLabel.font      = [UIFont fontWithName:kFontNormal size:12.f];
        noticeLabel.text      = @"出价需谨慎，先和卖家聊一聊，出价更准确";
        [self.chatNoticeView addSubview:noticeLabel];
        [noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.chatNoticeView);
        }];
        
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeBtn setImage:[UIImage imageNamed:@"recycle_detail_noticeClose"] forState:UIControlStateNormal];
        [self.chatNoticeView addSubview:closeBtn];
        [closeBtn addTarget:self action:@selector(closeBtnCloseAction:) forControlEvents:UIControlEventTouchUpInside];
        [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.chatNoticeView.mas_centerY);
            make.right.equalTo(self.chatNoticeView.mas_right).offset(-14.f);
            make.width.mas_equalTo(10.f);
            make.height.mas_equalTo(9.f);
        }];
        [[JHRecycleDetailNoticeManager shared] saveRecycleDetailNotice:YES];
    }
}

- (void)closeBtnCloseAction:(UIButton *)btn {
    [self.chatNoticeView removeFromSuperview];
    self.chatNoticeView = nil;
    [[JHRecycleDetailNoticeManager shared] saveRecycleDetailNotice:YES];
}


///用户
- (void)userTypeView{
    [self.footerView addSubview:self.buttonsView];
    [self.buttonsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.footerView).offset(7);
        make.right.mas_equalTo(self.footerView).offset(-14);
        make.left.mas_equalTo(self.footerView).offset(14);
        make.height.mas_equalTo(30);
    }];
    
    
}
///商家
- (void)businessTypeView{
    //收藏按钮
    [self.footerView addSubview:self.collectBtn];
    [self.collectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.footerView).offset(8);
        make.centerY.equalTo(self.footerView).offset(-UI.bottomSafeAreaHeight/2);
        make.size.mas_equalTo(CGSizeMake(58, 39));
    }];
    
    /// 联系卖家
    [self.footerView addSubview:self.chatButton];
    [self.chatButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.collectBtn.mas_right).offset(15);
        make.centerY.equalTo(self.collectBtn);
        make.size.mas_equalTo(CGSizeMake(64, 39));
    }];
    
    
    //出价按钮
    [self.footerView addSubview:self.bidBtn];
    [self.bidBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.chatButton.mas_right).offset(11.f);
        make.right.equalTo(self.footerView).offset(-12);
        make.height.mas_equalTo(40.f);
        make.centerY.equalTo(self.collectBtn);
    }];
    
}


#pragma mark - Action
///收藏
- (void)clickCollectBtnAction:(UIButton *)sender{
    NSMutableDictionary *dicData = [NSMutableDictionary dictionary];
    if (sender.selected) {//取消收藏
        dicData[@"collectionStatus"] = @0;
        dicData[@"productIds"] = @[@([self.productId integerValue])];//商品ID
    }else{//收藏
        dicData[@"collectionStatus"] = @1;
        dicData[@"productId"] = @([self.productId integerValue]);//商品ID
    }
    [self.detailViewModel.collectionProductCommand execute:dicData];
}

- (void)clickChatBtnAction:(UIButton *)sender {
    if (IS_LOGIN) {
        JHChatViewController *vc = [[JHChatViewController alloc] init];
        vc.userId = self.detailViewModel.recycleDetailModel.launchCustomerId;
        vc.name = self.detailViewModel.recycleDetailModel.customerName;
        vc.pageType = @"recycle_community";
        [self.navigationController pushViewController:vc animated:YES];
    }
}


///出价
- (void)clickBidBtnAction:(UIButton *)sender{
    JHRecycleBidPopView *alert = [[JHRecycleBidPopView alloc] initWithTitle:@"" andDesc:@"" cancleBtnTitle:@"确定"];
    alert.isReturn = YES;
    [alert displayTextFiledWithPlaceHoldStr:@"请输入您的出价金额，单位元"];
    alert.tfKeyboardType = UIKeyboardTypeDecimalPad;
    [alert addCloseBtn];
    [alert addBackGroundTap];
    [alert show];
    @weakify(self)
    @weakify(alert)
    [alert setCancleHandle:^{
        @strongify(self)
        @strongify(alert)
        if ([alert getTextFiledText].length > 0) {
            NSMutableDictionary *dicData = [NSMutableDictionary dictionary];
            dicData[@"bigPriceYuan"] = [alert getTextFiledText];//出价金额 单位为元
            dicData[@"productId"] = @([self.productId integerValue]);//商品ID
            [self.detailViewModel.goBidCommand execute:dicData];
        }else{
            JHTOAST(@"请输入您的出价金额");
        }
        
    }];

}

#pragma mark - LoadData
- (void)loadData{
    NSMutableDictionary *dicData = [NSMutableDictionary dictionary];
    dicData[@"imageType"] = @"s,m,b,o";//s 缩略图，m 小图，b 大图，o 原图
    dicData[@"productId"] = @([self.productId integerValue]);//商品ID
    [self.detailViewModel.recycleDetailCommand execute:dicData];
}

- (void)configData{
    @weakify(self);
    //详情列表
    [[RACObserve(self.detailViewModel, dataSourceArray) skip:1] subscribeNext:^(id _Nullable x) {
        @strongify(self)
        //商品状态：0 上架 1 下架 2 交易中 3 交易关闭 4 交易成功 5 平台拒绝（审核不通过或者禁售）
        NSInteger productStatus =  self.detailViewModel.recycleDetailModel.productStatus;
        int status = -1;
        if (productStatus == 0 && !self.detailViewModel.recycleDetailModel.hasBid) { //上架 未出价
            status = PublishedStatusTypeNoPrice;
        }else if (productStatus == 0 && self.detailViewModel.recycleDetailModel.hasBid){//上架 已出价
            status = PublishedStatusTypeHavePrice;
        }else if (productStatus == 1 ){//下架
            status = PublishedStatusTypeFailure;
        }else if (productStatus == 5 ){//平台拒绝
            status = PublishedStatusTypeRefused;
        }
        //按钮显示 0:商品下架  1:商品下架 查看报价  2:删除 重新上架  3:删除
        [self.buttonsView setStatusType:status fromIndex:1];
        
        [self.tableView reloadData];
        
        //商家
        if (self.identityType == 1) {
            //底部按钮View
            [self businessTypeView];
            
            //已收藏
            self.collectBtn.selected = self.detailViewModel.recycleDetailModel.isCollectedByBusinessId;
            if (self.collectBtn.selected) {
                [self.collectBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(58, 39));
                }];
            }else{
                [self.collectBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(58, 39));
                }];
            }
            //来源出价记录
            if ([self.fromSource isEqualToString:@"JHRecyclePriceHistoryListController"]) {
                self.bidBtn.selected = YES;
                self.bidBtn.userInteractionEnabled = NO;
                [self.bidBtn setTitle:@"已出价" forState:UIControlStateNormal];
            }else{
                //已出价
                if (self.detailViewModel.recycleDetailModel.currentBusinessHasBid) {
                        [self.bidBtn setTitle:@"已出价" forState:UIControlStateNormal];
                        self.bidBtn.selected = self.detailViewModel.recycleDetailModel.currentBusinessHasBid;
                        self.bidBtn.userInteractionEnabled = !self.detailViewModel.recycleDetailModel.currentBusinessHasBid;
                }else{
                    if (productStatus != 0) {
                        self.bidBtn.selected = YES;
                        self.bidBtn.userInteractionEnabled = NO;
                    }
                }
            }
            
        }else{
            //底部按钮View
            [self userTypeView];
        }
        
    }];
    
    
    //*****商户******
    //收藏
    [self.detailViewModel.collectionSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if (self.collectBtn.selected) {
            self.collectBtn.selected = NO;
            JHTOAST(@"已取消收藏");
            [self.collectBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(58, 39));
            }];
        }else{
            self.collectBtn.selected = YES;
            JHTOAST(@"收藏成功");
            [self.collectBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(58, 39));
            }];
        }
    }];
    //出价
    [self.detailViewModel.goBidSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        JHTOAST(@"出价成功！您可在出价记录页面查看出价记录");
        [self.navigationController popViewControllerAnimated:YES];
    }];
    

}


#pragma mark - Delegate
#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.detailViewModel.dataSourceArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([NSArray has:self.detailViewModel.dataSourceArray[section]]) {
        NSArray *arr = [NSArray cast:self.detailViewModel.dataSourceArray[section]];
        return arr.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.detailViewModel.sectionHeaderArray[indexPath.section] isEqualToString:@"宝贝信息"]) {
        JHRecycleDetailItemViewModel *itemViewModel = self.detailViewModel.dataSourceArray[indexPath.section][indexPath.row];
        return itemViewModel.cellHeight;
    }else{
        return UITableViewAutomaticDimension;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JHRecycleDetailItemViewModel *itemViewModel = self.detailViewModel.dataSourceArray[indexPath.section][indexPath.row];
    JHRecycleDetailBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:itemViewModel.cellIdentifier];
    [cell bindViewModel:itemViewModel.dataModel];
    
    //播放视频
    if([cell isKindOfClass:[JHRecycleVideoInfoTableViewCell class]]) {
        JHRecycleVideoInfoTableViewCell *videoInfoCell = (JHRecycleVideoInfoTableViewCell *)cell;
        @weakify(self);
        videoInfoCell.playCallback = ^(JHRecycleVideoInfoTableViewCell * _Nonnull videoCell) {
            @strongify(self);
            self.currentCell = videoCell;
            [self addPlayerToCell];
        };
    }
    //浏览图片
    if ([cell isKindOfClass:[JHRecycleImageInfoTableViewCell class]]) {
        JHRecycleImageInfoTableViewCell *imageCell = (JHRecycleImageInfoTableViewCell *)cell;
        @weakify(self);
        imageCell.selectImageBlack = ^(JHRecycleImageInfoTableViewCell * _Nonnull imageCell) {
            @strongify(self);
            // 图片内容的下标
            NSInteger tureIndex  = 0;
            for (NSString *imageStr in self.detailViewModel.imageSourceArray) {
                JHRecycleDetailImageUrlModel *imgUrlModel = itemViewModel.dataModel;
                if ([imgUrlModel.origin isEqualToString:imageStr]) {
                    break;
                }
                tureIndex ++;
            }
            [JHPhotoBrowserManager showPhotoBrowserThumbImages:self.detailViewModel.imageSourceArray mediumImages:self.detailViewModel.imageSourceArray origImages:self.detailViewModel.imageSourceArray sources:nil currentIndex:tureIndex canPreviewOrigImage:YES showStyle:GKPhotoBrowserShowStyleNone hideDownload:YES];
            
        };

    }

    return cell;

}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = UIColor.whiteColor;
    
    UILabel *sectionTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 5, 60, 17)];
    sectionTitleLabel.textColor = HEXCOLOR(0x333333);
    sectionTitleLabel.font = [UIFont fontWithName:kFontMedium size:12];
    sectionTitleLabel.text = self.detailViewModel.sectionHeaderArray[section];
    [view addSubview:sectionTitleLabel];
    
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = [UIColor colorWithHexString:@"F5F5F8"];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if ([self.detailViewModel.sectionHeaderArray[section] length] > 0) {
        return 27;
    }else{
        return CGFLOAT_MIN;

    }
}

#pragma mark - Lazy
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor =  HEXCOLOR(0xF5F5F8);
        [self registerCell:_tableView];
        
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior =UIScrollViewContentInsetAdjustmentNever;
            _tableView.contentInset = UIEdgeInsetsMake(0,0,0,0);
            _tableView.scrollIndicatorInsets =_tableView.contentInset;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
        }
    }
    return  _tableView;
}

- (void)registerCell:(UITableView *)tableView{
    [tableView registerClass:[JHRecycleDetailBaseTableViewCell class] forCellReuseIdentifier:NSStringFromClass([JHRecycleDetailBaseTableViewCell class])];
    [tableView registerClass:[JHRecycleTypeInfoTableViewCell class] forCellReuseIdentifier:NSStringFromClass([JHRecycleTypeInfoTableViewCell class])];
    [tableView registerClass:[JHRecycleDesInfoTableViewCell class] forCellReuseIdentifier:NSStringFromClass([JHRecycleDesInfoTableViewCell class])];
    [tableView registerClass:[JHRecycleImageInfoTableViewCell class] forCellReuseIdentifier:NSStringFromClass([JHRecycleImageInfoTableViewCell class])];
    [tableView registerClass:[JHRecycleVideoInfoTableViewCell class] forCellReuseIdentifier:NSStringFromClass([JHRecycleVideoInfoTableViewCell class])];
}

- (JHRecyclePublishButtonView *)buttonsView {
    if (_buttonsView == nil) {
        _buttonsView = [[JHRecyclePublishButtonView alloc] init];
        _buttonsView.productId = self.productId;
        @weakify(self)
        _buttonsView.refreshUIBlock = ^{
            @strongify(self)
            [self loadData];
        };
    }
    return _buttonsView;
}
- (JHRecycleDetailViewModel *)detailViewModel{
    if (!_detailViewModel) {
        _detailViewModel = [[JHRecycleDetailViewModel alloc] init];
    }
    return _detailViewModel;;
}

- (JHReLayoutButton *)collectBtn {
    if (!_collectBtn) {
        _collectBtn = [JHReLayoutButton buttonWithType:UIButtonTypeCustom];
        [_collectBtn setTitle:@"先收藏" forState:UIControlStateNormal];
        [_collectBtn setTitle:@"取消收藏" forState:UIControlStateSelected];
        [_collectBtn setTitleColor:HEXCOLOR(0x222222) forState:UIControlStateNormal];
        [_collectBtn setTitleColor:HEXCOLOR(0x222222) forState:UIControlStateSelected];
        _collectBtn.titleLabel.font = [UIFont fontWithName:kFontNormal size:12];
        _collectBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_collectBtn setImage:[UIImage imageNamed:@"recycle_icon_goods_detail_collect_normal"] forState:UIControlStateNormal];
        [_collectBtn setImage:[UIImage imageNamed:@"icon_goods_detail_collect_selected"] forState:UIControlStateSelected];
//        [_collectBtn setImageInsetStyle:MRImageInsetStyleTop spacing:15.f];

//        [_collectBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:20.f];
//        _collectBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
        
        _collectBtn.layoutType = RelayoutTypeUpDown;
        _collectBtn.margin = 5.f;
        _collectBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_collectBtn addTarget:self action:@selector(clickCollectBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _collectBtn;
}

- (JHReLayoutButton *)chatButton {
    if (!_chatButton) {
        _chatButton = [JHReLayoutButton buttonWithType:UIButtonTypeCustom];
        [_chatButton setTitle:@"联系卖家" forState:UIControlStateNormal];
        [_chatButton setTitleColor:HEXCOLOR(0x222222) forState:UIControlStateNormal];
        _chatButton.titleLabel.font = [UIFont fontWithName:kFontNormal size:12];
        _chatButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_chatButton setImage:[UIImage imageNamed:@"recycle_connenctBusiness"] forState:UIControlStateNormal];
        [_chatButton setImage:[UIImage imageNamed:@"recycle_connenctBusiness"] forState:UIControlStateSelected];
        [_chatButton setImageInsetStyle:MRImageInsetStyleTop spacing:15.f];
        _chatButton.layoutType = RelayoutTypeUpDown;
        _chatButton.margin = 5.f;

//        [_chatButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:20.f];
//        _chatButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
        _chatButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_chatButton addTarget:self action:@selector(clickChatBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _chatButton;
}


- (UIButton *)bidBtn {
    if (!_bidBtn) {
        _bidBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bidBtn setTitle:@"我要出价" forState:UIControlStateNormal];
        _bidBtn.titleLabel.font = [UIFont fontWithName:kFontNormal size:16];
        [_bidBtn setTitleColor:HEXCOLOR(0x222222) forState:UIControlStateNormal];
        [_bidBtn setTitleColor:HEXCOLOR(0x999999) forState:UIControlStateSelected];
        UIImage *normalImage = [UIImage createImageColor:HEXCOLOR(0xFFD70F) size:CGSizeMake(225, 45)];
        [_bidBtn setBackgroundImage:normalImage forState:UIControlStateNormal];
        UIImage *selectedImage = [UIImage createImageColor:HEXCOLOR(0xEEEEEE) size:CGSizeMake(225, 45)];
        [_bidBtn setBackgroundImage:selectedImage forState:UIControlStateSelected];
        [_bidBtn addTarget:self action:@selector(clickBidBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _bidBtn.layer.cornerRadius = 4.f;
        _bidBtn.layer.masksToBounds = YES;
    }
    return _bidBtn;
}

#pragma mark - 播放器相关
- (JHPlayerViewController *)playerController {
    if (_playerController == nil) {
        _playerController = [[JHPlayerViewController alloc] init];
        _playerController.muted = YES;
        _playerController.view.frame = CGRectMake(0, 0, ScreenW, ScreenW / 16. * 9.);
    }
    return _playerController;
}
- (JHNormalControlView *)normalPlayerControlView {
    if (_normalPlayerControlView == nil) {
        _normalPlayerControlView = [[JHNormalControlView alloc] initWithFrame:self.playerController.view.bounds];
        _normalPlayerControlView.playImage = JHImageNamed(@"recycle_video_icon");
    }
    return _normalPlayerControlView;
}

- (void)addPlayerToCell {
    self.playerController.view.frame = self.currentCell.videoView.bounds;
    [self.playerController setSubviewsFrame];
    [self.playerController setControlView:self.normalPlayerControlView];
    [self.currentCell.videoView addSubview: self.playerController.view];
    
    self.playerController.urlString = self.currentCell.videoUrl;
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self endScrollToPlayVideo];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self endScrollToPlayVideo];
}
// 触发自动播放事件
- (void)endScrollToPlayVideo {
    NSArray *visiableCells = [self.tableView visibleCells];
    if (![visiableCells containsObject:self.currentCell]) {
        if (self.playerController.isPLaying) {
            [self.playerController pause];
        }
    }
    //没有满足条件的 释放视频
}

@end
