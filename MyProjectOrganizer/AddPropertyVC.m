//
//  AddPropertyVC.m
//  LocationReport
//
//  Created by Mark Deraeve on 16/09/14.
//  Copyright (c) 2014 AssistU. All rights reserved.
//

#import "AddPropertyVC.h"

@interface AddPropertyVC ()

@end

@implementation AddPropertyVC
{
    NSArray * types;
    NSString * choice;
    VariableStore * store;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    store   = [VariableStore sharedInstance];
    types = [NSArray arrayWithObjects:store.sPersonText, store.sYesNoText, store.sTextText, nil];
    choice = store.sPersonText;
    self.txtTitle.text = [[VariableStore sharedInstance] Translate:@"$PO$Attendent"];
    // Do any additional setup after loading the view from its nib.
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.view.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:55/255.0 green:96/255.0 blue:124/255.0 alpha:1] CGColor], (id)[[UIColor colorWithRed:153/255.0 green:188/255.0 blue:244/255.0 alpha:1] CGColor], nil];
    [self.view.layer insertSublayer:gradient atIndex:0];
    [GeneralFunctions TranslateView:self.view];
    
    if (self.property!=nil)
    {
        self.selTypes.hidden=YES;
        self.txtTitle.text = self.property.prop_title;
        choice = self.property.prop_type;
        if ([self.property.prop_type isEqualToString:store.sYesNoText])
        {
            self.cbxChoice.hidden=NO;
            self.txtVal.hidden=YES;
            self.txtPersonVal.hidden=YES;
            if ([self.property.prop_value isEqualToString:[store Translate:@"$PO$Yes"]])
            {
                self.cbxChoice.selectedSegmentIndex = 0;
            }
            else if ([self.property.prop_value isEqualToString:[store Translate:@"$PO$No"]])
            {
                self.cbxChoice.selectedSegmentIndex = 1;
            }
            else
            {
                self.cbxChoice.selectedSegmentIndex = 2;
            }
        }
        else
        {
            self.cbxChoice.hidden=YES;
            if ([self.property.prop_type isEqualToString:[VariableStore sharedInstance].sPersonText])
            {
                self.txtPersonVal.text = self.property.prop_value;
                self.txtPersonVal.hidden=NO;
                self.txtVal.hidden=YES;
            }
            else if ([self.property.prop_type isEqualToString:[VariableStore sharedInstance].sTextText])
            {
                self.txtVal.text = self.property.prop_value;
                self.txtPersonVal.hidden=YES;
                self.txtVal.hidden=NO;
            }
        }
        
    }
    [self.txtVal isFirstResponder];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)btnSave:(id)sender
{
    NSString * value;
    NSString * title;
    if ([choice isEqualToString:store.sYesNoText])
    {
        //Save
        //if (self.cbxChoice.selectedSegmentIndex==0)
        //{
        value = [store Translate:[self.cbxChoice titleForSegmentAtIndex:self.cbxChoice.selectedSegmentIndex]];
        
        //}
    }
    else if ([choice isEqualToString:store.sPersonText])
    {
        //Save
        //Save the person to the person DB
        value = self.txtPersonVal.text;
    }
    else if ([choice isEqualToString:store.sTextText])
    {
        //Save
        value = self.txtVal.text;
    }
    title = self.txtTitle.text;
    
    if (self.property==nil)
    {
        AUProperty * prop = [DBStore CreateProperty:title AndValue:value AndType:choice  AndPropertyID:self.propID];
        if ([self.delegate respondsToSelector:@selector(PropertyAdded:)])
        {
            [self.delegate PropertyAdded:prop];
        }
    }
    else
    {
        self.property.prop_value = value;
        self.property.prop_title = title;
        [DBStore SaveContext];
        if ([self.delegate respondsToSelector:@selector(PropertyChanged)])
        {
            [self.delegate PropertyChanged];
        }  
    }
}



- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return types.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    return types[row];
}


#pragma mark -
#pragma mark PickerView Delegate
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{
    self.txtTitle.text = @"";
    choice = types[row];
    //show the corresponding control
    if ([choice isEqualToString:store.sYesNoText])
    {
        self.cbxChoice.hidden=NO;
        self.txtVal.hidden=YES;
        self.txtPersonVal.hidden=YES;
    }
    else
    {
        if ([choice isEqualToString:store.sPersonText])
        {
            self.txtTitle.text = [[VariableStore sharedInstance] Translate:@"$PO$Attendent"];
            self.txtVal.hidden=YES;
            self.txtPersonVal.hidden=NO;
        }
        else
        {
            self.txtVal.hidden=NO;
            self.txtPersonVal.hidden=YES;
        }
       
        self.cbxChoice.hidden=YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
