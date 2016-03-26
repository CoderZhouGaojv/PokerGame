//
//  UserListWithFMDB.h
//  APP
//
//  Created by zhougaojv on 15/5/14.
//  Copyright (c) 2015年 zhougaojv. All rights reserved.


//使用单例模式封装了FMDB数据库，使操作更加简便

#import <Foundation/Foundation.h>
#import "UserList.h"
#import "FMDB.h"

//使用的表名称
static NSString* tablenameForUserListWithFMDB = @"UserListData";

//默认使用的数据库文件名
static NSString* DBFileNameForUserListWithFMDB = @"PokerGame.db";

@interface UserListWithFMDB : NSObject

//打开沙盒Documents文件夹下的默认数据库
+(BOOL)openDB;

//打开指定位置的数据库文件
+(BOOL)openDBWithDBpath:(NSString*)DBpath;

//从数据库中读取数据到指定的UserList
+(BOOL)readToUserList:(UserList*)userList;

//将指定UserList的数据写入数据库中
+(BOOL)writeToDBFromUserList:(UserList*)userList;

//关闭数据库
+(BOOL)closeDB;

@end
