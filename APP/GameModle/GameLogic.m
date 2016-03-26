//
//  GameLogic.m
//  0513
//
//  Created by Raymond on 15-5-13.
//  Copyright (c) 2015年 517. All rights reserved.
//

#import "GameLogic.h"

@interface GameLogic ()

//参加本轮游戏的扑克牌
@property(nonatomic,strong)NSMutableArray* selectedpokerstack;

//得分
@property(nonatomic,readwrite)NSInteger score;

//参加本轮游戏的扑克牌总数
@property(nonatomic,readwrite)NSUInteger count;

//玩家可以点击的剩余次数
@property(nonatomic,readwrite)NSUInteger remainingNumber;

//每次匹配的张数
@property(nonatomic)NSUInteger marrynumber;

//判断剩余的牌是否还可以进行匹配
-(BOOL)onceAgainMarry;

//匹配两张扑克，计算得分
-(NSUInteger)marrypoker:(Poker*)apoker withotherpoker:(Poker*)otherpoker;

@end

@implementation GameLogic

//惰性初始化
-(NSMutableArray*)selectedpokerstack
{
    if (!_selectedpokerstack)
    {
        _selectedpokerstack = [[NSMutableArray alloc]init];
    }
    
    return _selectedpokerstack;
}

-(id)initWithCount:(NSUInteger)tcount Andselectedpokerstack:(PokerStack *)tps andmarrynumber:(NSUInteger)tmn
{
    if (tcount < 2||tmn < 2||tcount < tmn||[tps count] < tcount)
    {
        self = nil;
        return self;
    }
    
    if (self = [super init])
    {
        self.count = tcount;
        self.marrynumber = tmn;
        self.score = 0;
        self.remainingNumber = tcount;
        
        //从牌堆随机抽取扑克
        for (NSUInteger i = 0;i < tcount;i++)
        {
            [self.selectedpokerstack addObject:[tps pokerofrandom]];
        }
    }
    
    return self;
    
}

-(void)clickatindex:(NSUInteger)index
{
    if (self.remainingNumber > 0)
    {
        Poker* tp = [self pokeratindex:index];
        
        if ([tp selected])
        {
            //扑克已被选中的话直接取消选中，不做其他处理
            [tp setSelected:NO];
        }
        else
        {
            
//            self.remainingNumber -= 1;
//            
//            NSMutableArray* selectedpoker = [[NSMutableArray alloc]init];
//            
//            for (Poker* tp in self.selectedpokerstack)
//            {
//                if (tp.selected)
//                {
//                    [selectedpoker addObject:tp];
//                }
//            }
//            
//            if ([selectedpoker count] == self.marrynumber-1)
//            {
//                NSUInteger tscore = 0;
//                
//                for (Poker* ttp in selectedpoker)
//                {
//                    [ttp setSelected:NO];
//                    
//                    NSUInteger ttscore = [self marrypoker:tp withotherpoker:ttp];
//                    
//                    if (ttscore != 0)
//                    {
//                        tscore += ttscore;
//                        [ttp setMarryed:YES];
//                        self.remainingNumber++;
//                    }
//                }
//                
//                [tp setSelected:NO];
//                
//                if (tscore != 0)
//                {
//                    [tp setMarryed:YES];
//                    self.score += tscore;
//                }
//                
//                NSNotificationCenter* tnc = [NSNotificationCenter defaultCenter];
//                
//                [tnc postNotificationName:@"FinshOnceMarry" object:self];
//            }
//            else
//            {
//                [tp setSelected:YES];
//            }
            [tp setSelected:YES];
            
            self.remainingNumber -= 1;
            
            NSMutableArray* selectedpoker = [[NSMutableArray alloc]init];
            
            for (Poker* tp in self.selectedpokerstack)
            {
                if (tp.selected)
                {
                    [selectedpoker addObject:tp];
                }
            }
            
            if (selectedpoker.count == self.marrynumber)
            {
                NSUInteger tscore = 0;
                
                for (Poker* ttp in selectedpoker)
                {
                    NSUInteger ttscore = 0;
                    
                    [ttp setSelected:NO];
                    
                    for (Poker* tttp in selectedpoker)
                    {
                        ttscore = ttscore+[self marrypoker:ttp withotherpoker:tttp];
                    }
                    
                    //跟自己进行了一次匹配，所以要扣除这个分数
                    ttscore = ttscore-10;
                    
                    if (ttscore != 0)
                    {
                        tscore = tscore+ttscore;
                        [ttp setMarryed:YES];
                        self.remainingNumber++;
                    }
                }
                
                //采用这种算法时，每张牌都与其他牌进行了两次匹配，所以最后的分数要除以2
                self.score = self.score + tscore/2;
                
                NSNotificationCenter* tnc = [NSNotificationCenter defaultCenter];
                
                if (self.remainingNumber != 0)
                {
                    //发送广播，完成一次匹配
                    [tnc postNotificationName:@"FinshOnceMarry" object:self];
                }
                
                if (![self onceAgainMarry])
                {
                    //发送广播，成功完成游戏
                    [tnc postNotificationName:@"FinshGame" object:self];
                    return;
                }
            }
            
            if (self.remainingNumber == 0)
            {
                //发送广播，玩家失败，游戏结束
                NSNotificationCenter* tnc = [NSNotificationCenter defaultCenter];
                
                [tnc postNotificationName:@"GameOver" object:self];
            }
        }
    }
}

-(Poker*)pokeratindex:(NSUInteger)index
{
    return self.selectedpokerstack[index];
}


-(NSUInteger)marrypoker:(Poker *)apoker withotherpoker:(Poker *)otherpoker
{
    NSUInteger t = 0;
    
    if ([apoker.pattern isEqualToString:otherpoker.pattern])
    {
        //相同花色，加两分
        t += 2;
    }
    
    if (apoker.figure == otherpoker.figure)
    {
        //相同点数，加八分
        t += 8;
    }
    
    return t;
}

-(BOOL)onceAgainMarry
{
    BOOL t = YES;
    
    NSMutableArray* notMarryedPokers = [[NSMutableArray alloc]init];
    
    //选出所有还没有匹配成功的扑克
    for (Poker* tp in self.selectedpokerstack)
    {
        if (!tp.marryed)
        {
            [notMarryedPokers addObject:tp];
        }
    }
    
    NSUInteger ts = 0;
    
    //两两之间互相匹配，将总分数存储在ts中；
    for (Poker* tp in notMarryedPokers)
    {
        NSUInteger tts = 0;
        
        for (Poker* ttp in notMarryedPokers)
        {
            tts = tts + [self marrypoker:tp withotherpoker:ttp];
        }
        
        tts = tts - 10;
        
        ts = ts + tts;
    }
    
    //剩余扑克两两之间无法匹配或剩余的数量不够完成一次匹配时，判定游戏结束
    if (ts == 0||notMarryedPokers.count < self.marrynumber)
    {
        t = NO;
    }
    
    return t;
}

@end

