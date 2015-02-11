//
//  HomeVC.m
//  MyProjectOrganizer
//
//  Created by Mark Deraeve on 22/04/14.
//  Copyright (c) 2014 AssistU. All rights reserved.
//

#import "HomeVC.h"
#import "Button.h"

@interface HomeVC ()

@end

@implementation HomeVC
{
    /*Button * btnDetails;
    bool up;
    ProjectOverviewController * ph;*/
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
    // Do any additional setup after loading the view.
    [GeneralFunctions TranslateView:self.view];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    //[super viewDidLoad];
    self.homeMenu = [[HomeMenuVC alloc] init];
    [self.homeMenu CreateMenu:self];
    [super viewDidAppear:animated];
}

@end
