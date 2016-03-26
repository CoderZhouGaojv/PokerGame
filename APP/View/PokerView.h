//
//  PokerView.h
//  0513
//
//  Created by Raymond on 15-5-13.
//  Copyright (c) 2015年 517. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PokerView : UIView

//扑克视图的花色
@property(nonatomic,strong)NSString* pattern;

//扑克视图的点数，用字符串储存，方便输出
@property(nonatomic,strong)NSString* figure;

//是否正面朝上
@property(nonatomic)BOOL isFace;

//是否活动的扑克（是否可以点击）
@property(nonatomic,getter = isActived)BOOL actived;

//处理自身被点击事件的代理
@property(nonatomic,weak)id takeSelectDelegate;

//点击这个扑克视图
-(void)selected:(UIGestureRecognizer*)sender;



@end


//处理扑克视图被点击的代理协议
@protocol takeSelect <NSObject>

-(void)selectThisPoker:(PokerView*)sender;

@end
