//
//  JHClaimOrderListViewController.m
//  TTjianbao
//
//  Created by yaoyao on 2019/2/25.
//  Copyright © 2019年 Netease. All rights reserved.
//

#import "JHClaimOrderListViewController.h"
#import "JHClaimOrderListCell.h"
#import "JHAddClaimListViewController.h"
#import "JHAudienceApplyConnectView.h"
#import "NOSUpImageTool.h"


@interface JHClaimOrderListViewController () <UITableViewDelegate,UITableViewDataSource,JHAudienceApplyConnectViewDelegate>
{
}
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSIndexPath *deleteIndexPath;
@property(nonatomic, strong) NSIndexPath *selectedIndexPath;
@property(nonatomic, strong) UIButton *appraiseBtn;

@property(nonatomic, assign) NSTimeInterval startTime;
@property(nonatomic, strong) JHAudienceApplyConnectView *audienceAddPhotoView;
@property(nonatomic, copy) NSString *imageUrlString;
@property(nonatomic, strong) UIView *showImageView;
@property(nonatomic, strong) UIImage *coverImage;


@end

@implementation JHClaimOrderListViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
//    [self  initToolsBar];
//    [self.navbar setTitle:@"商城鉴定列表"];
    self.title = @"商城鉴定列表";
//    self.navbar.ImageView.hidden = YES;
    self.view.backgroundColor = HEXCOLOR(0xf7f7f7);
//    [self.navbar addBtn:nil withImage:kNavBackBlackImg withHImage:kNavBackBlackImg withFrame:CGRectMake(0,0,44,44)];
//    [self.navbar.comBtn addTarget :self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    
    if (_isLiving) {
        self.jhNavView.frame = CGRectMake(0, 0, ScreenW, 51);
//        self.navbar.backgroundColor = [UIColor whiteColor];
        UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
        [back setImage:[UIImage imageNamed:@"icon_alert_close"] forState:UIControlStateNormal];
        [back addTarget:self action:@selector(backActionButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.jhNavView addSubview:back];
        [back mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.jhNavView);
            make.trailing.equalTo(self.jhNavView);
            make.width.height.equalTo(@50);
        }];
        self.jhTitleLabel.frame = self.jhNavView.bounds;
        [self.jhLeftButton removeFromSuperview];
        
        
        
    }else {
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, UI.statusAndNavBarHeight-1, ScreenW, 1)];
        line.backgroundColor = HEXCOLOR(0xeeeeee);
        [self.jhNavView addSubview:line];

    }
    
    [self.view addSubview:self.tableView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = kGlobalThemeColor;
    [btn setTitle:@"认领商城鉴定" forState:UIControlStateNormal];
    [btn setTitleColor:HEXCOLOR(0x222222) forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.jhNavView.mas_bottom);
        make.leading.trailing.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-50);
    }];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView.mas_bottom);
        make.leading.trailing.bottom.equalTo(self.view);
        make.height.equalTo(@(50));
    }];
    
    if (_isLiving) {
        UIButton *appraiseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        appraiseBtn.backgroundColor = kGlobalThemeColor;
        [appraiseBtn setTitle:@"开始鉴定" forState:UIControlStateNormal];
        [appraiseBtn setTitle:@"结束鉴定" forState:UIControlStateSelected];
        
        [appraiseBtn setTitleColor:HEXCOLOR(0x222222) forState:UIControlStateNormal];
        [appraiseBtn addTarget:self action:@selector(appraiseAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:appraiseBtn];
        [appraiseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.leading.top.bottom.equalTo(btn);
        }];
        appraiseBtn.hidden = YES;
        self.appraiseBtn = appraiseBtn;
    }
    [self requestData];
}



- (void)viewDidLayoutSubviews {
    
}

- (void)backActionButton:(UIButton *)sender{
    if (_isLiving) {
        [self.view.superview performSelector:@selector(hiddenAlert) withObject:nil];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}


- (UIView *)showImageView {
    if (!_showImageView) {
        _showImageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
        _showImageView.backgroundColor = [UIColor blackColor];
        UIImageView *image = [[UIImageView alloc] initWithFrame:_showImageView.bounds];
        image.contentMode = UIViewContentModeScaleAspectFill;
        image.clipsToBounds = YES;
        image.image = self.coverImage;
        [_showImageView addSubview:image];
        CGFloat ww = (ScreenW-100)/2.;
        NSArray *titles = @[@"icon_pic_cancel", @"icon_pic_ok"];
        for (int i = 0; i<2; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(ww*i+50, ScreenH-90, ww, 70);
            [btn setImage:[UIImage imageNamed:titles[i]] forState:UIControlStateNormal];
            btn.tag = i;
            [btn addTarget:self action:@selector(actionSelecte:) forControlEvents:UIControlEventTouchUpInside];
            [_showImageView addSubview:btn];
            
        }
        
    }
    
    return _showImageView;
}
- (JHAudienceApplyConnectView *)audienceAddPhotoView {
    if (!_audienceAddPhotoView) {
        _audienceAddPhotoView = [[JHAudienceApplyConnectView alloc] initWithFrame:self.view.bounds];
        _audienceAddPhotoView.delegate=self;
        [_audienceAddPhotoView setEndAppraise];
    }
    return _audienceAddPhotoView;
}


- (UITableView*)tableView{
    
    if (!_tableView) {
        
        _tableView=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.alwaysBounceVertical=YES;
        _tableView.scrollEnabled=YES;
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.backgroundColor=[UIColor clearColor];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JHClaimOrderListCell class]) bundle:nil] forCellReuseIdentifier:@"JHClaimOrderListCell"];
        
    }
    return _tableView;
}


- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

#pragma mark - tableviewDatesource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.dataArray count];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"JHClaimOrderListCell";
    JHClaimOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.model = self.dataArray[indexPath.section];
    if (_isLiving) {
        cell.backgroundColor = [UIColor clearColor];
        cell.toLeadingWidth.constant = 8;
        if (self.selectedIndexPath && self.selectedIndexPath.section == indexPath.section) {
            cell.selectedImage.hidden = NO;
            if (self.isApraising) {
                cell.stateLabel.hidden = NO;
            }
        }else {
            cell.selectedImage.hidden = YES;
            cell.stateLabel.hidden = YES;
            
        }
    }
    return  cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  106;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_isLiving) {
        if (self.appraiseBtn.selected) {
            return;
        }
        self.selectedIndexPath = indexPath;
        [self.tableView reloadData];
        if (self.selectedIndexPath) {
            self.appraiseBtn.hidden = NO;
        }else {
            self.appraiseBtn.hidden = YES;
        }

        
        return;
        if (self.selectedIndexPath && self.selectedIndexPath.section == indexPath.section) {
            self.selectedIndexPath = nil;
            [self.tableView reloadData];
            
        }else {
            self.selectedIndexPath = indexPath;
            [self.tableView reloadData];
            
        }
    }else {
        
    }
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_isLiving) {
        return 15;
    }
    if (section == 0) {
        return 1;
    }
    return 10;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc]init];
    headerView.backgroundColor = HEXCOLOR(0xf7f7f7);
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return CGFLOAT_MIN;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}


#pragma mark - action

- (void)actionSelecte:(UIButton *)btn{
    if (btn.tag == 0) {
    } else {
        NOSFormData * data = [[NOSFormData alloc]init];
        data.fileImage = self.coverImage;
        data.fileDir = @"order_appraise";
        
        JH_WEAK(self)
        [[NOSUpImageTool getInstance] upImageWithformData:data successBlock:^(RequestModel *respondObject) {
            JH_STRONG(self)
            [SVProgressHUD showSuccessWithStatus:@"上传成功"];
            [self.audienceAddPhotoView setCameraImage:self.coverImage];
            self.imageUrlString = respondObject.data;
            
        } failureBlock:^(RequestModel *respondObject) {
            [SVProgressHUD show];
            [SVProgressHUD showErrorWithStatus:respondObject.message];
        }];
        
        [SVProgressHUD show];
    }
    [self.showImageView removeFromSuperview];
    self.showImageView = nil;
    
}

- (void)addAction:(UIButton *)btn {
    
    JHAddClaimListViewController *vc = [[JHAddClaimListViewController alloc] init];
    MJWeakSelf
    vc.finishBlock = ^(id sender) {
        [weakSelf requestData];
    };
    if (_isLiving) {
        [self.view.superview.viewController presentViewController:vc animated:YES completion:nil];
    }else {
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}

- (void)appraiseAction:(UIButton *)btn {
    if (self.selectedIndexPath) {
        OrderMode *model = self.dataArray[self.selectedIndexPath.section];
        if (!btn.selected) {
            //开始鉴定
            btn.selected = !btn.selected;
            
            [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/auth/orderAppraiseRel/start") Parameters:@{@"orderId":model.orderId,@"timeSpend":@""} successBlock:^(RequestModel *respondObject) {
                self.startTime = time(NULL);
                [self.view makeToast:@"开始鉴定" duration:1 position:CSToastPositionCenter];
                [SVProgressHUD dismiss];
                self.isApraising = YES;
                [self.tableView reloadData];
                [self backActionButton:nil];
                
            } failureBlock:^(RequestModel *respondObject) {
                [SVProgressHUD dismiss];
                [SVProgressHUD showErrorWithStatus:respondObject.message];
                
            }];
            [SVProgressHUD show];
        }else {
            //结束鉴定
            if (_audienceAddPhotoView) {
                [_audienceAddPhotoView removeFromSuperview];
            }
            [self.view addSubview:self.audienceAddPhotoView];
            [self.audienceAddPhotoView show];
            
            
            
        }
    }
}

- (void)requestData {
    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/order/auth/waitAppraise") Parameters:nil successBlock:^(RequestModel *respondObject) {
        self.dataArray = [OrderMode mj_objectArrayWithKeyValuesArray:respondObject.data];
        [self.tableView reloadData];
        if (self.dataArray.count) {
            [self hiddenDefaultImage];
        }else {
            [self showDefaultImageWithView:self.tableView];
        }
    } failureBlock:^(RequestModel *respondObject) {
        [self.view makeToast:respondObject.message];
        [self showDefaultImageWithView:self.tableView];
        
    }];
}


#pragma JHAudienceAddPhotoViewDelegate

- (void)addPhoto {
    if (self.clickImage) {
        self.clickImage(nil);
    }
}


- (void)onComplete{
    
    if (self.imageUrlString) {
    
        OrderMode *model = self.dataArray[self.selectedIndexPath.section];
        [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/auth/orderAppraiseRel/end") Parameters:@{@"orderId":model.orderId,@"timeSpend":@(time(NULL)-self.startTime), @"imgUrl":self.imageUrlString} successBlock:^(RequestModel *respondObject) {
            [SVProgressHUD dismiss];
            [self.dataArray removeObjectAtIndex:self.selectedIndexPath.section];
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:self.selectedIndexPath.section] withRowAnimation:UITableViewRowAnimationFade];
            self.selectedIndexPath = nil;
            self.appraiseBtn.hidden = YES;
            [self.view makeToast:@"结束鉴定" duration:1 position:CSToastPositionCenter];
            self.appraiseBtn.hidden = YES;
            self.appraiseBtn.selected = NO;
            self.selectedIndexPath = nil;
            self.isApraising = NO;

            if (self.dataArray.count == 0) {
                [self showDefaultImageWithView:self.tableView];
            }

        } failureBlock:^(RequestModel *respondObject) {
            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:respondObject.message];
        }];
        [SVProgressHUD show];
        
    }else{
        [self.view makeToast:@"请上传鉴定产品图片" duration:1.0 position:CSToastPositionCenter];
    }
    
}

- (void)catchImage:(UIImage *)image {
    if (!image) {
        return;
    }
    self.coverImage = image;
    [self.view.superview.viewController.view addSubview:self.showImageView];
    
}
@end
