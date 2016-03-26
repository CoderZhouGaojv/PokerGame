//
//  GameLogic.h
//  0513
//
//  Created by Raymond on 15-5-13.
//  Copyright (c) 2015年 517. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PokerStack.h"

@interface GameLogic : NSObject

//得分
@property(nonatomic,readonly)NSInteger score;

//参加本轮游戏的扑克牌总数
@property(nonatomic,readonly)NSUInteger count;

//玩家可以点击的剩余次数
@property(nonatomic,readonly)NSUInteger remainingNumber;

//指定初始化方法,tcount参数指定参加一轮游戏的扑克数量，tps制定从那个拍吨抽取扑克，tmn制定每次匹配的数量
-(id)initWithCount:(NSUInteger)tcount Andselectedpokerstack:(PokerStack*)tps andmarrynumber:(NSUInteger)tmn;

//点击某张牌
-(void)clickatindex:(NSUInteger)index;

//获得参加本轮游戏的某张牌
-(Poker*)pokeratindex:(NSUInteger)index;

@end

