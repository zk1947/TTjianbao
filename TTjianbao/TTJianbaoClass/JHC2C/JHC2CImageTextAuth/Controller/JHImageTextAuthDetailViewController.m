//
//  JHImageTextAuthDetailViewController.m
//  TTjianbao
//
//  Created by zk on 2021/6/15.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHImageTextAuthDetailViewController.h"
#import "JHImageTextAuthDetailTextCell.h"
#import "JHImageTextAuthDetailImageCell.h"
#import "JHImageTextAuthDetailVideoCell.h"
#import "NSString+UISize.h"
#import "JHImageTextWaitAuthBusiness.h"
#import "JHPlayerViewController.h"
#import "JHBeginIdentifyViewController.h"
#import "JHPhotoBrowserManager.h"
#import "CommAlertView.h"

@interface JHImageTextAuthDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

/** 数据源 */
@property (nonatomic, strong) JHImageTextWaitAuthDetailModel  *dataSourceModel;

@property (nonatomic, strong) UIView *submitView;

@property (nonatomic, strong) JHPlayerViewController  *playerController;

@property (nonatomic, strong) JHImageTextAuthDetailVideoCell *currentCell;

@property (nonatomic, strong) CommAlertView *jumpAlert;

@end

@implementation JHImageTextAuthDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupView];
    [self.tableView.mj_header beginRefreshing];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        NSMutableArray *mediumurls = [[NSMutableArray alloc] init];
        NSMutableArray *largeurls = [[NSMutableArray alloc] init];
        
        for (JHImageTextWaitAuthDetailImageModel *model in self.dataSourceModel.images) {
            [mediumurls appendObject:model.medium];
            [largeurls appendObject:model.big];
        }
        
        [JHPhotoBrowserManager showPhotoBrowserThumbImages:mediumurls
                                              mediumImages:mediumurls
                                                origImages:largeurls
                                                   sources:@[[UIImageView new]]
                                              currentIndex:indexPath.row
                                       canPreviewOrigImage:true
                                                 showStyle:GKPhotoBrowserShowStyleZoom];
    }
}
- (void)loadDetailData{
    @weakify(self);
    [JHImageTextWaitAuthBusiness getImageTextAuthDetailData:self.recordInfoId Completion:^(NSError * _Nullable error, JHImageTextWaitAuthDetailModel * _Nullable model) {
        @strongify(self);
        [self endRefresh];
        self.dataSourceModel = model;
        [self.tableView reloadData];
    }];
}

- (void)endRefresh {
    [self.tableView.mj_header endRefreshing];
}

- (void)setupView{
    //导航配置
    self.jhTitleLabel.text = @"鉴定详情";
    self.jhNavView.backgroundColor = [UIColor clearColor];
    [self.view layoutIfNeeded];
    //列表
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(self.jhNavView.bottom, 0, 68 + UI.bottomSafeAreaHeight, 0));
    }];
    @weakify(self);
    self.tableView.mj_header = [JHRefreshGifHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self loadDetailData];
    }];
    //提交按钮
    [self.view addSubview:self.submitView];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView                               = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource                     = self;
        _tableView.delegate                       = self;
        _tableView.backgroundColor                 = [UIColor clearColor];
        _tableView.separatorStyle                  = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator   = NO;
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedSectionHeaderHeight   = 0.1f;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets   = NO;
        }
        
        [_tableView registerClass:[JHImageTextAuthDetailTextCell class] forCellReuseIdentifier:NSStringFromClass([JHImageTextAuthDetailTextCell class])];
        [_tableView registerClass:[JHImageTextAuthDetailImageCell class] forCellReuseIdentifier:NSStringFromClass([JHImageTextAuthDetailImageCell class])];
        [_tableView registerClass:[JHImageTextAuthDetailVideoCell class] forCellReuseIdentifier:NSStringFromClass([JHImageTextAuthDetailVideoCell class])];
        
        if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
        }
        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_tableView setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 0)];
        }
    }
    return _tableView;
}

#pragma mark - Delegate DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:return self.dataSourceModel ? 1 : 0;
            break;
        case 1:return self.dataSourceModel.images.count;
            break;
        case 2:return self.dataSourceModel.videos.count;
            break;
        default:return 0;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:return self.dataSourceModel.cellHeight;
            break;
        case 1:{
            JHImageTextWaitAuthDetailImageModel *model = self.dataSourceModel.images[indexPath.row];
            return model.cellHeight;
        }
            break;
        case 2:{
            JHImageTextWaitAuthDetailVideoModel *model = self.dataSourceModel.videos[indexPath.row];
            return model.cellHeight;
        };
            break;
        default:return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:{
            JHImageTextAuthDetailTextCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHImageTextAuthDetailTextCell class])];
            if (!cell) {
                cell = [[JHImageTextAuthDetailTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JHImageTextAuthDetailTextCell class])];
            }
            cell.model = self.dataSourceModel;
            return cell;
        }
            break;
        case 1:{
            JHImageTextAuthDetailImageCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHImageTextAuthDetailImageCell class])];
            if (!cell) {
                cell = [[JHImageTextAuthDetailImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JHImageTextAuthDetailImageCell class])];
            }
            cell.model = self.dataSourceModel.images[indexPath.row];
            return cell;
        };
            break;
        case 2:{
            JHImageTextAuthDetailVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHImageTextAuthDetailVideoCell class])];
            if (!cell) {
                cell = [[JHImageTextAuthDetailVideoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JHImageTextAuthDetailVideoCell class])];
            }
            cell.model = self.dataSourceModel.videos[indexPath.row];
            cell.delegateSignal = [RACSubject subject];
            @weakify(self);
            [cell.delegateSignal subscribeNext:^(id x) {
                @strongify(self);
                JHImageTextWaitAuthDetailVideoModel *model = (JHImageTextWaitAuthDetailVideoModel *)x;
                // 播放视频
                [self toPlayVideo:cell model:model];
            }];
            return cell;
        };
            break;
        default:return [UITableViewCell new];
            break;
    }
}

- (UIView *)submitView{
    if (!_submitView) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight-68-UI.bottomSafeAreaHeight, kScreenWidth, 68+UI.bottomSafeAreaHeight)];
        view.backgroundColor = kColorFFF;
        _submitView = view;
        
        //跳过
        UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        leftBtn.frame = CGRectMake(12, 9, 100, 50);
        leftBtn.backgroundColor = kColorFFF;
        [leftBtn setTitle:@"跳过" forState:UIControlStateNormal];
        [leftBtn setTitleColor:kColor333 forState:UIControlStateNormal];
        leftBtn.titleLabel.font = JHMediumFont(16);
        leftBtn.layer.borderColor = HEXCOLOR(0xBDBFC2).CGColor;
        leftBtn.layer.borderWidth = 0.5;
        [leftBtn addTarget:self action:@selector(jumpBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [leftBtn jh_cornerRadius:5];
        [_submitView addSubview:leftBtn];
        
        //鉴定
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(125, 9, kScreenWidth-145, 50);
        [self addGradualColor:btn];
        
        if (self.isFromIdentify) {
            [btn setTitle:@"继续鉴定" forState:UIControlStateNormal];
        }else {
            [btn setTitle:@"开始鉴定" forState:UIControlStateNormal];
        }
        
        [btn setTitleColor:kColor222 forState:UIControlStateNormal];
        btn.titleLabel.font = JHMediumFont(16);
        [btn jh_cornerRadius:5];
        [btn addTarget:self action:@selector(submitBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_submitView addSubview:btn];
    }
    return _submitView;
}

#pragma mark - 跳过
- (void)jumpBtnAction:(UIButton *)btn{
    [self.jumpAlert show];
}

- (CommAlertView *)jumpAlert{
    if (!_jumpAlert) {
        CommAlertView *alert = [[CommAlertView alloc]initWithTitle:@"提示" andDesc:@"确认跳过该鉴定单吗？跳过后该鉴定单将会优先派给其他鉴定师" cancleBtnTitle:@"取消" sureBtnTitle:@"确定"];
        @weakify(self);
        alert.handle = ^{
            @strongify(self);
            [self cancleAuthLoad];
        };
        _jumpAlert = alert;
    }
    return _jumpAlert;
}

- (void)cancleAuthLoad{
    //跳过鉴定接口
    @weakify(self);
    [JHImageTextWaitAuthBusiness jumpAuthStep:self.taskId completion:^(BOOL isSuccess) {
        @strongify(self);
        if (isSuccess) {
            [self.view makeToast:@"操作成功！" duration:1.0 position:CSToastPositionCenter];
            [self performSelector:@selector(popPage) afterDelay:1.0];
        }
    }];
}

- (void)popPage{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 开始鉴定
- (void)submitBtnAction:(UIButton *)btn{
    
    if (self.isFromIdentify) {
        [self.navigationController popViewControllerAnimated:true];
        return;
    }
    
    JHBeginIdentifyViewController *vc = [JHBeginIdentifyViewController new];
    vc.taskId = [NSString stringWithFormat:@"%d",self.taskId];
    vc.recordInfoId = [NSString stringWithFormat:@"%d",self.recordInfoId];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self toStopPlay];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self toStopPlay];
}

// 播放事件
- (void)toPlayVideo:(JHImageTextAuthDetailVideoCell *)cell model:(JHImageTextWaitAuthDetailVideoModel *)model{
    CGRect rect = [cell convertRect:cell.bounds toView:[UIApplication sharedApplication].keyWindow];
    CGRect collectionRect = [self.tableView convertRect:self.tableView.bounds toView:[UIApplication sharedApplication].keyWindow];
    //只要cell在视图里面显示超过一半就给展示视频 && 视频类型 && 有视频链接
    if (rect.origin.y>=collectionRect.origin.y &&rect.origin.y+rect.size.height<=ScreenH-UI.bottomSafeAreaHeight-49 && model.url.length > 0) {
        self.currentCell = cell;
        /** 添加视频*/
        self.playerController.view.frame = cell.contentView.bounds;
        [self.playerController setSubviewsFrame];
        [cell.contentView addSubview:self.playerController.view];
        self.playerController.urlString = model.url;
        return;
    }
    //没有满足条件的 释放视频
    [self.playerController stop];
    [self.playerController.view removeFromSuperview];
}

//停止播放
- (void)toStopPlay{
    if (!self.currentCell) {
        return;
    }
    CGRect rect = [self.currentCell convertRect:self.currentCell.bounds toView:[UIApplication sharedApplication].keyWindow];
    CGRect collectionRect = [self.tableView convertRect:self.tableView.bounds toView:[UIApplication sharedApplication].keyWindow];
    //只要cell在视图里面显示超过一半就给展示视频 && 视频类型 && 有视频链接
    if (rect.origin.y>=collectionRect.origin.y &&rect.origin.y+rect.size.height<=ScreenH-UI.bottomSafeAreaHeight-49 && self.currentCell.model.url.length > 0) {
        
    }else{
        [self.playerController stop];
        [self.playerController.view removeFromSuperview];
    }
}

- (JHPlayerViewController *)playerController {
    if (_playerController == nil) {
        _playerController = [[JHPlayerViewController alloc] init];
        _playerController.muted = YES;
        _playerController.looping = YES;
        _playerController.hidePlayButton = YES;
        [self addChildViewController:_playerController];
    }
    return _playerController;
}

- (void)addGradualColor:(UIView *)view{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)HEXCOLOR(0xFED73A).CGColor, (__bridge id)HEXCOLOR(0xFECB33).CGColor];
    gradientLayer.locations = @[@0.0, @1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1.0);
    gradientLayer.frame = view.bounds;
    [view.layer addSublayer:gradientLayer];
}

- (void)setIsFromIdentify:(BOOL)isFromIdentify {
    _isFromIdentify = isFromIdentify;
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
