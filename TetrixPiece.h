//
//  TetrixPiece.h
//  IOSTetris
//
//  Created by Halo on 2018/11/7.
//  Copyright © 2018年 Halo. All rights reserved.
//

#import <Foundation/Foundation.h>
enum TetrixShape {
    NoShape, ZShape, SShape, LineShape, TShape, SquareShape,
    LShape, MirroredLShape
};

@interface TetrixPiece : NSObject{
    @private
    enum TetrixShape pieceShape;
    int coords[4][2];
}

//setX
-(void)set:(int)index X:(int)x;

//setY
-(void)set:(int)index Y:(int)y;

-(int)x:(int)index;

-(int)y:(int)index;

-(int)minX;

-(int)minY;

-(int)maxX;

-(int)maxY;

-(void)setShape:(enum TetrixShape)shape;

-(void)setRandomShape;

-(TetrixPiece*)rotatedRight;

-(TetrixPiece*)rotatedLeft;

-(enum TetrixShape)shape;

@end
