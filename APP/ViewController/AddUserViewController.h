//
//  AddUserViewController.h
//  APP
//
//  Created by zhougaojv on 15/5/15.
//  Copyright (c) 2015年 zhougaojv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserList.h"

@interface AddUserViewController : UIViewController

//当前用户列表
@property(nonatomic,weak)UserList* activeUserList;

@end
