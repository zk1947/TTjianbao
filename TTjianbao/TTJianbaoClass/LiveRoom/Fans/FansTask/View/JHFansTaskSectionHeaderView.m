//
//  JHFansTaskSectionHeaderView.m
//  TTjianbao
//
//  Created by jiangchao on 2021/3/16.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHFansTaskSectionHeaderView.h"
#import "TTjianbaoHeader.h"
#import "JHUIFactory.h"
#import "JHFansClubModel.h"



@interface JHFansTaskSectionHeaderView ()
{
}
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UILabel *descLabel;
@end

@implementation JHFansTaskSectionHeaderView

-(void)addSelfSubViews
{
    self.contentView.backgroundColor = [UIColor clearColor];
    [self setUpSubViews];
}
-(void)setUpSubViews{
    
    _titleLabel=[[UILabel alloc]init];
    _titleLabel.text=@"粉丝任务";
    _titleLabel.font=[UIFont fontWithName:kFontMedium size:15];
    _titleLabel.textColor=kColor333;
    _titleLabel.numberOfLines = 1;
    _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_titleLabel];
    
    _descLabel=[[UILabel alloc]init];
    _descLabel.text=@"";
    _descLabel.font=[UIFont fontWithName:kFontMedium size:13];
    _descLabel.textColor=kColor333;
    _descLabel.numberOfLines = 1;
    _descLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _descLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_descLabel];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(12);
        make.left.equalTo(self.contentView).offset(10);
    }];
    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_titleLabel);
        make.left.equalTo(_titleLabel.mas_right).offset(10);
    }];
    
}
-(void)setCurrentTime:(NSString *)currentTime{
    
    _currentTime = currentTime;
    _descLabel.text = [NSString stringWithFormat:@"(%@)",_currentTime?:@""];
}

- (void)setFansClubModel:(JHFansClubModel *)fansClubModel{
    _fansClubModel = fansClubModel;
    if (fansClubModel.freezeExpDesc.length) {
        [self.contentView addSubview:self.freezView];
        CGFloat height = fansClubModel.freezeUnfloderHeight;
        [self.freezView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.left.right.equalTo(self.contentView);
            make.height.mas_equalTo(height);
        }];
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.freezView.mas_bottom).offset(12);
            make.left.equalTo(self.contentView).offset(10);
        }];
        [self.descLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_titleLabel);
            make.left.equalTo(_titleLabel.mas_right).offset(10);
        }];
        self.freezView.fansClubModel = fansClubModel;
    }else{
        [self.freezView removeFromSuperview];
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(12);
            make.left.equalTo(self.contentView).offset(10);
        }];
        [self.descLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_titleLabel);
            make.left.equalTo(_titleLabel.mas_right).offset(10);
        }];
    }
    
}


- (JHFansFreezView *)freezView{
    if (!_freezView) {
        JHFansFreezView *view = [JHFansFreezView new];
        _freezView = view;
    }
    return _freezView;
}


@end
