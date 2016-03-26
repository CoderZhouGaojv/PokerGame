//
//  PokerStack.m
//  0513
//
//  Created by Raymond on 15-5-13.
//  Copyright (c) 2015年 517. All rights reserved.
//

#import "PokerStack.h"

@implementation PokerStack

//惰性初始化
-(NSMutableArray*)pokerarry
{
    if (!_pokerarry)
    {
        _pokerarry = [[NSMutableArray alloc]init];
        
        
        for (NSString* tpattern in [Poker patternValues])
        {
            for (NSInteger i = 1;i < 14;i++)
            {
                Poker* tp = [[Poker alloc]init];
                tp.pattern = tpattern;
                tp.figure = i;
                
                [_pokerarry addObject:tp];
            }
        }
    }
    
    return _pokerarry;
}

-(NSUInteger)count
{
    return [self.pokerarry count];
}

-(void)addpoker:(Poker *)tpoker
{
    [self.pokerarry addObject:tpoker];
}

-(Poker*)pokeratindex:(NSUInteger)index
{
    return [self.pokerarry objectAtIndex:index];
}

-(void)deletepoker:(NSUInteger)index
{
    [self.pokerarry removeObjectAtIndex:index];
}

-(Poker*)pokerofrandom
{
    NSUInteger t = arc4random()%[self count];
    
    Poker* tp = [self pokeratindex:t];
    
    [self deletepoker:t];
    
    return tp;
}

@end
