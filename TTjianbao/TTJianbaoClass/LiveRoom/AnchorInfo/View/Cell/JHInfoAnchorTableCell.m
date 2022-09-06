//
//  JHInfoAnchorTableCell.m
//  TTjianbao
//
//  Created by jesee on 19/7/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHInfoAnchorTableCell.h"
#import "UIImageView+JHWebImage.h"
#import "JHLine.h"
#import "JHLiveStatusView.h"
#import "TTjianbaoMarcoUI.h"

@interface JHInfoAnchorTableCell ()
{
    UIImageView* imgHeader; //bg
    UIImageView * headerImgView;
    UILabel* headerTitleLabel;
    UIImageView * imgView;
    UILabel* titleLabel;
    JHLiveStatusView* statusView;
    UITextView* infoLabel;
    UIRectCorner corner;
}
@end

@implementation JHInfoAnchorTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self drawSubviews];
    }
    return self;
}

- (void)drawSubviews
{
    //bg header
    imgHeader = [[UIImageView alloc] init];
    imgHeader.layer.cornerRadius = 8;
    imgHeader.layer.masksToBounds = YES;
    imgHeader.contentMode = UIViewContentModeScaleAspectFill;
    UIImage *image = [UIImage imageNamed:@"room_left_archor_bg"];
    [imgHeader setImage:[image resizableImageWithCapInsets:UIEdgeInsetsMake(20, 0, 0, 0) resizingMode:UIImageResizingModeStretch]];
    [self.contentView addSubview:imgHeader];
    [imgHeader mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
        make.height.mas_equalTo(self.contentView).offset(12);
    }];
    //header - 头像
    headerImgView = [[UIImageView alloc] init];
    [headerImgView setImage:[UIImage imageNamed:@"icon_anchor_intro"]];
    [self.contentView addSubview:headerImgView];
    [headerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.top.equalTo(self.contentView).offset(17);
        make.size.mas_equalTo(23);
    }];
    
    headerTitleLabel = [[UILabel alloc]init];
    headerTitleLabel.font = JHMediumFont(16);
    headerTitleLabel.textColor = HEXCOLOR(0x333333);
    headerTitleLabel.text = @"主播介绍";
    headerTitleLabel.numberOfLines = 1;
    headerTitleLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:headerTitleLabel];
    [headerTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerImgView.mas_right).offset(5);
        make.top.equalTo(headerImgView).offset(0);
        make.height.mas_equalTo(22);
    }];
    //common cell
    imgView = [[UIImageView alloc] init];
    imgView.layer.cornerRadius = 15;
    imgView.layer.masksToBounds = YES;
    [self.contentView addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.top.mas_equalTo(headerImgView.mas_bottom).offset(10);
        make.size.mas_equalTo(30);
    }];
    
    titleLabel = [[UILabel alloc] init];
    titleLabel.font = JHFont(14);
    titleLabel.textColor = HEXCOLOR(0x333333);
    titleLabel.numberOfLines = 1;
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(imgView.mas_right).offset(5);
        make.top.equalTo(imgView).offset(5);
        make.height.mas_equalTo(20);
    }];
    
    statusView = [[JHLiveStatusView alloc] init];
    statusView.fontSize = 9.f;
    statusView.layer.masksToBounds = YES;
    statusView.layer.cornerRadius = 8;
    [self.contentView addSubview:statusView];
    [statusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel).offset(1);
        make.left.mas_equalTo(titleLabel.mas_right).offset(6);
        make.height.mas_equalTo(18);
    }];
    
    infoLabel = [[UITextView alloc]init];
    infoLabel.font = JHFont(13);
    infoLabel.textColor = HEXCOLOR(0x666666);
    infoLabel.userInteractionEnabled = NO;
    infoLabel.textAlignment = NSTextAlignmentLeft;
    infoLabel.contentInset = UIEdgeInsetsMake(-7, 0, 0, 0);
    infoLabel.scrollEnabled = NO;
    [self.contentView addSubview:infoLabel];
    [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
        make.top.mas_equalTo(imgView.mas_bottom).offset(5);
        make.bottom.equalTo(self.contentView).offset(-8);
    }];
    
    //分割线
    JHCustomLine* line = [JHCustomLine new];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.contentView).offset(-1);
        make.left.equalTo(self.contentView).offset(5);
        make.right.equalTo(self.contentView).offset(-5);
        make.height.offset(0.5);
    }];
}

- (void)updateData:(JHLiveRoomAnchorInfoModel*)info cornerType:(JHCornerType)type roleType:(NSInteger)roleType
{
    if(roleType >= 9)
        headerTitleLabel.text = @"定制费用说明";
    else
        headerTitleLabel.text = @"主播介绍";
    if(info.liveStatus == JHAnchorLiveStatusNoData)
    {
        [imgHeader mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        self.backgroundColor = [UIColor clearColor];
        [imgHeader setHidden:NO];
        [headerImgView setHidden:NO];
        [headerTitleLabel setHidden:NO];
        [imgView setHidden:YES];
        [titleLabel setHidden:YES];
        [statusView setHidden:YES];
        infoLabel.text = @"暂无主播介绍~";
        [infoLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(10);
            make.right.equalTo(self.contentView).offset(-10);
            make.top.mas_equalTo(headerImgView.mas_bottom).offset(10);
            make.height.offset(50);
            make.bottom.equalTo(self.contentView).offset(-8);
        }];
    }
    else
    {
        if(type == JHCornerTypeTop || type == JHCornerTypeAll)
        {
            if(type == JHCornerTypeAll)
            {
                [imgHeader mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(self.contentView);
                }];
            }
            else
            {
                [imgHeader mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(self.contentView);
                    make.height.mas_equalTo(self.contentView).offset(12);
                }];
            }
            self.backgroundColor = [UIColor clearColor];
            [imgHeader setHidden:NO];
            [headerImgView setHidden:NO];
            [headerTitleLabel setHidden:NO];
            [imgView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView).offset(10);
                make.top.mas_equalTo(headerImgView.mas_bottom).offset(10);
                make.size.mas_equalTo(30);
            }];
        }
        else
        {
            if(type == JHCornerTypeBottom)
            {
                [imgHeader setHidden:NO];
                self.backgroundColor = [UIColor clearColor];
                [imgHeader mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(self.contentView);
                    make.top.mas_equalTo(self.contentView).offset(-20);
                }];
            }
            else
            {
                [imgHeader setHidden:YES];
                self.backgroundColor = [UIColor whiteColor];
            }
            
            [headerImgView setHidden:YES];
            [headerTitleLabel setHidden:YES];
            [imgView mas_remakeConstraints:^(MASConstraintMaker *make) {
              make.left.equalTo(self.contentView).offset(10);
              make.top.equalTo(self.contentView).offset(17);
              make.size.mas_equalTo(30);
            }];
        }
        [imgView setHidden:NO];
        [titleLabel setHidden:NO];
        [infoLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(10);
            make.right.equalTo(self.contentView).offset(-10);
            make.top.mas_equalTo(imgView.mas_bottom).offset(5);
            make.bottom.equalTo(self.contentView).offset(-8);
        }];
        [imgView jhSetImageWithURL:[NSURL URLWithString:info.avatar] placeholder:kDefaultAvatarImage];
        titleLabel.text = info.nick;
        if(JHAnchorLiveStatusPlaying == info.liveStatus)
        {
            [statusView setHidden:NO];
            [statusView setLiveStatus:2 watchTotal:nil];
        }
        else
        {
            [statusView setHidden:YES];
        }
        infoLabel.text = info.des;
    }
}

@end
