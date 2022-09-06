//
//  JHPublishSelectTopicView.m
//  TTjianbao
//
//  Created by jesee on 17/6/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHPublishSelectTopicView.h"
#import "JHTableViewExt.h"
#import "SVProgressHUD.h"
#import "JHPublishTopicDetailTableCell.h"
#import "JHPublishTopicRecordTableCell.h"

const CGFloat rowHeight = 88;
const CGFloat titleHeight = 35;

@interface JHPublishSelectTopicView () <UITableViewDelegate, UITableViewDataSource, JHDetailCollectionDelegate>
{
    //table布局:row=1已选话题 2 历史记录 3全部话题(title) 4全部话题(内容)
    NSInteger allTopicPlaceholderRow; //全部话题所在行数
}
@property (nonatomic, strong) JHTableViewExt* topicTableView; //tableview

///悬浮的
@property (nonatomic, strong) JHTableViewExt* headerTableView;

@property (nonatomic, strong) NSArray* dataArray; //全部话题数据topicModel的一部分
@property (nonatomic, strong) JHPublishTopicModel* topicModel;
@end

@implementation JHPublishSelectTopicView

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.backgroundColor = HEXCOLOR(0xFFFFFF);
        [self showViews];
    }
    return self;
}

- (void)showViews
{
    [self addSubview:self.headerTableView];
    [self.headerTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(rowHeight * 2 + titleHeight);
    }];
 
    [self addSubview:self.topicTableView];
    [self.topicTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerTableView.mas_bottom).offset(10);
        make.left.right.bottom.equalTo(self);
    }];
}

- (JHTableViewExt *)headerTableView
{
    if(!_headerTableView)
    {
        _headerTableView = [[JHTableViewExt alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _headerTableView.backgroundColor = HEXCOLOR(0xFFFFFF);
        _headerTableView.delegate = self;
        _headerTableView.dataSource = self;
        _headerTableView.tag = 1000;
        _headerTableView.scrollEnabled = NO;
        _headerTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _headerTableView;
}

- (JHTableViewExt *)topicTableView
{
    if(!_topicTableView)
    {
        _topicTableView = [[JHTableViewExt alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _topicTableView.backgroundColor = HEXCOLOR(0xFFFFFF);
        _topicTableView.delegate = self;
        _topicTableView.dataSource = self;
        _topicTableView.tag = 1001;
        _topicTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _topicTableView.showsHorizontalScrollIndicator = NO;
        _topicTableView.estimatedRowHeight = 60;
    }
    return _topicTableView;
}


- (void)reloadData
{
    [self.topicTableView reloadData];
    [self.headerTableView reloadData];
}
#pragma mark - data
- (void)updateTopicData:(JHPublishTopicModel*)topic
{
    if(topic)
    {
        allTopicPlaceholderRow = 0;
        self.topicModel = topic;
        self.dataArray = self.topicModel.detailArray;
        [self calculateTopicData];
        [self reloadData];
    }
}

- (void)calculateTopicData
{
    CGFloat height = titleHeight;
    if(self.topicModel.detailArray.count > 0)
    {
        allTopicPlaceholderRow = 0;
        if(self.topicModel.selectedArray.count > 0)
        {
            allTopicPlaceholderRow += 1;
            height += rowHeight;
        }
        if(self.topicModel.recordArray.count > 0)
        {
            allTopicPlaceholderRow += 1;
            height += rowHeight;
        }
    }
    
    [self.headerTableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
    }];
}

//选中话题数组
- (NSArray*)topicSelectedArray
{
    return self.topicModel.selectedArray;
}

- (void)refreshTopicTableView
{
    [self calculateTopicData];
    [self reloadData];
}

- (void)updateSelectedArray:(id)model
{
    if([self.topicModel.selectedArray count] >= 3)
    {
        [SVProgressHUD showInfoWithStatus:@"抱歉，您选择话题数量已经超过上限"];
        return;
    }
    //组装已选模型
    [self.topicModel makeTopicRecordModel:model];
    [self refreshTopicTableView];
}

#pragma mark - cell
- (JHPublishTopicDetailTableCell*)topicDetailCell:(UITableView *)tableView
{
    JHPublishTopicDetailTableCell* cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHPublishTopicDetailTableCell class])];
    if(!cell)
    {
        cell = [[JHPublishTopicDetailTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JHPublishTopicDetailTableCell class])];
    }
    
    return cell;
}

- (UITableViewCell*)allTopicTitleCell:(UITableView *)tableView
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([UITableViewCell class])];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = @"推荐话题";
    cell.textLabel.textColor = HEXCOLOR(0x333333);
    cell.textLabel.font = JHMediumFont(15);
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    [cell.textLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(21);
        make.left.equalTo(cell).offset(15);
        make.top.equalTo(cell).offset(10);
        make.bottom.equalTo(cell);
    }];
    
    return cell;
}

#pragma mark - table delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView.tag == 1000)
    {
        return (allTopicPlaceholderRow + 1);
    }
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView.tag == 1000)
    {
        if(indexPath.row == allTopicPlaceholderRow - 2 ||
           ([self.topicModel.selectedArray count] > 0 && allTopicPlaceholderRow == 1
            && indexPath.row == allTopicPlaceholderRow - 1))
        {//1已选话题(a:已选和历史都有数据 b:仅已选有数据,历史无数据)
            JHPublishTopicRecordTableCellExt* cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHPublishTopicRecordTableCellExt class])];
            if(!cell)
            {
                cell = [[JHPublishTopicRecordTableCellExt alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JHPublishTopicRecordTableCellExt class])];
                cell.delegate = self;
            }
            [cell updateData:self.topicModel.selectedArray];
            return cell;
        }
        else if(indexPath.row == allTopicPlaceholderRow - 1)
        {//2 历史记录
            JHPublishTopicRecordTableCell* cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHPublishTopicRecordTableCell class])];
            if(!cell)
            {
                cell = [[JHPublishTopicRecordTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JHPublishTopicRecordTableCell class])];
                cell.delegate = self;
            }
            JH_WEAK(self)
            cell.deleteTopicBlock = ^(id obj) {
               JH_STRONG(self)
                [self deleteAllHistoryRecord];
            };
            [cell updateData:self.topicModel.recordArray];
            return cell;
        }
        else
        {//3全部话题(title)
            UITableViewCell* cell = [self allTopicTitleCell:tableView];
            return cell;
        }
    }
    else
    {
        // 4全部话题(内容)
        JHPublishTopicDetailTableCell* cell = [self topicDetailCell:tableView];
        [cell updateData:self.dataArray[indexPath.row]];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView.tag == 1001)
    {
        [self updateSelectedArray:self.dataArray[indexPath.row]];
    }
}

#pragma mark - JHDetailCollectionDelegate
- (void)clickCollectionItem:(JHPublishTopicRecordModel*)item
{
    if(item.style == JHCollectionItemStyleDelete)
    {//删除功能
        for (JHPublishTopicRecordModel* model in self.topicModel.selectedArray)
        {
            if([model.title isEqualToString:item.title])
            {//TODO:::最好用id这类值判断
                [self.topicModel.selectedArray removeObject:model];
                break;
            }
        }
        [self refreshTopicTableView];
    }
    else
    {
        [self updateSelectedArray:item];
    }
}

- (void)deleteAllHistoryRecord
{
    self.topicModel.recordArray = nil;
    [JHPublishTopicRecordModel deleteAllTopicRecord];
    [self refreshTopicTableView];
}

@end
