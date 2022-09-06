//
//  JHLiveRoomListView.m
//  TTjianbao
//
//  Created by 于岳 on 2020/7/22.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHLiveRoomListView.h"
#import "JHLiveRoomListViewCell.h"
#import "JHLiveRoomListViewCellModel.h"

@interface JHLiveRoomListView()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;

@end
@implementation JHLiveRoomListView

-(instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.backgroundColor = HEXCOLORA(0x000000, 0);
        
        [self configUI];
    }
    return self;
}
- (void)configUI
{
    //live_room_list_bg
    [self bgImageView];
    [self tableView];
    self.tableView.layer.cornerRadius = 4;
    self.tableView.layer.masksToBounds = YES;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JHLiveRoomListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHLiveRoomListViewCell"];
    NSDictionary *dict = self.dataArr[indexPath.row];
    JHLiveRoomListViewCellModel *model = [JHLiveRoomListViewCellModel modelWithDictionary:dict];
    cell.model = model;
    if (indexPath.row == self.dataArr.count-1) {
        [cell showBottomLine:NO];
    }else{
        [cell showBottomLine:YES];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 34;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dict = self.dataArr[indexPath.row];
    JHLiveRoomListViewCellModel *model = [JHLiveRoomListViewCellModel modelWithDictionary:dict];
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectedItem:)]) {
        [_delegate didSelectedItem:model];
    }
}
-(UIImageView *)bgImageView
{
    if(!_bgImageView)
    {
        _bgImageView = [UIImageView new];
        [self addSubview:_bgImageView];
        _bgImageView.userInteractionEnabled = YES;
        _bgImageView.contentMode = UIViewContentModeScaleAspectFit;
        _bgImageView.image = [UIImage imageNamed:@"live_room_list_bg"];
        [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(12, 6));
            make.centerX.mas_equalTo(self.mas_centerX);
            
        }];
    }
    return _bgImageView;
}
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [self addSubview:_tableView];
        _tableView.backgroundColor = HEXCOLORA(0x000000, .9);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [[UIView alloc] init];
        [_tableView registerClass:[JHLiveRoomListViewCell class] forCellReuseIdentifier:@"JHLiveRoomListViewCell"];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.top.equalTo(self);
            make.bottom.equalTo(@-6);
        }];
    }
    return _tableView;
}
-(void)updateData:(NSArray *)dataArr
{
    self.dataArr = dataArr;
    [self.tableView reloadData];

}
@end
