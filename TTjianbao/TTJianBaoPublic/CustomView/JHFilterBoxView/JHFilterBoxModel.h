//
//  JHFilterBoxModel.h
//  test
//
//  Created by YJ on 2020/12/15.
//  Copyright © 2020 YJ. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHFilterBoxModel : NSObject

@property (copy, nonatomic) NSString *name;
@property (nonatomic, copy) NSString *Id;
@property (assign, nonatomic) BOOL isSelected;

@end

NS_ASSUME_NONNULL_END
