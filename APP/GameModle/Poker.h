//
//  Poker.h
//  0513
//
//  Created by Raymond on 15-5-13.
//  Copyright (c) 2015年 517. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Poker : NSObject

//花色
@property(nonatomic,strong)NSString* pattern;

//点数
@property(nonatomic)NSInteger figure;

//是否被选中
@property(nonatomic)BOOL selected;

//是否以匹配
@property(nonatomic)BOOL marryed;

//指定初始化方法
-(id)initWithpattern:(NSString*)tpattern Andfigure:(NSInteger)tfigure;

//获得扑克所有花色值的数组
+(NSArray*)patternValues;

//获得扑克所有点数值得数组
+(NSArray*)figureValues;

@end
