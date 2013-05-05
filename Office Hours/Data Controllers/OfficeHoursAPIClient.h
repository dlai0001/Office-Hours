//
//  OfficeHoursAPIClient.h
//  Office Hours
//
//  Created by Robert Colin on 5/4/13.
//
//

#import "AFHTTPClient.h"
#import "NetworkingAssistant.h"

@protocol OfficeHoursAPIClientDelegate;

@interface OfficeHoursAPIClient : AFHTTPClient

@property (weak, nonatomic) id <OfficeHoursAPIClientDelegate> delegate;

+ (OfficeHoursAPIClient *)sharedOfficeAPIClient;

- (void)loginStudentWithUsername:(NSString *)username andPassword:(NSString *)password;
- (void)logoutStudentWithToken:(NSString *)token;
- (void)registerStudentWithUsername:(NSString *)username password:(NSString *)password firstName:(NSString *)firstName lastName:(NSString *)lastName emailAddress:(NSString *)emailAddress forStudentClass:(NSString *)studentClass;

- (void)loginTeacherWithUsername:(NSString *)username andPassword:(NSString *)password;
- (void)logoutTeacherWithToken:(NSString *)token;
- (void)registerTeacherWithUsername:(NSString *)username password:(NSString *)password firstName:(NSString *)firstName lastName:(NSString *)lastName andEmailAddress:(NSString *)emailAddress;

- (void)createQuestionForToken:(NSString *)token withText:(NSString *)text;
- (void)deleteQuestionForToken:(NSString *)token withIdentification:(NSString *)identification;

- (void)getChatLogForChannel:(NSString *)channel;
- (void)getChatLogForChannel:(NSString *)channel fromDate:(NSDate *)date;

- (void)getStatusOfQuestionForIdentification:(NSString *)identification withToken:(NSString *)token;
- (void)getQuestionListForToken:(NSString *)token;

@end

@protocol OfficeHoursAPIClientDelegate <NSObject>

- (void)officeHoursAPIClient:(OfficeHoursAPIClient *)client didCreateStudent:(NSObject *)student;
- (void)officeHoursAPIClient:(OfficeHoursAPIClient *)client didLoginStudent:(NSObject *)student;

@end