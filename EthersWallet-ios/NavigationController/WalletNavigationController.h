//
//  WalletNavigationController.h
//  EthersWallet-ios
//
//  Created by weipeng.mao on 2018/7/30.
//  Copyright © 2018年 weipeng.mao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WalletNavigationController : UINavigationController

@property(nonatomic, strong) NSMutableArray *blackList;
- (void)addFullScreenPopBlackListItem:(UIViewController *)viewController;
- (void)removeFromFullScreenPopBlackList:(UIViewController *)viewController;

@end
