//
//  NormalGameViewController.m
//  APP
//
//  Created by Raymond on 15-5-15.
//  Copyright (c) 2015年 zhougaojv. All rights reserved.
//

#import "NormalGameViewController.h"
#import "PokerView.h"
#import "GameLogic.h"

@interface NormalGameViewController ()<takeSelect,UIAlertViewDelegate>

@property (strong, nonatomic) IBOutletCollection(PokerView) NSArray *pokerViewArray;

@property (weak, nonatomic) IBOutlet UILabel *myScorevLabel;
@property (weak, nonatomic) IBOutlet UILabel *myRemainingNumberView;
@property (weak, nonatomic) IBOutlet UILabel *gameOverLabel;
@property (weak, nonatomic) IBOutlet UIButton *reLoadGameButton;
@property (weak, nonatomic) IBOutlet UILabel *bigScoreLabel;
@property (weak, nonatomic) IBOutlet UIView *becomeBlackView;

@property(nonatomic,strong)GameLogic* myGameLogic;

@property(nonatomic,strong)PokerStack* myPokerStack;

-(void)updateUIWithTimes;

-(void)updateUI;

-(void)gameOver;

-(void)finshGame;

-(void)gameOverOpenAllPokers;

-(void)gameOverOpenAllPokersWithTimes;

-(void)finshGameOpenAllPokers;

-(void)finshGameOpenAllPokersWithTimes;

@end

@implementation NormalGameViewController

-(GameLogic*)myGameLogic
{
    if (!_myGameLogic)
    {
        _myGameLogic = [[GameLogic alloc]initWithCount:self.pokerViewArray.count Andselectedpokerstack:self.myPokerStack andmarrynumber:2];
    }
    
    return _myGameLogic;
}

-(PokerStack*)myPokerStack
{
    if (!_myPokerStack)
    {
        _myPokerStack = [[PokerStack alloc]init];
    }
    
    return _myPokerStack;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"普通模式";
    
//    CGFloat hue = ( arc4random() % 256 / 256.0 );
//    CGFloat saturation = ( arc4random() % 128 / 256.0 );
//    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;
//    UIColor* tv = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
//    self.view.backgroundColor = tv;
    
    for (PokerView* tpv in self.pokerViewArray)
    {
        UITapGestureRecognizer* tsgr = [[UITapGestureRecognizer alloc]initWithTarget:tpv action:@selector(selected:)];
        tpv.takeSelectDelegate = self;
        [tpv addGestureRecognizer:tsgr];
        tpv.pattern = [self.myGameLogic pokeratindex:[self.pokerViewArray indexOfObject:tpv]].pattern;
        tpv.figure = [Poker figureValues][[self.myGameLogic pokeratindex:[self.pokerViewArray indexOfObject:tpv]].figure];
        tpv.isFace = NO;
        tpv.actived = YES;
    }
    [self updateUI];
    
    NSNotificationCenter* tnc = [NSNotificationCenter defaultCenter];
    
    [tnc addObserver:self selector:@selector(updateUIWithTimes) name:@"FinshOnceMarry" object:nil];
    
    [tnc addObserver:self selector:@selector(gameOver) name:@"GameOver" object:nil];
    [tnc addObserver:self selector:@selector(finshGame) name:@"FinshGame" object:nil];
    
    self.reLoadGameButton.hidden = YES;
    self.gameOverLabel.hidden = YES;
    self.bigScoreLabel.hidden = YES;
    self.becomeBlackView.hidden = YES;
    
    [self.activedUser playonce];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickReLoadGameButton:(id)sender
{
    //判断玩家剩余游戏次数，不足的话弹出提示框
    if (self.activedUser.remainingNumber > 0)
    {
        [self.activedUser playonce];
        self.reLoadGameButton.hidden = YES;
        self.gameOverLabel.hidden = YES;
        self.bigScoreLabel.hidden = YES;
        self.becomeBlackView.hidden = YES;
        
        //对牌堆和游戏逻辑进行置空，因为采用了惰性初始化的模式，再次调用时便会生成新的牌堆和游戏逻辑
        self.myPokerStack = nil;
        self.myGameLogic = nil;
        
        for (PokerView* tpv in self.pokerViewArray)
        {
            UITapGestureRecognizer* tsgr = [[UITapGestureRecognizer alloc]initWithTarget:tpv action:@selector(selected:)];
            tpv.takeSelectDelegate = self;
            [tpv addGestureRecognizer:tsgr];
            tpv.pattern = [self.myGameLogic pokeratindex:[self.pokerViewArray indexOfObject:tpv]].pattern;
            tpv.figure = [Poker figureValues][[self.myGameLogic pokeratindex:[self.pokerViewArray indexOfObject:tpv]].figure];
            tpv.isFace = NO;
            tpv.actived = YES;
        }
        
        [self updateUI];
    }
    else
    {
        UIAlertView* tav = [[UIAlertView alloc]initWithTitle:@"剩余次数不足" message:@"请休息一会儿再来过" delegate:self cancelButtonTitle:nil otherButtonTitles:@"返回",nil];
        
        [tav show];
    }

}

-(void)selectThisPoker:(PokerView *)sender
{
    if (!sender.isFace)
    {
        CGContextRef context=UIGraphicsGetCurrentContext();
        [UIView beginAnimations:nil context:context];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:sender cache:YES];
        
        sender.isFace = YES;
        
        [UIView setAnimationDelegate:self];
        [UIView commitAnimations];
    }
    else
    {
        CGContextRef context=UIGraphicsGetCurrentContext();
        [UIView beginAnimations:nil context:context];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:sender cache:YES];
        
        sender.isFace = NO;
        
        [UIView setAnimationDelegate:self];
        [UIView commitAnimations];
    }
    
    [self.myGameLogic clickatindex:[self.pokerViewArray indexOfObject:sender]];
    self.myRemainingNumberView.text = [NSString stringWithFormat:@"剩余点击次数:%d",self.myGameLogic.remainingNumber];
}

-(void)updateUIWithTimes
{
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateUI) userInfo:nil repeats:NO];
}

-(void)updateUI
{
    NSLog(@"更新UI");
    
    self.myScorevLabel.text = [NSString stringWithFormat:@"分数:%d",self.myGameLogic.score];
    
    self.myRemainingNumberView.text = [NSString stringWithFormat:@"剩余点击次数:%d",self.myGameLogic.remainingNumber];
    
    for (PokerView* tpv in self.pokerViewArray)
    {
        if (tpv.isActived)
        {
            Poker* tp = [self.myGameLogic pokeratindex:[self.pokerViewArray indexOfObject:tpv]];
            if (!tp.marryed)
            {
                
                if (tpv.isFace != tp.selected)
                {
                    CGContextRef context=UIGraphicsGetCurrentContext();
                    [UIView beginAnimations:nil context:context];
                    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                    [UIView setAnimationBeginsFromCurrentState:YES];
                    [UIView setAnimationDuration:1.0];
                    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:tpv cache:YES];
                    
                    tpv.isFace = tp.selected;
                    
                    [UIView setAnimationDelegate:self];
                    [UIView commitAnimations];
                }
            }
            else
            {
                for (UIGestureRecognizer* tgr in tpv.gestureRecognizers)
                {
                    [tpv removeGestureRecognizer:tgr];
                }
                
                tpv.actived = NO;
                
                if (!tpv.isFace)
                {
                    tpv.actived = NO;
                    CGContextRef context=UIGraphicsGetCurrentContext();
                    [UIView beginAnimations:nil context:context];
                    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                    [UIView setAnimationDuration:1.0];
                    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:tpv cache:YES];
                    
                    tpv.isFace = YES;
                    
                    [UIView setAnimationDelegate:self];
                    [UIView commitAnimations];
                }
            }
        }
    }
}

-(void)gameOver
{
    self.gameOverLabel.text = @"Game Over";
    
    [self gameOverOpenAllPokersWithTimes];
}

-(void)finshGame
{
    self.gameOverLabel.text = @"Success!";
    
    [self finshGameOpenAllPokersWithTimes];
}

-(void)gameOverOpenAllPokers
{
    self.becomeBlackView.hidden = NO;
    
    for (PokerView* tpv in self.pokerViewArray)
    {
        if (tpv.actived)
        {
            for (UIGestureRecognizer* tgr in tpv.gestureRecognizers)
            {
                [tpv removeGestureRecognizer:tgr];
            }
            
            if (!tpv.isFace)
            {
                tpv.actived = NO;
                CGContextRef context=UIGraphicsGetCurrentContext();
                [UIView beginAnimations:nil context:context];
                [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                [UIView setAnimationDuration:1.0];
                [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:tpv cache:YES];
                
                tpv.isFace = YES;
                tpv.actived = YES;
                
                [UIView setAnimationDelegate:self];
                [UIView commitAnimations];
            }
        }
    }
    
    CGContextRef context=UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.gameOverLabel cache:YES];
    
    self.gameOverLabel.hidden = NO;
    
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
    
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.reLoadGameButton cache:YES];
    
    self.reLoadGameButton.hidden = NO;
    
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
    
}

-(void)gameOverOpenAllPokersWithTimes
{
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(gameOverOpenAllPokers) userInfo:nil repeats:NO];
}

-(void)finshGameOpenAllPokers
{
    self.bigScoreLabel.text = [NSString stringWithFormat:@"分数:%d",self.myGameLogic.score];
    self.becomeBlackView.hidden = NO;
    
    for (PokerView* tpv in self.pokerViewArray)
    {
        if (tpv.actived)
        {
            for (UIGestureRecognizer* tgr in tpv.gestureRecognizers)
            {
                [tpv removeGestureRecognizer:tgr];
            }
            
            if (!tpv.isFace)
            {
                tpv.actived = NO;
                CGContextRef context=UIGraphicsGetCurrentContext();
                [UIView beginAnimations:nil context:context];
                [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                [UIView setAnimationDuration:1.0];
                [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:tpv cache:YES];
                
                tpv.isFace = YES;
                tpv.actived = YES;
                
                [UIView setAnimationDelegate:self];
                [UIView commitAnimations];
            }
        }
    }
    
    CGContextRef context=UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.gameOverLabel cache:YES];
    
    self.gameOverLabel.hidden = NO;
    
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
    
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.reLoadGameButton cache:YES];
    
    self.reLoadGameButton.hidden = NO;
    
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
    
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
    
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.bigScoreLabel cache:YES];
    
    self.bigScoreLabel.hidden = NO;
    
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
    
}

-(void)finshGameOpenAllPokersWithTimes
{
    if (self.myGameLogic.score > self
        .activedUser.normalGameHighestScore)
    {
        self
        .activedUser.normalGameHighestScore = self.myGameLogic.score;
    }
    
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(finshGameOpenAllPokers) userInfo:nil repeats:NO];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
