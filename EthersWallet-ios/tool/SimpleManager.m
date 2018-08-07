//
//  SimpleManager.m
//  EthersWallet-ios
//
//  Created by weipeng.mao on 2018/8/7.
//  Copyright © 2018年 weipeng.mao. All rights reserved.
//

#import "SimpleManager.h"

@implementation SimpleManager

+(id)allocWithZone:(NSZone *)zone{
    return [SimpleManager shareInstance];
}
+(SimpleManager *)shareInstance{
    static SimpleManager * s_instance_dj_singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_instance_dj_singleton = [[super allocWithZone:nil] init];
    });
    return s_instance_dj_singleton;
}
-(id)copyWithZone:(NSZone *)zone{
    return [SimpleManager shareInstance];
}
-(id)mutableCopyWithZone:(NSZone *)zone{
    return [SimpleManager shareInstance];
}
@end
