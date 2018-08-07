//
//  RestoreWalletViewController.m
//  EthersWallet-ios
//
//  Created by weipeng.mao on 2018/8/7.
//  Copyright © 2018年 weipeng.mao. All rights reserved.
//

#import "RestoreWalletViewController.h"
#import "Masonry.h"
#import "MyTextField.h"
#import "WalletManager.h"
#import "NSString+judge.h"
#import "SVProgressHUD.h"
@interface RestoreWalletViewController ()
@property (nonatomic,strong)UITextView *textView;
@property (nonatomic,strong)MyTextField *pwdField;
@property (nonatomic,strong)MyTextField *validationField;
@end

@implementation RestoreWalletViewController


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUI];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(transformView:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
}


//键盘回收
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    for(UIView *view in self.view.subviews)
    {
        [view resignFirstResponder];
    }
}

-(void)transformView:(NSNotification *)aNSNotification
{
  
    NSValue *keyBoardBeginBounds=[[aNSNotification userInfo]objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect beginRect=[keyBoardBeginBounds CGRectValue];
    

    NSValue *keyBoardEndBounds=[[aNSNotification userInfo]objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect  endRect=[keyBoardEndBounds CGRectValue];

    CGFloat deltaY=endRect.origin.y-beginRect.origin.y;
    NSLog(@"看看这个变化的Y值:%f",deltaY);
    
    if (self.view.frame.size.width !=320)
    {
        return;
    }
    
    [UIView animateWithDuration:0.25f animations:^{
        [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+deltaY, self.view.frame.size.width, self.view.frame.size.height)];
    }];
}


-(void)setUI
{
    
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    
    but.frame =CGRectMake(0,0, 60, 44);
    
    [but setTitle:@"确定"forState:UIControlStateNormal];
    
    [but addTarget:self action:@selector(determine) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem  *barBut = [[UIBarButtonItem alloc]initWithCustomView:but];
    
    self.navigationItem.rightBarButtonItem = barBut;
    
    
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.font = [UIFont systemFontOfSize:14.];
    titleLabel.textColor = [UIColor lightGrayColor];
    titleLabel.numberOfLines = 0;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"输入您的恢复短语\n恢复短语:12个英文单词,空格分隔.";
    [self.view addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(30);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        //make.height.equalTo(@120);
    }];
    
    self.textView = [[UITextView alloc]init];
    self.textView.layer.cornerRadius = 5;
    self.textView.layer.masksToBounds = YES;
    self.textView.layer.borderWidth = 2;
    self.textView.text = @"habit lion garden pigeon skate gain accident process shove shift affair truck";
    self.textView.layer.borderColor = [UIColor blackColor].CGColor;
    
    
    
    [self.view addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(5);
        make.left.equalTo(self.view).offset(30);
        make.right.equalTo(self.view).offset(-30);
        make.height.equalTo(@200);
    }];
    
    self.pwdField = [[MyTextField alloc]init];
    self.pwdField.leftTitle = @"密码:";
    self.pwdField.leftTitleColor = [UIColor blackColor];
    self.pwdField.placeholder = @"请输入6位以上的密码";
    self.pwdField.placeholderColor = [UIColor lightGrayColor];
    self.pwdField.secureTextEntry = YES;
    
    [self.view addSubview:self.pwdField];
    [self.pwdField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textView.mas_bottom).offset(20);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.equalTo(@25);
    }];
    
    
    MyTextField *validation = [[MyTextField alloc]init];
    validation.leftTitle = @"重复密码:";
    validation.leftTitleColor = [UIColor blackColor];
    //validation.placeholder = @"请输入6位以上的密码";
   // validation.placeholderColor = [UIColor lightGrayColor];
    validation.secureTextEntry = YES;
    
    [self.view addSubview:validation];
    [validation mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pwdField.mas_bottom).offset(20);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.equalTo(@25);
    }];
    self.validationField = validation;
    
    
}

-(void)determine
{
    __weak typeof(self)weakself = self;
    if ([self.textView.text isBlank])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"输入正确的恢复短语" delegate:nil cancelButtonTitle:@"重新输入" otherButtonTitles:nil, nil];
        [alert show];
        
        return;
    }
    
    
    if ([self.pwdField.text isEqualToString:self.validationField.text] && ![self.pwdField.text isBlank])
    {
        [SVProgressHUD showWithStatus:@"正在恢复钱包..."];
        [WalletManager inportMnemonics:self.textView.text PassWord:self.pwdField.text block:^(NSString *address, NSString *keyStore, NSString *mnemonicPhrase, NSString *privateKey, BOOL success, NSString *ErrorMessage) {
            if (success)
            {
                [SVProgressHUD dismiss];
                 [weakself.navigationController dismissViewControllerAnimated:YES completion:nil];
            }
            else
            {
                [SVProgressHUD dismiss];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"%@",ErrorMessage] delegate:nil cancelButtonTitle:@"重新输入" otherButtonTitles:nil, nil];
                [alert show];
            }
           
            
            
        }];
        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"两次密码不一致" delegate:nil cancelButtonTitle:@"重新输入" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
