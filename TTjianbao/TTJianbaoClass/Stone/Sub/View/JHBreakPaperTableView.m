//
//  JHBreakPaperTableView.m
//  TTjianbao
//
//  Created by yaoyao on 2019/11/30.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHBreakPaperTableView.h"
#import "JHBreakPaperTableCell.h"
@implementation JHBreakPaperTableView



- (void)makeUI {
    [super makeUI];
    
    self.tableView.tableHeaderView = self.stoneOrderItem;
    [self.tableView registerClass:[JHBreakPaperTableCell class] forCellReuseIdentifier:NSStringFromClass([JHBreakPaperTableCell class])];
}

- (JHPopStoneOrderItem *)stoneOrderItem {
    if (!_stoneOrderItem) {
        _stoneOrderItem = [[JHPopStoneOrderItem alloc] init];
        _stoneOrderItem.size = CGSizeMake(self.tableView.width, 107);
    }
    return _stoneOrderItem;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JHBreakPaperTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHBreakPaperTableCell class])];
    cell.tag = indexPath.row+1;
    cell.model = self.dataArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return  cell;
}

@end
