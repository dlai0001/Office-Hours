//
//  NetworkingAssistant.m
//  Office Hours
//
//  Created by Robert Colin on 5/5/13.
//
//

#import "NetworkingAssistant.h"

@implementation NetworkingAssistant

+ (NSString *)generateParameterURLStringForParameters:(NSDictionary *)parameters
{
    NSString *retVal;
    
    if (parameters) {
        NSMutableArray *parts = [[NSMutableArray alloc] initWithCapacity:parameters.allKeys.count];
        
        for (id key in parameters) {
            id value = [parameters objectForKey:key];
            [parts addObject:[NSString stringWithFormat:@"%@=%@", key, value]];
        }
        
        retVal = [parts componentsJoinedByString:@"&"];
    }
    
    return retVal;
}

@end
