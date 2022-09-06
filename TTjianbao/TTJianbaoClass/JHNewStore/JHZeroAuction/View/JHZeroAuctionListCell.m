//
//  JHZeroAuctionListCell.m
//  TTjianbao
//
//  Created by zk on 2021/11/3.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHZeroAuctionListCell.h"
#import "JHZeroAuctionListViewController.h"

@interface JHZeroAuctionListCell ()<JHZeroAuctionListViewControllerDelegate>

@property (nonatomic, strong) JHZeroAuctionListViewController *vc;

@end

@implementation JHZeroAuctionListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupNewViews];
    }
    return self;
}

- (void)setupNewViews {
    _vc = [[JHZeroAuctionListViewController alloc] init];
    _vc.delegate = self;
    @weakify(self);
    _vc.haveDataBlock = ^(BOOL noData, JHZeroAuctionModel * _Nonnull listModel) {
        @strongify(self);
        if (self.haveDataBlock) {
            self.haveDataBlock(noData,listModel);
        }
    };
    
    _vc.goToBoutiqueDetailClickBlock = ^(BOOL isH5, NSString * _Nonnull showId, NSString * _Nonnull boutiqueName) {
        @strongify(self);
        if (self.goToBoutiqueDetailClickBlock) {
            self.goToBoutiqueDetailClickBlock(isH5,showId,boutiqueName);
        }
    };
    
    [self.contentView addSubview:_vc.view];
    [self.viewController addChildViewController:_vc];
    [_vc.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
        make.height.mas_equalTo(ScreenH - UI.statusAndNavBarHeight - 84);
    }];
}

- (void)releaseGoodListVC {
    [_vc.view removeFromSuperview];
    _vc = nil;
    [self setupNewViews];
}

- (void)makeDeatilDescModuleScroll:(BOOL)canScroll {
    [self.vc makeDeatilDescModuleScroll:canScroll];
}

- (void)JHStealTowerListViewControllerLeaveTop{
    if (self.delegate && [self.delegate respondsToSelector:@selector(JHStealTowerListCellLeaveTopd)]) {
        [self.delegate JHStealTowerListCellLeaveTopd];
    }
}

- (void)loadData:(JHZeroAuctionRequestModel *)requestModel completion:(void (^ __nullable)(BOOL finished))completion{
    [_vc loadData:requestModel completion:^(BOOL finished) {
        if (completion) {
            completion(YES);
        }
    }];
}

@end
