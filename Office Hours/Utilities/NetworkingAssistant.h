//
//  NetworkingAssistant.h
//  Office Hours
//
//  Created by Robert Colin on 5/5/13.
//
//

#import <Foundation/Foundation.h>

@interface NetworkingAssistant : NSObject

+ (NSString *)generateParameterURLStringForParameters:(NSDictionary *)parameters;

@end
