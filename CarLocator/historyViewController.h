//
//  historyViewController.h
//  CarLocator
//
//  Created by PPTS on 25/06/14.
//  Copyright (c) 2014 ppts. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"

@interface historyViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

{
      NSMutableArray *remainders;
    
    
    IBOutlet UITextField *dateChangeHistory;
    IBOutlet UIDatePicker *datePickerHistory;
}

@property (strong, nonatomic) IBOutlet UITableView *myTableView;


-(IBAction)pickerDateChanged:(UIDatePicker *)sender;



@end
