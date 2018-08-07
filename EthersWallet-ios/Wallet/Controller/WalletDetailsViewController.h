//
//  WalletDetailsViewController.h
//  EthersWallet-ios
//
//  Created by weipeng.mao on 2018/8/3.
//  Copyright © 2018年 weipeng.mao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountModel.h"
@interface WalletDetailsViewController : UIViewController
@property (nonatomic,strong)AccountModel *model;
@property (nonatomic,strong)NSString *balnce;
@end
