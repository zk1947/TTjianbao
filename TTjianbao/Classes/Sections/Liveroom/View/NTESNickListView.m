//
//  NTESNickListView.m
//  TTjianbao
//
//  Created by Netease on 2018/9/18.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import "NTESNickListView.h"
#import "UIView+NTES.h"

const float kNTESNickCellHeight = 14.0;
const float kNTESNickHeaderHeight = 14.0;

@interface NTESNickListView ()<UITableViewDataSource, UITableViewDelegate>
{
    CGRect _preRect;
}
@property (nonatomic, strong) UITableView *list;
@end

@implementation NTESNickListView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.list];
        self.backgroundColor = [UIColor clearColor];
        self.hidden = YES;
    }
    return self;
}

- (void)layoutSubviews {
    if (!CGRectEqualToRect(_preRect, self.bounds)) {
        _list.width = self.width;
        _preRect = self.bounds;
    }
}

#pragma mark - <UITableViewDataSource, UITableViewDelegate>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _nicks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"cell"];
        cell.textLabel.textColor = HEXCOLOR(0xffffff);
        cell.textLabel.font = [UIFont systemFontOfSize:11.f];
        cell.backgroundColor = [UIColor clearColor];
    }
    cell.textLabel.text = _nicks[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kNTESNickCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kNTESNickHeaderHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.width, kNTESNickCellHeight)];
    lab.textColor = HEXCOLOR(0xffffff);
    lab.font = [UIFont systemFontOfSize:11.f];
    lab.backgroundColor = [UIColor clearColor];
    lab.text = @"连麦列表:";
    return lab;
}

#pragma mark - Getter
- (UITableView *)list {
    if (!_list) {
        _list = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 100, 50) style:UITableViewStylePlain];
        [_list setBackgroundView:nil];
        [_list setBackgroundView:[[UIView alloc] init]];
        _list.backgroundView.backgroundColor = HEXCOLORA(0x0,0.3);
        _list.backgroundColor = [UIColor clearColor];
        _list.dataSource = self;
        _list.delegate = self;
        _list.estimatedRowHeight = 0;
        _list.estimatedSectionFooterHeight = 0;
        _list.estimatedSectionHeaderHeight = 0;
        _list.contentOffset = CGPointZero;
        _list.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (@available(iOS 11.0, *)) {
            _list.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _list;
}


- (void)setNicks:(NSMutableArray<NSString *> *)nicks {
    _nicks = nicks;
    NSInteger count = (nicks.count > 3 ? 3 : nicks.count);
    CGFloat height = (kNTESNickCellHeight * count + 1.0 * (count - 1)) + kNTESNickHeaderHeight;
    _list.frame = CGRectMake(0, 0, self.width, height);
    [_list reloadData];
    _list.contentOffset = CGPointZero;
}

- (CGFloat)estimationHeight {
    return _list.height;
}

@end
