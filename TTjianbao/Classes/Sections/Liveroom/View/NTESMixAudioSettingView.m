//
//  NTESMixAudioSettingView.m
//  TTjianbao
//
//  Created by chris on 2016/12/15.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import "NTESMixAudioSettingView.h"
#import <NIMAVChat/NIMAVChat.h>
#import "UIView+NTES.h"

#import "BaseView.h"

@interface NTESMixAudioSettingBar : BaseView

@property (nonatomic, weak) id<NTESMixAudioSettingViewDelegate> delegate;

@end


@interface NTESMixAudioSettingView()

@property (nonatomic,strong) NTESMixAudioSettingBar *bar;

@end

@implementation NTESMixAudioSettingView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addTarget:self action:@selector(onTapBackground:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.bar];
    }
    return self;
}

- (void)setDelegate:(id<NTESMixAudioSettingViewDelegate>)delegate
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

- (NTESMixAudioSettingBar *)bar
{
    if (!_bar) {
        _bar = [[NSBundle mainBundle] loadNibNamed:@"NTESMixAudioSettingBar" owner:nil options:nil].firstObject;
    }
    return _bar;
}




@end


@interface NTESMixAudioData : NSObject

@property (nonatomic,copy)   NSString *audioName;

@property (nonatomic,copy)   NSString *title;

@property (nonatomic,assign) UIControlState state;

@end


@interface NTESMixAudioSettingCell : UITableViewCell

@property (nonatomic,strong) UIButton *playButton;

- (void)refresh:(NTESMixAudioData *)data;

@end


@interface NTESMixAudioSettingBar()<UITableViewDelegate,UITableViewDataSource,NIMNetCallManagerDelegate>

@property (nonatomic,copy) NSArray<NTESMixAudioData *> *data;

@property (nonatomic,strong) IBOutlet UITableView *tableView;

@property (nonatomic,strong) IBOutlet UILabel  *volumeLabel;

@property (nonatomic,strong) IBOutlet UISlider *volumeSlider;

@property (nonatomic,strong) NTESMixAudioData *curentAudioData;

@end

@implementation NTESMixAudioSettingBar

- (void)awakeFromNib
{
    [super awakeFromNib];
    _data = [self buildData];
    [self.tableView registerClass:[NTESMixAudioSettingCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.tableHeaderView = [[UIView alloc] init];
    
    [self.volumeSlider setThumbImage:[UIImage imageNamed:@"icon_volume_slider_normal"] forState:UIControlStateNormal];
    [self.volumeSlider setThumbImage:[UIImage imageNamed:@"icon_volume_slider_disable"] forState:UIControlStateDisabled];
    
    [[NIMAVChatSDK sharedSDK].netCallManager addDelegate:self];
    
    //第一次默认关闭
    [self refresh:NO];
}

- (void)dealloc
{
    [[NIMAVChatSDK sharedSDK].netCallManager removeDelegate:self];
}

- (IBAction)switchMixAudio:(id)sender
{
    BOOL enabled = [(UISwitch *)sender isOn];
    [self refresh:enabled];
}

- (IBAction)changeVolume:(id)sender
{
    [self callbackUpdateMixAudio];
}

- (void)refresh:(BOOL)enabled
{
    for (NTESMixAudioData *data in self.data) {
        data.state = enabled? UIControlStateNormal : UIControlStateDisabled;
    }
    if (!enabled) {
        //关掉的时候，把声音也切掉
        [[NIMAVChatSDK sharedSDK].netCallManager stopAudioMix];
        self.curentAudioData = nil;
    }
    self.volumeLabel.textColor = enabled? HEXCOLOR(0xffffff) : HEXCOLOR(0x666666);
    self.volumeSlider.tintColor = enabled? HEXCOLOR(0x238efa) : HEXCOLOR(0x666666);
    self.volumeSlider.enabled = enabled;
    [self.tableView reloadData];
}

- (NSArray *)buildData
{
    NSArray *array = @[
                         @{@"audio":@"live_mix_auido_example_1.mp3",@"title":@"歌曲1",@"state":@(UIControlStateDisabled)},
                         @{@"audio":@"live_mix_auido_example_2.mp3",@"title":@"歌曲2",@"state":@(UIControlStateDisabled)},
                      ];
    NSMutableArray *data = [[NSMutableArray alloc] init];
    for (NSDictionary *item in array) {
        NTESMixAudioData *audioData = [[NTESMixAudioData alloc] init];
        audioData.audioName = item[@"audio"];
        audioData.title = item[@"title"];
        audioData.state = [item[@"state"] integerValue];
        [data addObject:audioData];
    }
    return data;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    NTESMixAudioSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.playButton.tag = indexPath.row;
    [cell.playButton addTarget:self action:@selector(onPressPlay:) forControlEvents:UIControlEventTouchUpInside];
    NTESMixAudioData *data = self.data[indexPath.row];
    [cell refresh:data];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


- (void)onPressPlay:(id)sender
{
    UIButton *button = sender;
    NTESMixAudioData *data = self.data[button.tag];
    if (self.curentAudioData == data) {
        if (self.curentAudioData.state == UIControlStateNormal)
        {
            //恢复
            self.curentAudioData.state = UIControlStateSelected;
            [self callbackResumeMixAudio];
        }
        else
        {
            //暂停
            self.curentAudioData.state = UIControlStateNormal;
            [self callbackPauseMixAudio];
        }
        
    }
    else{
        self.curentAudioData.state = UIControlStateNormal;
        self.curentAudioData = data;
        self.curentAudioData.state = UIControlStateSelected;
        //从头播放
        [self callbackSelectMixAudio];
    }
    [self.tableView reloadData];    
}

- (void)callbackSelectMixAudio
{
    if ([self.delegate respondsToSelector:@selector(didSelectMixAuido:sendVolume:playbackVolume:)]) {
        NSString *audioName = self.curentAudioData.audioName;
        NSURL *url = [[NSBundle mainBundle] URLForResource:audioName withExtension:nil];
        CGFloat volume = self.volumeSlider.value;
        [self.delegate didSelectMixAuido:url sendVolume:volume playbackVolume:volume];
    }
}

- (void)callbackPauseMixAudio
{
    if ([self.delegate respondsToSelector:@selector(didPauseMixAudio)]) {
        [self.delegate didPauseMixAudio];
    }
}

- (void)callbackResumeMixAudio
{
    if ([self.delegate respondsToSelector:@selector(didResumeMixAudio)]) {
        [self.delegate didResumeMixAudio];
    }
}

- (void)callbackUpdateMixAudio
{
    if ([self.delegate respondsToSelector:@selector(didUpdateMixAuido:playbackVolume:)]) {
        CGFloat volume = self.volumeSlider.value;
        [self.delegate didUpdateMixAuido:volume playbackVolume:volume];
    }
}

- (void)onAudioMixTaskCompleted
{
    self.curentAudioData.state = UIControlStateNormal;
    self.curentAudioData = nil;
    [self.tableView reloadData];
}


@end


@implementation NTESMixAudioSettingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playButton setImage:[UIImage imageNamed:@"icon_audio_mix_play_normal"] forState:UIControlStateNormal];
        [_playButton setImage:[UIImage imageNamed:@"icon_audio_mix_play_pressed"] forState:UIControlStateHighlighted];
        [_playButton setImage:[UIImage imageNamed:@"icon_audio_mix_play_disable"] forState:UIControlStateDisabled];
        [_playButton setImage:[UIImage imageNamed:@"icon_audio_mix_play_select_normal"] forState:UIControlStateSelected];
        [_playButton setImage:[UIImage imageNamed:@"icon_audio_mix_play_select_pressed"] forState:UIControlStateSelected|UIControlStateHighlighted];
        [_playButton sizeToFit];
        [self.contentView addSubview:_playButton];
        
        self.textLabel.font = [UIFont systemFontOfSize:15.f];
        
    }
    return self;
}

- (void)refresh:(NTESMixAudioData *)data
{
    if (data.state == UIControlStateSelected)
    {
        self.textLabel.text = [NSString stringWithFormat:@"%@ (播放中...)",data.title];
    }
    else
    {
        self.textLabel.text = data.title;
    }
    
    [self.textLabel sizeToFit];
    
    self.playButton.selected = NO;
    self.playButton.enabled  = YES;
    switch (data.state) {
        case UIControlStateSelected:
            self.playButton.selected = YES;
            self.textLabel.textColor = HEXCOLOR(0xffffff);
            break;
        case UIControlStateNormal:
            self.playButton.selected = NO;
            self.textLabel.textColor = HEXCOLOR(0xffffff);
            break;
        case UIControlStateDisabled:
            self.playButton.enabled = NO;
            self.textLabel.textColor = HEXCOLOR(0x666666);
            break;
        default:
            break;
    }
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.textLabel.left = 0;
    self.textLabel.centerY = self.height * .5f;
    
    CGFloat right = 10.f;
    self.playButton.right   = self.width - right;
    self.playButton.centerY = self.height * .5f;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{}

@end


@implementation NTESMixAudioData

@end
