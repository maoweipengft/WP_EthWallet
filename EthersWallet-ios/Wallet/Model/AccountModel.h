//
//  AccountModel.h
//  EthersWallet-ios
//
//  Created by weipeng.mao on 2018/8/3.
//  Copyright © 2018年 weipeng.mao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AddressModel.h"
@interface AccountModel : NSObject
@property (nonatomic, copy) NSData *QrCodeDate;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSData *privateKey;
@property (nonatomic, copy) NSString *mnemonicPhrase;
@property (nonatomic, copy) NSData *mnemonicData;
@property (nonatomic, strong)   AddressModel *address;
+ (NSString *)whc_SqliteVersion;
@end
