//
//  HomeViewController.m
//  EthersWallet-ios
//
//  Created by weipeng.mao on 2018/8/3.
//  Copyright © 2018年 weipeng.mao. All rights reserved.
//

#import "HomeViewController.h"
#import "KeychainItemWrapper.h"
#import "NotWalletViewController.h"
#import "WalletNavigationController.h"
#import "HomeCell.h"
#import "WalletDetailsViewController.h"
#import "WHC_ModelSqlite.h"
#import "AccountModel.h"
#import "HasKeyStoreViewController.h"
#import "SimpleManager.h"
#import "Setting ViewController.h"
@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,assign)BOOL isShow;
@property (nonatomic,strong)AccountModel *ethaccount;

@end

@implementation HomeViewController


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [self UpdateTable];
    
    SimpleManager *simple=[SimpleManager shareInstance];
    if (simple.Unlock)
    {
        NSLog(@"已经解锁");
    }
    else
    {
        NSLog(@"没有解锁");
    }
    
}





- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的钱包";
     [self.view addSubview:self.tableView];
    self.tableView.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    //创建了钱包
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UpdateTable) name:@"Notification_CreateWallet" object:nil];
    
    [self setNavLeftButton];

    
    [self UpdateTable];
   // [keychain resetKeychainItem];
}

-(void)setNavLeftButton
{
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    
    but.frame =CGRectMake(0,0, 32, 32);
    
    //[but setTitle:@"<返回"forState:UIControlStateNormal];
    [but setImage:[UIImage imageNamed:@"Menu"] forState:UIControlStateNormal];
    [but addTarget:self action:@selector(ShowMenu) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem  *barBut = [[UIBarButtonItem alloc]initWithCustomView:but];
    
    self.navigationItem.leftBarButtonItem = barBut;
}

-(void)ShowMenu
{
    Setting_ViewController *vc = [[Setting_ViewController alloc]init];
    WalletNavigationController *nc = [[WalletNavigationController alloc]initWithRootViewController:vc];
    [self.navigationController presentViewController:nc animated:YES completion:nil];
}


-(void)UpdateTable
{
    [self DetectionWallet];
    if (_isShow)
    {
        self.tableView.hidden = NO;
    }
    else
    {
        self.tableView.hidden = YES;
    }
    [self.tableView reloadData];
    
}


-(void)DetectionWallet
{
    NSArray *array = [WHC_ModelSqlite query:[AccountModel class]];
    if (array.count)
    {
        AccountModel *model = array.firstObject;
        _ethaccount = model;
        _isShow = YES;
        NSLog(@"发现本地钱包:%@",model.address.checksumAddress);
    }
    else
    {
        _isShow = NO;
        KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc]initWithIdentifier:@"ethers.mwp" accessGroup:nil];
        NSString *keyStore = [keychain objectForKey:(id)kSecValueData];
        if (keyStore.length>0)
        {
            //发现keyStore
            HasKeyStoreViewController *vc = [[HasKeyStoreViewController alloc]init];
            vc.keyStore = keyStore;
            
            WalletNavigationController *nc = [[WalletNavigationController alloc]initWithRootViewController:vc];
            [self.navigationController presentViewController:nc animated:YES completion:nil];
            
            
        }
        
        else
        {
            _isShow = NO;
            NotWalletViewController *vc = [[NotWalletViewController alloc]init];
            WalletNavigationController *nc = [[WalletNavigationController alloc]initWithRootViewController:vc];
            //vc.nav = self.navigationController;
            [self.navigationController presentViewController:nc animated:YES completion:nil];
        }
    }
    
    //[self UpdateTable];
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeCellid"];
    if (!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HomeCell" owner:self options:nil] firstObject];
    }
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.IconImageView.image = [UIImage imageNamed:@"eth"];
    cell.model = _ethaccount;
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    WalletDetailsViewController *vc = [[WalletDetailsViewController alloc]init];
    vc.model =  cell.model;
    vc.balnce = cell.numberLabel.text;
    [self.navigationController pushViewController:vc animated:YES];
    
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
    
}


@end
