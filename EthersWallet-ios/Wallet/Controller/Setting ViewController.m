//
//  Setting ViewController.m
//  EthersWallet-ios
//
//  Created by weipeng.mao on 2018/8/7.
//  Copyright © 2018年 weipeng.mao. All rights reserved.
//

#import "Setting ViewController.h"
#import "TableViewCell.h"
#import "HHShowView.h"
#import "WHC_ModelSqlite.h"
#import "AccountModel.h"
#import "KeychainItemWrapper.h"
@interface Setting_ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@end

@implementation Setting_ViewController


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    [self.view addSubview:self.tableView];
    [self setNavLeftButton];
}


-(void)setNavLeftButton
{
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    
    but.frame =CGRectMake(0,0, 20, 20);
   
    
    //[but setTitle:@"<返回"forState:UIControlStateNormal];
    [but setImage:[UIImage imageNamed:@"Close"] forState:UIControlStateNormal];
    [but addTarget:self action:@selector(backViewController) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem  *barBut = [[UIBarButtonItem alloc]initWithCustomView:but];
    
    self.navigationItem.leftBarButtonItem = barBut;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellid"];
    if (!cell)
    {
        cell = [[TableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellid"];
    }
    
    cell.textLabel.text = @"";
    
    switch (indexPath.row)
    {
        case 0:
            cell.textLabel.text = @"交易记录";
            break;
        case 1:
            cell.textLabel.text = @"查看恢复短语";
            break;
            
        case 2:
            cell.textLabel.text = @"注销钱包";
            break;
        default:
            break;
    }
    
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    switch (indexPath.row)
    {
        case 0:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有交易记录" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
            break;
            
        case 1:
        {
            NSArray *array = [WHC_ModelSqlite query:[AccountModel class]];
            AccountModel *account = [array firstObject];
            NSString *str = account.mnemonicPhrase;
            NSLog(@"%@",str);
            HHShowView *showView = [HHShowView alertTitle:@"您的恢复短语" message:str];
            showView.butttonCancelBgColor = [UIColor orangeColor];
            
           
            
            [showView addAction:[HHAlertAction actionTitle:@"确定" style:HHAlertActionConfirm handler:^(HHAlertAction *action) {
               
                
            }]];
            [showView show];
            
        }
            break;
        case 2:
        {
            __weak typeof(self)weakself = self;
            //忘记钱包
            HHShowView *showView = [HHShowView alertTitle:@"忘记钱包" message:@"将会在您的手机里彻底忘记这个钱包,并且创建一个新的钱包"];
            showView.butttonCancelBgColor = [UIColor orangeColor];
            
            [showView addAction:[HHAlertAction actionTitle:@"取消" style:HHAlertActionCancel handler:^(HHAlertAction *action) {
                
            }]];
            
            [showView addAction:[HHAlertAction actionTitle:@"确定" style:HHAlertActionConfirm handler:^(HHAlertAction *action) {
                KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc]initWithIdentifier:@"ethers.mwp" accessGroup:nil];
                [keychain resetKeychainItem];
                [WHC_ModelSqlite removeAllModel];
                [weakself.navigationController dismissViewControllerAnimated:YES completion:nil];
                
            }]];
            [showView show];
        }
            break;
            
        default:
            break;
    }
}


-(void)backViewController
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}


-(UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return _tableView;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
