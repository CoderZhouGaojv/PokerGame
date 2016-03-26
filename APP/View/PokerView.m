//
//  PokerView.m
//  0513
//
//  Created by Raymond on 15-5-13.
//  Copyright (c) 2015年 517. All rights reserved.
//

#import "PokerView.h"

//扑克视图中心图案的竖直缩进系数
static CGFloat pokerViewindentCoefficient = 0.9;

@interface PokerView ()

//初始化时进行的一些操作，为绘制做准备
-(void)setep;

//绘制背面图案
-(void)drawBack;

//单位高度
-(CGFloat)heightLengthUnit;

//单位高度
-(CGFloat)widthLengthUnit;

//扑克视图的圆角半径
-(CGFloat)roundedCornersRadius;

@end

@implementation PokerView

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    NSLog(@"改变扑克视图%@%@的位置",self.pattern,self.figure);
}

-(void)setCenter:(CGPoint)center
{
    [super setCenter:center];
    NSLog(@"改变扑克视图%@%@的中心位置",self.pattern,self.figure);
    NSLog(@"横坐标:%f,纵坐标:%f",center.x,center.y);
}

-(void)setFigure:(NSString *)figure
{
    //点数改变是重绘视图
    if (![_figure isEqualToString:figure])
    {
        _figure = figure;
        [self setNeedsDisplay];
    }
}

-(void)setPattern:(NSString *)pattern
{
    //花色改变时重绘视图
    if (![_pattern isEqualToString: pattern])
    {
        _pattern = pattern;
        [self setNeedsDisplay];
    }
}

-(void)setIsFace:(BOOL)isFace
{
    //是否正面改变时重绘视图
    if (_isFace != isFace)
    {
        _isFace = isFace;
        [self setNeedsDisplay];
    }
}

-(void)setActived:(BOOL)actived
{
    //是否活动改变时重绘视图
    if (_actived != actived)
    {
        _actived = actived;
        [self setNeedsDisplay];
    }
}

-(void)drawRect:(CGRect)rect
{
    NSLog(@"绘制扑克视图%@%@",self.pattern,self.figure);
    NSLog(@"横坐标:%f,纵坐标:%f",self.center.x,self.center.y);
    
    UIBezierPath* tbp = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:[self roundedCornersRadius]];
    
    //以这个曲线为界，下面的绘制如果超出这里就进行切割
    [tbp addClip];
    
    //设置描边、填充颜色并进行描边填充
    [[UIColor whiteColor]setFill];
    [[UIColor blackColor]setStroke];
    [tbp fill];
    [tbp stroke];
    
    //判断视图的正反面，并进行相应绘制
    if (self.isFace)
    {
        //设置花色点数的显示格式
        NSMutableParagraphStyle* titleFormat = [[NSMutableParagraphStyle alloc]init];
        titleFormat.alignment = NSTextAlignmentCenter;
        
        UIFont* titleFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        titleFont = [titleFont fontWithSize:titleFont.pointSize*([self widthLengthUnit]+[self heightLengthUnit])/3];
        NSMutableAttributedString* title = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@\n%@",self.figure,self.pattern] attributes:@{NSFontAttributeName:titleFont,NSParagraphStyleAttributeName:titleFormat}];
        
        //如果为红桃或方块时把字体颜色设为红色
        if ([self.pattern isEqualToString:@"♥︎"] || [self.pattern isEqualToString:@"♦︎"])
        {
            [title addAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} range:NSMakeRange(0, title.length)];
        }


        //绘制中间图案
        UIImage* centerImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@%@",self.pattern,self.figure]];
        if ([self.figure isEqualToString:@"A"])
        {
            [centerImage drawInRect:CGRectInset(self.bounds,self.bounds.size.width/4, (self.bounds.size.height-self.bounds.size.width/2)/2)];
        }
        else if ([self.figure isEqualToString:@"2"]||[self.figure isEqualToString:@"3"])
        {
            [centerImage drawInRect:CGRectInset(self.bounds,self.bounds.size.width/5*2, [self heightLengthUnit]*5+(self.bounds.size.height-[self heightLengthUnit]*5)*(1-pokerViewindentCoefficient))];
        }
        else
        {
            [centerImage drawInRect:CGRectInset(self.bounds,[self widthLengthUnit]*5+[title size].width, [self heightLengthUnit]*5+(self.bounds.size.height-[self heightLengthUnit]*5)*(1-pokerViewindentCoefficient))];
        }
        
        //绘制花色点数
        [title drawAtPoint:CGPointMake([self widthLengthUnit]*5, [self widthLengthUnit]*5)];
        
        CGContextRef turnupdown = UIGraphicsGetCurrentContext();
        CGContextTranslateCTM(turnupdown, self.bounds.size.width, self.bounds.size.height);
        
        //旋转180°后再次绘制花色点数
        CGContextRotateCTM(turnupdown, M_PI);
        
        [title drawAtPoint:CGPointMake([self widthLengthUnit]*5, [self widthLengthUnit]*5)];
    }
    else
    {
        //绘制背面图案
        [self drawBack];
    }
    
    //如果扑克视图不处于活动状态，为其蒙上一层阴影
    if (!self.isActived)
    {
        UIColor* tc = [UIColor colorWithWhite:0 alpha:0.5];
        [tc setFill];
        [tbp fill];
    }
}

-(void)drawBack
{
    UIImage* backImage= [UIImage imageNamed:@"backimage"];
    [backImage drawInRect:self.bounds];
}

-(void)setep
{
    //设置背景颜色为透明
    self.backgroundColor = nil;
    
    //设置整个背景为透明
    self.opaque = NO;
    
    //设置视图的frame改变时的响应模式为重新绘制
    self.contentMode = UIViewContentModeRedraw;
}

//从故事版调用时的初始化方法
-(void)awakeFromNib
{
    [super awakeFromNib];
    [self setep];
}

-(void)selected:(UIGestureRecognizer *)sender
{
    if ([sender isKindOfClass:[UISwipeGestureRecognizer class]])
    {
        if (sender.state ==UIGestureRecognizerStateEnded)
        {
            [self.takeSelectDelegate selectThisPoker:self];
        }
    }
    else if ([sender isKindOfClass:[UITapGestureRecognizer class]])
    {
        [self.takeSelectDelegate selectThisPoker:self];
    }
}

-(CGFloat)heightLengthUnit
{
    return self.bounds.size.height/100;
}

-(CGFloat)widthLengthUnit
{
    return self.bounds.size.width/100;
}

-(CGFloat)roundedCornersRadius
{
    return [self heightLengthUnit]*5;
}

@end
