//
//  UserIndexViewController.m
//  APP
//
//  Created by Raymond on 15-5-15.
//  Copyright (c) 2015年 zhougaojv. All rights reserved.
//

#import "UserIndexViewController.h"
#import "deleteUserViewController.h"
#import "SimpleGameViewController.h"
#import "NormalGameViewController.h"
#import "HardGameViewController.h"
#import "VeryHardViewController.h"

@interface UserIndexViewController ()<UIAlertViewDelegate>

//界面的各种元素
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *simpleGameHighestScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *normalGameHighestScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *hardGameHighestScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *veryHardGameHighestScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *veryHardGameHighestScoreTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *veryHardGameHighestScoreBackgroundView;
@property (weak, nonatomic) IBOutlet UILabel *remainingNumberLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *difficultySettingSegmented;
@property (weak, nonatomic) IBOutlet UISegmentedControl *difficultySettingSegmentedWithVeryHard;

//生成随机颜色
-(UIColor*)randomColor;

//点击删除按钮时调用的方法
-(void)clickDeleteButton;

//更新UI
-(void)updateui;

@end

@implementation UserIndexViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //设置导航栏的标题
    self.navigationItem.title = self.activeUser.myname;
    
    //设置导航控制器中下级视图的返回按钮
    UIBarButtonItem* tubbi = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = tubbi;
    
//    //设置背景颜色为随机颜色
//    CGFloat hue = ( arc4random() % 256 / 256.0 );
//    CGFloat saturation = ( arc4random() % 128 / 256.0 );
//    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;
//    UIColor* tv = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
//    self.view.backgroundColor = tv;
    
    //设置导航栏右按钮为删除按钮
    UIBarButtonItem* tbbi = [[UIBarButtonItem alloc]initWithTitle:@"删除" style:UIBarButtonItemStyleDone target:self action:@selector(clickDeleteButton)];
    tbbi.tintColor = [UIColor redColor];
    self.navigationItem.rightBarButtonItem = tbbi;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self updateui];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//私有方法
-(void)updateui
{
    self.userNameLabel.text = self.activeUser.myname;
    self.simpleGameHighestScoreLabel.text = [NSString stringWithFormat:@"%d",self.activeUser.simpleGameHighestScore];
    self.normalGameHighestScoreLabel.text = [NSString stringWithFormat:@"%d",self.activeUser.normalGameHighestScore];
    self.hardGameHighestScoreLabel.text = [NSString stringWithFormat:@"%d",self.activeUser.hardGameHighestScore];
    self.veryHardGameHighestScoreLabel.text = [NSString stringWithFormat:@"%d",self.activeUser.veryHardGameHighestScore];
    self.remainingNumberLabel.text = [NSString stringWithFormat:@"%d",self.activeUser.remainingNumber];
    
    //根据该用户是否解锁隐藏模式设定界面上的一下元素
    if (self.activeUser.openedVeryHard)
    {
        self.difficultySettingSegmented.hidden = YES;
        self.difficultySettingSegmentedWithVeryHard.hidden = NO;
        self.veryHardGameHighestScoreLabel.hidden = NO;
        self.veryHardGameHighestScoreTitleLabel.hidden = NO;
        self.veryHardGameHighestScoreBackgroundView.hidden = NO;
    }
    else
    {
        self.difficultySettingSegmented.hidden = NO;
        self.difficultySettingSegmentedWithVeryHard.hidden = YES;
        self.veryHardGameHighestScoreLabel.hidden = YES;
        self.veryHardGameHighestScoreTitleLabel.hidden = YES;
        self.veryHardGameHighestScoreBackgroundView.hidden = YES;
    }
}

- (IBAction)clickBeginGame:(UIButton *)sender
{
    NSUInteger t;
    
    //根据该用户是否解锁隐藏模式读取用户的难度选择
    if (self.activeUser.openedVeryHard)
    {
        t = self.difficultySettingSegmentedWithVeryHard.selectedSegmentIndex;
    }
    else
    {
        t = self.difficultySettingSegmented.selectedSegmentIndex;
    }
    
    //判断用户的剩余游戏次数是否不足，不足则不会开始游戏并弹出提示
    if (self.activeUser.remainingNumber > 0)
    {
        if (t == 0)
        {
            SimpleGameViewController* tsgvc = [self.storyboard instantiateViewControllerWithIdentifier:@"SimpleGameViewController"];
            tsgvc.activedUser = self.activeUser;
            [self.navigationController pushViewController:tsgvc animated:YES];
        }
        else if (t == 1)
        {
            NormalGameViewController* tngc = [self.storyboard instantiateViewControllerWithIdentifier:@"NormalGameViewController"];
            tngc.activedUser = self.activeUser;
            [self.navigationController pushViewController:tngc animated:YES];
        }
        else if (t == 2)
        {
            HardGameViewController* thgc = [self.storyboard instantiateViewControllerWithIdentifier:@"HardGameViewController"];
            thgc.activedUser = self.activeUser;
            [self.navigationController pushViewController:thgc animated:YES];
        }
        else if (t == 3)
        {
            VeryHardViewController* tvhgc = [self.storyboard instantiateViewControllerWithIdentifier:@"VeryHardViewController"];
            tvhgc.activedUser = self.activeUser;
            [self.navigationController pushViewController:tvhgc animated:YES];
        }
    }
    else
    {
        UIAlertView* tav = [[UIAlertView alloc]initWithTitle:@"剩余次数不足" message:@"请休息一会儿再来过" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [tav show];
    }
}

-(UIColor*)randomColor
{
    CGFloat hue = ( arc4random() % 256 / 256.0 );
    CGFloat saturation = ( arc4random() % 128 / 256.0 );
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;
    UIColor* tv = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    
    return tv;
}
-(void)clickDeleteButton
{
    //判断该用户是否设置了删除密码
    if ([self.activeUser.deletepassword isEqualToString:@""])
    {
        //没有删除密码，直接弹出删除确定提示框
        UIAlertView* tav = [[UIAlertView alloc]initWithTitle:@"确定要删除当前用户?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
        [tav show];
    }
    else
    {
        //有删除密码，转到删除界面
        deleteUserViewController* tuvc = [self.storyboard instantiateViewControllerWithIdentifier:@"deleteUserViewController"];
        tuvc.activeUser = self.activeUser;
        tuvc.activeUserList = self.activeUserList;
        [self.navigationController pushViewController:tuvc animated:YES];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //处理用户在删除提示框上进行的操作
    if (buttonIndex == alertView.firstOtherButtonIndex)
    {
        [self.activeUserList removeuser:self.activeUser];
        [self.navigationController popViewControllerAnimated:YES];
    }
}


@end
