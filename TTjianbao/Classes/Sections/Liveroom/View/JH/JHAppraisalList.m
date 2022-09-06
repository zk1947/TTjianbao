//
//  JHAppraisalList.m
//  TTjianbao
//
//  Created by yaoyao on 2018/12/12.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import "JHAppraisalList.h"

@interface JHAppraisalList ()<UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation JHAppraisalList

/*
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self makeUI];
    }
    return self;
}

- (void)makeUI {
    
    UIImageView *back = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_rect_black"]];
    [self addSubview:back];
    [back mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 0));

    }];
    [self addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(10, 0, 0, 0));
    }];
    
}

#pragma mark - GET

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
                [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JHLinkerTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"JHLinkerTableViewCell"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 250;
        _tableView.backgroundColor = [UIColor clearColor];

        
    }
    return _tableView;
}


#pragma mark - UITableViewDelegate UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        JHLinkerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHLinkerTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataArray[indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    cell.tag = indexPath.row;
    cell.delegate = self;
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


- (void)reloadData:(NSArray *)array {
    self.dataArray = array.mutableCopy;
    [self.tableView reloadData];
}



- (void)showAlert {
    CGRect rect = self.frame;
    if (rect.size.width<ScreenW) {
        rect.origin.y = ScreenH - rect.size.height - UI.bottomSafeAreaHeight - 49;
        
    }else {
        rect.origin.y = ScreenH - rect.size.height - UI.bottomSafeAreaHeight;        
    }
    [UIView animateWithDuration:0.25f animations:^{
        self.frame = rect;
    }];
}

- (void)hiddenAlert{
    CGRect rect = self.frame;
    rect.origin.y = ScreenH;
    [UIView animateWithDuration:0.25f animations:^{
        self.frame = rect;
    }];
    
}

- (void)didSelectedAppraisalListCell:(NSInteger)index model:(NTESMicConnector *)model {
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectedAppraisalListCell:model:)]) {
        [_delegate didSelectedAppraisalListCell:index model:model];
    }
}
*/
@end
