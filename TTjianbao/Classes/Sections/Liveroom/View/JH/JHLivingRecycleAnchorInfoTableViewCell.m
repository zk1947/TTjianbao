//
//  JHLivingRecycleAnchorInfoTableViewCell.m
//  TTjianbao
//
//  Created by user on 2021/4/10.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHLivingRecycleAnchorInfoTableViewCell.h"

@interface JHLivingRecycleAnchorInfoTableViewCell () {
    UIImageView *imgHeader; //bg
    UIImageView *imgAvatar;
    UIImageView *imgView;
    UILabel     *titleLabel;
    UILabel     *infoLabel;
}
@end

@implementation JHLivingRecycleAnchorInfoTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor]; //cell透明,使用imgHeader的圆角
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    //bg header
    imgHeader = [[UIImageView alloc] init];//
    imgHeader.layer.cornerRadius = 8;
    imgHeader.layer.masksToBounds = YES;
    imgHeader.contentMode = UIViewContentModeScaleAspectFill;
    UIImage *image = [UIImage imageNamed:@"room_left_liveroom_bg"];
    [imgHeader setImage:[image resizableImageWithCapInsets:UIEdgeInsetsMake(20, 0, 10, 0) resizingMode:UIImageResizingModeStretch]];
//    [imgHeader setImage:[UIImage imageNamed:@"room_left_liveroom_bg"]];
    [self.contentView addSubview:imgHeader];
    [imgHeader mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    imgView = [[UIImageView alloc] init];
    [imgView setImage:[UIImage imageNamed:@"livingRoon_recycle_icon"]];
    [imgHeader addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.top.equalTo(self.contentView).offset(16);
        make.size.mas_equalTo(CGSizeMake(17, 14));
    }];
    
    titleLabel = [[UILabel alloc]init];
    titleLabel.font = JHMediumFont(16);
    titleLabel.textColor = HEXCOLOR(0x333333);
    titleLabel.text = @"个人介绍";
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [imgHeader addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgView.mas_right).offset(5);
        make.top.equalTo(imgView).offset(-3);
        make.height.mas_equalTo(20);
    }];
    //介绍
    infoLabel = [[UILabel alloc] init];
    infoLabel.font = JHFont(13);
    infoLabel.textColor = HEXCOLOR(0x666666);
    infoLabel.textAlignment = NSTextAlignmentLeft;
    infoLabel.numberOfLines = 3;
    [imgHeader addSubview:infoLabel];
}

- (void)updateData:(NSString *)txt roleType:(NSInteger)roleType {
    titleLabel.text = @"个人介绍";
    [imgView setImage:[UIImage imageNamed:@"livingRoon_recycle_icon"]];
    [imgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.top.equalTo(self.contentView).offset(16);
        make.size.mas_equalTo(23);
    }];
    [titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgView.mas_right).offset(5);
        make.top.equalTo(imgView).offset(0);
        make.height.mas_equalTo(22);
    }];
    
    if([txt length] > 0) {
        infoLabel.text = txt;
        [infoLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imgView).offset(0);
            make.right.equalTo(self.contentView).offset(-10);
            make.top.mas_equalTo(imgView.mas_bottom).offset(6);
            make.bottom.equalTo(self.contentView).offset(-13);
        }];
    } else {
        infoLabel.text = @"暂无个人介绍~";
        [infoLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imgView).offset(0);
            make.right.equalTo(self.contentView).offset(-10);
            make.top.mas_equalTo(imgView.mas_bottom).offset(6);
            make.bottom.equalTo(self.contentView).offset(-13);
        }];
    }
}


@end
