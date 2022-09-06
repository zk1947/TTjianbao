//
//  JHDraftBoxTextTableCell.m
//  TTjianbao
//
//  Created by jesee on 28/6/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHDraftBoxTextTableCell.h"
#import "JHImage.h"
#import "CommHelp.h"

@interface JHDraftBoxTextTableCell ()

@property (nonatomic, strong) JHDraftBoxModel* draftModel;
@end

@implementation JHDraftBoxTextTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.backgroundColor = HEXCOLORA(0xFFFFFF, 0);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
            make.top.equalTo(self);
        }];
        
        self.bgView = [UIButton buttonWithType:UIButtonTypeCustom];
        self.bgView.backgroundColor = HEXCOLOR(0xFFFFFF);
        self.bgView.userInteractionEnabled = NO;
        [self.contentView addSubview:self.bgView];
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(kVerticalMargin);
            make.left.right.bottom.equalTo(self.contentView);
        }];
        
        [self drawSubviews];
    }
    return self;
}

- (void)drawEditSubviews
{
    //编辑时,右移距离
    self.editingMargin = kEditingRightMargin;
    //编辑时,选中按钮
    self.editImage = [UIButton buttonWithType:UIButtonTypeCustom];
    self.editImage.userInteractionEnabled = NO;
    [self.editImage setImage:[JHImage imageScaleSize:CGSizeMake(kEditImageSize, kEditImageSize) image:@"icon_draft_edit_default"] forState:UIControlStateNormal];
    [self.bgView addSubview:self.editImage];
    [self.bgView addTarget:self action:@selector(selectCellStatus) forControlEvents:UIControlEventTouchUpInside];
    self.bgView.userInteractionEnabled = YES;
    [self.editImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(5);
        make.centerY.equalTo(self.bgView); //周围扩展10像素
        make.size.mas_equalTo(kEditImageSize + kVerticalMargin);
    }];
    
    //修改布局
    [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.editImage.mas_right).offset(5);
        make.bottom.equalTo(self.bgView).offset(0 - kLeftRightMargin);
        make.height.mas_equalTo(16);
    }];
}

- (void)drawSubviews
{
    self.timeLabel = [UILabel new];
    self.timeLabel.textColor = HEXCOLOR(0x999999);
    self.timeLabel.font = JHFont(11);
    self.timeLabel.textAlignment = NSTextAlignmentLeft;
    [self.bgView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(kLeftRightMargin);
        make.bottom.equalTo(self.bgView).offset(0 - kLeftRightMargin);
        make.height.mas_equalTo(16);
    }];
    
    self.contentLabel = [UILabel new];
    self.contentLabel.textColor = HEXCOLOR(0x333333);
    self.contentLabel.font = JHFont(16);
    self.contentLabel.numberOfLines = 3;
    self.contentLabel.textAlignment = NSTextAlignmentLeft;
    [self.bgView addSubview:self.contentLabel];
}

- (void)updateEditStatus
{
    if(self.draftModel.editSelected)
        [self.editImage setImage:[JHImage imageScaleSize:CGSizeMake(25, 25) image:@"icon_draft_edit_selected"] forState:UIControlStateNormal];
    else
        [self.editImage setImage:[JHImage imageScaleSize:CGSizeMake(25, 25) image:@"icon_draft_edit_default"] forState:UIControlStateNormal];
}

#pragma mark - event
- (void)updateData:(JHDraftBoxModel*)model
{
    self.draftModel = model;
    self.contentLabel.text = model.content;
    self.timeLabel.text = [CommHelp showTimeFromTimeInterval:model.time];
    [self updateEditStatus];
}

- (void)selectCellStatus
{
    if(self.editImage)
    {
        self.draftModel.editSelected = !self.draftModel.editSelected; //保存选中状态
        [self updateEditStatus];
        
        //回调
        if([self.delegate respondsToSelector:@selector(pressCellEvent)])
            [self.delegate pressCellEvent];
    }
}

@end
