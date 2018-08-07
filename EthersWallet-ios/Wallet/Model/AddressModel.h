//
//  AddressModel.h
//  EthersWallet-ios
//
//  Created by weipeng.mao on 2018/8/3.
//  Copyright © 2018年 weipeng.mao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressModel : NSObject
@property (nonatomic, copy) NSString *checksumAddress;
@property (nonatomic, copy) NSString *icapAddress;

@property (nonatomic, copy) NSData *data;
+ (NSString *)whc_SqliteVersion;
@end
