//
//  ViewController.m
//  IOSTetris
//
//  Created by Halo on 2018/11/7.
//  Copyright © 2018年 Halo. All rights reserved.
//

#import "ViewController.h"
#import "BoardView.h"
#import "AppDelegate.h"

@interface ViewController ()

@end

@implementation ViewController

-(id)init{
    self = [super init];
    if (self) {

    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //通过tag获取btn按钮对象
    UIButton *upBtn =   (UIButton *)[self.view viewWithTag:(100)];
    UIButton *downBtn = (UIButton *)[self.view viewWithTag:(101)];
    UIButton *leftBtn = (UIButton *)[self.view viewWithTag:(102)];
    UIButton *rightBtn = (UIButton *)[self.view viewWithTag:(103)];
    
    UIButton *startBtn = (UIButton *)[self.view viewWithTag:(104)];
    UIButton *pauseBtn = (UIButton *)[self.view viewWithTag:(105)];
    UIButton *quitBtn = (UIButton *)[self.view viewWithTag:(106)];
    
    //绑定回调
    [upBtn addTarget:self action:@selector(up:) forControlEvents:UIControlEventTouchDown];
    [downBtn addTarget:self action:@selector(down:) forControlEvents:UIControlEventTouchDown];
    [leftBtn addTarget:self action:@selector(left:) forControlEvents:UIControlEventTouchDown];
    [rightBtn addTarget:self action:@selector(right:) forControlEvents:UIControlEventTouchDown];
    
    [startBtn addTarget:self action:@selector(start:) forControlEvents:UIControlEventTouchDown];
    [pauseBtn addTarget:self action:@selector(pause:) forControlEvents:UIControlEventTouchDown];
    [quitBtn addTarget:self action:@selector(quit:) forControlEvents:UIControlEventTouchDown];
    
    //初始化必要的参数
    self.isStarted = false;
    self.isPaused = false;
    
    self.curPiece = [[TetrixPiece alloc] init]; //[TetrixPiece new];
    self.nextPiece = [[TetrixPiece alloc] init]; //[TetrixPiece new];
    
    [self clearBoard];
    
    [[self nextPiece] setRandomShape];
    
    
    //添加自定义的view
    self.boardView = [[BoardView alloc] initWithCtrl:self];
    self.boardView.frame = CGRectMake(15, 40, 250, 506);
    
    //背景颜色
    self.boardView.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.0];
    
    //边框宽
    self.boardView.layer.borderWidth = 1;
    
    //边框颜色
    self.boardView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    [self.view addSubview:self.boardView];
    
    //初始化种子
    //srand((unsigned)time(0));
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return NO;
}

-(void)up:(UIButton*)sender{
    NSLog(@"up");
    [self tryMove:[self.curPiece rotatedRight] X:self.curX Y:self.curY];
}

-(void)down:(UIButton*)sender{
    NSLog(@"down");
    //[self tryMove:[self.curPiece rotatedLeft] X:self.curX Y:self.curY];
    [self dropDown];
}

-(void)left:(UIButton*)sender{
    NSLog(@"left");
    [self tryMove:self.curPiece X:self.curX - 1 Y:self.curY];
}

-(void)right:(UIButton*)sender{
    NSLog(@"right");
    [self tryMove:self.curPiece X:self.curX+ 1 Y:self.curY];
}

-(void)start:(UIButton*)sender{
    NSLog(@"start");
    
    if (self.isPaused)
        return;
    
    self.isStarted = true;
    self.isWaitingAfterLine = false;
    self.numLinesRemoved = 0;
    self.numPiecesDropped = 0;
    self.score = 0;
    self.level = 1;
    [self clearBoard];
    
//    emit linesRemovedChanged(numLinesRemoved);
//    emit scoreChanged(score);
    [self scoreChanged:self.score];
//    emit levelChanged(level);
    
    [self newPiece];
    
    //start timer
    self._timer = [NSTimer scheduledTimerWithTimeInterval:[self timeoutTime] target:self selector:@selector(timecount) userInfo:nil repeats:YES];
    
}

-(void)pause:(UIButton*)sender{
    NSLog(@"pause");

    if (!self.isStarted)
        return;
    
    self.isPaused = !self.isPaused;
    if (self.isPaused) {
        //stop timer
        [self._timer invalidate];
        
    } else {
        //timer.start(timeoutTime(), this);
        self._timer = [NSTimer scheduledTimerWithTimeInterval:[self timeoutTime] target:self selector:@selector(timecount) userInfo:nil repeats:YES];
    }
    
    //update();
    [self.boardView setNeedsDisplay];

}

//timer callback
- (void)timecount{

    NSLog(@"timer");
    
    if (self.isWaitingAfterLine) {
        self.isWaitingAfterLine = false;
        [self newPiece];
    } else {
        [self oneLineDown];
    }

}

-(void)quit:(UIButton*)sender{
    NSLog(@"quit");
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    
    UIWindow *window = app.window;
    
    [UIView animateWithDuration:1.0f animations:^{
        
        window.alpha = 0;
        
        window.frame = CGRectMake(0, window.bounds.size.width, 0, 0);
        
    } completion:^(BOOL finished) {
        
        exit(0);
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(enum TetrixShape)shape:(int)x At:(int)y{
    return board[(y * BoardWidth) + x];
}

-(int)timeoutTime{
    return 1;
}

-(int)squareWidth{
    return self.boardView.frame.size.width / BoardWidth;
}

-(int)squareHeight{
     return self.boardView.frame.size.height / BoardHeight;
}


-(void)clearBoard{
    for (int i = 0; i < BoardHeight * BoardWidth; ++i){
        board[i] = NoShape;
    }
}

-(bool)tryMove:(TetrixPiece*)newPiece X:(int)newX Y:(int)newY{
    for (int i = 0; i < 4; ++i) {
        int x = newX + [newPiece x:i];
        int y = newY - [newPiece y:i];
        if (x < 0 || x >= BoardWidth || y < 0 || y >= BoardHeight)
            return false;
        if ([self shape:x At:y] != NoShape)
            return false;
    }
    
    self.curPiece = newPiece;
    self.curX = newX;
    self.curY = newY;
    //update();
    [self.boardView setNeedsDisplay];
    
    return true;
}

-(void)dropDown{
    int dropHeight = 0;
    int newY = self.curY;
    while (newY > 0) {
        if (![self tryMove:self.curPiece X:self.curX Y:newY - 1])
            break;
        --newY;
        ++dropHeight;
    }
    
    [self pieceDropped:dropHeight];
}

-(void)oneLineDown{
    if (![self tryMove:self.curPiece X:self.curX Y:self.curY - 1])
        [self pieceDropped:0];
}

-(void)pieceDropped:(int)dropHeight{
    for (int i = 0; i < 4; ++i) {
        int x = self.curX + [self.curPiece x:i];
        int y = self.curY - [self.curPiece y:i];
        board[(y * BoardWidth) + x] = [self.curPiece shape];
    }
    
    
    //self.score += dropHeight + 7;
    //[self scoreChanged:self.score];
    [self removeFullLines];
    
    if (!self.isWaitingAfterLine)
        [self newPiece];
}

-(void)scoreChanged:(int)score{
    UILabel * scoreLabel = (UILabel *)[self.view viewWithTag:(1000)];
    NSString *newString =[NSString stringWithFormat:@"%d 分",score];
    scoreLabel.text = newString;
    NSLog(newString);
}

-(void)removeFullLines{
    int numFullLines = 0;
    
    for (int i = BoardHeight - 1; i >= 0; --i) {
        bool lineIsFull = true;
        
        for (int j = 0; j < BoardWidth; ++j) {
            if ([self shape:j At:i] == NoShape) {
                lineIsFull = false;
                break;
            }
        }
        
        if (lineIsFull) {
            
            ++numFullLines;
            for (int k = i; k < BoardHeight - 1; ++k) {
                for (int j = 0; j < BoardWidth; ++j)
                board[(k * BoardWidth) + j] = [self shape:j At:k+1];
            }
            
            for (int j = 0; j < BoardWidth; ++j){
                board[((BoardHeight - 1) * BoardWidth) + j] = NoShape;
            }
        }
        
    }
    
    if (numFullLines > 0) {
        self.numLinesRemoved += numFullLines;
        self.score += 1;
        //emit linesRemovedChanged(numLinesRemoved);
        //emit scoreChanged(score);
        [self scoreChanged:self.score];
        
        //timer.start(500, this);
        self.isWaitingAfterLine = true;
        [self.curPiece setShape:NoShape];
        //update();
        [self.boardView setNeedsDisplay];
    }
}

-(void)newPiece{
    self.curPiece = self.nextPiece;
    [self.nextPiece setRandomShape];
    //[self showNextPiece];
    self.curX = BoardWidth / 2 + 1;
    self.curY = BoardHeight - 1 + [self.curPiece minY];
    
    if (![self tryMove:self.curPiece X:self.curX Y:self.curY]) {
        [self.curPiece setShape:NoShape];
        //timer.stop();
        self.isStarted = false;
    }
}

-(void)showNextPiece{
    
    //    if (!nextPieceLabel)
    //        return;
    
    int dx = [self.nextPiece maxX] - [self.nextPiece minX] + 1;
    int dy = [self.nextPiece maxY] - [self.nextPiece minY] + 1;
    
    //    QPixmap pixmap(dx * squareWidth(), dy * squareHeight());
    //    QPainter painter(&pixmap);
    //    painter.fillRect(pixmap.rect(), nextPieceLabel->palette().background());
    
    for (int i = 0; i < 4; ++i) {
        int x = [self.nextPiece x:i] - [self.nextPiece minX];
        int y = [self.nextPiece y:i] - [self.nextPiece minY];
        [self drawSquareX:x * [self squareWidth]
                        Y:y * [self squareHeight]
                    Shape:[self.nextPiece shape]];
    }
    //    nextPieceLabel->setPixmap(pixmap);
}


@end
