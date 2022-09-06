//
//  JHMuteListModel.h
//  TTjianbao
//
//  Created by mac on 2019/8/26.
//  Copyright © 2019 Netease. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@interface JHMuteListModel : JHResponseModel
//hasTime = "\U5269\U4f590\U59290\U5c0f\U65f60\U5206";
//muteStartTime = "2019-06-24";
//muteTime = "0\U79d2";
//viewerIcon = "https://jianhuo-test.nos-eastchina1.126.net/user_dir/user/15614454725515337.jpg";
//viewerName = "\U5b9d\U53cb7085020";
@property (strong,nonatomic)NSString *viewerName;
@property (strong,nonatomic)NSString *hasTime;
@property (strong,nonatomic)NSString *wyAccid;
@property (strong,nonatomic)NSString *muteStartTime;
@property (strong,nonatomic)NSString *muteTime;
@property (strong,nonatomic)NSString *viewerIcon;

@end

NS_ASSUME_NONNULL_END
