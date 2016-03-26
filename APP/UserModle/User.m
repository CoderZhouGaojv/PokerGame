//
//  User.m
//  APP
//
//  Created by zhougaojv on 15/5/14.
//  Copyright (c) 2015年 zhougaojv. All rights reserved.
//

#import "User.h"

@implementation User

-(NSInteger)remainingNumber
{
    //计算距离上次游戏的时间间隔，单位秒；
    NSTimeInterval t = -[self.lastGameTime timeIntervalSinceNow];
    NSInteger timeInterval = round(t);
    
    //计算该玩家剩余游戏次数
    
    NSInteger returnnumber = self.lastRemainingNumber + timeInterval/300;
    
    if (returnnumber > 10)
    {
        returnnumber = 10;
    }
    
    return returnnumber;
}

-(id)initWithname:(NSString *)tname AndPassWord:(NSString *)tdeletepassword
{
    if (self = [super init])
    {
        _myname = tname;
        _deletepassword = tdeletepassword;
        _lastRemainingNumber = 10;
        _lastGameTime = [[NSDate alloc]init];
        _openedVeryHard = NO;
    }
    
    return self;
}

-(void)playonce
{
    self.lastRemainingNumber--;
}

@end
