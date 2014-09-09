//
//  historyViewController.m
//  CarLocator
//
//  Created by PPTS on 25/06/14.
//  Copyright (c) 2014 ppts. All rights reserved.
//

#import "historyViewController.h"
#import "reportView.h"
#import "settingsViewController.h"
UITableViewCell *cell;
NSString *inStr;
NSString *inShare;
NSString* inDel;
reportView *reminderToDisplay;
@interface historyViewController ()
@property (strong, nonatomic) NSDate *selectedDate;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@end

@implementation historyViewController
@synthesize myTableView;

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

[self setUpTextField];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSLog(@"date %@",dateChangeHistory.text);
    remainders = [[DBmanager getSharedInstance]findByDate:dateChangeHistory.text];
    [myTableView reloadData];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:(BOOL)animated];
    
    
    
    
}



- (void)setUpTextField {
    
    
    
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat: @"yyyy-MM-dd"];
    //[self.dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    //  [self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    NSDate *defaultDate = [NSDate date];
    
    dateChangeHistory.text = [self.dateFormatter stringFromDate:defaultDate];
    dateChangeHistory.textColor = [self.view tintColor];
    datePickerHistory.hidden = NO;
    datePickerHistory.alpha = 0.0f;
    
    [UIView animateWithDuration:0.25 animations:^{
        
       datePickerHistory.alpha = 1.0f;
        
    }];
    self.selectedDate = defaultDate;
    datePickerHistory.date = [NSDate date];
    
}

- (IBAction)pickerDateChanged:(UIDatePicker *)sender {
    
    dateChangeHistory.text =  [self.dateFormatter stringFromDate:sender.date];
    
    remainders = [[DBmanager getSharedInstance]findByDate:dateChangeHistory.text];
    [myTableView reloadData];

    
    self.selectedDate = sender.date;
}






- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [remainders count];
    }


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
    return 1;

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath  {
    static NSString *CellIdentifier;

    
    reminderToDisplay = [remainders objectAtIndex:indexPath.section];
    
        CellIdentifier = @"contentCell";
       cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
    
        
        if (cell == nil) {
            
          cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            
        }
    
   
    
    cell = [tableView dequeueReusableCellWithIdentifier:nil];
    
    
    
    UILabel *label1 = (UILabel *)[cell viewWithTag:1];
    label1.text= reminderToDisplay.carDate;
    
    
        UILabel *label2 = (UILabel *)[cell viewWithTag:2];
  
        label2.text= reminderToDisplay.carArea;
    
    UILabel *label3 = (UILabel *)[cell viewWithTag:3];
   
    label3.text= reminderToDisplay.sourceDate;
    
    
    UILabel *label4 = (UILabel *)[cell viewWithTag:4];
  
    label4.text= reminderToDisplay.sourceArea;
    
    
    NSInteger d=[reminderToDisplay.uniqueId integerValue];
  inDel = [NSString stringWithFormat: @"%d", (int)d];
    NSLog(@"indel val : %@",inDel);
    
    
    
    
UIButton *buttonShare = (UIButton *)[cell viewWithTag:12];
    NSInteger a=[reminderToDisplay.uniqueId integerValue];
    [buttonShare setTag:a];
[buttonShare addTarget:self action:@selector(buttonShareAction:tableView:) forControlEvents:UIControlEventTouchUpInside];
[cell.contentView addSubview:buttonShare];

  
 
UIButton *buttonDelete = (UIButton *)[cell viewWithTag:13];
    NSInteger b=[reminderToDisplay.uniqueId integerValue];
   
    

    
    NSLog(@"b value ::%d",b);
    [buttonDelete setTag:b];
    
   
    [buttonDelete addTarget:self action:@selector(buttonDeleteAction:) forControlEvents:UIControlEventTouchUpInside];
[cell.contentView addSubview:buttonDelete];
    
   

        return cell;
    }

- (IBAction)buttonShareAction:(id)sender tableView:(UITableView *)tableView
{
     NSLog(@"Section Share: %d",[sender tag]);
     inShare = [NSString stringWithFormat: @"%d", (int)[sender tag]];
     NSLog(@"Section Share: %@",inShare);
    NSLog(@"shareButton pressed");
    
    NSString *latt = reminderToDisplay.carLatitude;
       NSString *longg = reminderToDisplay.carLongitude;
    
    NSString *testVal = [NSString stringWithFormat:@"http://maps.google.com/maps?q=%@,%@&iwloc=A",latt,longg];
        
    NSURL *url = [NSURL URLWithString:testVal];
    
    
   
    NSArray *itemsToShare = @[url];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
    activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll]; //or whichever you don't need
    [self presentViewController:activityVC animated:YES completion:nil];
 }

-(IBAction)buttonDeleteAction:(id)sender
{
    [myTableView beginUpdates];
    
  //UIButton *btn = (UIButton *) sender;
  inStr = [NSString stringWithFormat: @"%d", (int)[sender tag]];
    NSLog(@"db val : %@",inStr);
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.myTableView];
    NSIndexPath *indexPath = [self.myTableView indexPathForRowAtPoint:buttonPosition];
    
    
    if (indexPath != nil)
    {
       // [remainders objectAtIndex:indexPath.section];
        
        
       
        
      NSLog(@"index val : %d",indexPath.section);
        BOOL response = [[DBmanager getSharedInstance]findByDelete:inStr];
        [remainders removeObjectAtIndex:indexPath.section];
        long section =[indexPath section];
        
        
        [myTableView deleteSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
    
    }
    
    [myTableView endUpdates];
     [myTableView reloadData];
    
  
   
    }



 
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath  {
 if (editingStyle == UITableViewCellEditingStyleDelete)
 {
     NSLog(@"value of del : %@",inDel);
     
   NSIndexPath *indexPath = [myTableView indexPathForCell:cell];
     
     NSLog(@"index value : %@",indexPath.description);
     
 /*[remainders removeObjectAtIndex:indexPath.section];
 reportView *test = [remainders objectAtIndex:indexPath.section];
 
 BOOL response = [[DBmanager getSharedInstance]findByDelete:test.uniqueId];
 NSLog(@"sucessssss %hhd",response);
 
 if (response == YES) {
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic]; */
 
 }
 
 
 
 
 //    NSInteger i = [test.uniqueId integerValue];
 // [myTableView deleteSections:[NSIndexSet indexSetWithIndex:i] withRowAnimation:UITableViewRowAnimationFade];
 //    [myTableView reloadData];
 
 
 
 // Delete the row from the data source
 }
// }






-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    long row = [indexPath row];
    NSLog(@"value of index  %ld",row);
}








- (IBAction)findLocation:(id)sender
{
    remainders = [[DBmanager getSharedInstance]findByDate:dateChangeHistory.text];
    [self.myTableView reloadData];
    
}







- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"sourceDestination"]) {
        NSIndexPath *indexPath = [self.myTableView indexPathForSelectedRow];
        NSLog(@"index %@", indexPath);
        settingsViewController *destViewController = segue.destinationViewController;
        
        reportView *test = [remainders objectAtIndex:indexPath.section];
        
        
        
        
        //    test.uniqueExpenseId;
        
        destViewController.uniqueId = test.uniqueId;
        
        destViewController.sourceArea = test.sourceArea;
        destViewController.sourceLat = test.sourceLati;
        destViewController.sourceLong = test.sourceLongi;
        destViewController.destinationArea = test.carArea;
        destViewController.destinationLat = test.carLatitude;
        destViewController.destinationLong = test.carLongitude;
       
    }
}









/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
