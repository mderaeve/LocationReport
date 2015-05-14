//
//  GeneralFunctions.m
//  MyProjectOrganizer
//
//  Created by Mark Deraeve on 02/04/14.
//  Copyright (c) 2014 AssistU. All rights reserved.
//

#import "GeneralFunctions.h"


@implementation GeneralFunctions

+(void) showUserToken:(UIViewController * ) vc
{
    VariableStore * store = [VariableStore sharedInstance];
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:[store Translate:@"Identificatie"]
                                          message:[store Translate:@"Geef je usertoken in:"]
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField)
     {
         if (!store.userToken)
         {
             textField.placeholder = [store Translate:@"Usertoken"];
         }
         else
         {
             textField.text = store.userToken;
         }
     }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField)
     {
         if (!store.userPwd)
         {
             textField.placeholder = [store Translate:@"¨Password"];
         }
         else
         {
             textField.text = store.userPwd;
         }
     }];
    
    //Request a user token
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:[store Translate:@"Bewaar"]
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   UITextField *login = alertController.textFields.firstObject;
                                   store.userToken = login.text;
                                   UITextField *pwd = [alertController.textFields objectAtIndex:1];
                                   store.userPwd = pwd.text;
                                   NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                   [defaults setObject:store.userToken forKey:userTokenDefaultsKey];
                                   [defaults setObject:store.userPwd forKey:userPwdDefaultsKey];
                               }];
    [alertController addAction:okAction];
    [vc presentViewController:alertController animated:YES completion:nil];
}

+ (void) MakeSimpleRoundView:(UIView *) vw
{
    [vw.layer setCornerRadius:10.0f];
    [vw.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [vw.layer setBorderWidth:1.0f];
}

+ (void) MakeRoundView:(UIView *) vw
{
    [vw.layer setCornerRadius:10.0f];
    [vw.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [vw.layer setBorderWidth:1.0f];
    [vw.layer setShadowColor:[UIColor blackColor].CGColor];
    [vw.layer setShadowOpacity:0.5];
    [vw.layer setShadowRadius:2.0];
    [vw.layer setShadowOffset:CGSizeMake(1.5, 1.5)];
}

+ (void) MakeRoundView:(UIView *) vw WithCornerRadius:(CGFloat) radius
{
    [vw.layer setCornerRadius:radius];
    [vw.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [vw.layer setBorderWidth:1.0f];
    [vw.layer setShadowColor:[UIColor blackColor].CGColor];
    [vw.layer setShadowOpacity:0.5];
    [vw.layer setShadowRadius:2.0];
    [vw.layer setShadowOffset:CGSizeMake(1.5, 1.5)];
}

+ (void) MakeListButton:(UIView *) vw
{
    vw.backgroundColor= [UIColor whiteColor];
    [vw.layer setCornerRadius:10.0f];
    [vw.layer setBorderColor:[UIColor redColor].CGColor];
    [vw.layer setBorderWidth:1.0f];
    [vw.layer setShadowColor:[UIColor grayColor].CGColor];
    [vw.layer setShadowOpacity:0.5];
    [vw.layer setShadowRadius:2.0];
    [vw.layer setShadowOffset:CGSizeMake(1.5, 1.5)];
}

+ (void) MakeNormalButton:(UIButton *) vw
{
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = vw.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor whiteColor] CGColor], (id)[[UIColor lightGrayColor] CGColor], nil];
    [vw.layer insertSublayer:gradient atIndex:0];
    vw.layer.masksToBounds = NO;
    vw.layer.shouldRasterize = YES;
    [vw.layer setShadowColor:[UIColor blackColor].CGColor];
    [vw.layer setShadowOpacity:0.5];
    [vw.layer setShadowRadius:2.0];
    [vw.layer setShadowOffset:CGSizeMake(2.0f, 2.0f)];
    [vw.layer setCornerRadius:5.0f];
    [vw bringSubviewToFront:vw.imageView];
}

+ (void) MakeSimpleButton:(UIView *) vw
{
    [vw.layer setCornerRadius:10.0f];
    [vw.layer setBorderColor:[UIColor darkGrayColor].CGColor];
    [vw.layer setBorderWidth:1.0f];
    [vw.layer setShadowColor:[UIColor grayColor].CGColor];
    [vw.layer setShadowOpacity:0.5];
    [vw.layer setShadowRadius:2.0];
    [vw.layer setShadowOffset:CGSizeMake(2.0f, 2.0f)];
}

+ (void) MakeSelectedButton:(UIView *) vw
{
    //vw.backgroundColor= [UIColor whiteColor];
    [vw.layer setCornerRadius:10.0f];
    [vw.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [vw.layer setBorderWidth:3.0f];
    [vw.layer setShadowColor:[UIColor blackColor].CGColor];
    [vw.layer setShadowOpacity:0.7];
    [vw.layer setShadowRadius:2.5];
    [vw.layer setShadowOffset:CGSizeMake(2.5f, 2.5f)];
}

+ (void) MakeListItemView:(UIView *) vw
{
    vw.backgroundColor= [UIColor whiteColor];
    [vw.layer setCornerRadius:10.0f];
    [vw.layer setBorderColor:[UIColor whiteColor].CGColor];
    [vw.layer setBorderWidth:1.5f];
    [vw.layer setShadowColor:[UIColor grayColor].CGColor];
    [vw.layer setShadowOpacity:0.5];
    [vw.layer setShadowRadius:2.0];
    [vw.layer setShadowOffset:CGSizeMake(2.0f, 2.0f)];
}

+(void) MakeCollViewCell:(UIView *) vw
{
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = vw.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor whiteColor] CGColor], (id)[[UIColor lightGrayColor] CGColor], nil];
    [vw.layer insertSublayer:gradient atIndex:0];
    //vw.backgroundColor= [UIColor darkGrayColor];
    vw.layer.masksToBounds = NO;
    //cell.layer.contentsScale = [UIScreen mainScreen].scale;
    //cell.layer.shadowOpacity = 0.75f;
    //cell.layer.shadowRadius = 5.0f;
    //cell.layer.shadowOffset = CGSizeZero;
    //cell.layer.shadowPath = [UIBezierPath bezierPathWithRect:cell.bounds].CGPath;
    vw.layer.shouldRasterize = YES;
    [vw.layer setShadowColor:[UIColor blackColor].CGColor];
    [vw.layer setShadowOpacity:0.5];
    [vw.layer setShadowRadius:2.0];
    [vw.layer setShadowOffset:CGSizeMake(2.0f, 2.0f)];
    [vw.layer setCornerRadius:5.0f];
}

+(void) MakeTextField:(UITextView *) vw
{
    vw.layer.cornerRadius = 5;
    vw.clipsToBounds = YES;
    [vw.layer setBackgroundColor:[[UIColor whiteColor] CGColor]];
    [vw.layer setBorderColor:[[UIColor grayColor] CGColor]];
    [vw.layer setBorderWidth:1.0];
    [vw.layer setCornerRadius:8.0f];
    [vw.layer setMasksToBounds:YES];
}

+ (void) TranslateView: (UIView *) vw
{
    for(UIView * subview in vw.subviews)
    {
        if ([subview isKindOfClass:[UILabel class]])
        {
            [((UILabel *)subview) setText:[[VariableStore sharedInstance] Translate: ((UILabel *)subview).text]];
        }
        else if ([subview isKindOfClass:[UIButton class]])
        {
            NSString * test = [[VariableStore sharedInstance] Translate: ((UIButton *)subview).titleLabel.text];
            [((UIButton *)subview) setTitle:test forState:UIControlStateNormal];
        }
        else if ([subview isKindOfClass:[UITextField class]])
        {
            [((UITextField *)subview) setPlaceholder:[[VariableStore sharedInstance] Translate: ((UITextField *)subview).placeholder]];
        }
        else if ([subview isKindOfClass:[UITextView class]])
        {
            [((UITextView *)subview) setText: [[VariableStore sharedInstance] Translate: ((UITextView *)subview).text]];
        }
        else if ([subview isKindOfClass:[UITableView class]])
        {
            //DO nothing with the table
        }
        else if ([subview isKindOfClass:[UISegmentedControl class]])
        {
            [self TranslateView:subview];
        }
        else if (subview.subviews.count>0)
        {
            //Recursive translate
            [GeneralFunctions TranslateView:subview];
        }
    }
}



//method to move the view up/down whenever the keyboard is shown/dismissed
+(void)setViewMovedUp:(BOOL)movedUp AndView:(UIView *) vw
{
    int movementDistance = 80; // tweak as needed
    if ( UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication]statusBarOrientation]))
    {
        movementDistance = kOFFSET_FOR_KEYBOARDHOR;
    }
    else
    {
        movementDistance = kOFFSET_FOR_KEYBOARDVER;
    }
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (movedUp ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    vw.frame = CGRectOffset(vw.frame, 0, movement);
    [UIView commitAnimations];
}


@end
