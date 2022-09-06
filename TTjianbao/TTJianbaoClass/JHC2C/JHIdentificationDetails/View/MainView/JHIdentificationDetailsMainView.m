//
//  JHIdentificationDetailsMainView.m
//  TTjianbao
//
//  Created by miao on 2021/6/11.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHIdentificationDetailsMainView.h"
#import "JHIdentificationDetailsCell.h"
#import "JHIdentDetailsIntroduceCell.h"
#import "JHIdentificationDetailsViewModel.h"
#import "JHIdentificationDetailsModel.h"
#import "JHJHIdentificationDetailsDelegate.h"
#import "MBProgressHUD.h"
#import "JHPhotoBrowserManager.h"

@interface JHIdentificationDetailsMainView ()<
UITableViewDelegate,
UITableViewDataSource
>
///  图片
@property (nonatomic, strong) UITableView *tableView;
/// 网络请求
@property (nonatomic, strong) JHIdentificationDetailsViewModel *detailViewModel;

@property (nonatomic, assign) NSInteger recordInfoId;

@end

@implementation JHIdentificationDetailsMainView

- (instancetype)initWithRecordInfoId:(NSInteger)recordInfoId {
    if (self == [super init]) {
        
        _recordInfoId = recordInfoId;
        [self p_drawSubViews];
        [self p_makeLayout];
        [MBProgressHUD showHUDAddedTo:self animated:YES];
        [self p_loadIdentificationDetailData];
        
    }
    return self;
}

- (void)p_drawSubViews {
    
    _tableView = [[UITableView alloc] init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = HEXCOLOR(0xf5f5f8);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    [_tableView registerClass:JHIdentificationDetailsCell.class forCellReuseIdentifier:[JHIdentificationDetailsCell cellIdentifier]];
    [_tableView registerClass:JHIdentDetailsIntroduceCell.class forCellReuseIdentifier:[JHIdentDetailsIntroduceCell cellIdentifier]];
    [self addSubview:_tableView];
    @weakify(self);
    _tableView.mj_header = [JHRefreshGifHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self p_loadIdentificationDetailData];
    }];

}

- (void)p_makeLayout {
    
    @weakify(self);
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (void)p_loadIdentificationDetailData {
    
    NSDictionary *params = @{@"imageType":@"s,m,b,o",@"recordInfoId":@(_recordInfoId)};
    [self.detailViewModel.identDetailsCommand execute:params];
    @weakify(self);
    [self.detailViewModel.identDetailsSubject subscribeNext:^(JHIdentificationDetailsModel * _Nullable x) {
        @strongify(self);
        [MBProgressHUD hideHUDForView:self animated:YES];
        [self.tableView jh_endRefreshing];
        if (x) {
            if (x.imagesAndVideosAll.count == 0) {
                [self.tableView jh_reloadDataWithEmputyView];
            } else {
                [self.tableView reloadData];
            }
        } else {
            [self.tableView jh_reloadDataWithEmputyView];
        }
    }];
}

#pragma mark - UITableViewDelegate UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.detailViewModel.identetailsModel.imagesAndVideosAll.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat cellHeight = 0.0f;
    if (indexPath.row == 0) {
        cellHeight =  self.detailViewModel.identetailsModel.introduceHeight;
    } else {
        JHIdentDetailImageOrVideoModel *infoModel = [self.detailViewModel.identetailsModel.imagesAndVideosAll objectAtIndex:indexPath.row - 1];
        return infoModel.aNewHeight;
    }
    return cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        JHIdentDetailsIntroduceCell  *cell = [JHIdentDetailsIntroduceCell dequeueReusableCellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setIntroduceModel:self.detailViewModel.identetailsModel];
        return cell;
    }
    JHIdentificationDetailsCell *cell =  [JHIdentificationDetailsCell dequeueReusableCellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    JHIdentDetailImageOrVideoModel *infoModel = [self.detailViewModel.identetailsModel.imagesAndVideosAll objectAtIndex:indexPath.row - 1];
    [cell setDetailOrVideoModel:infoModel];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    JHIdentDetailImageOrVideoModel *infoModel = [self.detailViewModel.identetailsModel.imagesAndVideosAll objectAtIndex:indexPath.row - 1];
    JHIdentificationDetailsCell *cell = (JHIdentificationDetailsCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    if (!infoModel.isVideo) {
    
        [JHPhotoBrowserManager showPhotoBrowserImages:@[infoModel.origin]
                                              sources:@[cell.imageView]
                                         currentIndex:0];
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(playdentDetailsVideo:)]) {
        [self.delegate playdentDetailsVideo:cell];
    }
    
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.delegate && [self.delegate respondsToSelector:@selector(endScrollToStopVideo:)]) {
        [self.delegate endScrollToStopVideo:self.tableView];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (self.delegate && [self.delegate respondsToSelector:@selector(endScrollToStopVideo:)]) {
        [self.delegate endScrollToStopVideo:self.tableView];
    }
}

#pragma mark - set/get

- (JHIdentificationDetailsViewModel *)detailViewModel {
    if (!_detailViewModel) {
        _detailViewModel = [[JHIdentificationDetailsViewModel alloc]init];
    }
    return _detailViewModel;
}

@end
