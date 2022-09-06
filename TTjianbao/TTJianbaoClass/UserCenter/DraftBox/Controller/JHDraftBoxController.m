//
//  JHDraftBoxController.m
//  TTjianbao
//
//  Created by jesee on 28/6/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHDraftBoxController.h"
#import "JHDraftBoxView.h"
#import "JHDraftBoxModel.h"

#define kRightEditText @"编辑"
#define kRightFinishText @"完成"

@interface JHDraftBoxController ()

@property (nonatomic, strong) JHDraftBoxView* draftBox;
@property (nonatomic, strong) JHDraftBoxView* editDraftBox;
@property (nonatomic, assign) BOOL isFirstShow;
@end

@implementation JHDraftBoxController

- (void)dealloc
{
    NSLog(@"~~~dealloc !! ");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.isFirstShow = YES;
    [self setTitle:@"草稿"];
    [self initRightButtonWithName:kRightEditText action:@selector(rightActionButton:)];
    [self drawSubviews];
}
- (void)viewDidAppear:(BOOL)animated{
    if (_draftBox && !self.isFirstShow) {
        [_draftBox refreshView];
    }
    self.isFirstShow = NO;
}
#pragma mark - subviews
- (JHDraftBoxView *)draftBox
{
    if(!_draftBox)
    {
        _draftBox = [[JHDraftBoxView alloc] initWitEditType:NO];
    }
    return _draftBox;
}

- (JHDraftBoxView *)editDraftBox
{
    if(!_editDraftBox)
    {
        _editDraftBox = [[JHDraftBoxView alloc] initWitEditType:YES];
        JH_WEAK(self)
        _editDraftBox.finishAction = ^(id obj) {
            JH_STRONG(self)
            [self editDraftBoxHidden:YES]; //???
        };
    }
    return _editDraftBox;
}

- (void)drawSubviews
{
    [self.view addSubview: self.draftBox];
    [self.draftBox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.jhNavView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
}

- (void)editDraftBoxHidden:(BOOL)hidden
{
    if(hidden)
    {
        [self.jhRightButton setTitle:kRightEditText forState:UIControlStateNormal];
        [self.editDraftBox removeFromSuperview];
        self.editDraftBox = nil;
        [self.draftBox refreshView];
    }
    else
    {
        [self.jhRightButton setTitle:kRightFinishText forState:UIControlStateNormal];
        [self.view addSubview:self.editDraftBox];
        [self.editDraftBox mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.draftBox);
        }];
    }
}

#pragma mark - event
- (void)rightActionButton:(UIButton *)sender
{
    if([sender.titleLabel.text isEqualToString:kRightFinishText])
        [self editDraftBoxHidden:YES];
    else
        [self editDraftBoxHidden:NO];
}

@end
