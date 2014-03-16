//
//  AKViewController.m
//  AddContact
//
//  Created by Kourtessia on 16.03.14.
//  Copyright (c) 2014 Kourtessia. All rights reserved.
//

#import "AKAddContactViewController.h"
#import "JVFloatLabeledTextField.h"

const static CGFloat kJVFieldHeight = 40.0f;
const static CGFloat kJVFieldHMargin = 150.0f; // padding left
const static CGFloat kJVFieldFontSize = 14.0f;
const static CGFloat kJVFieldFloatingLabelFontSize = 14.0f;
static NSString *reuseIdentifier = CELL_REUSE_IDENTIFIER;

#pragma mark - EditableListViewController

@interface AKAddContactViewController () <UITextFieldDelegate> {
    NSMutableArray *rowsContent;
}
@end


@interface AKAddContactViewController ()

@end

@implementation AKAddContactViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self.tableView setEditing:YES animated:YES];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Contents Assignment

- (NSArray *)contents
{
    return rowsContent;
}

- (void)contentsDidChange
{
}

- (void)setContents:(NSArray *)contents
{
    
    rowsContent = [NSMutableArray arrayWithArray:contents];
    [self.tableView reloadData];
    
    
}

#pragma mark - Table Changes

- (void)removeCachedSubviewsRow
{
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    // wird eine Zelle with customized TextField gelöscht, werden die gecachted Subviews gelöscht
    if ([cell.contentView subviews]){
        for (UIView *subview in [cell.contentView subviews]) {
            [subview removeFromSuperview];
        }
    }
}


- (void)deleteRow:(NSIndexPath *)indexPath
{
    [self removeCachedSubviewsRow];
    [rowsContent removeObjectAtIndex:indexPath.row];
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
    [self contentsDidChange];
}

- (void)addRow:(NSIndexPath *)indexPath text:(NSString *)text
{
    [self removeCachedSubviewsRow];
    
    if (rowsContent == nil) {
        rowsContent = [[NSMutableArray alloc] initWithCapacity:1];
    }
    
    [rowsContent addObject:text];
    NSIndexPath *nextRow = [NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section];
    [self.tableView beginUpdates];
    
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:nextRow] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
    
    [self contentsDidChange];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ((indexPath.row > 3) && (indexPath.row < rowsContent.count))
        return 123.0;
    else if (indexPath.row < 2)
        return 80.0;
    else
        return 40.0;
}

- (void)addCustomizedRow:(UIView *)view
{
    CGFloat topOffset = 0.0f;
    
    // Frame for 'Straße'
    CGRect frameStreet = CGRectMake(kJVFieldHMargin + 10.0f,  // links padding
                                    topOffset,
                                    view.frame.size.width - kJVFieldHMargin,  // Breite
                                    kJVFieldHeight);
    
    
    
    JVFloatLabeledTextField *titleField = [self createTextFieldForFrame:&frameStreet
                                                               withText:NSLocalizedString(@"Straße", @"")];
    CGRect divSubStreetFrame = CGRectMake(kJVFieldHMargin,
                                          titleField.frame.origin.y + titleField.frame.size.height,
                                          view.frame.size.width - kJVFieldHMargin,
                                          1.0f);
    UIView *divSubStreet = [self createDivForFrame:&divSubStreetFrame];
    
    // Frame for 'PLZ'
    CGRect plzFieldFrame = CGRectMake(kJVFieldHMargin + 10.0f,
                                      divSubStreet.frame.origin.y + divSubStreet.frame.size.height,
                                      60.0f,   // Breite
                                      kJVFieldHeight);
    
    JVFloatLabeledTextField *plzField = [self createTextFieldForFrame:&plzFieldFrame
                                                             withText:NSLocalizedString(@"PLZ", @"")];
    
    CGRect divSubPlzFrame = CGRectMake(kJVFieldHMargin + plzField.frame.size.width,
                                       titleField.frame.origin.y + titleField.frame.size.height + 1.0f,
                                       1.0f,
                                       kJVFieldHeight);
    UIView *divSubPlz = [self createDivForFrame:&divSubPlzFrame];
    
    // Frame for 'Stadt'
    CGRect frame = CGRectMake(kJVFieldHMargin + plzField.frame.size.width + 11.0f,
                              divSubStreet.frame.origin.y + divSubStreet.frame.size.height,
                              view.frame.size.width - kJVFieldHMargin - plzField.frame.size.width, kJVFieldHeight);
    
    JVFloatLabeledTextField *locationField = [self createTextFieldForFrame:&frame
                                                                  withText:NSLocalizedString(@"Stadt", @"")];
    CGRect div3Frame = CGRectMake(kJVFieldHMargin,
                                  plzField.frame.origin.y + plzField.frame.size.height,
                                  view.frame.size.width - kJVFieldHMargin,
                                  1.0f);
    UIView *div3 = [self createDivForFrame:&div3Frame];
    
    // Frame for 'Staat'
    CGRect frameStaat = CGRectMake(kJVFieldHMargin + 10.0f,
                                   div3.frame.origin.y + div3.frame.size.height,
                                   view.frame.size.width - kJVFieldHMargin,
                                   kJVFieldHeight - 3.0f);
    
    JVFloatLabeledTextField *staatField = [self createTextFieldForFrame:&frameStaat withText:NSLocalizedString(@"Country", @"")];
    
    CGRect divHorizFrame = CGRectMake(kJVFieldHMargin,  // Breite ab...
                                      topOffset, // Höhe ab...
                                      1.0f,
                                      123.0f);
    UIView *divHoriz = [self createDivForFrame:&divHorizFrame];
    
    [view addSubview:titleField];
    
    [view addSubview:divSubStreet];
    [view addSubview:plzField];
    [view addSubview:divSubPlz];
    [view addSubview:locationField];
    [view addSubview:div3];
    [view addSubview:staatField];
    [view addSubview:divHoriz];
    //[titleField becomeFirstResponder];
    
}

// create subview for text field for adress cell in edit mode
- (JVFloatLabeledTextField *)createTextFieldForFrame:(CGRect *)frame withText:(NSString *)text
{
    UIColor *floatingLabelColor = [UIColor grayColor];
    
    JVFloatLabeledTextField *textfield = [[JVFloatLabeledTextField alloc] initWithFrame:*frame];
    textfield.placeholder = text;
    textfield.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textfield.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    textfield.floatingLabel.font = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    textfield.floatingLabelTextColor = floatingLabelColor;
    textfield.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    return textfield;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    return indexPath;
}

- (UIView *)createDivForFrame:(CGRect *)frame
{
    UIView *div = [UIView new];
    div.frame = *(frame);
    div.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3f];
    return div;
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return rowsContent.count + 1; // inserting new row
}

- (UITextField *)createTextFieldForCell:(UITableViewCell *)cell
{
    CGFloat padding = 8.0f;
    CGRect frame = CGRectInset(cell.contentView.bounds, padding, padding / 2);

    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    CGFloat spareHeight = cell.contentView.bounds.size.height - textField.font.pointSize;
    frame.origin.y = self.tableView.style == UITableViewStyleGrouped ? spareHeight / 2 : spareHeight - padding/2;
    textField.frame = frame;
    textField.tag = TAG_TEXT_FIELD;
    textField.borderStyle = UITextBorderStyleNone;
    textField.returnKeyType = UIReturnKeyDone;
    textField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
    textField.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    return textField;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    
    // Separator line width if cell empty
    self.tableView.separatorInset = UIEdgeInsetsMake (0, 35, 0,0);
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    
    UITextField *textField = (UITextField *)[cell viewWithTag:TAG_TEXT_FIELD];
    if (textField == nil) {
        textField = [self createTextFieldForCell:cell];
        [cell.contentView addSubview:textField];
        
    }

    
    textField.delegate = self;
    
    if (indexPath.row < rowsContent.count)
    {
        textField.text = [rowsContent objectAtIndex:indexPath.row];
        textField.placeholder = nil;
        if ([textField.text isEqualToString:@"Privat"]
            || [textField.text isEqualToString:@"Arbeit"]
            || [textField.text isEqualToString:@"Andere"]){
            [self removeCachedSubviewsRow];
            
            [self addCustomizedRow:cell];
        }
        
    } else {
        
        textField.text = nil;
        textField.placeholder = NSLocalizedString(@"Adresse hinzufügen", nil);
        UIColor *color = [UIColor blueColor];
        textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:textField.placeholder attributes:@{NSForegroundColorAttributeName: color}];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (editingStyle) {
            
        case UITableViewCellEditingStyleDelete: {
            [self deleteRow:indexPath];
            break;
        }
            
        case UITableViewCellEditingStyleInsert:
            break;
            
        case UITableViewCellEditingStyleNone:
            break;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
     // Return NO if you do not want the specified item to be editable.
     return (indexPath.section == 0);
}


#pragma mark - TableViewDelegate

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < 4)
    return UITableViewCellEditingStyleNone;
    //    if ([indexPath.row textField.placeholder length] != 0) {
    //        return UITableViewCellEditingStyleInsert;    }
    return indexPath.row < rowsContent.count ? UITableViewCellEditingStyleDelete : UITableViewCellEditingStyleInsert;
}

- (NSIndexPath *)tableView:(UITableView *)tableView
targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath
       toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    return
    proposedDestinationIndexPath.section == 0
    && proposedDestinationIndexPath.row < rowsContent.count
    ? proposedDestinationIndexPath
    : [NSIndexPath indexPathForRow:rowsContent.count-1 inSection:0];
}


#pragma mark - UICustomTextViewdDelegate

- (NSIndexPath *)indexPathForCell:(UITextField *)textField
{
    UIView *view = textField;
    while (![view isKindOfClass:[UITableViewCell class]]) {
        view = [view superview];
    }
    return [self.tableView indexPathForCell:(UITableViewCell *)view];
}

- (NSUInteger)rowIndexForField:(UITextField *)textField
{
    return [self indexPathForCell:textField].row;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([textField.text length] == 0) {
        
        textField.placeholder = NSLocalizedString(@"", nil);
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //damit wird eine neue Zeile mit StyleDelete hinzugefügt..
	[textField resignFirstResponder];
	return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
        return NO;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
//    if (textField.returnKeyType == UIReturnKeyNext) {
//    [textField changeReturnKey:UIReturnKeyDone];
//    }
    
    return NO;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    
    if (self.editing) {
        self.tableView.separatorInset = UIEdgeInsetsMake (0, 45, 0,0);
    } else {
        self.tableView.separatorInset = UIEdgeInsetsMake (0, 35, 0,0);
    }
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    NSIndexPath *currRow = [self indexPathForCell:textField];
    NSLog(@"currRow %d", currRow.row);
    
    [self removeCachedSubviewsRow];
    
    // Zelle nicht editierbar
    if ([textField.placeholder isEqualToString:NSLocalizedString(@"Adresse hinzufügen", nil)])
    {
  
        if (currRow.row == 4)
            [self addRow:currRow text:@"Privat"];
        if (currRow.row == 5)
            [self addRow:currRow text:@"Arbeit"];
        if (currRow.row == 6)
            [self addRow:currRow text:@"Andere"];
        return NO;
    }
    
    return YES; // editierbar
    
}


@end
