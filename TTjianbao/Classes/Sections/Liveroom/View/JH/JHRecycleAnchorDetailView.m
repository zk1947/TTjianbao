//
//  JHRecycleAnchorDetailView.m
//  TTjianbao
//
//  Created by user on 2021/4/10.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleAnchorDetailView.h"
#import "JHTableViewExt.h"
#import "JHLiveRoomIntroduceModel.h"
#import "JHLivingRecycleAnchorInfoTableViewCell.h"
#import "JHLivingRecycleAnchorCagetoryTableViewCell.h"

@interface JHRecycleAnchorDetailView ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSString* channelLocalId;
@property (nonatomic, strong) JHTableViewExt* infoTableView; //tableview
@property (nonatomic, strong) JHLiveRoomIntroduceModel* infoModel;
@property (nonatomic, strong) NSArray* dataArray; //JHLiveRoomAnchorInfoModel
@property (nonatomic, assign) NSInteger roleType;

@end

@implementation JHRecycleAnchorDetailView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

///请求直播及主播信息
- (void)requestRoomInfo {
    JH_WEAK(self)
//    self.channelLocalId = @"777";//test
    [JHLiveRoomIntroduceModel requestLiveRoomInfo:self.channelLocalId completeBlock:^(NSString* errorMsg, JHLiveRoomIntroduceModel* data) {
        JH_STRONG(self);
        if (errorMsg) {
            [SVProgressHUD showErrorWithStatus:errorMsg];
        } else {
            [self refreshData:data];
        }
    }];
}

#pragma mark - subviews
- (void)setupViews {
    [self addSubview:self.infoTableView];
    [self.infoTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.height.mas_equalTo(316);
        make.bottom.equalTo(self).offset(0);
    }];
}

- (JHTableViewExt *)infoTableView {
    if (!_infoTableView) {
        _infoTableView = [[JHTableViewExt alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _infoTableView.backgroundColor = [UIColor clearColor];
        _infoTableView.delegate = self;
        _infoTableView.dataSource = self;
        _infoTableView.showsVerticalScrollIndicator = NO;
        _infoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _infoTableView.showsHorizontalScrollIndicator = NO;
        _infoTableView.estimatedRowHeight = 20;
        _infoTableView.sectionHeaderHeight = 1;
        _infoTableView.sectionFooterHeight = 9;
        [_infoTableView registerClass:[JHLivingRecycleAnchorInfoTableViewCell class] forCellReuseIdentifier:NSStringFromClass([JHLivingRecycleAnchorInfoTableViewCell class])];
        [_infoTableView registerClass:[JHLivingRecycleAnchorCagetoryTableViewCell class] forCellReuseIdentifier:NSStringFromClass([JHLivingRecycleAnchorCagetoryTableViewCell class])];
    }
    return _infoTableView;
}

#pragma mark - table delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
        JHLivingRecycleAnchorInfoTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHLivingRecycleAnchorInfoTableViewCell class])];
        if (!cell) {
            cell = [[JHLivingRecycleAnchorInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JHLivingRecycleAnchorInfoTableViewCell class])];
        }
        [cell updateData:self.infoModel.roomDes roleType:self.roleType];
        return cell;
    } else {
        JHLivingRecycleAnchorCagetoryTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHLivingRecycleAnchorCagetoryTableViewCell class])];
        if (!cell) {
            cell = [[JHLivingRecycleAnchorCagetoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JHLivingRecycleAnchorCagetoryTableViewCell class])];
        }
        [cell updateData:self.infoModel.cateNames];
        return cell;
    }
}

#pragma mark - refresh Data

- (void)refreshViewWithChannelLocalId:(NSString *)channelLocalId
                             roleType:(NSInteger)type {
    self.roleType = type;
    self.channelLocalId = channelLocalId;
    [self requestRoomInfo];
}

- (void)refreshData:(JHLiveRoomIntroduceModel *)model {
    self.infoModel = model;
    if([model.broads count] > 0) {
        self.dataArray = model.broads;
        [self.infoTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.right.equalTo(self).offset(-10);
            make.height.mas_equalTo(316);
            make.bottom.equalTo(self).offset(0);
        }];
    } else {
        JHLiveRoomAnchorInfoModel *info = [JHLiveRoomAnchorInfoModel new];
        info.liveState = @"-11";
        self.dataArray = [NSArray arrayWithObject:info];
        [self.infoTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.right.equalTo(self).offset(-10);
            make.height.mas_equalTo(256);
            make.bottom.equalTo(self).offset(0);
        }];
    }
    [self.infoTableView reloadData];
}

@end
