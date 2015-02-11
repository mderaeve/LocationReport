//
//  PictureEditVC.h
//  LocationReport
//
//  Created by Mark Deraeve on 03/06/14.
//  Copyright (c) 2014 AssistU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Button.h"
#import "AUPicture.h"

@interface PictureEditVC : HomeVC <UIScrollViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet Button *btnEdit;
@property (weak, nonatomic) IBOutlet Button *btnUndo;
@property (weak, nonatomic) IBOutlet Button *btnSave;

@property (weak, nonatomic) IBOutlet UIButton *btnYellow;
@property (weak, nonatomic) IBOutlet UIButton *btnGreen;
@property (weak, nonatomic) IBOutlet UIButton *btnRed;
@property (weak, nonatomic) IBOutlet UIButton *btnBlack;
@property (weak, nonatomic) IBOutlet UIButton *btnText;
@property (weak, nonatomic) IBOutlet UIButton *btnDraw;

@property (weak, nonatomic) UIImage * imageForMainView;

@property (weak, nonatomic) AUPicture * pic;

@end
