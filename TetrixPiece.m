//
//  TetrixPiece.m
//  IOSTetris
//
//  Created by Halo on 2018/11/7.
//  Copyright © 2018年 Halo. All rights reserved.
//

#import "TetrixPiece.h"


@implementation TetrixPiece

-(instancetype)init{
    self = [super init];
    if (self) {
        [self setShape:NoShape];
    }
    return self;
}

-(void)set:(int)index X:(int)x
{
    coords[index][0] = x;
}

-(void)set:(int)index Y:(int)y
{
    coords[index][1] = y;
}


- (int)x:(int)index { 
    return coords[index][0];
}

- (int)y:(int)index { 
    return coords[index][1];
}

- (int)minX { 
    int min = coords[0][0];
    for(int i = 1; i < 4; i++){
        min = min < coords[i][0] ? min : coords[i][0];
    }
    
    return min;
}

- (int)minY { 
    int min = coords[0][1];
    for(int i = 1; i < 4; i++){
        min = min < coords[i][1] ? min : coords[i][1];
    }
    
    return min;
}

- (int)maxX {
    int max = coords[0][0];
    for(int i = 1; i < 4; i++){
        max = MAX(coords[i][0], max);
    }
    
    return max;
}

- (int)maxY {
    int max = coords[0][1];
    for(int i = 1; i < 4; i++){
        max = MAX(coords[i][1], max);
    }
    
    return max;
}

- (void)setShape:(enum TetrixShape)shape {
    static const int coordsTable[8][4][2] = {
        { { 0, 0 },   { 0, 0 },   { 0, 0 },   { 0, 0 } },
        { { 0, -1 },  { 0, 0 },   { -1, 0 },  { -1, 1 } },
        { { 0, -1 },  { 0, 0 },   { 1, 0 },   { 1, 1 } },
        { { 0, -1 },  { 0, 0 },   { 0, 1 },   { 0, 2 } },
        { { -1, 0 },  { 0, 0 },   { 1, 0 },   { 0, 1 } },
        { { 0, 0 },   { 1, 0 },   { 0, 1 },   { 1, 1 } },
        { { -1, -1 }, { 0, -1 },  { 0, 0 },   { 0, 1 } },
        { { 1, -1 },  { 0, -1 },  { 0, 0 },   { 0, 1 } }
    };
    
    for (int i = 0; i < 4 ; i++) {
        for (int j = 0; j < 2; ++j)
            coords[i][j] = coordsTable[shape][i][j];
    }
    pieceShape = shape;
}

- (TetrixPiece*)rotatedLeft{
    if (pieceShape == SquareShape)
        return self;
    
    TetrixPiece* result = [TetrixPiece new];
    result->pieceShape = pieceShape;
    for (int i = 0; i < 4; ++i) {
        [result set:i X:[self y:i]];
        [result set:i Y:-[self x:i]];
    }
    return result;
}

- (TetrixPiece*)rotatedRight{
    if (pieceShape == SquareShape)
        return self;
    
    TetrixPiece* result = [TetrixPiece new];
    result->pieceShape = pieceShape;
    for (int i = 0; i < 4; ++i) {
        [result set:i X:-[self y:i]];
        [result set:i Y:[self x:i]];
    }

    return result;
}

- (void)setRandomShape{
    [self setShape:(arc4random()%7+1)];
    //[self setShape:(7)];
}

- (enum TetrixShape)shape{
    return pieceShape;
}



@end
