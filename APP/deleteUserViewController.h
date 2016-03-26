//
//  deleteUserViewController.h
//  APP
//
//  Created by Raymond on 15-5-20.
//  Copyright (c) 2015年 zhougaojv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserList.h"

@interface deleteUserViewController : UIViewController

//当前用户
@property(nonatomic,weak)User* activeUser;

//当前用户列表
@property(nonatomic,weak)UserList* activeUserList;

@end
