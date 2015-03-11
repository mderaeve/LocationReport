//
//  AddPropertyVC.m
//  LocationReport
//
//  Created by Mark Deraeve on 16/09/14.
//  Copyright (c) 2014 AssistU. All rights reserved.
//

#import "AddPropertyVC.h"

@interface AddPropertyVC () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tblAutocomplete;

@end

@implementation AddPropertyVC
{
    NSArray * types;
    NSString * choice;
    VariableStore * store;
    NSArray * results;
    bool searchTitle;
    AUPropertyTemplate * selectedProperty;
    //Get the propertytemplate for the value
    AUPropertyTemplate * existingTempl;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tblAutocomplete.hidden = YES;
    self.tblAutocomplete.delegate = self;
    self.tblAutocomplete.dataSource = self;
    
    store   = [VariableStore sharedInstance];
    types = [NSArray arrayWithObjects:store.sPersonText, store.sYesNoText, store.sTextText,store.sChoiceText, nil];
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
        [self SetControlsForChoice:self.property.prop_type];
        self.selTypes.hidden=YES;
        self.txtTitle.text = self.property.prop_title;
        choice = self.property.prop_type;
        if ([self.property.prop_type isEqualToString:store.sYesNoText])
        {
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
            [self.txtVal isFirstResponder];
            if ([self.property.prop_type isEqualToString:[VariableStore sharedInstance].sPersonText])
            {
                self.txtPersonVal.text = self.property.prop_value;
                [self.txtPersonVal isFirstResponder];
            }
            else if ([self.property.prop_type isEqualToString:[VariableStore sharedInstance].sTextText])
            {
                self.txtVal.text = self.property.prop_value;
            }
        }
        
    }
}


#pragma mark Autocomplete

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    if (textField == self.txtTitle)
    {
        searchTitle=YES;
        
        self.tblAutocomplete.hidden = NO;
        [self searchAutocompleteEntriesWithSubstring:self.txtTitle.text];
        
    }
    else if (textField == self.txtVal)
    {
        searchTitle=NO;
        if (existingTempl==nil)
        {
            existingTempl = [DBStore GetPropertyTemplateByTemplTitle:self.txtTitle.text];
        }
        self.tblAutocomplete.hidden = NO;
        [self searchAutocompleteEntriesWithSubstring:self.txtVal.text];
        
    }
    return YES;
    
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (textField==self.txtVal)
    {
        self.tblAutocomplete.hidden = YES;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.txtTitle || textField == self.txtVal)
    {
        if (results.count==1)
        {
             selectedProperty =  ((AUPropertyTemplate *) [results objectAtIndex:0]);
            if (searchTitle==YES)
            {
                self.txtTitle.text = selectedProperty.templ_title;
           
            }
            else
            {
                self.txtVal.text = selectedProperty.prop_title;
                
            }
            self.tblAutocomplete.hidden = YES;
        }
    }
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.txtTitle)
    {
        searchTitle=YES;
    }
    else
    {
        searchTitle=NO;
    }
    
    self.tblAutocomplete.hidden = NO;
    
    NSString *substring = [NSString stringWithString:textField.text];
    substring = [substring
                 stringByReplacingCharactersInRange:range withString:string];
    [self searchAutocompleteEntriesWithSubstring:substring];
    return YES;
}

- (void)searchAutocompleteEntriesWithSubstring:(NSString *)substring {
    
    // Put anything that starts with this substring into the autocompleteUrls array
    // The items in this array is what will show up in the table view
    if (searchTitle==YES)
    {
        results = [DBStore GetPropertyTemplateByStartLetters:substring andTemplateID:nil];
    }
    else
    {
        results = [DBStore GetPropertyTemplateByStartLetters:substring andTemplateID:existingTempl.templ_id];
    }
    [self.tblAutocomplete reloadData];
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
    else if ([choice isEqualToString:store.sChoiceText])
    {
        value = self.txtVal.text;
    }
    title = self.txtTitle.text;
    
    if (self.property==nil)
    {
        AUProperty * prop = [DBStore CreateProperty:title AndValue:value AndType:choice  AndPropertyID:self.propID];
        if ([choice isEqualToString:store.sChoiceText])
        {
            //if the template already exists for property, do nothing, else create the template
            //value = template_title, prop_title = prop.title and prop.
            // prop_type;
            // prop_title;
            // prop_default_value;
            // NSNumber * templ_id;
            // templ_title;
            //Kijken als de gekozen templ title bestaat, zoniet inserten
            AUPropertyTemplate * existingProp;
            
            existingTempl = [DBStore GetPropertyTemplateByTemplTitle:title];
            
            //Dan kijken al de gekozen val bestaat, zoniet, insert en koppelen aan de templ
            if (existingTempl==nil)
            {
                existingTempl = [DBStore CreatePropertyTemplate:title AndValue:nil AndType:choice andTemplateID:nil];
            }
            existingProp = [DBStore GetPropertyTemplateByPropTitle:value];
            if (existingProp==nil)
            {
                [DBStore CreatePropertyTemplate:existingTempl.templ_title AndValue:value AndType:choice andTemplateID:existingTempl.templ_id];
            }
        }
        [DBStore SaveContext];
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

#pragma mark - UITableViewDelegate / Datasource

#pragma mark UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger) section
{
    return results.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = nil;
    static NSString *autoCompleteRowIdentifier = @"AutoCompleteRowIdentifier";
    cell = [tableView dequeueReusableCellWithIdentifier:autoCompleteRowIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault reuseIdentifier:autoCompleteRowIdentifier];
    }
    if (searchTitle==YES)
    {
        cell.textLabel.text = ((AUPropertyTemplate *) [results objectAtIndex:indexPath.row]).templ_title;
    }
    else
    {
        cell.textLabel.text = ((AUPropertyTemplate *) [results objectAtIndex:indexPath.row]).prop_title;
    }
    
    return cell;
}

// Override to support conditional editing of the table view.
// This only needs to be implemented if you are going to be returning NO
// for some items. By default, all items are editable.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
   
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        AUPropertyTemplate * pt = [results objectAtIndex:indexPath.row];
        [DBStore DeletePropertyTemplate:pt];
        if (searchTitle)
        {
            [self searchAutocompleteEntriesWithSubstring:self.txtTitle.text];
        }
        else
        {
            [self searchAutocompleteEntriesWithSubstring:self.txtVal.text];
        }
    }
}

#pragma mark UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedProperty = [results objectAtIndex:indexPath.row];
    if (searchTitle)
    {
        self.txtTitle.text = selectedProperty.templ_title;
    }
    else
    {
        self.txtVal.text = selectedProperty.prop_title;
    }
    self.tblAutocomplete.hidden = YES;
}

#pragma mark -
#pragma mark PickerView Delegate
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{
    self.txtTitle.text = @"";
    choice = types[row];
    [self SetControlsForChoice:choice];
    //show the corresponding control
    
}

-(void) SetControlsForChoice:(NSString *) typeChoice
{
    if ([typeChoice isEqualToString:store.sYesNoText])
    {
        self.cbxChoice.hidden=NO;
        self.txtVal.hidden=YES;
        self.txtPersonVal.hidden=YES;
    }
    else if ([typeChoice isEqualToString:store.sChoiceText])
    {
        self.cbxChoice.hidden=YES;
        self.tblAutocomplete.hidden = NO;
        self.txtVal.hidden=NO;
        self.txtTitle.delegate = self;
        self.txtVal.delegate = self;
        self.txtPersonVal.hidden=YES;
    }
    else
    {
        if ([typeChoice isEqualToString:store.sPersonText])
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
