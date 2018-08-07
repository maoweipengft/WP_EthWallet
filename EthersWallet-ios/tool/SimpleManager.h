//
//  SimpleManager.h
//  EthersWallet-ios
//
//  Created by weipeng.mao on 2018/8/7.
//  Copyright © 2018年 weipeng.mao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SimpleManager : NSObject
+(SimpleManager *)shareInstance;

-(BOOL)VerifyPassword:(NSString *)pwd;

@property (nonatomic,assign)BOOL Unlock;
@end
