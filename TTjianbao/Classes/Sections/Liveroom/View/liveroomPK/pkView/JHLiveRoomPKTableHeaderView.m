//
//  JHLiveRoomPKTableHeaderView.m
//  TTjianbao
//
//  Created by apple on 2020/8/18.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHLiveRoomPKTableHeaderView.h"
#import "JHLiveRoomPkPortraitView.h"

@interface JHLiveRoomPKTableHeaderView ()
@property (nonatomic,strong)JHLiveRoomPKModel *model;
@property (nonatomic,strong)NSMutableArray <JHLiveRoomPKInfoModel *>*modelArray;
@property (nonatomic,copy)NSString *type;
@property (nonatomic,strong)UITapGestureRecognizer * tap;
@property (nonatomic,strong)UITapGestureRecognizer * tap2;
@property (nonatomic,strong)UITapGestureRecognizer * tap3;
@property (nonatomic,assign)BOOL isShowUserInfo;
@end

@implementation JHLiveRoomPKTableHeaderView
- (instancetype)initWithFrame:(CGRect)frame andModel:(JHLiveRoomPKModel *)model andType:(NSString *)type andIsShowUserInfo:(BOOL)isShowUserInfo{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.model = model;
        self.type = type;
        self.isShowUserInfo = isShowUserInfo;
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    
    if ([self.type isEqualToString:@"summaryRanking"]) {
        if (self.height == 179) {
            self.image = [UIImage imageNamed:@"totalHeader_bg_179"];//increaseHeader_bg
        }else{
            self.image = [UIImage imageNamed:@"totalHeader_bg"];//
        }
        self.modelArray = self.model.summaryRanking;
    }else if ([self.type isEqualToString:@"increaseRanking"]) {
        if (self.height == 179) {
            self.image = [UIImage imageNamed:@"fansRankingHeader_bg"];
        }else{
            self.image = [UIImage imageNamed:@"increaseHeader_bg"];//
        }
        self.modelArray = self.model.increaseRanking;
    }else if ([self.type isEqualToString:@"fansRanking"]) {
        self.image = [UIImage imageNamed:@"fansRankingHeader_bg"];//
        self.modelArray = self.model.fansRanking;
    }
    //
    
    //用户排名
        
    UIView * rankView = [[UIView alloc] init];
    rankView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.15];
    rankView.layer.cornerRadius = 15;
    rankView.clipsToBounds = YES;
    [self addSubview:rankView];

    [rankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(31);
    }];

    UIImageView * headerImage = [[UIImageView alloc] init];
    headerImage.layer.cornerRadius = 9;
    headerImage.clipsToBounds = YES;
    [rankView addSubview:headerImage];

    JHLiveRoomPKUserModel * user = self.model.user;
    [headerImage jhSetImageWithURL:[NSURL URLWithString:user.headImg ? : @""] placeholder:kDefaultAvatarImage];
    
    UILabel *label = [[UILabel alloc] init];
    [rankView addSubview:label];
    label.font = JHFont(13);
    label.textColor = HEXCOLOR(0xFFFCF5);
    [label setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    
    if (user.rankTip.length>0 || user.ranking.length>0) {
        NSMutableAttributedString * str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",user.rankTip,user.ranking]];
        [str addAttributes:@{NSFontAttributeName:JHDINBoldFont(15)} range:NSMakeRange(user.rankTip.length, user.ranking.length)];
        label.attributedText = str;
    }
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(headerImage.mas_right).offset(5);
//        make.right.mas_equalTo(headerImage.mas_left);
        make.centerX.mas_equalTo(rankView.centerX);
        make.top.mas_equalTo(5);
        make.height.mas_equalTo(21);
    }];
    //计算宽度
//    CGFloat width = [str sizeWithFont:[UIFont systemFontOfSize:11 weight:UIFontWeightMedium] maxSize:CGSizeMake(CGFLOAT_MAX, FixH(13))].width;
    [headerImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(label.mas_left).offset(-5);
        make.top.mas_equalTo(6);
        make.size.mas_equalTo(CGSizeMake(18, 18));
    }];
    
    if ([self.type isEqualToString:@"fansRanking"] || !self.isShowUserInfo){
        [rankView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.height.mas_equalTo(0);
        }];
    }
    
    JHLiveRoomPKInfoModel *firstModel;
    if (self.modelArray.count>0) {
         firstModel = self.modelArray[0];
    }
    UIView * first = [JHLiveRoomPkPortraitView headPortrait:CGSizeMake(70, 70) andranking:1 andUrl:firstModel.img isLive:[firstModel.isOpen boolValue]];
    [self addSubview:first];
    [first mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-70);
        make.size.mas_equalTo(CGSizeMake(60, 93));
    }];
    first.userInteractionEnabled = YES;
    JH_WEAK(self);
    self.tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
       JH_STRONG(self);
        if ([firstModel.isOpen boolValue] && self.headerClickBlock) {
            self.headerClickBlock(firstModel.channelId);
        }
    }];
    [first addGestureRecognizer:self.tap];
    UILabel *firstlabel = [JHLiveRoomPkPortraitView rankingLabel:JHFont(15)];
    firstlabel.text = firstModel.name;
    [self addSubview:firstlabel];
    [firstlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(first.mas_bottom).offset(12);
        make.centerX.equalTo(first);
        make.size.mas_equalTo(CGSizeMake(105, 21));
    }];
    UILabel *firstlabel2 = [JHLiveRoomPkPortraitView rankingLabel:JHFont(13)];
    firstlabel2.text = firstModel.score;
    [self addSubview:firstlabel2];
    [firstlabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(firstlabel.mas_bottom).offset(-2);
        make.centerX.equalTo(first);
        make.size.mas_equalTo(CGSizeMake(105, 18));
    }];
    
    JHLiveRoomPKInfoModel *secondModel;
    if (self.modelArray.count>1) {
         secondModel = self.modelArray[1];
    }
    UIView * second = [JHLiveRoomPkPortraitView headPortrait:CGSizeMake(60, 60) andranking:2 andUrl:secondModel.img isLive:[secondModel.isOpen boolValue]];
    [self addSubview:second];
    [second mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(37);
        make.bottom.equalTo(self).offset(-55);
        make.size.mas_equalTo(CGSizeMake(60, 83));
    }];
    self.tap2 = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        JH_STRONG(self);
        if ([secondModel.isOpen boolValue] && self.headerClickBlock) {
            self.headerClickBlock(secondModel.channelId);
        }
    }];
    [second addGestureRecognizer:self.tap2];
    
    UILabel *secondlabel = [JHLiveRoomPkPortraitView rankingLabel:JHFont(14)];
    secondlabel.text = secondModel.name;
    [self addSubview:secondlabel];
    [secondlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(second.mas_bottom).offset(6);
        make.centerX.equalTo(second);
        make.size.mas_equalTo(CGSizeMake(105, 20));
    }];
    UILabel *secondlabel2 = [JHLiveRoomPkPortraitView rankingLabel:JHFont(12)];
    secondlabel2.text = secondModel.score;
    [self addSubview:secondlabel2];
    [secondlabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(secondlabel.mas_bottom).offset(-2);
        make.centerX.equalTo(second);
        make.size.mas_equalTo(CGSizeMake(105, 17));
    }];
    
    JHLiveRoomPKInfoModel *thirdModel;
    if (self.modelArray.count>2) {
         thirdModel = self.modelArray[2];
    }
    UIView * third = [JHLiveRoomPkPortraitView headPortrait:CGSizeMake(60, 60) andranking:3 andUrl:thirdModel.img  isLive:[thirdModel.isOpen boolValue]];
   [self addSubview:third];
   [third mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-37);
        make.bottom.equalTo(self).offset(-50);
        make.size.mas_equalTo(CGSizeMake(60, 83));
   }];
    self.tap3 = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        JH_STRONG(self);
        if ([thirdModel.isOpen boolValue] && self.headerClickBlock) {
            self.headerClickBlock(thirdModel.channelId);
        }
    }];
    [third addGestureRecognizer:self.tap3];
    UILabel *thirdlabel = [JHLiveRoomPkPortraitView rankingLabel:JHFont(13)];
    thirdlabel.text = thirdModel.name;
    [self addSubview:thirdlabel];
    [thirdlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(third.mas_bottom).offset(4);
        make.centerX.equalTo(third);
        make.size.mas_equalTo(CGSizeMake(105, 20));
    }];
    UILabel *thirdlabel2 = [JHLiveRoomPkPortraitView rankingLabel:JHFont(11)];
    thirdlabel2.text = thirdModel.score;
    [self addSubview:thirdlabel2];
    [thirdlabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(thirdlabel.mas_bottom).offset(-2);
        make.centerX.equalTo(third);
        make.size.mas_equalTo(CGSizeMake(105, 17));
    }];
    if ([self.type isEqualToString:@"increaseRanking"]) {
        [self setLabelStyle:firstlabel2 andModle:firstModel];
        [self setLabelStyle:secondlabel2 andModle:secondModel];
        [self setLabelStyle:thirdlabel2 andModle:thirdModel];
    }
    
}
-(void)setLabelStyle:(UILabel *)rightLabel andModle:(JHLiveRoomPKInfoModel *)model{
    rightLabel.font = JHMediumFont(12);
    rightLabel.textColor = [UIColor whiteColor];
    if (model.increase.length>0) {
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:model.increase];
        NSTextAttachment *attch = [[NSTextAttachment alloc] init];

        if ([model.increase integerValue]>0) {
            attch.image = [UIImage imageNamed:@"up_arrows_white"];
            attch.bounds = CGRectMake(0, -2, 9, 12);
            NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
            [attri insertAttributedString:string atIndex:0];
        }else if ([model.increase integerValue] == 0){
            attch.image = [UIImage imageNamed:@"flat_arrows_white"];
            attch.bounds = CGRectMake(0, 0, 15, 2);
            NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
            [attri replaceCharactersInRange:NSMakeRange(0, 1) withAttributedString:string];
        }else{
           attch.image = [UIImage imageNamed:@"down_arrows_white"];
           attch.bounds = CGRectMake(0, -2, 9, 12);
            NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
            [attri replaceCharactersInRange:NSMakeRange(0, 1) withAttributedString:string];
        }
        
        rightLabel.attributedText = attri;
    }
}
@end
