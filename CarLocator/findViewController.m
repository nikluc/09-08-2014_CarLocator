//
//  findViewController.m
//  CarLocator
//
//  Created by PPTS on 25/06/14.
//  Copyright (c) 2014 ppts. All rights reserved.
//

#import "findViewController.h"
#import "reportView.h"

 
reportView *reminderToDisplay;
@interface findViewController ()
@property (strong, nonatomic) NSDate *selectedDate;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@end

@implementation findViewController
@synthesize mapView;

double latitude;
double longitude;
CLLocationManager *locationManager;
CLGeocoder *geocoder;
CLPlacemark *placemark;

CLLocation *currentLocation;
NSString *cityName;

MKPlacemark *destinationPlacemark;
MKMapItem *destination;





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

    
   }


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
      [self setUpTextField];
    locationManager = [[CLLocationManager alloc] init];
    geocoder = [[CLGeocoder alloc] init];
    
    
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [locationManager startUpdatingLocation];
    self.mapView.delegate = self;
    
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:(BOOL)animated];
    
    [mapView removeAnnotations:mapView.annotations];
    
    findLatitudeLabel.text =@"";
    findLongitudeLabel.text =@"";
    
    
    
}

- (IBAction)findLocation:(id)sender;
{
    NSLog(@"Source saved success");
    data = [[DBmanager getSharedInstance]findByDateId];
    NSLog(@"data mutable aarray %@",data);
    [self sourceAndDestination];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    // saving an NSString
    [prefs setObject:@"" forKey:@"sessionToLastId"];
    // This is suggested to synch prefs, but is not needed
    [prefs synchronize];
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
        sourceLongitude.text = [NSString stringWithFormat:@"%.8f", longitude];
        
        sourceLatitude.text = [NSString stringWithFormat:@"%.8f", latitude];
        
        
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
            sourceArea.text = [NSString stringWithFormat:@"%@", cityName];
            
        }
        
        
        
        else {
            NSLog(@"%@", error.debugDescription);
        }
        
    }];
    
    [self saveLocationOfSource];
}


-(void)saveLocationOfSource
{
    //storing of source
    [[DBmanager getSharedInstance]findSaveLocation:findDateChange.text sourceAreaLocation:sourceArea.text sourceLati:sourceLatitude.text sourceLongi:sourceLongitude.text];
  NSLog(@"source longitude: %@", sourceLongitude.text);
}

- (void)setUpTextField {
    
    
    
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat: @"yyyy-MM-dd"];
    //[self.dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    //  [self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    NSDate *defaultDate = [NSDate date];
    
    findDateChange.text = [self.dateFormatter stringFromDate:defaultDate];
   findDateChange.textColor = [self.view tintColor];
   datePicker.hidden = NO;
   datePicker.alpha = 0.0f;
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self->datePicker.alpha = 1.0f;
        
    }];
    self.selectedDate = defaultDate;
    datePicker.date = [NSDate date];
    
}

- (IBAction)pickerDateChanged:(UIDatePicker *)sender {
    
    findDateChange.text =  [self.dateFormatter stringFromDate:sender.date];
    
    self.selectedDate = sender.date;
}









-(void)sourceAndDestination
{
    
   
    NSString* firstString = [[data componentsSeparatedByString:@","] objectAtIndex:0];
    NSString* secondString = [[data componentsSeparatedByString:@","] objectAtIndex:1];
    
    findLatitudeLabel.text =firstString;
    findLongitudeLabel.text =secondString;
    
    
    NSLog(@"first string value  :%@",firstString);
     NSLog(@"Second string value  :%@",secondString);

    
    
    
    // Make the destination
    NSString *x = findLatitudeLabel.text;
    NSLog(@"value at x : %@",x);
    NSScanner *scanner1 = [NSScanner scannerWithString:x];
    
    BOOL success1 = [scanner1 scanDouble:&latitude];
    NSLog(@"%d", success1);
    
    NSString *y = findLongitudeLabel.text;
    NSLog(@"value at y : %@",y);
    NSScanner *scanner2 = [NSScanner scannerWithString:y];
    
    BOOL success2 = [scanner2 scanDouble:&longitude];
    NSLog(@"%d", success2);
    
    
    CLLocationCoordinate2D destinationCoords = CLLocationCoordinate2DMake(latitude, longitude);
    destinationPlacemark = [[MKPlacemark alloc] initWithCoordinate:destinationCoords addressDictionary:nil];
    destination = [[MKMapItem alloc] initWithPlacemark:destinationPlacemark];
    // Add an annotation
    MKPointAnnotation *destpoint = [[MKPointAnnotation alloc] init];
    destpoint.coordinate = destinationPlacemark.coordinate;
    destpoint.title = @"Destination";
    
    
    [mapView addAnnotation:destpoint];
    
    [self getDirections];
    
}


- (void)getDirections
{
    MKDirectionsRequest *request =
    [[MKDirectionsRequest alloc] init];
    
    request.source = [MKMapItem mapItemForCurrentLocation];
    
    request.destination = destination;
    request.requestsAlternateRoutes = YES;
    MKDirections *directions =
    [[MKDirections alloc] initWithRequest:request];
    
    [directions calculateDirectionsWithCompletionHandler:
     ^(MKDirectionsResponse *response, NSError *error) {
         if (error) {
             // Handle error
         } else {
             [self showRoute:response];
         }
     }];
}



-(void)showRoute:(MKDirectionsResponse *)response
{
    for (MKRoute *route in response.routes)
    {
        
        NSLog(@"drawing for route");

        [mapView addOverlay:route.polyline level:MKOverlayLevelAboveLabels];
        
        
        for (MKRouteStep *step in route.steps)
        {
            NSLog(@"%@", step.instructions);
        }
    }
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id < MKOverlay >)overlay
{
    NSLog(@"drawing polyline for route");
    
    MKPolylineRenderer *renderer =
    [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    renderer.strokeColor = [UIColor blueColor];
    renderer.lineWidth = 4.0;
    return renderer;
}


@end
