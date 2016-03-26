//
//  User.h
//  APP
//
//  Created by zhougaojv on 15/5/14.
//  Copyright (c) 2015年 zhougaojv. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

//用户的名称
@property(nonatomic,strong)NSString* myname;

//删除密码
@property(nonatomic,strong)NSString* deletepassword;

//简单模式的最该分数
@property(nonatomic)NSInteger simpleGameHighestScore;

//普通模式的最高分数;
@property(nonatomic)NSInteger normalGameHighestScore;

//困难难度的最高分数
@property(nonatomic)NSInteger hardGameHighestScore;

//是否已经开启非常困难模式
@property(nonatomic)BOOL openedVeryHard;

//非常困难模式（隐藏模式）的最高分数
@property(nonatomic)NSInteger veryHardGameHighestScore;

//上次结束游戏时的剩余次数
@property(nonatomic)NSInteger lastRemainingNumber;

//实时的剩余次数
@property(nonatomic)NSInteger remainingNumber;

//上次结束游戏时的时间
@property(nonatomic)NSDate* lastGameTime;

//使用用户名和密码进行初始化
-(id)initWithname:(NSString*)tname AndPassWord:(NSString*)tdeletepassword;

//进行一次游戏
-(void)playonce;

@end
