//
//  deleteUserViewController.m
//  APP
//
//  Created by Raymond on 15-5-20.
//  Copyright (c) 2015年 zhougaojv. All rights reserved.
//

#import "deleteUserViewController.h"

@interface deleteUserViewController ()<UIAlertViewDelegate,UITextFieldDelegate>

//删除密码输入栏
@property (weak, nonatomic) IBOutlet UITextField *deletePassWordTextField;

//用户点击空白时响应的操作
-(void)clickBlankSpace;

@end

@implementation deleteUserViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //设置输入栏的代理为视图控制器
    self.deletePassWordTextField.delegate = self;
    
//    //初始化背景颜色，设置为随机颜色
//    
//    //随机生成色调，数值在0-1.0之间
//    CGFloat hue = ( arc4random() % 256 / 256.0 );
//    
//    //随进生成饱和度，数值的0-0.5之间，防止颜色太浓导致界面太过刺眼
//    CGFloat saturation = ( arc4random() % 128 / 256.0 );
//    
//    //随机生成亮度，数值在0.5-1之间，防止背景颜色太暗导致用户违法看清其他内容
//    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;
//    
//    UIColor* tv = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
//    self.view.backgroundColor = tv;
    
    //设置导航栏的标题
    self.navigationItem.title =  [NSString stringWithFormat:@"删除%@",self.activeUser.myname];
    
    //为整个视图的背景添加一个点击触发动作
    UITapGestureRecognizer* tgr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickBlankSpace)];
    [self.view addGestureRecognizer:tgr];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//点击完成按钮时调用的方法
- (IBAction)clickFinshButton
{
    //判断删除密码是否正确，并弹出相应的提示窗口
    if ([self.activeUser.deletepassword isEqualToString:self.deletePassWordTextField.text])
    {
        UIAlertView* tav = [[UIAlertView alloc]initWithTitle:@"确定要删除吗?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
        [tav show];
    }
    else
    {
        UIAlertView* tav = [[UIAlertView alloc]initWithTitle:@"删除密码错误" message:nil delegate:nil cancelButtonTitle:@"重新输入" otherButtonTitles:nil];
        [tav show];
    }
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //处理用户在提示窗口进行的操作
    if (buttonIndex == alertView.firstOtherButtonIndex)
    {
        [self.activeUserList removeuser:self.activeUser];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

//用户的输入栏点击回车时调用的方法
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //取消输入栏的第一响应位置
    return [textField resignFirstResponder];
}

//用户点击空白时调用的方法
-(void)clickBlankSpace
{
    //取消输入栏的第一响应位置
    [self.deletePassWordTextField resignFirstResponder];
}

@end
