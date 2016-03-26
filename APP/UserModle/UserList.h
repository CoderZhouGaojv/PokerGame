//
//  UserList.h
//  APP
//
//  Created by zhougaojv on 15/5/14.
//  Copyright (c) 2015年 zhougaojv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface UserList : NSObject

//加入一个用户
-(BOOL)adduser:(User*)tuser;

//删除一个用户
-(void)removeuser:(User*)tuser;

//根据下标获取一个用户
-(User*)useratindex:(NSInteger)index;

//获取用户总数
-(NSInteger)usercount;

@end
