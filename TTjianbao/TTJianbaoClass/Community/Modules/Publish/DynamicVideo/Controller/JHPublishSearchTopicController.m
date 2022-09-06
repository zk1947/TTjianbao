//
//  JHPublishSearchTopicController.m
//  TTjianbao
//
//  Created by jesee on 17/6/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHPublishSearchTopicController.h"
#import "JHSearchView.h"
#import "JHPublishTopicModel.h"
#import "JHPublishSearchTopicView.h"
#import "JHGrowingIO.h"

@interface JHPublishSearchTopicController () <JHSearchViewDelegate>

@property (nonatomic, strong) JHSearchView* searchView;
@property (nonatomic, strong) JHPublishSearchTopicView* contentView;
@property (nonatomic, strong) JHPublishTopicDetailModel* topicSearchData;
@end

@implementation JHPublishSearchTopicController

-(void)dealloc
{
    NSLog(@"~~~dealloc!!");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self jhNavBottomLine];
    [self drawNavSearchView];
    [self drawContentView];
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
    [self.searchView showSearchKeyboard]; //键盘主动显示
}

- (void)drawContentView
{
    [self.view addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.jhNavBottomLine.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    JH_WEAK(self)
    self.contentView.searchTopicBlock = ^(JHPublishTopicDetailModel*model) {
        JH_STRONG(self)
        [self backSelectTopicPage:model];
    };
}

#pragma mark - subviews
- (JHSearchView *)searchView
{
    if(!_searchView)
    {
        _searchView = [[JHSearchView alloc] initWithShow:JHSearchShowTypeRightCancel];
        _searchView.delegate = self;
    }
    return _searchView;
}

- (JHPublishSearchTopicView *)contentView
{
    if(!_contentView)
    {
        _contentView = [JHPublishSearchTopicView new];
    }
    return _contentView;
}

#pragma mark - request
- (JHPublishTopicDetailModel *)topicSearchData
{
    if(!_topicSearchData)
    {
        _topicSearchData = [JHPublishTopicDetailModel new];
    }
    return _topicSearchData;
}

#pragma mark - event
- (void)searchViewChangeText:(NSString*)text
{
    if(text)
    {
        JH_WEAK(self)
        [self.topicSearchData requestTopicKeyword:text response:^(NSMutableArray* array, NSString *errorMsg) {
            JH_STRONG(self)
            if(errorMsg)
            {
                //donothing
            }
            else
            {//editing
                [self.contentView updateData:array];
            }
        }];
        [JHGrowingIO trackEventId:JHSQPublishSeleteTopicSearchClick];
    }
}

- (void)activeButtonEvents:(JHSearchShowType)type keyword:(NSString*)keyword
{
    if(type == JHSearchShowTypeDefault)
    {
        [self searchAction:keyword]; //键盘search
    }
    else
    {
        [self backSelectTopicPage:nil];
    }
}

- (void)backActionButton:(UIButton *)sender
{
    [self backSelectTopicPage:nil];
}

- (void)searchAction:(NSString*)text
{
    //search result
}

- (void)backSelectTopicPage:(JHPublishTopicDetailModel*)model
{
    if(self.selectedTopicBlock && model)
        self.selectedTopicBlock(model);
    [self.navigationController popViewControllerAnimated:NO];
}

@end
