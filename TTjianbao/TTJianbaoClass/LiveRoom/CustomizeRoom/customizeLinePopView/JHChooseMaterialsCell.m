//
//  JHChooseMaterialsCell.m
//  TTjianbao
//
//  Created by apple on 2020/11/3.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHChooseMaterialsCell.h"
#import "UIImageView+WebCache.h"
#import "JHMeterialsCategoryModel.h"

@interface JHChooseMaterialsCell ()
@property (strong, nonatomic)  UIImageView *coverImage;
@property (strong, nonatomic)  UILabel* title;
@property (strong, nonatomic)  UIButton* chooseBtn;

@property (strong, nonatomic)  UILabel* bgLabel;
@end

@implementation JHChooseMaterialsCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 8;
        self.layer.masksToBounds = YES;
        
        _coverImage = [[UIImageView alloc] init];
        _coverImage.contentMode = UIViewContentModeScaleAspectFill;
        _coverImage.clipsToBounds = YES;
         [self.contentView addSubview:_coverImage];

        [_coverImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.contentView);
        }];

        _title = [[UILabel alloc] init];
        _title.backgroundColor = HEXCOLORA(0x000000, .4);
        _title.textAlignment = NSTextAlignmentCenter;
        _title.font = JHMediumFont(12);
        _title.textColor = HEXCOLOR(0xFFFFFF);
        _title.numberOfLines = 1;
        [self.contentView addSubview:_title];
        [_title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(23);
            make.bottom.equalTo(_coverImage.mas_bottom);
            make.left.right.equalTo(_coverImage);
        }];

        _chooseBtn = [[UIButton alloc] init];
        _chooseBtn.backgroundColor = [UIColor clearColor];
        [_chooseBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
        [_chooseBtn setImage:[UIImage imageNamed:@"customizeagreeBtnNormal"] forState:UIControlStateNormal];
        [_chooseBtn setImage:[UIImage imageNamed:@"customizeagreeBtnSelect"] forState:UIControlStateSelected];
        _chooseBtn.userInteractionEnabled = NO;
//        [_chooseBtn addTarget:self action:@selector(chooseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_chooseBtn];
        [self.chooseBtn  mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.equalTo(@0);
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];
        
        
        self.bgLabel = [[UILabel alloc] init];
        self.bgLabel.backgroundColor = HEXCOLORA(0xDDDDDD, .8);
        self.bgLabel.textAlignment = NSTextAlignmentCenter;
        self.bgLabel.font = JHFont(12);
        self.bgLabel.textColor = HEXCOLOR(0x666666);
        self.bgLabel.numberOfLines = 0;
        [self.contentView addSubview:self.bgLabel];
        [self.bgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.contentView);
        }];
    }
    return self;
}
- (void)chooseBtnClick:(UIButton *)sender{
    _chooseBtn.selected = !sender.selected;
}
- (void)setRecordModel:(JHMeterialsCategoryModel *)model andNullTitle:(NSString *)title andprocess:(NSString *)process{

    _chooseBtn.selected = model.isSelect;
    [_coverImage sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:@"cover_default_list"]];
    _title.text = model.name;
    if ([process isEqualToString:@"first"]) {
        if (model.supportFlag) {
            self.bgLabel.hidden = YES;
        }else{
            self.bgLabel.hidden = NO;
            self.bgLabel.text = title;
        }
    }else{
        if (model.customizeFlag) {
            self.bgLabel.hidden = YES;
        }else{
            self.bgLabel.hidden = NO;
            self.bgLabel.text = title;
        }
    }
    
}

@end
