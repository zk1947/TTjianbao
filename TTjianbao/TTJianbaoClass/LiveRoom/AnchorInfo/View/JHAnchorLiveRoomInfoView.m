//
//  JHAnchorLiveRoomInfoView.m
//  TTjianbao
//
//  Created by jesee on 19/7/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHAnchorLiveRoomInfoView.h"
#import "JHLiveRoomIntroduceModel.h"
#import "JHTableViewExt.h"
#import "JHInfoAnchorTableCell.h"
#import "JHInfoLivingTableCell.h"
#import "JHCustomizeFeeInfoTableCell.h"
#import "SVProgressHUD.h"

#define kAnchorHeaderHeight (17+23)

/*JHAudienceUserRoleType
*   0, // 鉴定观众
*   1, // 卖货观众
*   2, //卖货助理
*   9, // 定制观众
*  10, //定制助理
*/

@interface JHAnchorLiveRoomInfoView () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSString* channelLocalId;
@property (nonatomic, strong) JHTableViewExt* infoTableView; //tableview
@property (nonatomic, strong) JHLiveRoomIntroduceModel* infoModel;
@property (nonatomic, strong) NSArray* dataArray; //JHLiveRoomAnchorInfoModel
@property (nonatomic, assign) NSInteger roleType;
@end

@implementation JHAnchorLiveRoomInfoView

- (void)dealloc
{
    NSLog(@"JHAnchorLiveRoomInfoView");
}

- (instancetype)init
{
    if(self = [super init])
    {
        self.backgroundColor = [UIColor clearColor];
        [self showViews];
    }
    return self;
}

- (void)refreshViewWithChannelLocalId:(NSString*)channelLocalId roleType:(NSInteger)type
{
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

///请求直播及主播信息
- (void)requestRoomInfo {
    JH_WEAK(self)
//    self.channelLocalId = @"777";//test
  //  [SVProgressHUD show];
    [JHLiveRoomIntroduceModel requestLiveRoomInfo:self.channelLocalId completeBlock:^(NSString* errorMsg, JHLiveRoomIntroduceModel* data) {
        JH_STRONG(self);
        if (errorMsg) {
            [SVProgressHUD showErrorWithStatus:errorMsg];
        } else {
           // [SVProgressHUD dismiss];
            [self refreshData:data];
        }
    }];
}

#pragma mark - subviews
- (void)showViews {
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
//        [_infoTableView.tableHeaderView layoutIfNeeded];
//        _infoTableView.tableHeaderView = [self infoHeader];
    }
    return _infoTableView;
}

#pragma mark - table delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;//self.dataArray.count+1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    if (self.roleType >= 9) {
        return 1;
    }
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
        JHInfoLivingTableCell* cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHInfoLivingTableCell class])];
        if (!cell) {
            cell = [[JHInfoLivingTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JHInfoLivingTableCell class])];
            JH_WEAK(self)
            cell.actionBlock = ^(NSNumber* height) {
                JH_STRONG(self)
                self.infoTableView.estimatedRowHeight = [height floatValue] + 70;
                [self.infoTableView reloadData];
                [self.infoTableView layoutIfNeeded];
            };
        }
        [cell updateData:self.infoModel.roomDes roleType:self.roleType];
        return cell;
    } else {
        if (self.roleType >= 9) {
            JHCustomizeFeeInfoTableCell* cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHCustomizeFeeInfoTableCell class])];
            if(!cell) {
                cell = [[JHCustomizeFeeInfoTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JHCustomizeFeeInfoTableCell class])];
            }
            [cell updateData:self.infoModel.fees];
            return cell;
        } else {
            JHInfoAnchorTableCell* cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHInfoAnchorTableCell class])];
            if (!cell) {
                cell = [[JHInfoAnchorTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JHInfoAnchorTableCell class])];
            }
            if (indexPath.row == 0) {
                if (self.dataArray.count == 1) {
                    [cell updateData:self.dataArray[indexPath.row] cornerType:JHCornerTypeAll roleType:self.roleType];
                } else {
                    [cell updateData:self.dataArray[indexPath.row] cornerType:JHCornerTypeTop roleType:self.roleType];
                }
            } else if (indexPath.row == self.dataArray.count - 1) {
                [cell updateData:self.dataArray[indexPath.row] cornerType:JHCornerTypeBottom roleType:self.roleType];
            } else {
                [cell updateData:self.dataArray[indexPath.row] cornerType:JHCornerTypeNone roleType:self.roleType];
            }
            return cell;
        }
    }
}

@end
