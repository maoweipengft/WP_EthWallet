//
//  HasKeyStoreViewController.m
//  EthersWallet-ios
//
//  Created by weipeng.mao on 2018/8/7.
//  Copyright © 2018年 weipeng.mao. All rights reserved.
//

#import "HasKeyStoreViewController.h"
#import "MyTextField.h"
#import "KeychainItemWrapper.h"
#import "HHShowView.h"
#import "WalletManager.h"
#import "NSString+judge.h"
#import "SVProgressHUD.h"
@interface HasKeyStoreViewController ()
@property (weak, nonatomic) IBOutlet MyTextField *PwdTextfield;

@end

@implementation HasKeyStoreViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    
}
- (IBAction)loginBtn:(id)sender {
    __weak typeof(self)weakself = self;
    if (_PwdTextfield.text.length < 6 || [_PwdTextfield.text isBlank])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"密码格式错误" delegate:nil cancelButtonTitle:@"重新输入" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    else
    {
        [SVProgressHUD showWithStatus:@"正在登录..."];
        [WalletManager importKeyStore:_keyStore PassWord:_PwdTextfield.text block:^(NSString *address, NSString *keyStore, NSString *mnemonicPhrase, NSString *privateKey, BOOL success, NSString *ErrorMessage) {
            if (success)
            {
                [SVProgressHUD dismiss];
                [weakself.navigationController dismissViewControllerAnimated:YES completion:nil];
            }
            else
            {
                [SVProgressHUD showErrorWithStatus:@"登录失败!"];
                
            }
            
            
        }];
    }
    
    
}

- (IBAction)forgetBtn:(id)sender {
    
    __weak typeof(self)weakself = self;
    //忘记钱包
    HHShowView *showView = [HHShowView alertTitle:@"忘记钱包" message:@"将会在您的手机里彻底忘记这个钱包,并且创建一个新的钱包"];
    showView.butttonCancelBgColor = [UIColor orangeColor];
    
    [showView addAction:[HHAlertAction actionTitle:@"取消" style:HHAlertActionCancel handler:^(HHAlertAction *action) {
        
    }]];
    
    [showView addAction:[HHAlertAction actionTitle:@"确定" style:HHAlertActionConfirm handler:^(HHAlertAction *action) {
        KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc]initWithIdentifier:@"ethers.mwp" accessGroup:nil];
        [keychain resetKeychainItem];
        
        [weakself.navigationController dismissViewControllerAnimated:YES completion:nil];
        
    }]];
    [showView show];
    
    
    
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"需要提供密码";
    self.PwdTextfield.leftTitle = @"密码:";
    self.PwdTextfield.leftTitleColor = [UIColor lightGrayColor];
    self.PwdTextfield.secureTextEntry = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
