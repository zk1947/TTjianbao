//
//  JHTMallGranduateeTableCell.m
//  TTjianbao
//
//  Created by lihui on 2020/12/5.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHTMallGranduateeTableCell.h"
#import "UIButton+ImageTitleSpacing.h"
#import "JHSkinManager.h"
#import "JHSkinSceneManager.h"

@interface JHTMallGranduateeTableCell ()
@property (nonatomic, strong) UIView *backImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *enterButton;

@property (nonatomic, strong) UIImageView *imageViewOne;
@property (nonatomic, strong) UILabel *labelOne;

@property (nonatomic, strong) UIImageView *imageViewTwo;
@property (nonatomic, strong) UILabel *labelTwo;

@property (nonatomic, strong) UIImageView *imageViewThree;
@property (nonatomic, strong) UILabel *labelThree;

@end

@implementation JHTMallGranduateeTableCell

+ (CGFloat)viewHeight {
    return 50.f;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initViews];
    }
    return self;
}

- (void)initViews {
    
    UIView *bgView = [UIView jh_viewWithColor:HEXCOLOR(0xF7F4F0) addToSuperview:self.contentView];
    [self.contentView addSubview:bgView];
    [bgView jh_cornerRadius:5 borderColor:HEXCOLOR(0xf1e9df) borderWidth:0.5];
    _backImageView = bgView;
    
    UIImageView *backImageView = [[UIImageView alloc] init];
    backImageView.image = [UIImage imageNamed:@"home_back_shadow_logo"];
    [_backImageView addSubview:backImageView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"平台鉴定后发货 源头好物有保障";
//    titleLabel.textColor = HEXCOLOR(0xB9855D);
   
    
    titleLabel.font = [UIFont fontWithName:kFontBoldPingFang size:15.f];
//    titleLabel.font = [UIFont systemFontOfSize:14.f weight:UIFontWeightHeavy];
    [_backImageView addSubview:titleLabel];
    _titleLabel = titleLabel;

    _enterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_enterButton setImage:[UIImage imageNamed:@"mall_home_enter"] forState:UIControlStateNormal];
    [_backImageView addSubview:_enterButton];
    
    [_backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 12, 0, 12));
    }];
    
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backImageView);
        make.top.equalTo(self.backImageView);
        make.width.mas_equalTo(78);
        make.height.mas_equalTo(23);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backImageView).offset(9.f);
        make.top.equalTo(self.backImageView).offset(8.f);
        make.right.equalTo(self.backImageView).offset(-10.f);
        make.height.mas_equalTo(16.5f);
    }];

    [_enterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.backImageView).offset(-12);
        make.centerY.equalTo(self.backImageView);
        make.size.mas_equalTo(CGSizeMake(5.5f, 9.f));
    }];
    
    self.imageViewOne = [self getImageView];
    self.imageViewTwo = [self getImageView];
    self.imageViewThree = [self getImageView];
    
    self.labelOne = [self getLabel];
    self.labelTwo = [self getLabel];
    self.labelThree = [self getLabel];
    
    
    UIStackView *stackView1 = [self getStackView : @[self.imageViewOne, self.labelOne]];
    UIStackView *stackView2 = [self getStackView : @[self.imageViewTwo, self.labelTwo]];
    UIStackView *stackView3 = [self getStackView : @[self.imageViewThree, self.labelThree]];
    
    [self.backImageView addSubview:stackView1];
    [self.backImageView addSubview:stackView2];
    [self.backImageView addSubview:stackView3];
    
    [self.imageViewOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(14, 14));
    }];
    [self.imageViewTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.imageViewOne);
    }];
    [self.imageViewThree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.imageViewOne);
    }];
    
    [stackView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(5.f);
        make.height.mas_equalTo(13.f);
    }];
    [stackView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(stackView1.mas_right).offset(13.f);
        make.top.height.mas_equalTo(stackView1);
    }];
    [stackView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(stackView2.mas_right).offset(13.f);
        make.top.height.mas_equalTo(stackView1);
    }];
    
    /* hutao--change */
    JHSkinSceneManager *manager = [JHSkinSceneManager shareManager];
    @weakify(self)
    [RACObserve(manager, scenePlatformTitleModel)
     subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        JHSkinSceneModel *scene = x;
        if (scene == nil) return;
        self.titleLabel.textColor = scene.colorNor;
    }];
    [RACObserve(manager, scenePlatformBgModel)
     subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        JHSkinSceneModel *scene = x;
        if (scene == nil) return;
        self.backImageView.backgroundColor = scene.colorNor;
        [self.backImageView jh_cornerRadius:5 borderColor:scene.colorBorderNor borderWidth:0.5];
    }];
    
    
    [RACObserve(manager, scenePlatformRightModel)
     subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        JHSkinSceneModel *scene = x;
        if (scene == nil) return;
        if (scene.imageNor == nil) return;
        [self.enterButton setImage:scene.imageNor forState:UIControlStateNormal];
    }];

    [RACObserve(manager, scenePlatformOneModel)
     subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        JHSkinSceneModel *scene = x;
        if (scene == nil) return;
        self.imageViewOne.image = scene.imageNor;
        self.labelOne.text = scene.titleNor;
        self.labelOne.textColor = scene.colorNor;
    }];
    
    [RACObserve(manager, scenePlatformTwoModel)
     subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        JHSkinSceneModel *scene = x;
        if (scene == nil) return;
        self.imageViewTwo.image = scene.imageNor;
        self.labelTwo.text = scene.titleNor;
        self.labelTwo.textColor = scene.colorNor;
    }];
    
    [RACObserve(manager, scenePlatformThreeModel)
     subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        JHSkinSceneModel *scene = x;
        if (scene == nil) return;
        self.imageViewThree.image = scene.imageNor;
        self.labelThree.text = scene.titleNor;
        self.labelThree.textColor = scene.colorNor;
    }];
    
//    JHSkinModel *model = [JHSkinManager platformBottom];
//      if (model.isChange)
//      {
//          if ([model.type intValue] == 1)
//          {
//              bgView.backgroundColor = COLOR_CHANGE(model.name);
//              [bgView jh_cornerRadius:5 borderColor:COLOR_CHANGE(model.name) borderWidth:0.5];
//          }
//      }
//    JHSkinModel *font_model = [JHSkinManager platformFont];
//    if (font_model.isChange)
//    {
//        if ([font_model.type intValue] == 1)
//        {
//            titleLabel.textColor = COLOR_CHANGE(font_model.name);
//        }
//    }
//    JHSkinModel *enter_model = [JHSkinManager platformRight];
//    if (enter_model.isChange)
//    {
//        if ([enter_model.type intValue] == 0)
//        {
//            UIImage *image = [JHSkinManager getPlatformRightImage];
//            [_enterButton setImage:image forState:UIControlStateNormal];
//        }
//    }
//    NSMutableArray *imagesArray = [NSMutableArray new];
//
//    JHSkinModel *address_model = [JHSkinManager sourceLive];
//    if (address_model.isChange)
//    {
//        if ([address_model.type intValue] == 0)
//        {
//            UIImage *address_image = [JHSkinManager getSourceLiveImage];
//            [imagesArray addObject:address_image];
//        }
//    }
//
//    JHSkinModel *door_model = [JHSkinManager experts];
//    if (door_model.isChange)
//    {
//        if ([door_model.type intValue] == 0)
//        {
//            UIImage *door_image = [JHSkinManager getExpertsImage];
//            [imagesArray addObject:door_image];
//        }
//    }
//
//    JHSkinModel *seven_model = [JHSkinManager exchange];
//    if (seven_model.isChange)
//    {
//        if ([seven_model.type intValue] == 0)
//        {
//            UIImage *seven_image = [JHSkinManager getExchangeImage];
//            [imagesArray addObject:seven_image];
//        }
//    }
    
    
//    NSArray *iconImages = @[@"mall_home_address", @"mall_home_door", @"mall_home_seven"];
//    NSArray *titles = @[@"源头直播低价购", @"专家逐件把关", @"7天无理由退换"];
//    UIView *lastView = nil;
//    for (int i = 0; i < iconImages.count; i ++) {
//        UIView *descView = [[UIView alloc] init];
//        [_backImageView addSubview:descView];
//
//        /* hutao--change */
//        UIImageView *icon = [[UIImageView alloc] init];
//        if (seven_model.isChange)
//        {
//            icon.image = imagesArray[i];
//        }
//        else
//        {
//            icon.image = [UIImage imageNamed:iconImages[i]];
//        }
//
//        //UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:iconImages[i]]];
//        //UIImageView *icon = [[UIImageView alloc] initWithImage:imagesArray[i]];
//
//        icon.contentMode = UIViewContentModeScaleAspectFill;
//        [descView addSubview:icon];
//
//        UILabel *label = [[UILabel alloc] init];
//        label.text = titles[i];
//        label.font = [UIFont fontWithName:kFontMedium size:10.f];
//        label.textColor = HEXCOLOR(0xB9855D);
//        [descView addSubview:label];
//
//        JHSkinModel *f_model = [JHSkinManager platformFont];
//        if (f_model.isChange)
//        {
//            if ([f_model.type intValue] == 1)
//            {
//                label.textColor = COLOR_CHANGE(f_model.name);
//            }
//        }
//
//        if (lastView == nil) {
//            ///第一个
//            [descView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.equalTo(self.titleLabel);
//                make.top.equalTo(self.titleLabel.mas_bottom).offset(5.f);
//                make.height.mas_equalTo(13.f);
//            }];
//        }
//        else {
//            [descView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.equalTo(lastView.mas_right).offset(13.f);
//                make.centerY.equalTo(lastView);
//                make.height.equalTo(lastView);
//            }];
//        }
//        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.top.bottom.equalTo(descView);
//            make.width.equalTo(descView.mas_height);
//        }];
//
//        [label mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.bottom.right.equalTo(descView);
//            make.left.equalTo(icon.mas_right).offset(2);
//        }];
//
//        lastView = descView;
//    }
}

- (UIImageView *)getImageView {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    return imageView;
}
- (UILabel *)getLabel {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.font = [UIFont fontWithName:kFontMedium size:10.f];
    label.textColor = HEXCOLOR(0xB9855D);
    return label;
}
- (UIStackView *)getStackView : (NSArray<UIView*> *)views{
    UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:views];
    stackView.spacing = 2;
    stackView.axis = UILayoutConstraintAxisHorizontal;
    stackView.alignment = UIStackViewAlignmentFill;
    stackView.distribution = UIStackViewDistributionFill;
    
    return stackView;
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
