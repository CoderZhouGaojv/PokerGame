//
//  PokerStack.h
//  0513
//
//  Created by Raymond on 15-5-13.
//  Copyright (c) 2015年 517. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Poker.h"

@interface PokerStack : NSObject

@property(nonatomic,strong)NSMutableArray* pokerarry;

//牌堆中扑克牌的总数
-(NSUInteger)count;

//加入一张扑克
-(void)addpoker:(Poker*)tpoker;

//返回制定下标的一张扑克
-(Poker*)pokeratindex:(NSUInteger)index;

//删除一张扑克牌
-(void)deletepoker:(NSUInteger)index;

//随机抽出一张扑克
-(Poker*)pokerofrandom;


@end
