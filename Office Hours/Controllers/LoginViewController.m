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
        [self performSegueWithIdentifier:@"goToQueue"
                                  sender:self];
    }
}

#define EMPTY_STRING @""

- (BOOL)validateLoginCredentials
{
    NSString *username = self.usernameTextField.text;
    NSString *passowrd = self.passwordTextField.text;
    
    if ([username isEqualToString:EMPTY_STRING] ||
        [passowrd isEqualToString:EMPTY_STRING]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Invalid username/password"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil, nil];
        [alertView show];
        [self.usernameTextField becomeFirstResponder];
    }
    
    NSLog(@"username: %@, password: %@", username, passowrd);
    
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
