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
    NSDictionary *outgoingParameters = @{@"username": username, @"password": password};
    NSString *parameterString = [NetworkingAssistant generateParameterURLStringForParameters:outgoingParameters];
    
    NSLog(@"parameterString: %@", parameterString);
}

- (void)logoutStudentWithToken:(NSString *)token
{
    NSDictionary *outgoingParameters = @{@"token": token};
    NSString *paramterString = [NetworkingAssistant generateParameterURLStringForParameters:outgoingParameters];
    
    NSLog(@"parameterString: %@", paramterString);
}

- (void)registerStudentWithUsername:(NSString *)username password:(NSString *)password firstName:(NSString *)firstName lastName:(NSString *)lastName emailAddress:(NSString *)emailAddress forStudentClass:(NSString *)studentClass
{
    NSDictionary *outgoingParameters = @{@"username": username, @"password": password, @"firstName": firstName,
                                         @"lastName": lastName, @"email": emailAddress, @"studentClass": studentClass};
    NSString *parameterString = [NetworkingAssistant generateParameterURLStringForParameters:outgoingParameters];
    
    NSLog(@"parameterString: %@", parameterString);
}

#pragma mark - Teacher Login Related Methods

- (void)loginTeacherWithUsername:(NSString *)username andPassword:(NSString *)password
{
    NSDictionary *outgoingParameters = @{@"username": username, @"password": password};
    NSString *parameterString = [NetworkingAssistant generateParameterURLStringForParameters:outgoingParameters];
    
    NSLog(@"parameterString: %@", parameterString);
}

- (void)logoutTeacherWithToken:(NSString *)token
{
    NSDictionary *outgoingParameters = @{@"token": token};
    NSString *parameterString = [NetworkingAssistant generateParameterURLStringForParameters:outgoingParameters];
    
    NSLog(@"parameterString: %@", parameterString);
}

- (void)registerTeacherWithUsername:(NSString *)username password:(NSString *)password firstName:(NSString *)firstName lastName:(NSString *)lastName andEmailAddress:(NSString *)emailAddress
{
    NSDictionary *outgoingParameters = @{@"username": username, @"password": password, @"firstName": firstName,
                                         @"lastName": lastName, @"email": emailAddress};
    NSString *parameterString = [NetworkingAssistant generateParameterURLStringForParameters:outgoingParameters];
    
    NSLog(@"parameterString: %@", parameterString);
}

#pragma mark - Question Methods

- (void)createQuestionForToken:(NSString *)token withText:(NSString *)text
{
    NSDictionary *outgoingParameters = @{@"token": token, @"text": text};
    NSString *parameterString = [NetworkingAssistant generateParameterURLStringForParameters:outgoingParameters];
    
    NSLog(@"parameterString: %@", parameterString);
}

- (void)deleteQuestionForToken:(NSString *)token withIdentification:(NSString *)identification
{
    NSDictionary *outgoingParameters = @{@"token": token, @"id": identification};
    NSString *parameterString = [NetworkingAssistant generateParameterURLStringForParameters:outgoingParameters];
    
    NSLog(@"parameterString: %@", parameterString);
}

#pragma mark - Chat Log Methods

- (void)getChatLogForChannel:(NSString *)channel
{
    NSDictionary *outgoingParameters = @{@"channel": channel};
    NSString *parameterString = [NetworkingAssistant generateParameterURLStringForParameters:outgoingParameters];
    
    NSLog(@"parameterString: %@", parameterString);
}

- (void)getChatLogForChannel:(NSString *)channel fromDate:(NSDate *)date
{
    NSString *timeIntervalString = [NSString stringWithFormat:@"%f", [date timeIntervalSince1970]];
    NSDictionary *outgoingParameters = @{@"channel": channel, @"from": timeIntervalString};
    NSString *parameterString = [NetworkingAssistant generateParameterURLStringForParameters:outgoingParameters];
    
    NSLog(@"parameterString: %@", parameterString);
}

#pragma mark - Question Status Methods

- (void)getStatusOfQuestionForIdentification:(NSString *)identification withToken:(NSString *)token
{
    NSDictionary *outgoingParameters = @{@"id": identification, @"token": token};
    NSString *parameterString = [NetworkingAssistant generateParameterURLStringForParameters:outgoingParameters];
    
    NSLog(@"parameterString: %@", parameterString);
}

- (void)getQuestionListForToken:(NSString *)token
{
    NSDictionary *outgoingParameters = @{@"token": token};
    NSString *parameterString = [NetworkingAssistant generateParameterURLStringForParameters:outgoingParameters];
    
    NSLog(@"parameterString: %@", parameterString);
}

@end
