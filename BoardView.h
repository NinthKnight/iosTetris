//
//  BoardView.h
//  IOSTetris
//
//  Created by Halo on 2018/11/8.
//  Copyright © 2018年 Halo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@interface BoardView : UIView

@property (nonatomic) ViewController* viewCtrl;

-(id)initWithCtrl:(ViewController*)_viewCtrl;
@end
