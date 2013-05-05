//
//  RegistrationViewController.m
//  Office Hours
//
//  Created by Robert Colin on 5/4/13.
//
//

#import "RegistrationViewController.h"

#define H_FIRST_NAME_TEXT_FIELD 1
#define H_MIDDLE_NAME_TEXT_FIELD 2
#define H_LAST_NAME_TEXT_FIELD 3
#define H_USERNAME_TEXT_FIELD 4
#define H_PASSWORD_TEXT_FIELD 5
#define H_PASSWORD_CONFIRM_TEXT_FIELD 6
#define H_EMAIL_TEXT_FIELD 7
#define H_EMAIL_CONFIRM_TEXT_FIELD 8
#define H_PHONE_NUMBER_TEXT_FIELD 9

@interface RegistrationViewController () <UITextFieldDelegate>
@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSString *passwordConfirm;
@property (strong, nonatomic) NSString *emailAddress;
@property (strong, nonatomic) NSString *emailAddressConfirm;
@property (strong, nonatomic) NSString *studentClassName;

@property (weak, nonatomic) IBOutlet UISegmentedControl *studentTeacherSegmentedControl;

@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordConfirmTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailConfirmTextField;
@property (weak, nonatomic) IBOutlet UITextField *studentClassNameTextField;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *submitBarButtonItem;
@end

@implementation RegistrationViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO
                                             animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.firstNameTextField becomeFirstResponder];
}

- (IBAction)cancelRegistration:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)submitRegistration:(UIBarButtonItem *)sender
{
    if ([self registrationFieldsAreValid]) {
        NSLog(@"Successful registration");
        switch (self.studentTeacherSegmentedControl.selectedSegmentIndex) {
            case 0:
                [OfficeHoursAPIClient.sharedOfficeAPIClient registerStudentWithUsername:self.username
                                                                               password:self.password
                                                                              firstName:self.firstName
                                                                               lastName:self.lastName
                                                                           emailAddress:self.emailAddress
                                                                        forStudentClass:self.studentClassName];
                break;
            case 1:
                [OfficeHoursAPIClient.sharedOfficeAPIClient registerTeacherWithUsername:self.username
                                                                               password:self.password
                                                                              firstName:self.firstName
                                                                               lastName:self.lastName
                                                                        andEmailAddress:self.emailAddress];
                break;
        }
            } else {
        NSLog(@"Unsuccessful registration");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Please be sure to fill in all of the appropriate fields"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil, nil];
        [alertView show];
        [self.firstNameTextField becomeFirstResponder];
    }
    
    [self clearTextFields];
}

#define EMPTY_STRING @""

- (BOOL)registrationFieldsAreValid
{
    BOOL fieldsAreValid = NO;
    
    self.firstName = self.firstNameTextField.text;
    self.lastName = self.lastNameTextField.text;
    self.username = self.usernameTextField.text;
    self.password = self.passwordTextField.text;
    self.passwordConfirm = self.passwordConfirmTextField.text;
    self.emailAddress = self.emailTextField.text;
    self.emailAddressConfirm = self.emailConfirmTextField.text;
    self.studentClassName = self.studentClassNameTextField.text;
    
    // Be sure to not include middle name as it is optional
    NSArray *stringArray = @[self.firstName,self.lastName,self.username,self.password,
                             self.passwordConfirm,self.emailAddress,self.emailAddressConfirm,
                             self.studentClassName];
    
    if ([self arrayContainsEmptyStrings:stringArray]) {
        NSLog(@"array contains empty strings");
        fieldsAreValid = NO;
    } else {
        NSLog(@"array contains valid data");
        fieldsAreValid = YES;
        
        if ([self passwordAndEmailFieldsAreValid]) {
            NSLog(@"Email and Passwords are valid");
        } else {
            NSLog(@"Email and/or Passwords are invalid");
        }
    }
    
    return fieldsAreValid;
}

- (BOOL)passwordAndEmailFieldsAreValid
{
    BOOL emailIsValid = NO;
    BOOL passwordIsValid = NO;
    
    // Error messages
    NSString *emailErrorMessage = @"Email and confirmation do not match";
    NSString *passwordErrorMessage = @"Password and confirmation do not match";
    NSString *bothErrorMessages = [NSString stringWithFormat:@"%@\n%@", emailErrorMessage, passwordErrorMessage];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@""
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil, nil];
    
    emailIsValid = [self.emailAddress isEqualToString:self.emailAddressConfirm] ? YES : NO;
    passwordIsValid = [self.password isEqualToString:self.passwordConfirm] ? YES : NO;
    
    if (!emailIsValid && !passwordIsValid) {
        alertView.message = bothErrorMessages;
        [alertView show];
    } else if (!emailIsValid) {
        alertView.message = emailErrorMessage;
        [alertView show];
    } else if (!passwordIsValid) {
        alertView.message = passwordErrorMessage;
        [alertView show];
    }
    
    return (emailIsValid && passwordIsValid);
}

- (BOOL)arrayContainsEmptyStrings:(NSArray *)stringArray
{
    BOOL retVal = NO;
    
    for (NSString *string in stringArray) {
        if ([string isEqualToString:EMPTY_STRING]) {
            retVal = YES;
            break;
        }
    }
    
    return retVal;
}

- (void)clearTextFields
{
    self.firstNameTextField.text = self.lastNameTextField.text =
    self.usernameTextField.text = self.passwordTextField.text =
    self.passwordConfirmTextField.text = self.emailTextField.text =
    self.emailConfirmTextField.text = EMPTY_STRING;
}

#pragma mark - UITextFieldDelegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    UITextField *currentTextField = (UITextField *)[self.view viewWithTag:textField.tag+1];
    
    if (currentTextField.tag != 9) {
        [currentTextField becomeFirstResponder];
    } else {
        [self submitRegistration:self.submitBarButtonItem];
    }
    
    return YES;
}

@end
