//
//  JHHonnerCerDetailViewController.m
//  TTjianbao
//
//  Created by user on 2020/10/26.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHHonnerCerDetailViewController.h"
#import "JHHonnerCerDetailNavView.h"
#import "JHHonnerCerDetailImageViewTableViewCell.h"
#import "JHHonnerCerDetailTitleTableViewCell.h"
#import "JHHonnerCerDetailInfoTableViewCell.h"
#import "JHHonnerCerDetailPeopleTableViewCell.h"
#import "JHHonnerCerDetailTimeTableViewCell.h"
#import "JHHonnerCerDetailOrignTableViewCell.h"
#import "JHCustomerApiManager.h"
#import "JHBaseOperationView.h"

@interface JHHonnerCerDetailViewController () <
UITableViewDelegate,
UITableViewDataSource>
@property (nonatomic, strong) UITableView              *hcTabelView;
@property (nonatomic, strong) JHHonnerCerDetailNavView *navView;
@property (nonatomic, strong) NSMutableArray           *dataSourceArray;
@property (nonatomic, strong) UILabel                  *reviewStatusView;
@end

@implementation JHHonnerCerDetailViewController
- (void)dealloc {
    NSLog(@"%s",__func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HEXCOLOR(0xffffff);
    [self removeNavView];
    [self setupNav];
    [self setupViews];
    [self loadData];
}

- (CGFloat)navViewHeight {
    CGFloat navHeight = UI.statusBarHeight + 60.f;
    return navHeight;
}

- (void)setupNav {
    self.navView = [[JHHonnerCerDetailNavView alloc] init];
    self.navView.isAnchor = self.isAnchor;
    [self.view addSubview:self.navView];
    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo([self navViewHeight]);
    }];
    [self.navView reloadHCInfoName:@"荣誉证书"];
    @weakify(self);
    [self.navView honnerCerNavViewBtnAction:^(JHHonnerCerDetailButtonStyle style) {
        @strongify(self);
        switch (style) {
            case JHHonnerCerDetailButtonStyle_Back: {
                [self.navigationController popViewControllerAnimated:YES];
            }
                break;
            case JHHonnerCerDetailButtonStyle_Share: {
                NSLog(@"分享按钮点击事件");
                /// 分享
                JHShareInfo* info = [JHShareInfo new];
                info.title = self.shareData.title;
                info.desc  = self.shareData.desc;
                info.shareType = ShareObjectTypeCustomizeNormal;
                info.url = self.shareData.url;
                info.img = self.shareData.img;
                [JHBaseOperationView showShareView:info objectFlag:nil];
            }
                break;
            case JHHonnerCerDetailButtonStyle_Delete: {
                UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"" message:@"确认要删除么？" preferredStyle:UIAlertControllerStyleAlert];
                JH_WEAK(self)
                [alertVc addAction:[UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }]];
                [alertVc addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    JH_STRONG(self)
                    [self deleteCerById];
                }]];
                [self presentViewController:alertVc animated:YES completion:nil];
            }
                break;
            default:
                break;
        }
    }];
}

- (void)setupViews {
    [self.view addSubview:self.hcTabelView];
    [self.hcTabelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake([self navViewHeight], 0.f, 0.f, 0.f));
    }];
    
    _reviewStatusView               = [[UILabel alloc] init];
    _reviewStatusView.textColor     = HEXCOLOR(0xFF4200);
    _reviewStatusView.backgroundColor = HEXCOLOR(0xFFEDE7);
    _reviewStatusView.textAlignment = NSTextAlignmentCenter;
    _reviewStatusView.font          = [UIFont fontWithName:kFontNormal size:12.f];
    _reviewStatusView.hidden        = YES;
    [self.view addSubview:_reviewStatusView];
    [_reviewStatusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.navView.mas_bottom);
        make.height.mas_equalTo(26.f);
    }];
    
    if (self.infoModel.status == 2) {
        self.reviewStatusView.hidden = NO;
        if (isEmpty(self.infoModel.reason)) {
            self.reviewStatusView.text = @"审核未通过";
        } else {
            self.reviewStatusView.text = self.infoModel.reason;
        }
    } else {
        self.reviewStatusView.hidden = YES;
    }
}

- (UITableView *)hcTabelView {
    if (!_hcTabelView) {
        _hcTabelView                                = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _hcTabelView.dataSource                     = self;
        _hcTabelView.delegate                       = self;
        _hcTabelView.separatorColor                 = [UIColor clearColor];
        _hcTabelView.separatorStyle                 = UITableViewCellSeparatorStyleNone;
        _hcTabelView.estimatedRowHeight             = 10.f;
        if (@available(iOS 11.0, *)) {
            _hcTabelView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets   = NO;
        }

        [_hcTabelView registerClass:[JHHonnerCerDetailImageViewTableViewCell class] forCellReuseIdentifier:NSStringFromClass([JHHonnerCerDetailImageViewTableViewCell class])];
        [_hcTabelView registerClass:[JHHonnerCerDetailTitleTableViewCell class] forCellReuseIdentifier:NSStringFromClass([JHHonnerCerDetailTitleTableViewCell class])];
        [_hcTabelView registerClass:[JHHonnerCerDetailInfoTableViewCell class] forCellReuseIdentifier:NSStringFromClass([JHHonnerCerDetailInfoTableViewCell class])];
        [_hcTabelView registerClass:[JHHonnerCerDetailPeopleTableViewCell class] forCellReuseIdentifier:NSStringFromClass([JHHonnerCerDetailPeopleTableViewCell class])];
        [_hcTabelView registerClass:[JHHonnerCerDetailTimeTableViewCell class] forCellReuseIdentifier:NSStringFromClass([JHHonnerCerDetailTimeTableViewCell class])];
        [_hcTabelView registerClass:[JHHonnerCerDetailOrignTableViewCell class] forCellReuseIdentifier:NSStringFromClass([JHHonnerCerDetailOrignTableViewCell class])];

        if ([_hcTabelView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_hcTabelView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
        }
        if ([_hcTabelView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_hcTabelView setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 0)];
        }
    }
    return _hcTabelView;
}

- (NSMutableArray *)dataSourceArray {
    if (!_dataSourceArray) {
        _dataSourceArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSourceArray;
}

- (void)loadData {
    [self.dataSourceArray removeAllObjects];
    [self.dataSourceArray addObject:self.infoModel.img];
    [self.dataSourceArray addObject:self.infoModel.name];
    [self.dataSourceArray addObject:self.infoModel.awards];
    [self.dataSourceArray addObject:self.infoModel.holder];
    [self.dataSourceArray addObject:self.infoModel.date];
    [self.dataSourceArray addObject:self.infoModel.organization];
    [self.hcTabelView reloadData];
}

- (void)deleteCerById {
    @weakify(self);
    [JHCustomerApiManager deleteCertificateById:[self.infoModel.ID integerValue] completeBlock:^(id  _Nullable respObj, BOOL hasError) {
        [JHDispatch ui:^{
            @strongify(self);
            if (hasError) {
                [self.view makeToast:@"删除失败" duration:1.0 position:CSToastPositionCenter];
            } else {
                [self.view makeToast:@"删除成功" duration:1.0 position:CSToastPositionCenter];
                if (self.callbackMethod) {
                    self.callbackMethod();
                }
                [JHDispatch after:1.f execute:^{
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }
        }];
    }];
}

#pragma mark - Delegate DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        JHHonnerCerDetailImageViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHHonnerCerDetailImageViewTableViewCell class])];
        if (!cell) {
            cell = [[JHHonnerCerDetailImageViewTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JHHonnerCerDetailImageViewTableViewCell class])];
        }
        [cell setViewModel:self.dataSourceArray[indexPath.row]];
        return cell;
    } else if (indexPath.row == 1) {
        JHHonnerCerDetailTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHHonnerCerDetailTitleTableViewCell class])];
        if (!cell) {
            cell = [[JHHonnerCerDetailTitleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JHHonnerCerDetailTitleTableViewCell class])];
        }
        [cell setViewModel:self.dataSourceArray[indexPath.row]];
        return cell;
    } else if (indexPath.row == 2) {
        JHHonnerCerDetailInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHHonnerCerDetailInfoTableViewCell class])];
        if (!cell) {
            cell = [[JHHonnerCerDetailInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JHHonnerCerDetailInfoTableViewCell class])];
        }
        [cell setViewModel:self.dataSourceArray[indexPath.row]];
        return cell;
    } else if (indexPath.row == 3) {
        JHHonnerCerDetailPeopleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHHonnerCerDetailPeopleTableViewCell class])];
        if (!cell) {
            cell = [[JHHonnerCerDetailPeopleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JHHonnerCerDetailPeopleTableViewCell class])];
        }
        [cell setViewModel:self.dataSourceArray[indexPath.row]];
        return cell;
    } else if (indexPath.row == 4) {
        JHHonnerCerDetailTimeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHHonnerCerDetailTimeTableViewCell class])];
        if (!cell) {
            cell = [[JHHonnerCerDetailTimeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JHHonnerCerDetailTimeTableViewCell class])];
        }
        [cell setViewModel:self.dataSourceArray[indexPath.row]];
        return cell;
    } else {
        JHHonnerCerDetailOrignTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHHonnerCerDetailOrignTableViewCell class])];
        if (!cell) {
            cell = [[JHHonnerCerDetailOrignTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JHHonnerCerDetailOrignTableViewCell class])];
        }
        [cell setViewModel:self.dataSourceArray[indexPath.row]];
        return cell;
    }
}

@end
