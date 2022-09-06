//
//  JHEvaluateReportViewCell.m
//  TTjianbao
//
//  Created by Jesse on 2020/7/9.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHEvaluateReportViewCell.h"

@interface JHEvaluateReportViewCell ()
{
    UIButton* titleBtn;
    JHEvaluateReportTagsModel* tagsModel;
}
@end

@implementation JHEvaluateReportViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.layer.cornerRadius = 15;
        self.layer.borderColor = HEXCOLORA(0xBDBFC2, 1).CGColor;
        self.layer.borderWidth = 0.5;
        self.layer.masksToBounds = YES;
        self.selectedBackgroundView = [UIView new];
        self.selectedBackgroundView.backgroundColor = HEXCOLOR(0xFFFFFF);
        
        titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        titleBtn.backgroundColor = [UIColor clearColor];
        titleBtn.titleLabel.font = JHFont(13);
        [titleBtn setTitleColor:HEXCOLOR(0x999999) forState:UIControlStateNormal];
        [self.contentView addSubview:titleBtn];
        [titleBtn addTarget:self action:@selector(pressTitleAction) forControlEvents:UIControlEventTouchUpInside];
        [titleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.contentView);
        }];
    }
    return self;
}

- (void)setCellSelectedStatus
{
    self.selected = tagsModel.selected;
    if(tagsModel.selected)
    {
        self.selectedBackgroundView.backgroundColor = HEXCOLOR(0xFFFDF1);
        self.layer.borderColor = HEXCOLORA(0xFEE100, 1).CGColor;
        [titleBtn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    }
    else
    {
        self.selectedBackgroundView.backgroundColor = HEXCOLOR(0xFFFFFF);
        self.layer.borderColor = HEXCOLORA(0xBDBFC2, 1).CGColor;
        [titleBtn setTitleColor:HEXCOLOR(0x999999) forState:UIControlStateNormal];
    }
}

- (void)updateData:(JHEvaluateReportTagsModel*)model
{
    tagsModel = model;
    [titleBtn setTitle:model.name forState:UIControlStateNormal];
    [self setCellSelectedStatus];
}

- (void)pressTitleAction
{
    tagsModel.selected = !tagsModel.selected;
    [self setCellSelectedStatus];
    if([self.mDelegate respondsToSelector:@selector(pressTitleAction)])
    {
        [self.mDelegate pressTitleAction];
    }
        
}

@end
