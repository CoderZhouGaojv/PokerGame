//
//  Poker.m
//  0513
//
//  Created by Raymond on 15-5-13.
//  Copyright (c) 2015年 517. All rights reserved.
//

#import "Poker.h"

@implementation Poker

//set get 都进行了重写，所以这里要声明一下
@synthesize pattern = _pattern;

@synthesize figure = _figure;

-(NSString*)pattern
{
    if (!_pattern)
    {
        _pattern = [[NSString alloc]init];
    }
    
    return _pattern;
}

-(void)setPattern:(NSString *)pattern
{
    //判断设置的值是否是扑克牌合法的花色值
    if ([[Poker patternValues]containsObject:pattern])
    {
        _pattern = pattern;
    }
}

-(void)setFigure:(NSInteger)figure
{
    //判断设置的点数值是否是扑克牌合法的点数值
    if (figure > 0 && figure < 14)
    {
        _figure = figure;
    }
}

-(id)initWithpattern:(NSString *)tpattern Andfigure:(NSInteger)tfigure
{
    if (![[Poker patternValues]containsObject:tpattern])
    {
        self = nil;
        return self;
    }
    
    if (tfigure > 13 || tfigure < 1)
    {
        self = nil;
        return self;
    }
    
    if (self = [super init])
    {
        _pattern = tpattern;
        _figure = tfigure;
        self.selected = NO;
        self.marryed = NO;
    }
    
    return self;
}

+(NSArray*)patternValues
{
    return @[@"♠︎",@"♣︎",@"♥︎",@"♦︎"];
}

+(NSArray*)figureValues
{
    return @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"];
}
@end

