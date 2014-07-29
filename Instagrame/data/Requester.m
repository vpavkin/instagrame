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

- (NSString*) urlForClass:(NSString*) class{
    return [NSString stringWithFormat:@"%@classes/%@?", APP_URL, class];
}

- (void) userForEmail:(NSString *)email
          andPassword:(NSString *)password
           completion:(void (^)(BOOL, NSDictionary *))completion{
    NSString * params = [@"where={\"email\":\"vpavkin@gmail.com\",\"password\":\"12345\"}" stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:[[self urlForClass:@"User"] stringByAppendingString:params]];
    
    
//        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[@"https://api.parse.com/1/classes/User?where={}" stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]]]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//    [request setHTTPMethod:@"GET"];
//    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:APP_ID forHTTPHeaderField:@"X-Parse-Application-Id"];
    [request setValue:APP_KEY forHTTPHeaderField:@"X-Parse-REST-API-Key"];
//    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:@{@"email":@"vpavkin@gmail.com", @"password":@"12345"}
//                                                       options:0 error:NULL];
//    NSString *requestString = [[NSString stringWithFormat:@"where=%@", [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    NSString * requestString = @"a=1";
//    [request setHTTPBody:[NSData dataWithBytes:[requestString UTF8String] length:[requestString length]]];
    
    NSLog(@"request:\n%@", request);
    NSLog(@"requestString:\n%@", requestString);
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data, NSError *connectionError){
                               NSLog(@"response:\n%@",response);
                               if (data.length > 0 && connectionError == nil){
                                   NSLog(@"request result:\n%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
                               }else{
                                   NSLog(@"error:\n%@",connectionError);
                               }
                           }];
}

@end
