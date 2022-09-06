//
//  JHJHCustomServiceSearchHistoryCell.m
//  TTjianbao
//
//  Created by wangjianios on 2020/9/24.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomServiceSearchHistoryCell.h"

@implementation JHCustomServiceSearchHistoryCell

- (void)addSelfSubViews
{
    UIView *view = [UIView jh_viewWithColor:UIColor.whiteColor addToSuperview:self.contentView];
    [view jh_cornerRadius:13.5 borderColor:RGB(238,238,238) borderWidth:1];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    _wordLabel = [UILabel jh_labelWithFont:12 textColor:RGB515151 addToSuperView:view];
    [_wordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view).insets(UIEdgeInsetsMake(0, 14, 0, 14));
        make.width.mas_lessThanOrEqualTo(ScreenW - 48);
        make.height.mas_equalTo(27);
    }];
}

@end


@interface JHCustomServiceSearchHistoryHeader ()

@property (nonatomic, weak) UILabel *titleLabel;

@property (nonatomic, weak) UIButton *deleteButton;

@end

@implementation JHCustomServiceSearchHistoryHeader

- (void)addSelfSubViews
{
    _titleLabel = [UILabel jh_labelWithBoldFont:15 textColor:RGB515151 addToSuperView:self];
    _titleLabel.text = @"历史记录";
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.centerY.equalTo(self);
    }];
    
    _deleteButton = [UIButton jh_buttonWithImage:@"common_delete" target:self action:@selector(deleteMethod) addToSuperView:self];
    [_deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(44, 44));
        make.centerY.right.equalTo(self);
    }];
}

-(void)deleteMethod
{
    if(self.deleteBlock)
    {
        self.deleteBlock();
    }
}

-(void)setContentHidden:(BOOL)contentHidden
{
    _contentHidden = contentHidden;
    _titleLabel.hidden = contentHidden;
    _deleteButton.hidden = contentHidden;
}
@end

@implementation JHCustomServiceSearchHistoryFooter

@end


