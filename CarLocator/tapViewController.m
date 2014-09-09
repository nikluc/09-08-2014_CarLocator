//
//  tapViewController.m
//  CarLocator
//
//  Created by PPTS on 25/06/14.
//  Copyright (c) 2014 ppts. All rights reserved.
//

#import "tapViewController.h"
#import "reportView.h"



reportView *reminderToDisplay;
@interface tapViewController ()
@property (strong, nonatomic) NSDate *selectedDate;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@end

@implementation tapViewController
@synthesize mapView;



double latitude;
double longitude;
CLLocationManager *locationManager;
CLGeocoder *geocoder;
CLPlacemark *placemark;

CLLocation *currentLocation;
NSString *cityName;




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
    
    

    
   
   
    
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
  
        
        [self setUpTextField];
    
    locationManager = [[CLLocationManager alloc] init];
    
    geocoder = [[CLGeocoder alloc] init];
    
    
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [locationManager startUpdatingLocation];

}


- (void)setUpTextField {
    
    
    
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat: @"yyyy-MM-dd"];
    //[self.dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    //  [self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    NSDate *defaultDate = [NSDate date];
    
    self->dateChange.text = [self.dateFormatter stringFromDate:defaultDate];
    self->dateChange.textColor = [self.view tintColor];
    self->datePicker.hidden = NO;
    self->datePicker.alpha = 0.0f;
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self->datePicker.alpha = 1.0f;
        
    }];
    self.selectedDate = defaultDate;
    datePicker.date = [NSDate date];
    
}

- (IBAction)pickerDateChanged:(UIDatePicker *)sender {
    
    dateChange.text =  [self.dateFormatter stringFromDate:sender.date];
    
    self.selectedDate = sender.date;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}




- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    
    MKCoordinateRegion region = [self.mapView regionThatFits:MKCoordinateRegionMakeWithDistance(currentLocation.coordinate, 1000, 1000)];
        region.span.latitudeDelta = 0.01;
        region.span.longitudeDelta = 0.01;
     [self.mapView setRegion:region animated:YES];
    
    
    latitude = currentLocation.coordinate.latitude;
   longitude = currentLocation.coordinate.longitude;
    
    NSLog(@"didUpdateToLocation: %@", newLocation);
    currentLocation = newLocation;
    
    if (currentLocation != nil) {
        longitudeLabel.text = [NSString stringWithFormat:@"%.8f", longitude];
        
       
        latitudeLabel.text = [NSString stringWithFormat:@"%.8f", latitude];

        
    }
    // Reverse Geocoding
   //[locationManager stopUpdatingLocation];
    NSLog(@"Resolving the Address");
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray* placemarks, NSError* error){
        
        // Check for returned placemarks
        if (placemarks && placemarks.count > 0) {
            placemark = [placemarks objectAtIndex:0];
            
            cityName = [NSString stringWithFormat:@"%@ %@ %@ %@ %@\n%@",
                        placemark.subThoroughfare, placemark.thoroughfare,
                        placemark.postalCode, placemark.locality,
                        placemark.administrativeArea,
                        placemark.country];
            areaLabel.text = [NSString stringWithFormat:@"%@", cityName];
            
        }
        
 
        
        else {
            NSLog(@"%@", error.debugDescription);
        }
        
    }];
    
    
}







- (IBAction)saveLocation:(id)sender
{
    NSLog(@"long %@",longitudeLabel.text);
    NSLog(@"lat %@",latitudeLabel.text);
    NSString *returnSuccess;
    NSUserDefaults *retrievePrefs = [NSUserDefaults standardUserDefaults];
    
    // getting an NSString
    NSString *checkLastRowId = [retrievePrefs stringForKey:@"sessionToLastId"];

    
    NSString *alertSuccess = @"parking location saved";
    if (checkLastRowId == nil || [checkLastRowId  isEqual: @""])
    {
        NSLog(@"saved success");
        
      returnSuccess=  [[DBmanager getSharedInstance]saveLocation:dateChange.text areaLocation:areaLabel.text lati:latitudeLabel.text longi:longitudeLabel.text];
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
        // saving an NSString
        [prefs setObject:returnSuccess forKey:@"sessionToLastId"];
        // This is suggested to synch prefs, but is not needed
        [prefs synchronize];

        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:
                              alertSuccess message:nil
                                                      delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        
    }
    else {
           NSLog(@"updated success");
        [[DBmanager getSharedInstance]updateLocation:dateChange.text areaLocation:areaLabel.text lati:latitudeLabel.text longi:longitudeLabel.text];      
    }
    

    
}



@end
