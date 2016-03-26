//
//  AddUserViewController.m
//  APP
//
//  Created by zhougaojv on 15/5/15.
//  Copyright (c) 2015年 zhougaojv. All rights reserved.
//

#import "AddUserViewController.h"
#import "UserListWithFMDB.h"

@interface AddUserViewController ()<UITextFieldDelegate,UITextFieldDelegate>

//界面中的各种元素
@property (weak, nonatomic) IBOutlet UITextField *usernametextfield;
@property (weak, nonatomic) IBOutlet UIView *usernametextfieldBackgroundView;
@property (weak, nonatomic) IBOutlet UITextField *deletepasswordtextfield;
@property (weak, nonatomic) IBOutlet UIView *deletepasswordtextfieldBackgroundView;

//生成随机颜色
-(UIColor*)randomColor;

//点击空白时调用的方法
-(void)clickBlankSpace;

@end

@implementation AddUserViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    //设置背景颜色为随机颜色
//    self.view.backgroundColor = [self randomColor];
//    
//    //设置两个提示文字背景颜色为随机颜色
//    self.usernametextfieldBackgroundView.backgroundColor = [self randomColor];
//    self.deletepasswordtextfieldBackgroundView.backgroundColor = [self randomColor];
    
    //为背景添加一个点击动作
    UITapGestureRecognizer* tgr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickBlankSpace)];
    [self.view addGestureRecognizer:tgr];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//点击完成按钮时调用的方法
- (IBAction)clickfinshedbutton:(id)sender
{
    //判断用户是否填写了用户名
    if ([self.usernametextfield.text isEqualToString:@""])
    {
        //没有填写用户名，弹出提示框
        UIAlertView* tav =[[UIAlertView alloc]initWithTitle:@"用户名不能为空" message:nil delegate:nil cancelButtonTitle:@"重新填写" otherButtonTitles:nil];
        [tav show];
        
    }
    else
    {
        User* tu = [[User alloc]initWithname:self.usernametextfield.text AndPassWord:self.deletepasswordtextfield.text];
    
        //判断是否存在用户名相同的用户
        if ([self.activeUserList adduser:tu])
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            //存在则弹出提示框
            UIAlertView* tav =[[UIAlertView alloc]initWithTitle:@"用户名已存在" message:nil delegate:nil cancelButtonTitle:@"重新填写" otherButtonTitles:nil];
            [tav show];
        }
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//用户在输入框中点击回车时调用的方法
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    BOOL t = [textField resignFirstResponder];
    
    if (textField == self.usernametextfield)
    {
        return [self.deletepasswordtextfield becomeFirstResponder];
    }
    
    return t;
}

-(UIColor*)randomColor;
{
    CGFloat hue = ( arc4random() % 256 / 256.0 );
    CGFloat saturation = ( arc4random() % 128 / 256.0 );
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;
    UIColor* tv = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    
    return tv;
}

-(void)clickBlankSpace
{
    //取消输入框的第一响应位置
    [self.usernametextfield resignFirstResponder];
    [self.deletepasswordtextfield resignFirstResponder];
}



@end
