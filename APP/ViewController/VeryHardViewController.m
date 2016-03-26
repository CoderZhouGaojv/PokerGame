//
//  VeryHardViewController.m
//  APP
//
//  Created by Raymond on 15-5-15.
//  Copyright (c) 2015年 zhougaojv. All rights reserved.
//

#import "VeryHardViewController.h"
#import "PokerView.h"
#import "GameLogic.h"


@interface VeryHardViewController ()<takeSelect,UIAlertViewDelegate>

//保存所有扑克视图的数组
@property (strong, nonatomic) IBOutletCollection(PokerView) NSArray *pokerViewArray;

//分数显示栏
@property (weak, nonatomic) IBOutlet UILabel *myScorevLabel;
//剩余次数显示栏
@property (weak, nonatomic) IBOutlet UILabel *myRemainingNumberView;
//游戏结束的显示栏
@property (weak, nonatomic) IBOutlet UILabel *gameOverLabel;
//重新开始按钮
@property (weak, nonatomic) IBOutlet UIButton *reLoadGameButton;
//完成游戏时较大的分数显示栏
@property (weak, nonatomic) IBOutlet UILabel *bigScoreLabel;
@property (weak, nonatomic) IBOutlet UIView *becomeBlackView;

//游戏逻辑控制器
@property(nonatomic,strong)GameLogic* myGameLogic;

//产生扑克的牌堆
@property(nonatomic,strong)PokerStack* myPokerStack;

//延时更新UI
-(void)updateUIWithTimes;

//更新UI
-(void)updateUI;

//玩家失败，游戏结束
-(void)gameOver;

//玩家胜利，完成游戏
-(void)finshGame;

//玩家失败时处理界面
-(void)gameOverOpenAllPokers;

//玩家失败时延时处理界面
-(void)gameOverOpenAllPokersWithTimes;

//玩家胜利时处理界面
-(void)finshGameOpenAllPokers;

//玩家胜利时延时处理界面
-(void)finshGameOpenAllPokersWithTimes;

@end

@implementation VeryHardViewController

//惰性初始化

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
    //设置导航栏的标题
    self.navigationItem.title = @"极难模式";
    
//    //设置背景颜色为随机颜色
//    CGFloat hue = ( arc4random() % 256 / 256.0 );
//    CGFloat saturation = ( arc4random() % 128 / 256.0 );
//    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;
//    UIColor* tv = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
//    self.view.backgroundColor = tv;
    
    //读取游戏逻辑中每张扑克的信息，使用这些信息初始化扑克视图
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
    
    //监听“完成一次匹配”、“游戏失败”、“游戏完成”这三个广播频道
    NSNotificationCenter* tnc = [NSNotificationCenter defaultCenter];
    
    [tnc addObserver:self selector:@selector(updateUIWithTimes) name:@"FinshOnceMarry" object:nil];
    [tnc addObserver:self selector:@selector(gameOver) name:@"GameOver" object:nil];
    [tnc addObserver:self selector:@selector(finshGame) name:@"FinshGame" object:nil];
    
    //隐藏游戏结束时的提示信息
    self.reLoadGameButton.hidden = YES;
    self.gameOverLabel.hidden = YES;
    self.bigScoreLabel.hidden = YES;
    self.becomeBlackView.hidden = YES;
    
    //调用User类进行一次游戏的方法
    [self.activedUser playonce];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//点击重新开始时调用的方法
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

//takeSelect协议中必须实现的方法，处理扑克视图被点击事件
-(void)selectThisPoker:(PokerView *)sender
{
    //动画效果
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
    
    //向游戏逻辑发送某张牌被单击的消息
    [self.myGameLogic clickatindex:[self.pokerViewArray indexOfObject:sender]];
    
    //更新剩余次数栏
    self.myRemainingNumberView.text = [NSString stringWithFormat:@"剩余点击次数:%d",self.myGameLogic.remainingNumber];
}

-(void)updateUIWithTimes
{
    //延时一秒更新UI
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateUI) userInfo:nil repeats:NO];
}

-(void)updateUI
{
    NSLog(@"更新UI");
    
    self.myScorevLabel.text = [NSString stringWithFormat:@"分数:%d",self.myGameLogic.score];
    
    self.myRemainingNumberView.text = [NSString stringWithFormat:@"剩余点击次数:%d",self.myGameLogic.remainingNumber];
    
    for (PokerView* tpv in self.pokerViewArray)
    {
        //不更新已经处于非活动状态的扑克视图
        if (tpv.isActived)
        {
            Poker* tp = [self.myGameLogic pokeratindex:[self.pokerViewArray indexOfObject:tpv]];
            //游戏逻辑中该扑克牌是否已经匹配成功
            if (!tp.marryed)
            {
                //没有成功的话通过动画同步两者的状态
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
                //成功的话移除触摸动作
                for (UIGestureRecognizer* tgr in tpv.gestureRecognizers)
                {
                    [tpv removeGestureRecognizer:tgr];
                }
                
                //同步活动状态
                tpv.actived = NO;
                
                //通过动画将该扑克变为正面
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
    self.becomeBlackView.hidden  = NO;
    
    //游戏失败时的动画效果
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
    //延时一秒进行游戏失败的动画效果
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(gameOverOpenAllPokers) userInfo:nil repeats:NO];
}

-(void)finshGameOpenAllPokers
{
    self.bigScoreLabel.text = [NSString stringWithFormat:@"分数:%d",self.myGameLogic.score];
    self.becomeBlackView.hidden = NO;
    
    //游戏完成时的动画效果
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
    //本局得分如果高于最高分数，更新最高分
    if (self.myGameLogic.score > self
        .activedUser.veryHardGameHighestScore)
    {
        self
        .activedUser.veryHardGameHighestScore = self.myGameLogic.score;
    }

    //延时一秒进行游戏完成的动画效果
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(finshGameOpenAllPokers) userInfo:nil repeats:NO];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
