//
//  JHLiveRoomPkPortraitView.m
//  TTjianbao
//
//  Created by apple on 2020/8/18.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHLiveRoomPkPortraitView.h"

@implementation JHLiveRoomPkPortraitView

//t头像
+ (UIView *)headPortrait:(CGSize)size andranking:(NSInteger)ranking andUrl:(NSString *)url isLive:(BOOL)islive{
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height+23)];
    
    UIImageView * crownImage = [[UIImageView alloc] init];
    [view addSubview:crownImage];
    [crownImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(3);
        make.size.mas_equalTo(CGSizeMake(31, 23));
        make.centerX.equalTo(view);
    }];
    if (ranking == 1) {
        crownImage.image = [UIImage imageNamed:@"firstRanking"];//
    }else if(ranking == 2){
        crownImage.image = [UIImage imageNamed:@"secondRanking"];
    }else if(ranking == 3){
        crownImage.image = [UIImage imageNamed:@"thirdRanking"];
    }
    
    UIImageView * imageV = [[UIImageView alloc] init];
    imageV.userInteractionEnabled = YES;
    imageV.contentMode = UIViewContentModeScaleAspectFill;
    imageV.layer.cornerRadius = size.width/2;
    imageV.layer.borderWidth = 3;
    imageV.layer.borderColor = [UIColor whiteColor].CGColor;
    imageV.clipsToBounds = YES;
    [view addSubview:imageV];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(view.mas_bottom);
        make.size.mas_equalTo(size);
        make.centerX.equalTo(view);
    }];
    [imageV jhSetImageWithURL:[NSURL URLWithString:url ? : @""] placeholder:kDefaultAvatarImage];
    
    if (islive) {
        UIView *statusBackView = [[UIView alloc] init];
        statusBackView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6];
        statusBackView.layer.cornerRadius = 10;
        [view addSubview:statusBackView];
        
        [statusBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(60, 19));
            make.top.mas_equalTo(imageV.mas_bottom).offset(-15);
            make.centerX.equalTo(view);
        }];
        
        UIImageView *playingImage = [[UIImageView alloc]init];
        playingImage.contentMode = UIViewContentModeScaleAspectFit;
        playingImage.image = [UIImage imageNamed:@"icon_buy_living"];
        [statusBackView addSubview:playingImage];
        [playingImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(statusBackView);
            make.left.equalTo(statusBackView).offset(6);
            make.size.mas_equalTo(CGSizeMake(12, 13));
        }];
        UILabel * status = [[UILabel alloc]init];
        status.text = @"直播中";
        status.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
        status.textColor = [CommHelp toUIColorByStr:@"#ffffff"];
        status.textAlignment = UIControlContentHorizontalAlignmentCenter;
        status.lineBreakMode = NSLineBreakByWordWrapping;
        [statusBackView addSubview:status];
        
        [status mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(statusBackView);
            make.left.equalTo(playingImage.mas_right).offset(4);
        }];
    }
    
    
    return view;
}

//排名
+ (UILabel *)rankingLabel:(UIFont *)font{
    UILabel * label = [[UILabel alloc] init];
    label.font = font;
    label.textColor = UIColor.whiteColor;
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}
@end
