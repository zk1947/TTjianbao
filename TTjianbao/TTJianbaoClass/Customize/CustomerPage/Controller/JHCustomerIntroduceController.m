//
//  JHCustomerIntroduceController.m
//  TTjianbao
//
//  Created by lihui on 2020/11/3.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomerIntroduceController.h"
#import "JHCustomerBriefController.h"
#import "TTjianbao.h"
#import "JHLiveRoomModel.h"
#import "UIScrollView+JHEmpty.h"

@interface JHCustomerIntroduceController ()
///定制师的名字
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UITextView *descTextView;
@property (nonatomic, strong) UILabel *reviewStatusView;
@end

@implementation JHCustomerIntroduceController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColorFFF;
    [self configNav];
    [self configUI];
    [self reviewStatus];
}

- (void)configNav {
    self.jhTitleLabel.text = [self.roomInfo.name isNotBlank] ? self.roomInfo.name : @"暂无昵称";
    self.jhNavBottomLine.hidden = NO;
    [self initRightButtonWithName:@"编辑" action:@selector(handleEditEvent)];
    ///是否显示编辑按钮 需要看是否是定制师或者定制师助理
    self.jhRightButton.hidden = !self.roomInfo.showButton;
}

- (void)configUI {
    if (isEmpty(self.roomInfo.customizeIntro)) {
        JHEmptyView *emptyView = [[JHEmptyView alloc] init];
        emptyView.textLabel.text = @"暂无介绍~";
        [self.view addSubview:emptyView];
        [emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(self.view);
            make.top.equalTo(self.jhNavView.mas_bottom);
            make.left.right.bottom.equalTo(self.view);
        }];
        return;
    }
    
    _reviewStatusView = ({
        UILabel *reviewStatusView = [[UILabel alloc] init];
        reviewStatusView.backgroundColor = HEXCOLOR(0xFFEDE7);
        reviewStatusView.textAlignment = NSTextAlignmentCenter;
        reviewStatusView.font = [UIFont fontWithName:kFontNormal size:12];
        reviewStatusView.textColor = HEXCOLOR(0xFF4200);
        reviewStatusView;
    });
    
    
    _nameLabel = ({
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.text = @"个人介绍";
        nameLabel.font = [UIFont fontWithName:kFontMedium size:18];
        nameLabel.textColor = kColor333;
        nameLabel;
    });
    
    _descTextView = ({
        UITextView *descTextView = [[UITextView alloc] init];
        descTextView.text = [self.roomInfo.customizeIntro isNotBlank] ? self.roomInfo.customizeIntro : @"暂无介绍~";
        descTextView.font = [UIFont fontWithName:kFontNormal size:15];
        descTextView.textColor = kColor666;
        descTextView.userInteractionEnabled = NO;
        descTextView;
    });
    
    [self.view addSubview:_reviewStatusView];
    [self.view addSubview:_nameLabel];
    [self.view addSubview:_descTextView];
    
    [_reviewStatusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.jhNavView.mas_bottom).offset(2);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(37.f);
    }];

    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view).offset(15);
        make.trailing.equalTo(self.view).offset(-15);
        make.top.equalTo(self.reviewStatusView.mas_bottom).offset(20);
    }];
    
    [_descTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.nameLabel);
        make.top.equalTo(self.nameLabel.mas_bottom);
        make.bottom.equalTo(self.view).offset(-UI.bottomSafeAreaHeight-10);
    }];
    
    _reviewStatusView.hidden = YES;
}

- (void)reviewStatus {
    if (self.roomInfo.showButton) {
        /// 表示主播自己,
        if (self.roomInfo.introStatus == 2) { /// 0-待审核、1-通过、2-不通过
            self.jhRightButton.hidden = NO;
            self.reviewStatusView.hidden = NO;
            self.reviewStatusView.text = NONNULL_STR(self.roomInfo.reason);
            [self.reviewStatusView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.jhNavView.mas_bottom).offset(2);
                make.height.mas_equalTo(37.f);
            }];
        } else {
            self.jhRightButton.hidden = YES;
            self.reviewStatusView.hidden = YES;
            [self.reviewStatusView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.jhNavView.mas_bottom).offset(0.f);
                make.height.mas_equalTo(0.f);
            }];
        }
    } else {
        self.reviewStatusView.hidden = YES;
        [self.reviewStatusView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.jhNavView.mas_bottom).offset(0.f);
            make.height.mas_equalTo(0.f);
        }];
    }
}




- (void)handleEditEvent {
    NSLog(@"--- handleEditEvent ---");
    ///编辑定制师说明
    NSString *vcName = self.isRecycle?@"JHRecycleInfoViewController":@"JHCustomerInfoController";
    [JHRootController toNativeVC:NSStringFromClass([JHCustomerBriefController class])
                       withParam:@{
                           @"isRecycle":@(self.isRecycle),
                           @"channelLocalId":self.roomInfo.channelLocalId,
                           @"text":self.roomInfo.customizeIntro,
                           @"callbackMethod":self.updateBlock,
                           @"vcName":vcName}
                            from:JHLiveFromCustomizeHomePage];
}

@end
