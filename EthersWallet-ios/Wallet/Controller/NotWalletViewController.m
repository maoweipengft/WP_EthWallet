//
//  NotWalletViewController.m
//  EthersWallet-ios
//
//  Created by weipeng.mao on 2018/7/30.
//  Copyright © 2018年 weipeng.mao. All rights reserved.
//

#import "NotWalletViewController.h"
#import "CreateWalletViewController.h"
#import "RestoreWalletViewController.h"
@interface NotWalletViewController ()

@end

@implementation NotWalletViewController


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)CreateWallet:(id)sender {
    CreateWalletViewController *vc = [[CreateWalletViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)BackWallet:(id)sender {
    
    RestoreWalletViewController *vc = [[RestoreWalletViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

@end
