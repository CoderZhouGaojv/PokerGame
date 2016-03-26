//
//  IndexViewController.m
//  APP
//
//  Created by zhougaojv on 15/5/15.
//  Copyright (c) 2015年 zhougaojv. All rights reserved.
//

#import "IndexViewController.h"
#import "AddUserViewController.h"
#import "UserIndexViewController.h"
#import "UserListWithFMDB.h"

@interface IndexViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *mytable;
@property (weak, nonatomic) IBOutlet UIButton *addUserButton;

//生成随机颜色
-(UIColor*)randomcolor;

//用户列表
@property(nonatomic,strong)UserList* myUserList;

//保存用户列表到数据库
-(void)save;

@end

@implementation IndexViewController

//惰性初始化
-(UserList*)myUserList
{
    if (!_myUserList)
    {
        _myUserList = [[UserList alloc]init];
    }
    
    return _myUserList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //从数据库中读取用户数据
    [UserListWithFMDB openDB];
    [UserListWithFMDB readToUserList:self.myUserList];
    [UserListWithFMDB closeDB];
    
    //监听程序进入后台的广播频道"DidEnterBackground"
    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(save) name:@"DidEnterBackground" object:nil];
    
//    //设置背景颜色为随机颜色
//    self.view.backgroundColor = [self randomcolor];
    
//    //设置添加玩家按钮为随机颜色
//    [self.addUserButton setBackgroundColor:[self randomcolor]];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.mytable reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//为tableview提供tableviewcell
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* key = @"cell";
    
    UITableViewCell* tvc = [self.mytable dequeueReusableCellWithIdentifier:key];
    
    if (!tvc)
    {
        tvc = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:key];
    }
    
    tvc.textLabel.text = [[self.myUserList useratindex:indexPath.row]myname];
    
//    //以视图背景颜色为基础，设置每个CELL渐变颜色
//    CIColor* tcicolor = [[CIColor alloc]initWithColor:self.view.backgroundColor];
//    UIColor* tv = [UIColor colorWithCIColor:[CIColor colorWithRed:tcicolor.red+indexPath.row*0.1 green:tcicolor.green+indexPath.row*0.1 blue:tcicolor.blue+indexPath.row*0.1 alpha:tcicolor.alpha]];
//    tvc.backgroundColor = tv;
    
    //设置每个cell的背景颜色为随机颜色
    tvc.backgroundColor = [self randomcolor];
//    tvc.textLabel.textColor = [UIColor whiteColor];
    tvc.textLabel.textColor = [UIColor colorWithRed:1 green:0.5 blue:(CGFloat)36/255 alpha:1];
    
    return tvc;
}

//返回tableview中对应组的元素个数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.myUserList.usercount;
}

//故事版跳转的一些准备工作
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"jumptoadduservc"])
    {
        if ([segue.destinationViewController isKindOfClass:[AddUserViewController class]])
        {
            AddUserViewController* tauvc = (AddUserViewController*)segue.destinationViewController;
            tauvc.activeUserList = self.myUserList;
        }
    }
    else if ([segue.identifier isEqualToString:@"jumptouserindexvc"])
    {
        if ([segue.destinationViewController isKindOfClass:[UserIndexViewController class]])
        {
            UserIndexViewController* tuivc = (UserIndexViewController*)segue.destinationViewController;
            tuivc.activeUser = [self.myUserList useratindex:[[self.mytable indexPathForSelectedRow]row]];
            tuivc.activeUserList = self.myUserList;
        }
    }
}

-(UIColor*)randomcolor
{
    CGFloat hue = ( arc4random() % 256 / 256.0 );
    CGFloat saturation = ( arc4random() % 128 / 256.0 );
//    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;
    CGFloat brightness = 0.95;
    UIColor* tv = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    
    return tv;
}

-(void)save
{
    NSLog(@"保存数据");
    
    //保存用户数据到数据库
    [UserListWithFMDB openDB];
    [UserListWithFMDB writeToDBFromUserList:self.myUserList];
    [UserListWithFMDB closeDB];
}
@end
