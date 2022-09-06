//
//  JHPublishSelectTopicController.m
//  TTjianbao
//
//  Created by jesee on 17/6/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHPublishSelectTopicController.h"
#import "JHPublishSearchTopicController.h"
#import "JHSearchView.h"
#import "JHPublishTopicModel.h"
#import "JHPublishSelectTopicView.h"
#import "UIResponder+NTESFirstResponder.h"

@interface JHPublishSelectTopicController ()<JHSearchViewDelegate>
{
    BOOL validNotify; //通知有效
}
@property (nonatomic, strong) JHSearchView* searchView;
@property (nonatomic, strong) JHPublishSelectTopicView* contentView;
@property (nonatomic, strong) JHPublishTopicModel* topicData;
@end

@implementation JHPublishSelectTopicController

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"~~~dealloc!!");
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    validNotify = YES;
    [_searchView dismissSearchKeyboard]; //键盘主动消失
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    validNotify = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self drawNavSearchView];
    [self drawContentView];
    //请求数据
    [self requestData];
}

- (void)drawNavSearchView
{
    [self.jhNavView addSubview:self.searchView];
    [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.jhNavView).offset(50);
        make.right.equalTo(self.jhNavView);
        make.centerY.equalTo(self.jhLeftButton);
        make.height.mas_equalTo(40);
    }];
}

- (void)drawContentView
{
    [self.view addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.jhNavBottomLine.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
}

#pragma mark - subviews
- (JHSearchView *)searchView
{
    if(!_searchView)
    {
        _searchView = [[JHSearchView alloc] initWithShow:JHSearchShowTypeRightFinish];
        _searchView.delegate = self;
    }
    return _searchView;
}

- (JHPublishSelectTopicView *)contentView
{
    if(!_contentView)
    {
        _contentView = [JHPublishSelectTopicView new];
    }
    return _contentView;
}

#pragma mark - request
- (JHPublishTopicModel *)topicData
{
    if(!_topicData)
    {
        _topicData = [JHPublishTopicModel new];
    }
    return _topicData;
}

- (void)requestData
{
    JH_WEAK(self)
    [self.topicData requestTopicDataResponse:^(id respData, NSString *errorMsg) {
        JH_STRONG(self)
        if(errorMsg)
        {
            [SVProgressHUD showErrorWithStatus:errorMsg];
        }
        [self.contentView updateTopicData:self.topicData];
    }];
}

- (void)prepareSelectedTopicArray:(NSArray*)selectedArray
{
    self.topicData.selectedArray = [NSMutableArray arrayWithArray:selectedArray];
}

#pragma mark - event
- (void)activeButtonEvents:(JHSearchShowType)type keyword:(NSString*)keyword
{
    if(type == JHSearchShowTypeRightFinish)
    {
        [self backToPublishPageWithModel:nil];
    }
}

- (void)searchViewBeginEditing:(BOOL)editing
{
    if(editing && validNotify)
    {
        validNotify = NO;
        JHPublishSearchTopicController* publishSearch = [JHPublishSearchTopicController new];
        JH_WEAK(self)
        publishSearch.selectedTopicBlock = ^(JHPublishTopicDetailModel* model) {
            JH_STRONG(self)
            [self.contentView updateSelectedArray:model];
        };
        [self.navigationController pushViewController:publishSearch animated:NO];
    }
}

- (void)backToPublishPageWithModel:(id)sender
{
    NSArray* selectedArray = [self.contentView topicSelectedArray];
    if(_selectDataBlock)
    {
        _selectDataBlock(selectedArray);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
