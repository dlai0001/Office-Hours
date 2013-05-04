//
//  LoginViewController.m
//  Office Hours
//
//  Created by Robert Colin on 5/4/13.
//
//

#import "LoginViewController.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@end

@implementation LoginViewController

- (IBAction)signInPressed
{
    NSLog(@"Sign In Pressed");
    
    if ([self validateLoginCredentials]) {

    }
}

- (BOOL)validateLoginCredentials
{
    NSString *username = self.usernameTextField.text;
    NSString *passowrd = self.passwordTextField.text;
    
    NSLog(@"username: %@, password: %@", username, passowrd);
    
    [self clearTextFields];
    
    return YES;
}

- (void)clearTextFields
{
    self.usernameTextField.text =
    self.passwordTextField.text = @"";
}

@end
