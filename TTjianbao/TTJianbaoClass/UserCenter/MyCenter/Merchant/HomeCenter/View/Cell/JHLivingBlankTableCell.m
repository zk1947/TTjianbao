//
//  JHLivingBlankTableCell.m
//  TTjianbao
//
//  Created by lihui on 2021/4/10.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHLivingBlankTableCell.h"
#import "JHWebViewController.h"

@implementation JHLivingBlankTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = HEXCOLOR(0xF8F8F8);
        [self initViews];
    }
    return self;
}

- (void)initViews {
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_default_page"]];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:imgView];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"抱歉，您暂未开通直播服务哦~";
    label.font = [UIFont fontWithName:kFontNormal size:12.];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = kColor999;
    [self addSubview:label];
    
    UIButton *openButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [openButton setTitle:@"开通新服务" forState:UIControlStateNormal];
    [openButton setTitleColor:kColor333 forState:UIControlStateNormal];
    openButton.titleLabel.font = [UIFont fontWithName:kFontNormal size:14.];
    openButton.backgroundColor = HEXCOLOR(0xFFD70F);
    openButton.layer.cornerRadius = 5.f;
    openButton.layer.masksToBounds = YES;
    [self addSubview:openButton];
    [openButton addTarget:self action:@selector(openNewService) forControlEvents:UIControlEventTouchUpInside];
    
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(92);
        make.size.mas_equalTo(CGSizeMake(90, 72));
        make.centerX.equalTo(self);
    }];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(imgView.mas_bottom).offset(15);
    }];
    
    [openButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(label.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(102, 36));
    }];
}

#pragma mark - action event

- (void)openNewService {
    JHWebViewController *vc = [[JHWebViewController alloc] init];
    vc.urlString = H5_BASE_STRING(@"/jianhuo/app/recycle/applyBusiness.html");
    [JHRootController.currentViewController.navigationController pushViewController:vc animated:YES];
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
