//
//  UserListWithFMDB.m
//  APP
//
//  Created by zhougaojv on 15/5/14.
//  Copyright (c) 2015年 zhougaojv. All rights reserved.
//

#import "UserListWithFMDB.h"

//单例保有的静态变量
static FMDatabase* FMDBforUserListWithFMDB = nil;

@interface UserListWithFMDB ()

//判断数据库中是否有需要的表
+(BOOL)havetable;

//在数据库中新建一个表
+(BOOL)newtable;

@end

@implementation UserListWithFMDB

//打开沙盒Documents文件夹下的默认数据库
+(BOOL)openDB
{
    NSString* dbpath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"PokerGame.db"];
    
    return [self openDBWithDBpath:dbpath];
}

//打开指定位置的数据库文件
+(BOOL)openDBWithDBpath:(NSString *)DBpath
{
    //单例模式一次只能打开一个数据库，判断是否已经有打开的数据库
    if (FMDBforUserListWithFMDB != nil)
    {
        NSLog(@"数据库已经打开,不能再次打开");
        return NO;
    }
    else
    {
        FMDBforUserListWithFMDB = [FMDatabase databaseWithPath:DBpath];
        
        //判断数据库打开是否成功
        if ([FMDBforUserListWithFMDB open])
        {
            NSLog(@"数据库打开成功");
            return YES;
        }
        else
        {
            //如果打开失败，将保有的静态变量置空
            FMDBforUserListWithFMDB = nil;
            NSLog(@"数据库打开失败");
            return NO;
        }
    }
}

//从数据库中读取数据到指定的UserList
+(BOOL)readToUserList:(UserList *)userList
{
    //判断是否已经打开数据库，否则不进行其他操作
    if (!FMDBforUserListWithFMDB)
    {
        NSLog(@"没有打开数据库");
        return NO;
    }
    
    //判断数据库中是否有需要的表，否则否则不进行其他操作
    if (![self havetable])
    {
        NSLog(@"数据库中没有需要的表");
        return NO;
    }
    else
    {
        NSString* fmdbcode1 = [NSString stringWithFormat:@"SELECT * FROM %@",tablenameForUserListWithFMDB];
        
        NSLog(@"从数据库中读取数据");
        
        FMResultSet* trs = [FMDBforUserListWithFMDB executeQuery:fmdbcode1];
        
        while ([trs next])
        {
            NSLog(@"读取一条用户记录");
            User* tu = [[User alloc]init];
            
            tu.myname = [trs stringForColumn:@"myname"];
            tu.deletepassword = [trs stringForColumn:@"deletepassword"];
            tu.simpleGameHighestScore = [trs intForColumn:@"simpleGameHighestScore"];
            tu.normalGameHighestScore = [trs intForColumn:@"normalGameHighestScore"];
            tu.hardGameHighestScore = [trs intForColumn:@"hardGameHighestScore"];
            tu.openedVeryHard = [trs boolForColumn:@"openedVeryHard"];
            tu.veryHardGameHighestScore = [trs intForColumn:@"veryHardGameHighestScore"];
            tu.lastRemainingNumber = [trs intForColumn:@"lastRemainingNumber"];
            tu.lastGameTime = [trs dateForColumn:@"lastGameTime"];
            
            tu.lastRemainingNumber = tu.remainingNumber;
            tu.lastGameTime = [[NSDate alloc]init];
            
            [userList adduser:tu];
        }
        
        NSLog(@"读取数据结束");
        return YES;
    }
    
}

//将指定的UserList的数据写入数据库中
+(BOOL)writeToDBFromUserList:(UserList *)userList
{
    //判断是否已经打开数据库，否则不进行其他操作
    if (!FMDBforUserListWithFMDB)
    {
        NSLog(@"没有打开数据库");
        return NO;
    }
    
    //判断数据库中是否有需要的表，是则清空这个表的数据，为写入新数据做准备，否则新建这个表
    if ([self havetable])
    {
        NSLog(@"清空数据表的原始内容");
        NSString* fmdbcode1 = [NSString stringWithFormat:@"DELETE FROM %@", tablenameForUserListWithFMDB];
        [FMDBforUserListWithFMDB executeUpdate:fmdbcode1];
    }
    else
    {
        [self newtable];
    }
    
    NSLog(@"开始写入用户数据到数据表");
    
    for (NSInteger i = 0;i < userList.usercount;i++)
    {
        NSLog(@"写入一条数据");
        User* tu = [userList useratindex:i];
        
        NSString* fmdbcode2 = [NSString stringWithFormat:@"INSERT INTO %@ (myname, deletepassword, simpleGameHighestScore,normalGameHighestScore,hardGameHighestScore,openedVeryHard,veryHardGameHighestScore,lastRemainingNumber,lastGameTime) VALUES (?, ?, %d,%d,%d,%i,%d,%d,?)",tablenameForUserListWithFMDB, tu.simpleGameHighestScore, tu.normalGameHighestScore, tu.hardGameHighestScore, tu.openedVeryHard, tu.veryHardGameHighestScore,tu.remainingNumber];
        
        //NSString* fmdbcode2 = [NSString stringWithFormat:@"INSERT INTO %@ (myname, deletepassword, simpleGameHighestScore,normalGameHighestScore,hardGameHighestScore,openedVeryHard,veryHardGameHighestScore,lastRemainingNumber,lastGameTime) VALUES (?, ?, %ld,%ld,%ld,%i,%ld,%ld,?)",tablenameForUserListWithFMDB, tu.simpleGameHighestScore, tu.normalGameHighestScore, tu.hardGameHighestScore, tu.openedVeryHard, tu.veryHardGameHighestScore,tu.lastRemainingNumber];
        
        [FMDBforUserListWithFMDB executeUpdate:fmdbcode2, tu.myname, tu.deletepassword, [[NSDate alloc]init]];
    }
    NSLog(@"数据写入完成");
    return YES;
}

//关闭数据库
+(BOOL)closeDB
{
    //判断是否已经打开数据库，否则不进行其他操作
    if (!FMDBforUserListWithFMDB)
    {
        NSLog(@"没有打开数据库");
        return NO;
    }
    
    NSLog(@"开始关闭数据库");
    BOOL t =  [FMDBforUserListWithFMDB close];
    
    if (t)
    {
        NSLog(@"数据库成功关闭");
        FMDBforUserListWithFMDB = nil;
    }
    else
    {
        NSLog(@"数据库关闭失败");
    }
    
    return t;
}



//私有方法

//判断数据库中是否有需要的表
+(BOOL)havetable
{
    //判断是否已经打开数据库，否则不进行其他操作
    if (!FMDBforUserListWithFMDB)
    {
        NSLog(@"没有打开数据库");
        return NO;
    }
    
    FMResultSet* t = [FMDBforUserListWithFMDB executeQuery:@"select count(*) from sqlite_master where type ='table' and name = ?",tablenameForUserListWithFMDB];
    
    while ([t next])
    {
        if ([t intForColumnIndex:0] != 0)
        {
            NSLog(@"需要的数据表存在");
            return YES;
        }
    }

    NSLog(@"需要的数据表不存在");
    return NO;
}

//在数据库中新建一个表
+(BOOL)newtable
{
    //判断是否已经打开数据库，否则不进行其他操作
    if (!FMDBforUserListWithFMDB)
    {
        NSLog(@"没有打开数据库");
        return NO;
    }
    
    NSLog(@"开始新建数据表");
    
    NSString* fmbdcode1 = [NSString stringWithFormat:@"CREATE TABLE %@ (myname text, deletepassword text, simpleGameHighestScore integer, normalGameHighestScore integer, hardGameHighestScore integer, openedVeryHard, veryHardGameHighestScore integer, lastRemainingNumber integer, lastGameTime)",tablenameForUserListWithFMDB];
    
    if ([FMDBforUserListWithFMDB executeUpdate:fmbdcode1])
    {
        NSLog(@"新建数据表成功");
        return YES;
    }
    else
    {
        NSLog(@"新建数据表失败");
        return NO;
    }
}
@end
