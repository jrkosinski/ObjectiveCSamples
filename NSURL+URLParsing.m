//
//  NSURL+URLParsing.m
//  [Client Name]
//
//  Created by John Kosinski on 10/5/15.
//

#import "NSURL+URLParsing.h"

@implementation NSURL (URLParsing)

-(NSDictionary*)urlParams {
    NSDictionary *returningDictionary = @{};
    if ([self absoluteString])
    {
        NSArray *params_url = [[self absoluteString] componentsSeparatedByString:@"?"];
        if ([params_url count] >= 2)
        {
            NSString *params_string = params_url[1];
            NSArray *components = [params_string componentsSeparatedByString:@"&"];
            
            NSLog(@"Components are : %@", components);
            NSMutableDictionary *params_dict = [[NSMutableDictionary alloc] init];
            
            for (NSString *keyValuePair in components) {
                NSArray *componentValues = [keyValuePair componentsSeparatedByString:@"="];
                if ([componentValues count] == 2) {
                    [params_dict setObject:componentValues[1] forKey:componentValues[0]];
                }
            }
            returningDictionary = [[NSDictionary alloc] initWithDictionary:params_dict];
        }
    }
    
    NSLog(@"Returning Dict : %@", returningDictionary);
    return returningDictionary;
}

@end
