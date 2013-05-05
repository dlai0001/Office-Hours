//
//  StudentQueueViewController.m
//  Office Hours
//
//  Created by Robert Colin on 5/4/13.
//
//

#import "StudentQueueViewController.h"

@interface StudentQueueViewController () <UIAlertViewDelegate>

@end

@implementation StudentQueueViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO
                                             animated:YES];
}
- (void)checkForPositionInQueue
{
    
}

- (IBAction)signOut:(UIBarButtonItem *)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sign Out"
                                                        message:@"Are you sure you would like to sign out?"
                                                       delegate:self
                                              cancelButtonTitle:@"No"
                                              otherButtonTitles:@"Yes", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
