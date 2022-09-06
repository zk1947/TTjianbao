//
//  NTESVideoQualityView.m
//  TTjianbao
//
//  Created by Simon Blue on 2017/5/18.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "NTESVideoQualityView.h"
#import "UIView+NTES.h"

@interface NTESVideoQualityBar : UIView

@property (nonatomic, weak) id<NTESVideoQualityViewDelegate> delegate;

@property(nonatomic) NSInteger lastIndex;


@end

@interface NTESVideoQualityView()

@property (nonatomic,strong) NTESVideoQualityBar *bar;

@property (nonatomic) NTESLiveQuality defaultQuality;

@end

@implementation NTESVideoQualityView

- (instancetype)initWithFrame:(CGRect)frame quality:(NTESLiveQuality)quality
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addTarget:self action:@selector(onTapBackground:) forControlEvents:UIControlEventTouchUpInside];
        self.defaultQuality = quality;
        [self addSubview:self.bar];
    }
    return self;
}

- (void)setDelegate:(id<NTESVideoQualityViewDelegate>)delegate
{
    _delegate = delegate;
    self.bar.delegate = delegate;
}

- (void)onTapBackground:(id)sender
{
    [self dismiss];
}

- (void)show
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    self.bar.top = self.height;
    self.bar.width = self.width;
    [UIView animateWithDuration:0.25 animations:^{
        self.bar.bottom = self.height;
    }];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.25 animations:^{
        self.bar.top = self.height;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (NTESVideoQualityBar *)bar
{
    if (!_bar) {
        _bar = [[NSBundle mainBundle] loadNibNamed:@"NTESVideoQualityBar" owner:nil options:nil].firstObject;
        _bar.lastIndex = self.defaultQuality == NTESLiveQualityHigh ? 0 : 1 ;
    }
    return _bar;
}


@end

@interface NTESVideoQualityCell : UITableViewCell

@property (nonatomic,strong) UIImageView * selectedImage;


@end

@interface NTESVideoQualityBar ()<NIMNetCallManagerDelegate, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (weak, nonatomic) IBOutlet UIButton *cancleButton;



@end

@implementation NTESVideoQualityBar

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self.tableview registerClass:[NTESVideoQualityCell class] forCellReuseIdentifier:@"cell"];
    
    self.tableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    self.tableview.delegate = self;
    
    self.tableview.dataSource = self;
    
    [[NIMAVChatSDK sharedSDK].netCallManager addDelegate:self];

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56.f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    
    NTESVideoQualityCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];

    cell.tintColor = HEXCOLOR(0xffffff);
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"高清";
    }
    if (indexPath.row == 1) {
        cell.textLabel.text = @"普清";
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, MAXFLOAT)];
    }
   
    if (indexPath.row == self.lastIndex) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSIndexPath * oldIndex = [NSIndexPath indexPathForRow:self.lastIndex inSection:0];
    
    NTESVideoQualityCell *oldCell = [tableView cellForRowAtIndexPath:oldIndex];

    oldCell.accessoryType = UITableViewCellAccessoryNone;

    NTESVideoQualityCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
    
    newCell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    self.lastIndex = indexPath.row;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(onVideoQualitySelected:)]) {
        [self.delegate onVideoQualitySelected:indexPath.row];
    }
    
}

- (IBAction)onCancelButtonPressed:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onVideoQualityViewCancelButtonPressed)]) {
        [self.delegate onVideoQualityViewCancelButtonPressed];
    }
}

@end

@implementation NTESVideoQualityCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.backgroundColor = [UIColor clearColor];
        
        self.textLabel.textColor = HEXCOLOR(0xffffff);

        self.selectedImage = [[UIImageView alloc]init];
        

        [self.selectedImage sizeToFit];

        [self.contentView addSubview:self.selectedImage];
    }
    return self;
}

- (void)refresh
{
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.selectedImage.right = self.width - 10;
    
    self.selectedImage.centerY = self.height * .5f;
    
}


@end
