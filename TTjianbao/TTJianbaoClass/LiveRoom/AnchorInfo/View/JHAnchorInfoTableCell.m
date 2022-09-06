//
//  JHAnchorInfoTableCell.m
//  TTjianbao
//
//  Created by lihui on 2020/7/16.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHAnchorInfoTableCell.h"
#import "JHLiveStatusView.h"
#import "JHLiveRoomModel.h"
#import "UIImageView+JHWebImage.h"
#import "TTjianbaoMarcoUI.h"

#define space  10

@interface JHAnchorInfoTableCell ()

///主播头像
@property (nonatomic, strong) UIImageView *iconImagView;
///直播间名称
@property (nonatomic, strong) UILabel *nameLabel;
///直播间介绍描述
@property (nonatomic, strong) UILabel *descLabel;
///编辑按钮
@property (nonatomic, strong) UIButton *editButton;
///删除按钮
@property (nonatomic, strong) UIButton *deleteButton;
///开播
@property (nonatomic, strong) UIButton *playButton;


@property (nonatomic, strong) JHLiveStatusView *statusView;

@end

@implementation JHAnchorInfoTableCell

- (void)setAnchorInfo:(JHAnchorInfo *)anchorInfo {
    if (!anchorInfo) {
        return;
    }
    
    _anchorInfo = anchorInfo;
    [_iconImagView jhSetImageWithURL:[NSURL URLWithString:_anchorInfo.avatar] placeholder:kDefaultAvatarImage];
    _nameLabel.text = _anchorInfo.nick?:@"暂无昵称";
    _descLabel.text = _anchorInfo.des;
    [_statusView setLiveStatus:2 watchTotal:nil];
    _statusView.hidden = !_anchorInfo.liveState;
    _playButton.selected = _anchorInfo.liveState;
    
    ///isAnchor 如果是yes标识当前是助理 需要显示按钮 反之不显示
    _playButton.hidden = !_isAnchor;
    _deleteButton.hidden = !_isAnchor;
    _editButton.hidden = !_isAnchor;
    
//    _nameLabel.adjustsFontSizeToFitWidth = YES;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    UIImageView *iconImage = [[UIImageView alloc] initWithImage:kDefaultAvatarImage];
    iconImage.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:iconImage];
    _iconImagView = iconImage;
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = @"暂无昵称";
    nameLabel.font = [UIFont fontWithName:kFontMedium size:15];
    [self.contentView addSubview:nameLabel];
    _nameLabel = nameLabel;
    
    JHLiveStatusView *statusView = [[JHLiveStatusView alloc] init];
    [self.contentView addSubview:statusView];
    [_statusView setLiveStatus:2 watchTotal:nil];
    _statusView = statusView;
    _statusView.fontSize = 9.f;
    _statusView.hidden = YES;
    
    UIButton *playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [playButton setTitle:@"开播" forState:UIControlStateNormal];
    [playButton setTitle:@"下播" forState:UIControlStateSelected];
    [playButton setTitleColor:HEXCOLOR(0x408FFE) forState:UIControlStateNormal];
    playButton.titleLabel.font = [UIFont fontWithName:kFontMedium size:14];
    [self.contentView addSubview:playButton];
    _playButton = playButton;
    _playButton.hidden = YES;
    [playButton addTarget:self action:@selector(playButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [editBtn setTitleColor:HEXCOLOR(0x408FFE) forState:UIControlStateNormal];
    editBtn.titleLabel.font = [UIFont fontWithName:kFontMedium size:14];
    [self.contentView addSubview:editBtn];
    _editButton = editBtn;
    _editButton.hidden = YES;
    [editBtn addTarget:self action:@selector(editBtnEvent) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [deleteBtn setTitleColor:HEXCOLOR(0x408FFE) forState:UIControlStateNormal];
    deleteBtn.titleLabel.font = [UIFont fontWithName:kFontMedium size:14];
    [self.contentView addSubview:deleteBtn];
    _deleteButton = deleteBtn;
    _deleteButton.hidden = YES;
    [deleteBtn addTarget:self action:@selector(deleteEvent) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *descLabel = [[UILabel alloc] init];
    descLabel.text = @"暂无介绍";
    descLabel.font = [UIFont fontWithName:kFontNormal size:12.f];
    descLabel.textColor = kColor666;
    [self.contentView addSubview:descLabel];
    descLabel.numberOfLines = 0;
    descLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _descLabel = descLabel;

    [self makeLayouts];
}


- (void)playButtonEvent {
    if (![JHRootController isLogin]) {
        [JHRootController presentLoginVC:^(BOOL result) {
        }];
        return;
    }
    
    self.playButton.selected = !self.playButton.selected;
    if (self.eventBlock) {
        self.eventBlock(self.indexPath.row ,self.anchorInfo, JHAnchorEventTypeSetPlay);
    }
}

- (void)editBtnEvent {
    if (![JHRootController isLogin]) {
        [JHRootController presentLoginVC:^(BOOL result) {
            
        }];
        return;
    }
    
    if (self.eventBlock) {
        self.eventBlock(self.indexPath.row ,self.anchorInfo, JHAnchorEventTypeEdit);
    }
}

- (void)deleteEvent {
    if (![JHRootController isLogin]) {
        [JHRootController presentLoginVC:^(BOOL result) {
            
        }];
        return;
    }
    
    if (self.eventBlock) {
        self.eventBlock(self.indexPath.row ,self.anchorInfo, JHAnchorEventTypeDelete);
    }
}

- (void)makeLayouts {
    [_deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-10);
        make.top.equalTo(self.contentView).offset(15);
    }];
    
    [_editButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.deleteButton.mas_left).offset(-space);
        make.centerY.equalTo(self.deleteButton);
    }];
    
    [_playButton mas_makeConstraints:^(MASConstraintMaker *make)  {
        make.right.equalTo(self.editButton.mas_left).offset(-space);
        make.centerY.equalTo(self.editButton);
    }];
    
    [_iconImagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.centerY.equalTo(self.deleteButton);
        make.size.mas_equalTo(CGSizeMake(26, 26));
    }];
    
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImagView.mas_right).offset(7);
        make.centerY.equalTo(self.deleteButton);
//        make.width.lessThanOrEqualTo(@110);
    }];
    
    [_statusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameLabel);
        make.left.equalTo(self.nameLabel.mas_right).offset(5);
        make.height.mas_equalTo(16);
    }];

    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImagView.mas_bottom).offset(10);
        make.left.equalTo(self.iconImagView);
        make.right.equalTo(self.contentView).offset(-10);
        make.bottom.equalTo(self.contentView).offset(-15);
    }];
    
    [self layoutIfNeeded];
    _iconImagView.layer.cornerRadius = 13.f;
    _iconImagView.layer.masksToBounds = YES;
    _iconImagView.clipsToBounds = YES;
    _statusView.layer.cornerRadius = _statusView.height/2.f;
    _statusView.layer.masksToBounds = YES;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
