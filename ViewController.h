//
//  ViewController.h
//  IOSTetris
//
//  Created by Halo on 2018/11/7.
//  Copyright © 2018年 Halo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TetrixPiece.h"

@class BoardView;

enum { BoardWidth = 10, BoardHeight = 22 };

@interface ViewController : UIViewController{
    
    enum TetrixShape board[BoardWidth * BoardHeight];
}

@property (nonatomic) BoardView* boardView;
@property (nonatomic) TetrixPiece* curPiece;
@property (nonatomic) TetrixPiece* nextPiece;
@property (nonatomic) NSTimer *_timer;

@property (nonatomic) bool isStarted;
@property (nonatomic) bool isPaused;
@property (nonatomic) bool isWaitingAfterLine;
@property (nonatomic) int curX;
@property (nonatomic) int curY;
@property (nonatomic) int numLinesRemoved;
@property (nonatomic) int numPiecesDropped;
@property (nonatomic) int score;
@property (nonatomic) int level;


-(id)init;
-(enum TetrixShape)shape:(int)x At:(int)y;
-(int)timeoutTime;
-(int)squareWidth;
-(int)squareHeight;
-(void)clearBoard;
-(void)dropDown;
-(void)oneLineDown;
-(void)pieceDropped:(int)dropHeight;
-(void)removeFullLines;
-(void)newPiece;
-(void)showNextPiece;
-(bool)tryMove:(TetrixPiece*)newPiece X:(int)newX Y:(int)newY;
-(void)drawSquareX:(int)x Y:(int)y Shape:(enum TetrixShape)shape;
-(void)scoreChanged:(int)score;

@end

