//
//  JHSQHotCommentView.m
//  TTjianbao
//
//  Created by wuyd on 2020/7/1.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHSQHotCommentView.h"
#import "JHSQModel.h"
#import "JHHotCommentListView.h"

static NSInteger const commentCount_MAX = 3;

@interface JHSQHotCommentView ()
@property (nonatomic, copy) NSArray <JHCommentData *>*commentArray;
///评论的列表
@property (nonatomic, strong) NSMutableArray <JHHotCommentListView *>*commentPanels;
@end

@implementation JHSQHotCommentView

- (void)dealloc {
    NSLog(@"---%s被释放了🔥🔥🔥🔥---", __func__);
}

#pragma mark -
#pragma mark - setter / getter method

- (void)setPostData:(JHPostData *)postData {
    _postData = postData;
    _commentArray = _postData.hot_comments;
    
    for (int i = (int)_commentArray.count; i < commentCount_MAX; i ++) {
        JHHotCommentListView *panel = self.commentPanels[i];
        [panel.layer cancelCurrentImageRequest];
        panel.hidden = YES;
    }
    
    for (int i = 0; i < _commentArray.count; i ++) {
        JHHotCommentListView *panel = self.commentPanels[i];
        panel.hotComment = _commentArray[i];
        panel.showLine = (i != _commentArray.count - 1);
        panel.hidden = NO;
    }
    
    JHHotCommentListView *lastPanel = self.commentPanels[_commentArray.count - 1];
    [self setupAutoHeightWithBottomView:lastPanel bottomMargin:0];
    [self layoutIfNeeded];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = HEXCOLOR(0xF9FAF9);
        self.clipsToBounds = YES;
        self.sd_cornerRadius = @(8);
        
        [self initViews];
    }
    return self;
}

- (void)initViews {
    JHHotCommentListView *marginView = nil;
    for (int i = 0; i < commentCount_MAX; i ++) {
        JHHotCommentListView *hotCommentPanel = [[JHHotCommentListView alloc] init];
        [self addSubview:hotCommentPanel];
        [self.commentPanels addObject:hotCommentPanel];
        if (marginView == nil) {
            hotCommentPanel.sd_layout
            .leftSpaceToView(self, 10)
            .rightSpaceToView(self, 5)
            .topSpaceToView(self, 0)
            .autoHeightRatio(0);
        }
        else {
            hotCommentPanel.sd_layout
            .leftSpaceToView(self, 10)
            .rightSpaceToView(self, 5)
            .topSpaceToView(marginView, 0)
            .autoHeightRatio(0);
        }
        
        marginView = hotCommentPanel;
    }
}

- (NSMutableArray<JHHotCommentListView *> *)commentPanels {
    if (!_commentPanels) {
        _commentPanels = [NSMutableArray array];
    }
    return _commentPanels;
}
@end
