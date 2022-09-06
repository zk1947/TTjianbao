//
//  JHPicDetailVoteView.m
//  TTjianbao
//
//  Created by lihui on 2019/12/27.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//


#import "JHPicDetailVoteView.h"
#import "JHNormalTableViewCell.h"
#import "JHVotedTableViewCell.h"
#import "JHDiscoverPicCommentModel.h"
#import "JHVoteFooterView.h"




@interface JHPicDetailVoteView () <UITableViewDelegate, UITableViewDataSource, JHVoteFooterViewDelegate, JHNormalTableViewCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *voteArray;
@property (nonatomic, assign) BOOL isVoted;
@property (nonatomic, strong) JHVoteFooterView *footer;
@property (nonatomic, strong) NSMutableArray *optionIds;
@property (nonatomic, assign) NSInteger selectIndex;

@end

@implementation JHPicDetailVoteView

- (instancetype)init {
    self = [super init];
    if (self) {
        _selectIndex = 0;
        _isVoted = NO;
        [self initViews];
    }
    return self;
}

#pragma mark -
#pragma mark - setter / getter method

- (void)setArticleModel:(CommunityArticalModel *)articleModel {
    _articleModel = articleModel;
    if (!_articleModel) {
        return;
    }
    _isVoted = [_articleModel.voteInfo.is_voted boolValue];
    if (!_isVoted && _articleModel.voteInfo) {
        _tableView.tableFooterView = self.footer;
    }
    _voteArray = [NSMutableArray arrayWithArray:_articleModel.voteInfo.optionInfos.copy];
    _footer.voteModel = _articleModel.voteInfo;
  
    [_tableView reloadData];
}

- (void)initViews {
    _tableView = ({
        UITableView *tableV = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        tableV.delegate = self;
        tableV.dataSource = self;
        tableV.scrollEnabled = NO;
        tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableV.tableFooterView = [[UIView alloc] init];
        [tableV registerClass:[JHNormalTableViewCell class] forCellReuseIdentifier:@"JHNormalTableViewCell"];
        [tableV registerClass:[JHVotedTableViewCell class] forCellReuseIdentifier:@"JHVotedTableViewCell"];
        tableV;
    });
    
    [self addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (JHVoteFooterView *)footer {
    if (!_footer) {
        _footer = [[JHVoteFooterView alloc] init];
        _footer.frame = CGRectMake(0, 0, ScreenW, 80);
        _footer.delegate = self;
    }
    return _footer;
}

- (NSMutableArray *)optionIds {
    if (!_optionIds) {
        _optionIds = [NSMutableArray array];
    }
    return _optionIds;
}

#pragma mark -
#pragma mark - JHTableVIewFooter Delegate
-(void)commitVoteResult {
    if (![JHRootController isLogin]) {
        [JHRootController presentLoginVCWithTarget:[JHRootController currentViewController] complete:^(BOOL result) {}];
        return;
    }
    if (self.optionIds.count == 0) {
        [UITipView showTipStr:@"请选择您的投票~"];
        return;
    }
    
    @weakify(self);
    NSString *url = COMMUNITY_FILE_BASE_STRING(@"/auth/content/voteCommit");
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:_articleModel.item_id forKey:@"item_id"];
    [params setValue:self.optionIds forKey:@"option_ids"];
    [HttpRequestTool postWithURL:url Parameters:params requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel*respondObject) {
        @strongify(self);
        NSLog(@"投票成功");
        [self updateData:respondObject.data];
    } failureBlock:^(RequestModel *respondObject) {
        NSLog(@"投票失败");
        [UITipView showTipStr:respondObject.message];
    }];
}

///点击立即投票后更新数据
- (void)updateData:(id)data {
    if (![data isKindOfClass:[NSDictionary class]]) {
        return;
    }
    self.isVoted = YES;
    NSArray *voteArray = [JHOptionVoteModel mj_objectArrayWithKeyValuesArray:data[@"option_info"]];
    _articleModel.voteInfo.optionInfos = [NSArray arrayWithArray:voteArray.copy];
    _articleModel.voteInfo.is_voted = data[@"is_voted"];
    self.voteArray = [NSMutableArray arrayWithArray:_articleModel.voteInfo.optionInfos.copy];
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JHOptionVoteModel *model = self.voteArray[indexPath.row];
    if (self.isVoted) {
        static NSString *votedIdentifer = @"JHVotedTableViewCell";
        JHVotedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:votedIdentifer];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.optionInfo = model;
        return cell;
    }
    ///未投票的样式
    static NSString *normalIdentifer = @"JHNormalTableViewCell";
    JHNormalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:normalIdentifer];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.optionInfo = model;
    cell.delegate = self;
    return cell;
}

- (void)selectInfoVote:(JHOptionVoteModel *)model {
    if (_isVoted) {
        return;
    }
    ///多选
    NSInteger selectIndex = [self.voteArray indexOfObject:model];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:selectIndex inSection:0];
   if (_articleModel.voteInfo.vote_type == JHPicDetailVoteTypeMutiple) {
       model.isSelected = !model.isSelected;
       if (model.isSelected) {
           [self.optionIds addObject:model.optionId];
       }
       else {
          [self.optionIds removeObject:model.optionId];
       }
       NSLog(@"optionIds:-- %@", self.optionIds);
       [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
       return;
   }
   ///取消选中  单选
   JHOptionVoteModel *selModel = self.voteArray[_selectIndex];
   selModel.isSelected = [NSNumber numberWithBool:NO];
   _selectIndex = indexPath.row;
  
   ///选中当前的model
   JHOptionVoteModel *curModel = self.voteArray[indexPath.row];
   curModel.isSelected = !curModel.isSelected;
   self.optionIds = [NSMutableArray arrayWithArray:@[curModel.optionId]];
   [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_isVoted) {
        return;
    }
    ///多选
    if (_articleModel.voteInfo.vote_type == JHPicDetailVoteTypeMutiple) {
        JHOptionVoteModel *model = self.voteArray[indexPath.row];
        model.isSelected = !model.isSelected;
        if (model.isSelected) {
            [self.optionIds addObject:model.optionId];
        }
        else {
           [self.optionIds removeObject:model.optionId];
        }
        NSLog(@"optionIds:-- %@", self.optionIds);
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        return;
    }
    ///取消选中  单选
    JHOptionVoteModel *selModel = self.voteArray[_selectIndex];
    selModel.isSelected = [NSNumber numberWithBool:NO];
    _selectIndex = indexPath.row;
   
    ///选中当前的model
    JHOptionVoteModel *curModel = self.voteArray[indexPath.row];
    curModel.isSelected = !curModel.isSelected;
    self.optionIds = [NSMutableArray arrayWithArray:@[curModel.optionId]];
    [tableView reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.voteArray.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_isVoted) {
        return 46;
    }
    return 40;
}

- (NSMutableArray *)voteArray {
    if (!_voteArray) {
        _voteArray = [NSMutableArray array];
    }
    return _voteArray;
}

- (CGFloat)voteAllHeight {
    return self.tableView.contentSize.height+4;
}

#pragma mark -
#pragma mark - lazy loading


@end
