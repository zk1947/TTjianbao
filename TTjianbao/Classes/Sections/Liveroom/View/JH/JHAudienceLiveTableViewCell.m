//
//  JHAudienceLiveTableViewCell.m
//  TTjianbao
//
//  Created by jiang on 2019/7/29.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHAudienceLiveTableViewCell.h"
#import "JHAudienceLiveCoverView.h"

@interface JHAudienceLiveTableViewCell ()
@property (nonatomic, strong) JHAudienceLiveCoverView    *coverView;
@end
@implementation JHAudienceLiveTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

          [self.contentView addSubview:self.coverView];
          [self.contentView addSubview:self.infoView];
        
    }
    return self;
}
- (UIView *)infoView
{
    if (!_infoView) {
        _infoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
    }
    return _infoView;
}
- (JHAudienceLiveCoverView *)coverView
{
    if (!_coverView) {
        _coverView = [[JHAudienceLiveCoverView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
    }
    return _coverView;
}
-(void)setChannelMode:(JHLiveRoomMode *)channelMode{

    _channelMode=channelMode;
      [self.coverView setCoverImage:_channelMode.coverImg];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

