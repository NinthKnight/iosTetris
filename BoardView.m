//
//  BoardView.m
//  IOSTetris
//
//  Created by Halo on 2018/11/8.
//  Copyright © 2018年 Halo. All rights reserved.
//

#import "BoardView.h"


@implementation BoardView

-(id)initWithCtrl:(ViewController*)_viewCtrl{
    self = [super init];
    if (self) {
        self.viewCtrl = _viewCtrl;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

*/

- (void)drawRect:(CGRect)rect {
    //1.取得图形上下文对象
    CGContextRef context = UIGraphicsGetCurrentContext();

    int boardTop = self.frame.origin.y - BoardHeight * [self.viewCtrl squareHeight];
    
    for (int i = 0; i < BoardHeight; ++i) {
        for (int j = 0; j < BoardWidth; ++j) {
            enum TetrixShape shape = [self.viewCtrl shape:j At:(BoardHeight - i - 1)];
            if (shape != NoShape){
                int nCurX = j * [self.viewCtrl squareWidth];
                int nCurY = i * [self.viewCtrl squareHeight];
                
                [self drawSquare:context
                               X:nCurX
                               Y:nCurY
                           Shape:shape];
            }

            
        }
    }

    
    //! [10]
    if ([self.viewCtrl.curPiece shape] != NoShape) {
        for (int i = 0; i < 4; ++i) {
            int x = self.viewCtrl.curX + [self.viewCtrl.curPiece x:i];
            int y = self.viewCtrl.curY - [self.viewCtrl.curPiece y:i];
            
            int nCurX = x * [self.viewCtrl squareWidth];
            int nCurY = (BoardHeight - y - 1) * [self.viewCtrl squareHeight];
            
            [self drawSquare:context
                           X:nCurX
                           Y:nCurY
                       Shape:[self.viewCtrl.curPiece shape]];
        }
    }

}

-(CGColorRef) getColorFromRed:(int)red Green:(int)green Blue:(int)blue Alpha:(int)alpha
{
    CGFloat r = (CGFloat) red/255.0;
    CGFloat g = (CGFloat) green/255.0;
    CGFloat b = (CGFloat) blue/255.0;
    CGFloat a = (CGFloat) alpha/255.0;
    CGFloat components[4] = {r,g,b,a};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGColorRef color = (CGColorRef)CGColorCreate(colorSpace, components);
    CGColorSpaceRelease(colorSpace);
    
    return color;
}

//绘制图形
-(void)drawSquare:(CGContextRef)context X:(int)x Y:(int)y Shape:(enum TetrixShape)shape{
    //    static const QRgb colorTable[8] = {
    //        0x000000, 0xCC6666, 0x66CC66, 0x6666CC,
    //        0xCCCC66, 0xCC66CC, 0x66CCCC, 0xDAAA00
    //    };
    
    static const float colorTable[8][4] = {
        {0,0,0,1},
        {0.8,0.4,0.4,1},
        {0.4,0.8,0.4,1},
        {0.4,0.4,0.8,1},
        {0.8,0.8,0.4,1},
        {0.8,0.4,0.8,1},
        {0.4,0.8,0.8,1},
        {0.85,0.66,0,1},
    };
    
    static const float lightColorTable[8][4] = {
        {0,0,0,1},
        {255/255.0,178/255.0,178/255.0,1},
        {178/255.0,255/255.0,178/255.0,1},
        {178/255.0,178/255.0,255/255.0,1},
        {255/255.0,255/255.0,178/255.0,1},
        {255/255.0,178/255.0,255/255.0,1},
        {178/255.0,255/255.0,255/255.0,1},
        {255/255.0,215/255.0,72/255.0,1},
    };
    
    static const float darkColorTable[8][4] = {
        {0,0,0,1},
        {102/255.0,51/255.0,51/255.0,1},
        {51/255.0,102/255.0,51/255.0,1},
        {51/255.0,51/255.0,102/255.0,1},
        {102/255.0,102/255.0,51/255.0,1},
        {102/255.0,51/255.0,102/255.0,1},
        {51/255.0,102/255.0,102/255.0,1},
        {109/255.0,85/255.0,0/255.0,1},
    };

    
    //绘制矩形
    
    //CGContextSetLineWidth(context, 2.0);//线的宽度
    UIColor* aColor = [UIColor colorWithRed:colorTable[shape][0] green:colorTable[shape][1] blue:colorTable[shape][2] alpha:colorTable[shape][3]];
    CGContextSetFillColorWithColor(context, aColor.CGColor);//填充颜色
    CGContextSetStrokeColorWithColor(context, aColor.CGColor);//线框颜色
    CGContextAddRect(context,CGRectMake(x + 1, y + 1, [self.viewCtrl squareWidth] - 2, [self.viewCtrl squareHeight] - 2));//画方框
    CGContextDrawPath(context, kCGPathFillStroke); //绘制路径加填充
    
    //绘制两条浅色边框
    CGContextSetRGBStrokeColor(context,lightColorTable[shape][0],lightColorTable[shape][1],lightColorTable[shape][2],1.0);//画笔线的颜色
    CGPoint aPoints[2];//坐标点
    aPoints[0] =CGPointMake(x, y + [self.viewCtrl squareHeight] - 1);//坐标1
    aPoints[1] =CGPointMake(x, y);//坐标2
    CGContextAddLines(context, aPoints, 2);//添加线
    CGContextDrawPath(context, kCGPathStroke); //根据坐标绘制路径
    
    aPoints[0] =CGPointMake(x, y);//坐标1
    aPoints[1] =CGPointMake(x + [self.viewCtrl squareWidth] - 1, y);//坐标2
    CGContextAddLines(context, aPoints, 2);//添加线
    CGContextDrawPath(context, kCGPathStroke); //根据坐标绘制路径
    
    //绘制两条深色边框
    CGContextSetRGBStrokeColor(context,darkColorTable[shape][0],darkColorTable[shape][1],darkColorTable[shape][2],1.0);//画笔线的颜色
    aPoints[0] =CGPointMake(x + 1, y + [self.viewCtrl squareHeight] - 1);//坐标1
    aPoints[1] =CGPointMake(x + [self.viewCtrl squareWidth] - 1, y + [self.viewCtrl squareHeight] - 1);//坐标2
    CGContextAddLines(context, aPoints, 2);//添加线
    CGContextDrawPath(context, kCGPathStroke); //根据坐标绘制路径
    
    aPoints[0] =CGPointMake(x + [self.viewCtrl squareWidth] - 1, y + [self.viewCtrl squareHeight] - 1);//坐标1
    aPoints[1] =CGPointMake(x + [self.viewCtrl squareWidth] - 1, y + 1);//坐标2
    CGContextAddLines(context, aPoints, 2);//添加线
    CGContextDrawPath(context, kCGPathStroke); //根据坐标绘制路径
    
    
    //    QColor color = colorTable[int(shape)];
    //    painter.fillRect(x + 1, y + 1, squareWidth() - 2, squareHeight() - 2,
    //                     color);
    //
    //    painter.setPen(color.light());
    //    painter.drawLine(x, y + squareHeight() - 1, x, y);
    //    painter.drawLine(x, y, x + squareWidth() - 1, y);
    //
    //    painter.setPen(color.dark());
    //    painter.drawLine(x + 1, y + squareHeight() - 1,
    //                     x + squareWidth() - 1, y + squareHeight() - 1);
    //    painter.drawLine(x + squareWidth() - 1, y + squareHeight() - 1,
    //                     x + squareWidth() - 1, y + 1);
}

@end
