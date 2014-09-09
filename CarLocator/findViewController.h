//
//  findViewController.h
//  CarLocator
//
//  Created by PPTS on 25/06/14.
//  Copyright (c) 2014 ppts. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "DBManager.h"

@interface findViewController : UIViewController<MKMapViewDelegate, CLLocationManagerDelegate>




{
    NSString *data;
    IBOutlet UILabel *findLatitudeLabel;
    IBOutlet UILabel *findLongitudeLabel;
    IBOutlet UITextField *sourceArea;
    IBOutlet UITextField *sourceLatitude;
    IBOutlet UITextField *sourceLongitude;
   IBOutlet UILabel *findDateChange;
    IBOutlet UIDatePicker *datePicker;
   
   
}
- (IBAction)findLocation:(id)sender;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
 -(IBAction)pickerDateChanged:(UIDatePicker *)sender;
@end
