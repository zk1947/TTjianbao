//
//  JHMallGroupConditionView.m
//  TTjianbao
//
//  Created by apple on 2020/3/26.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//
#import "JHMallGroupConditionController.h"
#import "JHMallGroupConditionView.h"
@interface JHMallGroupConditionView ()

@property (nonatomic, weak) UILabel *titleLabel;

@property (nonatomic, weak) UILabel *descLabel;

@property (nonatomic, weak) UIImageView *imageView;

@end

@implementation JHMallGroupConditionView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickMethod)]];
        [self addSelfView];
    }
    return self;
}

-(void)addSelfView
{
    _titleLabel = [UILabel jh_labelWithBoldFont:15 textColor:UIColor.blackColor addToSuperView:self];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self).offset(15);
        make.width.mas_equalTo(ScreenW/2.f - 110);
    }];
    
    _descLabel = [UILabel jh_labelWithFont:12 textColor:RGB(153, 153, 153) addToSuperView:self];
    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(7);
        make.width.equalTo(self.titleLabel);
    }];
    
    _imageView = [UIImageView jh_imageViewAddToSuperview:self];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-10);
        make.top.equalTo(self).offset(0.5);
        make.width.height.mas_equalTo([JHMallGroupConditionView viewSize].height - 1);
    }];
}

-(void)setModel:(JHMallGroupConditionModel *)model
{
    _model = model;
    
    _descLabel.text = _model.desc;
    
    _titleLabel.text = _model.name;
    
    [_imageView jh_setImageWithUrl:_model.iconUrl];
}
-(void)clickMethod
{
    JHMallGroupConditionController *vc = [JHMallGroupConditionController new];
    vc.groupIdArray = self.model.groupIds;
    vc.title = self.model.name;
    [self.viewController.navigationController pushViewController:vc animated:YES];
}

+(CGSize)viewSize
{
    return CGSizeMake(ScreenW/2.f-10, 67.5);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
