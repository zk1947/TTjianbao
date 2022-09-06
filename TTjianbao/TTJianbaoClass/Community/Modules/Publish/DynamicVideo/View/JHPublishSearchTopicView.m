//
//  JHPublishSearchTopicView.m
//  TTjianbao
//
//  Created by jesee on 17/6/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHPublishSearchTopicView.h"
#import "JHTableViewExt.h"
#import "JHPublishTopicDetailTableCell.h"

@interface JHPublishSearchTopicView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) JHTableViewExt* topicTableView; //tableview
@property (nonatomic, strong) NSArray* dataArray;
@end

@implementation JHPublishSearchTopicView

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self showViews];
    }
    return self;
}

- (void)updateData:(NSArray*)array
{
    self.dataArray = array;
    [self.topicTableView reloadData];
}

#pragma mark - subviews
- (void)showViews
{
    [self addSubview:self.topicTableView];
    [self.topicTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (JHTableViewExt *)topicTableView
{
    if(!_topicTableView)
    {
        _topicTableView = [[JHTableViewExt alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _topicTableView.backgroundColor = HEXCOLOR(0xFFFFFF);
        _topicTableView.delegate = self;
        _topicTableView.dataSource = self;
        _topicTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _topicTableView.showsHorizontalScrollIndicator = NO;
        _topicTableView.estimatedRowHeight = 60;
        _topicTableView.tableHeaderView = [self headerView];
    }
    return _topicTableView;
}
//占位15像素
- (UIView*)headerView
{
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 15)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (JHPublishTopicDetailTableCell*)topicDetailCell:(UITableView *)tableView
{
    JHPublishTopicDetailTableCell* cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHPublishTopicDetailTableCell class])];
    if(!cell)
    {
        cell = [[JHPublishTopicDetailTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JHPublishTopicDetailTableCell class])];
    }
    
    return cell;
}

#pragma mark - table delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JHPublishTopicDetailTableCell* cell = [self topicDetailCell:tableView];
    [cell updateData:self.dataArray[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.searchTopicBlock)
    {
        if(indexPath.row < self.dataArray.count)
            self.searchTopicBlock(self.dataArray[indexPath.row]);
    }
}

@end
