//
//  CreateWalletViewController.m
//  EthersWallet-ios
//
//  Created by weipeng.mao on 2018/7/30.
//  Copyright © 2018年 weipeng.mao. All rights reserved.
//

#import "CreateWalletViewController.h"
#import "UINavigationBar+BackgroundColor.h"
#import "NSString+judge.h"
#import "SVProgressHUD.h"
#import "WalletManager.h"
#import "KeychainItemWrapper.h"
#import "SimpleManager.h"
@interface CreateWalletViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet MyTextField *PassWordtextField;
@property (weak, nonatomic) IBOutlet MyTextField *VerifyPassWordtextField;
@property (weak, nonatomic) IBOutlet UILabel *PasswordLevelLabel;
@property (weak, nonatomic) IBOutlet UILabel *LevelLabel;
@property (weak, nonatomic) IBOutlet UIButton *CreateButton;

@end

@implementation CreateWalletViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"创建新钱包";
    
    
    self.PassWordtextField.leftTitle = @"钱包密码:";
    self.PassWordtextField.leftTitleColor = [UIColor blackColor];
    self.PassWordtextField.placeholder = @"请输入6位以上的密码";
    self.PassWordtextField.placeholderColor = [UIColor lightGrayColor];
    self.PassWordtextField.secureTextEntry = YES;
    
    [self.PassWordtextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    self.VerifyPassWordtextField.leftTitle = @"确认密码:";
    self.VerifyPassWordtextField.leftTitleColor = [UIColor blackColor];
    self.VerifyPassWordtextField.placeholder = @"验证你的密码";
    self.VerifyPassWordtextField.placeholderColor = [UIColor lightGrayColor];
    self.VerifyPassWordtextField.secureTextEntry = YES;
    [self.VerifyPassWordtextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
   
}




-(void)textFieldDidChange :(UITextField *)textField{
    if (textField == self.PassWordtextField)
    {
        self.PasswordLevelLabel.hidden = NO;
        self.LevelLabel.hidden = NO;
        if ([textField.text blackClassLblText] < 2)
        {
            self.LevelLabel.text = @"低";
        }
        else if ([textField.text blackClassLblText] == 2 && textField.text.length >=6)
        {
            self.LevelLabel.text = @"一般";
        }
        
        
        if ([textField.text blackClassLblText] > 2 &&textField.text.length >=6)
        {
            self.LevelLabel.text = @"高";
        }
        
        
        if ([textField.text isBlank])
        {
            self.PasswordLevelLabel.hidden = YES;
            self.LevelLabel.hidden = YES;
        }
        
    }
}

- (IBAction)ClickCreateWallet:(id)sender {
    
    if (self.PassWordtextField.text.length >=6  && self.VerifyPassWordtextField.text.length >=6)
    {
        if ([self.PassWordtextField.text isEqualToString:self.VerifyPassWordtextField.text])
        {
            [SVProgressHUD showWithStatus:@"创建钱包..."];
            [WalletManager createWithPassWord:self.PassWordtextField.text block:^(NSString *address, NSString *keyStore, NSString *mnemonicPhrase, NSString *privateKey, BOOL success, NSString *ErrorMessage) {
                if (success)
                {
                 
                    [SVProgressHUD showSuccessWithStatus:@"钱包创建成功!"];
                    
                    SimpleManager *simple=[SimpleManager shareInstance];
                    simple.Unlock = YES;
                    NSNotification *not = [NSNotification notificationWithName:@"Notification_CreateWallet" object:nil];
                    [[NSNotificationCenter defaultCenter] postNotification:not];
                    
                    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                    
                }
                
                else
                {
                    NSLog(@"错误信息:%@",ErrorMessage);
                    [SVProgressHUD showErrorWithStatus:@"钱包创建失败!"];
                    
                }
            }];
            
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"两次密码不一致" delegate:nil cancelButtonTitle:@"重新输入" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    }
    
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"请输入正确的密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
    }
    
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
