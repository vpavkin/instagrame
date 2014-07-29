//
//  Requester.m
//  Instagrame
//
//  Created by vpavkin on 29.07.14.
//  Copyright (c) 2014 instagrame. All rights reserved.
//

#import "Requester.h"

#define APP_URL @"https://api.parse.com/1/"
#define APP_ID @"QEFpYvxRkPGnVWKgLvttKZTBIlaUUgF7xR7mPDEt"
#define APP_KEY @"LHaaBVKvBzW8wWY8WOI0DKXcvHfhics8izFSo9V2"

@implementation Requester

-(NSString*) jsonFromDictionary:(NSDictionary*) dictionary{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (!jsonData) {
        NSLog(@"Error parsing json: %@", error);
        return @"";
    }
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

-(NSString*) urlEncode:(NSString*) string {
    return [string stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
}

- (NSString*) urlEncodedFromDictionary:(NSDictionary*) dictionary{
    NSMutableArray *parts = [NSMutableArray array];
    for (id key in dictionary) {
        id value = [dictionary objectForKey: key];
        NSString *part = [NSString stringWithFormat: @"%@=%@", [self urlEncode:key] , [self urlEncode:value]];
        [parts addObject: part];
    }
    return [parts componentsJoinedByString: @"&"];
}

- (NSString*) urlForClass:(NSString*) class{
    return [NSString stringWithFormat:@"%@classes/%@", APP_URL, class];
}

- (NSString*) url:(NSString*) url withParams:(NSDictionary*) params{
    return [NSString stringWithFormat:@"%@?%@",url, [self urlEncodedFromDictionary:params]];
}

- (void) userForEmail:(NSString *)email
          andPassword:(NSString *)password
           completion:(void (^)(BOOL success, NSDictionary *data))completion{
    
    NSURL *url = [NSURL URLWithString:[self url:[self urlForClass:@"User"]
                                     withParams:@{@"where": [self jsonFromDictionary:@{@"email":email, @"password":password}]}]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:APP_ID forHTTPHeaderField:@"X-Parse-Application-Id"];
    [request setValue:APP_KEY forHTTPHeaderField:@"X-Parse-REST-API-Key"];

    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data, NSError *connectionError){
                               NSLog(@"response:\n%@",response);
                               if (data.length > 0 && connectionError == nil){
                                   NSDictionary *jsonResult =
                                   [[NSJSONSerialization JSONObjectWithData:data
                                                                   options: NSJSONReadingMutableContainers
                                                                     error: NULL][@"results"] firstObject];
                                   if (completion) {
                                       completion (YES, jsonResult);
                                   }
                               }else{
                                   NSLog(@"error:\n%@", connectionError);
                               }
                           }];
}

@end
