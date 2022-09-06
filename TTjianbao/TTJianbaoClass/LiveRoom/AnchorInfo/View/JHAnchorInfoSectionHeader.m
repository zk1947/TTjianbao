//
//  JHAnchorInfoSectionHeader.m
//  TTjianbao
//
//  Created by lihui on 2020/7/17.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHAnchorInfoSectionHeader.h"
#import "UIImageView+JHWebImage.h"
#import "JHLiveRoomModel.h"
#import <YYKit/YYKit.h>

@interface JHAnchorInfoSectionHeader ()

///直播图标
@property (nonatomic, strong) UIImageView *liveIcon;
///直播间名称
@property (nonatomic, strong) UILabel *liveNameLabel;
///直播间介绍描述
@property (nonatomic, strong) YYLabel *descLabel;
///编辑按钮
@property (nonatomic, strong) UIButton *editButton;
///删除按钮
@property (nonatomic, strong) UIButton *deleteButton;


@end
 
@implementation JHAnchorInfoSectionHeader


- (void)setRoomInfo:(JHLiveRoomModel *)roomInfo {
    if (!roomInfo) {
        return;
    }
    _roomInfo = roomInfo;
    if (_roomInfo.showButton && self.type == JHArchorSectionTypeLiveRoom) {
        if ([_roomInfo.roomDes isNotBlank]) {
            _editButton.hidden = NO;
            _deleteButton.hidden = NO;
        }
        else {
            _editButton.hidden = YES;
            _deleteButton.hidden = YES;
        }
    }
    else {
        _editButton.hidden = YES;
        _deleteButton.hidden = YES;
    }
}


- (void)setTitle:(NSString *)title {
    if (!title) {
        return;
    }
    _title = title;
    _liveNameLabel.text = _title;
}

- (void)setHeaderIcon:(NSString *)headerIcon {
    if (!headerIcon) {
        return;
    }
    _headerIcon = headerIcon;
    
    if ([_headerIcon hasPrefix:@"http"]) {
        [_liveIcon jhSetImageWithURL:[NSURL URLWithString:_headerIcon]];
    }
    else {
        _liveIcon.image = [UIImage imageNamed:_headerIcon];
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
    }
    return self;
}

- (void)setTitle:(NSString *)title HeaderIcon:(NSString *)headerIcon {
    self.title = title;
    self.headerIcon = headerIcon;
}

- (void)initViews {
    
    UIImageView *liveIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_anchor_living"]];
    liveIcon.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:liveIcon];
    _liveIcon = liveIcon;
    
    UILabel *liveLabel = [[UILabel alloc] init];
    liveLabel.text = @"--";
    liveLabel.font = [UIFont fontWithName:kFontMedium size:15];
    [self addSubview:liveLabel];
    _liveNameLabel = liveLabel;
    
    UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [editBtn setTitleColor:HEXCOLOR(0x408FFE) forState:UIControlStateNormal];
    editBtn.titleLabel.font = [UIFont fontWithName:kFontMedium size:14];
    [self addSubview:editBtn];
    _editButton = editBtn;
    _editButton.hidden = YES;
    [editBtn addTarget:self action:@selector(editBtnEvent) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [deleteBtn setTitleColor:HEXCOLOR(0x408FFE) forState:UIControlStateNormal];
    deleteBtn.titleLabel.font = [UIFont fontWithName:kFontMedium size:14];
    [self addSubview:deleteBtn];
    _deleteButton = deleteBtn;
    _deleteButton.hidden = YES;
    [deleteBtn addTarget:self action:@selector(deleteEvent) forControlEvents:UIControlEventTouchUpInside];
      
    [self makeLayouts];
}

- (void)makeLayouts {
    [_liveNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(40);
        make.top.equalTo(self).offset(15);
        make.right.equalTo(self);
    }];

    [_liveIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(13);
        make.centerY.equalTo(self.liveNameLabel);
        make.size.mas_equalTo(CGSizeMake(21, 21));
    }];
    
    [_deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-10);
        make.centerY.equalTo(self.liveNameLabel);
    }];
    
    [_editButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.deleteButton.mas_left).offset(-50);
        make.centerY.equalTo(self.deleteButton);
    }];
}


#pragma mark -
#pragma mark - action event
///编辑
- (void)editBtnEvent {
    NSLog(@"editBtnEvent");
    if (![JHRootController isLogin]) {
        [JHRootController presentLoginVC:^(BOOL result) {
            
        }];
        return;
    }
    
    if (self.editBlock) {
        self.editBlock(self.type);
    }
}

///删除
- (void)deleteEvent {
    NSLog(@"deleteEvent");
    if (![JHRootController isLogin]) {
        [JHRootController presentLoginVC:^(BOOL result) {
            
        }];
        return;
    }
    
    if (self.deleteBlock) {
        self.deleteBlock(self.type);
    }
}

@end
