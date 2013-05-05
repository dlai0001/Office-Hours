//
//  LoginViewController.m
//  Office Hours
//
//  Created by Robert Colin on 5/4/13.
//
//

#import "LoginViewController.h"

#define H_USERNAME_TEXT_FIELD_TAG 1
#define H_PASSWORD_TEXT_FIELD_TAG 2

@interface LoginViewController () <UITextFieldDelegate>

@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *password;

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@end

@implementation LoginViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES
                                             animated:NO];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.usernameTextField becomeFirstResponder];
}

- (IBAction)signInPressed
{
    if ([self validateLoginCredentials]) {
        // Shoot off HTML request
        
        [OfficeHoursAPIClient.sharedOfficeAPIClient loginStudentWithUsername:self.username
                                                                 andPassword:self.password];
        
        [self performSegueWithIdentifier:@"goToQueue"
                                  sender:self];
    }
}

#define EMPTY_STRING @""

- (BOOL)validateLoginCredentials
{
    self.username = self.usernameTextField.text;
    self.password = self.passwordTextField.text;
    
    if ([self.username isEqualToString:EMPTY_STRING] ||
        [self.password isEqualToString:EMPTY_STRING]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Invalid username/password"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil, nil];
        [alertView show];
        [self.usernameTextField becomeFirstResponder];
    }
    
    NSLog(@"username: %@, password: %@", self.username, self.password);
    
    [self clearTextFields];
    
    return YES;
}

- (void)clearTextFields
{
    self.usernameTextField.text =
    self.passwordTextField.text = @"";
}

#pragma mark - UITextFieldDelegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    switch (textField.tag) {
        case H_USERNAME_TEXT_FIELD_TAG:
            [self.passwordTextField becomeFirstResponder];
            break;
        case H_PASSWORD_TEXT_FIELD_TAG:
            [self.passwordTextField resignFirstResponder];
            [self signInPressed];
            break;
    }
    
    return YES;
}

@end
