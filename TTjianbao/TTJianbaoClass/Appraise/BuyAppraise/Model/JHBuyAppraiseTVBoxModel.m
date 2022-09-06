//
//  JHBuyAppraiseTVBoxModel.m
//  TTjianbao
//
//  Created by wangjianios on 2020/12/16.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHBuyAppraiseTVBoxModel.h"

@implementation JHBuyAppraiseTVBoxLivingModel

@end


@implementation JHBuyAppraiseTVBoxplayVideoModel

@end


@implementation JHBuyAppraiseTVBoxModel

- (void)mj_didConvertToObjectWithKeyValues:(NSDictionary *)keyValues {
    
    if(_status && IS_STRING(_status)) {
        _isLiving = [_status isEqualToString:@"live"];
    }
    
    if(_isLiving) {
        _coverUrl = _liveInfo.coverImg;
    }
    else {
        if(_playbackInfos && IS_ARRAY(_playbackInfos)) {
            JHBuyAppraiseTVBoxplayVideoModel *video = _playbackInfos[0];
            _coverUrl = video.coverImg;
        }
    }
    
    if(IS_ARRAY(_currentDepositories)) {
        for (NSString *name in _currentDepositories) {
            if(_desc) {
                _desc = [NSString stringWithFormat:@"%@·%@",_desc,name];
            }
            else {
                _desc = [NSString stringWithFormat:@"%@",name];
            }
        }
        NSString *tip = @"";
        if(_currentDepositories.count >= 2) {
            tip = [NSString stringWithFormat:@"%@仓同时",@(_currentDepositories.count)];
        }
        _desc = [NSString stringWithFormat:@"%@%@%@中",_desc,tip,(_isLiving ? @"直播" : @"回放")];
    }
}

+ (void)requestDataModelBlock:(void (^) (BOOL success, JHBuyAppraiseTVBoxModel *model))complete {
    NSString *url = FILE_BASE_STRING(@"/dl/app/info");
    [HttpRequestTool getWithURL:url Parameters:@{} successBlock:^(RequestModel * _Nullable respondObject) {
        if(IS_DICTIONARY(respondObject.data)) {
            if(complete) {
                JHBuyAppraiseTVBoxModel *m = [JHBuyAppraiseTVBoxModel mj_objectWithKeyValues:respondObject.data];
                complete(YES,m);
            }
        }
        else {
            if(complete) {
                complete(NO,nil);
            }
        }
        
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        if(complete) {
            complete(NO,nil);
        }
    }];
}

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"playbackInfos" : [JHBuyAppraiseTVBoxplayVideoModel class]};
}

//- (void)setVideoIndex:(NSInteger)videoIndex {
//    if(_playbackInfos && videoIndex < _playbackInfos.count)
//    {
//        _videoIndex = videoIndex;
//    }
//    else {
//        _videoIndex = 0;
//    }
//}

@end
