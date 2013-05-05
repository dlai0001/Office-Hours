//
//  OfficeHoursAPIClient.m
//  Office Hours
//
//  Created by Robert Colin on 5/4/13.
//
//

#import "OfficeHoursAPIClient.h"

@implementation OfficeHoursAPIClient

#define BASE_URL_STRING @"http://officehoursatthack.appspot.com/"

+ (OfficeHoursAPIClient *)sharedOfficeAPIClient
{
    static OfficeHoursAPIClient *_sharedOfficeAPIClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedOfficeAPIClient = [[OfficeHoursAPIClient alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL_STRING]];
    });
    return _sharedOfficeAPIClient;
}

- (id)initWithBaseURL:(NSURL *)url
{
    if ((self = [super initWithBaseURL:url])) {
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [self setDefaultHeader:@"Accept" value:@"application/json"];
    }
    
    return self;
}

#pragma mark - Student Login Related Methods

- (void)loginStudentWithUsername:(NSString *)username andPassword:(NSString *)password
{
    NSDictionary *outgoingParameters = @{@"action":@"login", @"username": username, @"password": password};
    
    [self getPath:@"auth"
       parameters:outgoingParameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSLog(@"responseObject: %@", responseObject);
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"error: %@", error.localizedDescription);
          }];
}

- (void)logoutStudentWithToken:(NSString *)token
{
    NSDictionary *outgoingParameters = @{@"action": @"logout", @"token": token};
    
    [self getPath:@"auth"
       parameters:outgoingParameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSLog(@"responseObject: %@", responseObject);
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"error: %@", error.localizedDescription);
          }];
}

- (void)registerStudentWithUsername:(NSString *)username password:(NSString *)password firstName:(NSString *)firstName lastName:(NSString *)lastName emailAddress:(NSString *)emailAddress forStudentClass:(NSString *)studentClass
{
    NSDictionary *outgoingParameters = @{@"action": @"register", @"username": username, @"password": password, @"firstName": firstName,
                                         @"lastName": lastName, @"email": emailAddress, @"studentClass": studentClass};
    [self getPath:@"auth"
       parameters:outgoingParameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSLog(@"responseObject: %@", responseObject);
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"@error: %@", error.localizedDescription);
          }];
}

#pragma mark - Teacher Login Related Methods

- (void)loginTeacherWithUsername:(NSString *)username andPassword:(NSString *)password
{
    NSDictionary *outgoingParameters = @{@"action": @"login", @"username": username, @"password": password};
    
    [self getPath:@"teacherauth"
       parameters:outgoingParameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSLog(@"responseObject: %@", responseObject);
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"error: %@", error.localizedDescription);
          }];
}

- (void)logoutTeacherWithToken:(NSString *)token
{
    NSDictionary *outgoingParameters = @{@"action": @"logout", @"token": token};
    
    [self getPath:@"teacherauth"
       parameters:outgoingParameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSLog(@"responseObject: %@", responseObject);
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"error: %@", error.localizedDescription);
          }];
}

- (void)registerTeacherWithUsername:(NSString *)username password:(NSString *)password firstName:(NSString *)firstName lastName:(NSString *)lastName andEmailAddress:(NSString *)emailAddress
{
    NSDictionary *outgoingParameters = @{@"action": @"register", @"username": username, @"password": password, @"firstName": firstName,
                                         @"lastName": lastName, @"email": emailAddress};
    
    [self getPath:@"teacherauth"
       parameters:outgoingParameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSLog(@"responseObject: %@", responseObject);
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"error: %@", error.localizedDescription);
          }];
}

#pragma mark - Question Methods

- (void)createQuestionForToken:(NSString *)token withText:(NSString *)text
{
    NSDictionary *outgoingParameters = @{@"action": @"new", @"token": token, @"text": text};
    
    [self getPath:@"questions"
       parameters:outgoingParameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSLog(@"responseObject: %@", responseObject);
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"error: %@", error.localizedDescription);
          }];
}

- (void)deleteQuestionForToken:(NSString *)token withIdentification:(NSString *)identification
{
    NSDictionary *outgoingParameters = @{@"action": @"delete", @"token": token, @"id": identification};
    
    [self getPath:@"question"
       parameters:outgoingParameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSLog(@"responseObject: %@", responseObject);
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"error: %@", error.localizedDescription);
          }];
}

#pragma mark - Chat Log Methods

- (void)getChatLogForChannel:(NSString *)channel
{
    NSDictionary *outgoingParameters = @{@"action": @"getChat", @"channel": channel};
    
    [self getPath:@"chat"
       parameters:outgoingParameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSLog(@"responseObject: %@", responseObject);
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"error: %@", error.localizedDescription);
          }];
}

- (void)getChatLogForChannel:(NSString *)channel fromDate:(NSDate *)date
{
    NSString *timeIntervalString = [NSString stringWithFormat:@"%f", [date timeIntervalSince1970]];
    NSDictionary *outgoingParameters = @{@"action": @"getChatLog", @"channel": channel, @"from": timeIntervalString};
    
    [self getPath:@"chat"
       parameters:outgoingParameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSLog(@"responseObject: %@", responseObject);
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"error: %@", error.localizedDescription);
          }];
}

- (void)sendChatLogOnChannel:(NSString *)channel fromSender:(NSString *)sender withMessage:(NSString *)message
{
    NSDictionary *outgoingParameters = @{@"action": @"new", @"channel": channel, @"sender": sender, @"message": message};
    
    [self getPath:@"chat"
       parameters:outgoingParameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSLog(@"responseObject: %@", responseObject);
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"error: %@", error.localizedDescription);
          }];
}

#pragma mark - Question Status Methods

- (void)getStatusOfQuestionForIdentification:(NSString *)identification withToken:(NSString *)token
{
    NSDictionary *outgoingParameters = @{@"action": @"status", @"id": identification, @"token": token};
    
    [self getPath:@"questions"
       parameters:outgoingParameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSLog(@"responseObject: %@", responseObject);
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"error: %@", error.localizedDescription);
          }];
}

- (void)getQuestionListForToken:(NSString *)token
{
    NSDictionary *outgoingParameters = @{@"action": @"list", @"token": token};
    
    [self getPath:@"questions"
       parameters:outgoingParameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSLog(@"responseObject: %@", responseObject);
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"error: %@", error.localizedDescription);
          }];
}

- (void)setQuestionToAnsweredWithIdentification:(NSString *)identification withToken:(NSString *)token
{
    NSDictionary *outgoingParameters = @{@"action": @"answer", @"id": identification, @"token": token};
    
    [self getPath:@"questions"
       parameters:outgoingParameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSLog(@"responseObject: %@", responseObject);
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"error: %@", error.localizedDescription);
          }];
}

#pragma mark - Notification Status Methods

- (void)setNotificationForToken:(NSString *)token ofType:(NSString *)type
{
    NSDictionary *outgoingParameters = @{@"action": @"setNotify", @"token": token, @"type": type};
    
    [self getPath:@"questions"
       parameters:outgoingParameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSLog(@"responseObject: %@", responseObject);
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"error: %@", error.localizedDescription);
          }];
}

@end
