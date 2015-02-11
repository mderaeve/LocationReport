//
//  PictureEditVC.m
//  LocationReport
//
//  Created by Mark Deraeve on 03/06/14.
//  Copyright (c) 2014 AssistU. All rights reserved.
//

#import "PictureEditVC.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface PictureEditVC ()

@end

@implementation PictureEditVC
{
    bool drawActive;
    CGPoint cumTranslation;
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat brush;
    CGFloat opacity;
    CGRect pageRect;
    UIImage * initImage;
    UIImageView * tempDrawImage;
    UIImageView * mainImageView;
    UIScrollView * scrollView;
    bool mouseSwiped;
    CGPoint lastPoint;
    CGPoint scaleLastPoint;
    BOOL textEditor;
    UITextField *drawnTextField;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
     [GeneralFunctions MakeSelectedButton:self.btnBlack];
    
}

-(void) viewDidAppear:(BOOL)animated
{
    // Do any additional setup after loading the view from its nib.
    tempDrawImage.userInteractionEnabled =YES;
    cumTranslation = CGPointMake(0,0);
    textEditor= NO;
    [GeneralFunctions MakeSelectedButton:self.btnDraw];
    drawActive = NO;
    red = 0.0/255.0;
    green = 0.0/255.0;
    blue = 0.0/255.0;
    
    brush = 3.0;
    opacity = 1.0;
    
    mainImageView.contentMode = UIViewContentModeScaleAspectFit;
    pageRect = self.view.frame;
    pageRect.origin = CGPointMake(0,0);
    if (self.imageForMainView)
    {
        mainImageView = [[UIImageView alloc] initWithFrame:pageRect];
        mainImageView.image = self.imageForMainView;
        mainImageView.frame = pageRect;
    }
    else
    {
        mainImageView = [[UIImageView alloc] initWithFrame:pageRect];
    }
    
    tempDrawImage =[[UIImageView alloc] initWithFrame:pageRect];
    
    scrollView = [[UIScrollView alloc] initWithFrame:pageRect];
    scrollView.delegate = self;
    scrollView.minimumZoomScale = 0.3;
    scrollView.maximumZoomScale = 3.0;
    
    scrollView.contentSize= pageRect.size;
    
    [scrollView addSubview:mainImageView];
    [scrollView addSubview:tempDrawImage];
    [scrollView sendSubviewToBack:mainImageView];
    
    [self.view addSubview:scrollView];
    [self.view sendSubviewToBack: scrollView];
    
    UIPanGestureRecognizer *Scrolling  = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onScroll:)];
    UIPinchGestureRecognizer *Zooming   = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(onZoom:)];
    UITapGestureRecognizer *Tap   = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    
    [scrollView addGestureRecognizer:Scrolling];
    [scrollView addGestureRecognizer:Zooming];
    [scrollView addGestureRecognizer:Tap];
}

#pragma mark Zoom / Draw

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return tempDrawImage;
}

- (void)onTap:(UIPinchGestureRecognizer*)sender
{

    if (drawActive==YES)
    {
        if (textEditor==YES)
        {
            UIGraphicsBeginImageContextWithOptions(tempDrawImage.frame.size, NO,0.0);
            [tempDrawImage.image drawInRect:CGRectMake(0, 0, tempDrawImage.frame.size.width, tempDrawImage.frame.size.height)];
            CGContextFlush(UIGraphicsGetCurrentContext());
            tempDrawImage.image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            CGPoint currentPoint = [sender locationInView:tempDrawImage];
            
            CGPoint scalePoint;
            scalePoint.x = currentPoint.x*scrollView.zoomScale;
            scalePoint.y = currentPoint.y*scrollView.zoomScale;
            
            scaleLastPoint = scalePoint;

            if (drawnTextField)
            {
                [drawnTextField removeFromSuperview];
            }
            //Show a text popup on location
            drawnTextField = [[UITextField alloc] initWithFrame:CGRectMake(scaleLastPoint.x, scaleLastPoint.y, 300, 40)];
            drawnTextField.borderStyle = UITextBorderStyleRoundedRect;
            drawnTextField.font = [UIFont systemFontOfSize:15];
            drawnTextField.placeholder = @"enter text";
            drawnTextField.autocorrectionType = UITextAutocorrectionTypeNo;
            drawnTextField.keyboardType = UIKeyboardTypeDefault;
            drawnTextField.returnKeyType = UIReturnKeyDone;
            drawnTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
            drawnTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            drawnTextField.delegate = self;
            drawnTextField.textColor = [UIColor colorWithRed:red green:green blue:blue alpha:1];
            [self.view addSubview:drawnTextField];
        }
        else
        {
            UIGraphicsBeginImageContextWithOptions(tempDrawImage.frame.size, NO,0.0);
            [tempDrawImage.image drawInRect:CGRectMake(0, 0, tempDrawImage.frame.size.width, tempDrawImage.frame.size.height)];
            
            CGPoint currentPoint = [sender locationInView:tempDrawImage];
            
            CGPoint scalePoint;
            scalePoint.x = currentPoint.x*scrollView.zoomScale;
            scalePoint.y = currentPoint.y*scrollView.zoomScale;
            
            CGRect borderRect = CGRectMake(scalePoint.x, scalePoint.y, brush, brush);
            CGContextRef context = UIGraphicsGetCurrentContext();
            CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);
            CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, 1.0);
            CGContextSetLineWidth(context, brush);
            CGContextFillEllipseInRect (context, borderRect);
            CGContextStrokeEllipseInRect(context, borderRect);
            CGContextFillPath(context);
            
            CGContextFlush(UIGraphicsGetCurrentContext());
            tempDrawImage.image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            //Draw dot.
        }
    
    }
}

- (void)onZoom:(UIPinchGestureRecognizer*)sender
{
    if (drawActive==NO)
    {
        sender.view.transform = CGAffineTransformScale(sender.view.transform, sender.scale, sender.scale);
        sender.scale = 1;
    }
}

- (void)onScroll:(UIPanGestureRecognizer*)sender
{
    if (drawActive==NO)
    {
        CGPoint translation = [sender translationInView:self.view];
        sender.view.center = CGPointMake(sender.view.center.x + translation.x,
                                         sender.view.center.y + translation.y);
        [sender setTranslation:CGPointMake(0, 0) inView:self.view];
        cumTranslation = CGPointMake(cumTranslation.x + translation.x,
                                     cumTranslation.y + translation.y);
    }
    else
    {
        if (textEditor==NO)
        {
            if (sender.state == UIGestureRecognizerStateBegan)
            { /* drawing began */
                
                mouseSwiped = NO;
                
                lastPoint = [sender locationInView:tempDrawImage];
                scaleLastPoint.x = lastPoint.x*scrollView.zoomScale;
                scaleLastPoint.y = lastPoint.y*scrollView.zoomScale;
                
            }
            else if (sender.state == UIGestureRecognizerStateChanged)
            { /* drawing occured */
                mouseSwiped = YES;
                
                CGPoint currentPoint = [sender locationInView:tempDrawImage];
                
                CGPoint scalePoint;
                scalePoint.x = currentPoint.x*scrollView.zoomScale;
                scalePoint.y = currentPoint.y*scrollView.zoomScale;
                
                UIGraphicsBeginImageContextWithOptions(tempDrawImage.frame.size, NO,0.0);
                [tempDrawImage.image drawInRect:CGRectMake(0, 0, tempDrawImage.frame.size.width, tempDrawImage.frame.size.height)];
                CGContextMoveToPoint(UIGraphicsGetCurrentContext(), scaleLastPoint.x, scaleLastPoint.y);
                CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), scalePoint.x, scalePoint.y);
                CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
                CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brush );
                CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, 1.0);
                CGContextSetBlendMode(UIGraphicsGetCurrentContext(),kCGBlendModeNormal);
                
                CGContextStrokePath(UIGraphicsGetCurrentContext());
                tempDrawImage.image = UIGraphicsGetImageFromCurrentImageContext();
                [tempDrawImage setAlpha:opacity];
                UIGraphicsEndImageContext();
                
                scaleLastPoint = scalePoint;
            }
            else if (sender.state == UIGestureRecognizerStateEnded)
            { /* drawing ended */
                if(!mouseSwiped) {
                     UIGraphicsBeginImageContextWithOptions(tempDrawImage.frame.size, NO,0.0);
                    [tempDrawImage.image drawInRect:CGRectMake(0, 0, tempDrawImage.frame.size.width, tempDrawImage.frame.size.height)];
                    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
                    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brush);
                    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, opacity);
                    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), scaleLastPoint.x, scaleLastPoint.y);
                    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), scaleLastPoint.x, scaleLastPoint.y);
                    CGContextStrokePath(UIGraphicsGetCurrentContext());
                    CGContextFlush(UIGraphicsGetCurrentContext());
                    tempDrawImage.image = UIGraphicsGetImageFromCurrentImageContext();
                    UIGraphicsEndImageContext();
                }
            }
        }
    }
}

#pragma mark Text

-(void) textFieldDidEndEditing:(UITextField *)textField
{
    NSString * test = textField.text;
    tempDrawImage.image = [self burnTextIntoImage:test inImage:tempDrawImage.image atPoint:scaleLastPoint];
   // tempDrawImage.image = [self addText:tempDrawImage.image text:test];
    [textField removeFromSuperview];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSString * test = textField.text;
    tempDrawImage.image = [self burnTextIntoImage:test inImage:tempDrawImage.image atPoint:scaleLastPoint];
    [textField resignFirstResponder];
    return YES;
}

/* Creates an image with a home-grown graphics context, burns the supplied string into it. */
- (UIImage *)burnTextIntoImage:(NSString *)text inImage:(UIImage *)img atPoint:(CGPoint)  point{
    
    UIGraphicsBeginImageContextWithOptions(img.size,NO,0.0);
    
    CGRect aRectangle = CGRectMake(0,0, img.size.width, img.size.height);
    [img drawInRect:aRectangle];
 
    NSInteger fontSize = 18;
    if ( [text length] > 200 ) {
        fontSize = 12;
    }
    UIFont *font = [UIFont boldSystemFontOfSize: fontSize];
    //[[UIColor redColor] setFill];
    // set text font
    NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys: font, NSFontAttributeName,[UIColor colorWithRed:red green:green blue:blue alpha:1],NSForegroundColorAttributeName,
                                nil];
    CGRect rect = CGRectMake(point.x, point.y, 200, 45);
    [ text drawInRect : rect                      // render the text
             withAttributes:dictionary ];
    UIImage *theImage=UIGraphicsGetImageFromCurrentImageContext();   // extract the image
    UIGraphicsEndImageContext();     // clean  up the context.
    [tempDrawImage setAlpha:opacity];
    return theImage;
}

#pragma mark Button events

- (IBAction)btnEditClicked:(id)sender
{
    
    self.btnBlack.hidden = drawActive;
    self.btnGreen.hidden = drawActive;
    self.btnRed.hidden = drawActive;
    self.btnYellow.hidden = drawActive;
    self.btnText.hidden = drawActive;
    self.btnDraw.hidden = drawActive;
    drawActive = !drawActive;
    if (drawActive==YES)
    {
        [self.btnEdit setTitle:[[VariableStore sharedInstance] Translate:@"$PO$Zoom"] forState:UIControlStateNormal];
    }
    else
    {
        [self.btnEdit setTitle:[[VariableStore sharedInstance] Translate:@"$PO$Draw"] forState:UIControlStateNormal];
    }
}
- (IBAction)btnYellowClicked:(id)sender
{
    red = 255/255.0;
    green = 255.0/255.0;
    blue = 0.0/255.0;
    [self SetClicked:self.btnYellow];
}
- (IBAction)btnGreenClicked:(id)sender
{
    red = 0.0/255.0;
    green = 255.0/255.0;
    blue = 0.0/255.0;
    [self SetClicked:self.btnGreen];
}
- (IBAction)btnRedClicked:(id)sender
{
    red = 255.0/255.0;
    green = 0.0/255.0;
    blue = 0.0/255.0;
    [self SetClicked:self.btnRed];
}
- (IBAction)btnBlackClicked:(id)sender
{
    red = 0.0/255.0;
    green = 0.0/255.0;
    blue = 0.0/255.0;
    [self SetClicked:self.btnBlack];
}

- (IBAction)btnAZClicked:(id)sender
{
    //Activate the text function
    
    [GeneralFunctions MakeSelectedButton:self.btnText];
    [GeneralFunctions MakeSimpleButton:self.btnDraw];
    textEditor=YES;
    
}

- (IBAction)btnDrawClicked:(id)sender
{
    [GeneralFunctions MakeSelectedButton:self.btnDraw];
    [GeneralFunctions MakeSimpleButton:self.btnText];
    textEditor=NO;
}

-(void) SetClicked:(UIButton *) btn
{
    [GeneralFunctions MakeSimpleButton:self.btnBlack];
    [GeneralFunctions MakeSimpleButton:self.btnRed];
    [GeneralFunctions MakeSimpleButton:self.btnYellow];
    [GeneralFunctions MakeSimpleButton:self.btnGreen];
    [GeneralFunctions MakeSelectedButton:btn];
}

- (IBAction)btnUndoClicked:(id)sender
{
    tempDrawImage.image = nil;
}
- (IBAction)btnSaveClicked:(id)sender
{
    if (tempDrawImage!=nil)
    {
        UIGraphicsBeginImageContext(mainImageView.frame.size);
        
        [mainImageView.image drawInRect:CGRectMake(0, 0, mainImageView.frame.size.width, mainImageView.frame.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
        [tempDrawImage.image drawInRect:CGRectMake(0, 0, tempDrawImage.frame.size.width, tempDrawImage.frame.size.height) blendMode:kCGBlendModeNormal alpha:opacity];
        mainImageView.image = UIGraphicsGetImageFromCurrentImageContext();
        tempDrawImage.image = nil;
        UIGraphicsEndImageContext();

        //overwrite the picture in the picture library
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [library writeImageToSavedPhotosAlbum:mainImageView.image.CGImage orientation:(ALAssetOrientation)mainImageView.image.imageOrientation completionBlock:^(NSURL *assetURL, NSError *error )
         {
             if (self.pic)
             {
                 self.pic.pic_url = [NSString stringWithFormat:@"%@", assetURL];
                 [DBStore SaveContext];
             }
         }];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
