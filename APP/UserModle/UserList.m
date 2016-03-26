//
//  UserList.m
//  APP
//
//  Created by zhougaojv on 15/5/14.
//  Copyright (c) 2015年 zhougaojv. All rights reserved.
//

#import "UserList.h"

@interface UserList ()

//保存User的数组
@property(nonatomic,strong)NSMutableArray* userarry;

@end

@implementation UserList

//惰性初始化
-(NSMutableArray*)userarry
{
    if (!_userarry)
    {
        _userarry = [[NSMutableArray alloc]init];
    }
    
    return _userarry;
}

-(BOOL)adduser:(User *)tuser
{
    //判断是否有相同用户名的用户存在
    for (User* i in self.userarry)
    {
        //如果有则返回NO
        if ([i.myname isEqualToString:tuser.myname])
        {
            return NO;
        }
    }
    
    [self.userarry addObject:tuser];
    
    return YES;
}

-(void)removeuser:(User *)tuser
{
    [self.userarry removeObject:tuser];
}

-(User*)useratindex:(NSInteger)index
{
    if (index < self.userarry.count)
    {
        return [self.userarry objectAtIndex:index];
    }
    else
    {
        NSLog(@"从UserList获取User时下标越界");
        return nil;
    }
}

-(NSInteger)usercount
{
    return self.userarry.count;
}

@end
