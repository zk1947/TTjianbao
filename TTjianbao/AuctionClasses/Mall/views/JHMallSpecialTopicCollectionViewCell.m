//
//  JHMallSpecialTopicCollectionViewCell.m
//  TTjianbao
//
//  Created by jiang on 2020/4/28.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHMallSpecialTopicCollectionViewCell.h"
#import "UIImage+GIF.h"
#import "TTjianbaoHeader.h"
#import "UIImageView+YYWebImage.h"
@interface JHMallSpecialTopicCollectionViewCell ()
{
   
}
@property (strong, nonatomic)  YYAnimatedImageView *headImage;
@property (strong, nonatomic)  UILabel* title;
@end

@implementation JHMallSpecialTopicCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
      //  self.backgroundColor = [UIColor whiteColor];
      //  self.backgroundColor = [CommHelp randomColor];
        
        UIImageView *circleImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@""]];
        [self.contentView addSubview:circleImage];
        
        [circleImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(5);
            make.size.mas_equalTo(CGSizeMake(58, 58));
            make.centerX.equalTo(self.contentView);
        }];
        
        _headImage=[[YYAnimatedImageView alloc]init];
        _headImage.image=kDefaultCoverImage;
//        _headImage.layer.masksToBounds = YES;
//        _headImage.layer.cornerRadius = 25;
        _headImage.userInteractionEnabled=YES;
        //        _headImage.layer.borderColor = [[CommHelp toUIColorByStr:@"#fee100"] colorWithAlphaComponent:1.0].CGColor;
        [circleImage addSubview:_headImage];
        
        [_headImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(50, 50));
            make.center.equalTo(circleImage);
        }];
        
        
        _title=[[UILabel alloc]init];
        _title.text=@"";
        _title.font=[UIFont fontWithName:kFontMedium size:12];
        _title.textColor=[CommHelp toUIColorByStr:@"#333333"];
        _title.numberOfLines = 1;
        _title.textAlignment = NSTextAlignmentCenter;
        _title.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:_title];
        [_title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(circleImage.mas_bottom).offset(5);
            make.left.equalTo(self.contentView).offset(5);
            make.right.equalTo(self.contentView).offset(-5);
           
          //  make.centerX.equalTo(circleImage);
        }];
        
        
    }
    return self;
}
//-(void)setLiveRoomMode:(JHLiveRoomMode *)liveRoomMode{
//
//    _liveRoomMode=liveRoomMode;
//    _title.text=_liveRoomMode.anchorName;
//
//    [_headImage jhSetImageWithURL:[NSURL URLWithString:liveRoomMode.smallCoverImg] placeholderImage:kDefaultAvatarImage];
//
//
//}
-(void)setSpecialTopicMode:(JHMallSpecialTopicModel *)specialTopicMode{
    
    _specialTopicMode=specialTopicMode;
      _title.text=_specialTopicMode.name;
     [_headImage setImageWithURL:[NSURL URLWithString:_specialTopicMode.icon] placeholder:kDefaultCoverImage];

}
@end
