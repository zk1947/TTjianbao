//
//  JHSaleLiveRoomCustomizeList.m
//  TTjianbao
//
//  Created by apple on 2020/11/26.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHSaleLiveRoomCustomizeList.h"
#import "JHSaleLiveRoomCustomizeCell.h"
#import "UIButton+zan.h"
#import "JHCustomerInfoController.h"

@implementation JHSaleLiveRoomCustomizeListModel
@end

@interface JHSaleLiveRoomCustomizeList ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)  UIButton* bottomBtn;

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray <JHSaleLiveRoomCustomizeListModel*> *modelArray;
@end

@implementation JHSaleLiveRoomCustomizeList

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.layer.cornerRadius = 4;
        self.backgroundColor = [UIColor clearColor];
        self.hidden = YES;
        
        [self addSubview:self.tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(3, 3, 5, 3));
        }];
        
        [self addSubview:self.bottomBtn];
        [self.bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.mas_bottom).offset(0);
            make.left.right.equalTo(self);
            make.height.mas_equalTo(35);
        }];

    }
    return self;
}


- (void)setChannelLocalId:(NSString *)channelLocalId{
    if (self.modelArray || channelLocalId.length==0 ) {
        return;
    }
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/anon/appraisal/customizeChannelRel/simple-customizes") Parameters:@{@"channelId":channelLocalId} requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        self.modelArray = [JHSaleLiveRoomCustomizeListModel mj_objectArrayWithKeyValuesArray:respondObject.data];
        if (self.modelArray.count>0) {
            self.hidden = NO;
            [self.tableView reloadData];
        }else{
            self.hidden = YES;
        }
        
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        
    }];
}

- (UIButton *)bottomBtn{
    if (!_bottomBtn) {
        _bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bottomBtn setImage:[UIImage imageNamed:@"customizeList_shrink"] forState:UIControlStateSelected];
        [_bottomBtn setTitle:@"收起" forState:UIControlStateSelected];
        [_bottomBtn setImage:[UIImage imageNamed:@"customizeList_unfold"] forState:UIControlStateNormal];
        [_bottomBtn setTitle:@"展开" forState:UIControlStateNormal];
        _bottomBtn.titleLabel.font = JHFont(10);
        [_bottomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal|UIControlStateSelected];
        [_bottomBtn refresh_leftImv_rightTitle_space:5];
        [_bottomBtn addTarget:self action:@selector(bottomBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomBtn;
}

- (void)bottomBtnAction:(UIButton *)sender{
    
    sender.selected = !sender.selected;
    if (sender.selected) {
        if (self.modelArray.count>4) {
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(66, 312));
            }];
        }else if(self.modelArray.count>=2){
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(66, 65 * self.modelArray.count));
            }];
        }else{
            
        }
    }else{
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(66,94));
        }];
    }
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = HEXCOLOR(0xf5f5f5);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.estimatedRowHeight = 44;
        
    }
    return _tableView;
}

#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JHSaleLiveRoomCustomizeCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellPop"];
    if (!cell) {
        cell = [[JHSaleLiveRoomCustomizeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellPop"];
    }
    [cell.imageV jh_setImageWithUrl:self.modelArray[indexPath.row].img];
    cell.nameLabel.text = self.modelArray[indexPath.row].anchorName;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    JHSaleLiveRoomCustomizeListModel * mode = self.modelArray[indexPath.item];
    JHCustomerInfoController *vc = [[JHCustomerInfoController alloc] init];
    vc.roomId = mode.roomId;
    vc.anchorId = mode.customerId;
    vc.channelLocalId = mode.channelId;
    [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
}

@end
