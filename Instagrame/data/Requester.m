//
//  Requester.m
//  Instagrame
//
//  Created by vpavkin on 29.07.14.
//  Copyright (c) 2014 instagrame. All rights reserved.
//

#import "Requester.h"
#import "InstagrameContext.h"
#import "User.h"
#import "Room.h"

#define APP_URL @"https://api.parse.com/1/"
#define APP_ID @"QEFpYvxRkPGnVWKgLvttKZTBIlaUUgF7xR7mPDEt"
#define APP_KEY @"LHaaBVKvBzW8wWY8WOI0DKXcvHfhics8izFSo9V2"

@implementation Requester

-(NSString*) jsonFromDictionary:(NSDictionary*) dictionary{
    NSData *data = [Requester dataFromDictionary:dictionary];
    if (!data) {
        return @"";
    }
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

+ (NSData*) dataFromDictionary:(NSDictionary*) dictionary{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (!jsonData) {
        NSLog(@"Error parsing json: %@", error);
        return nil;
    }
    return jsonData;
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
    
    [self queryClass:USER_CLASS withPredicate:@{@"email":email, @"password":password} completion:^(BOOL success, NSArray *data) {
        if (completion) {
            completion(success, success ? [data firstObject] : nil);
        }
    }];
}

- (void) userForVKId:(NSString*) vkId
          completion: (void(^)(BOOL success, NSDictionary *data))completion{
    [self queryClass:USER_CLASS withPredicate:@{@"vkId":vkId} completion:^(BOOL success, NSArray *data) {
        if (completion) {
            completion(success, success ? [data firstObject] : nil);
        }
    }];
}

- (void) addUserFromVk:(NSDictionary*) preparedInfo
            completion:(void(^)(BOOL success, NSDictionary *data))completion{
    [self createEntity:USER_CLASS withFields:preparedInfo completion:^(BOOL success, NSString *objectId) {
        [self queryClass:USER_CLASS withPredicate:@{@"objectId":objectId} completion:^(BOOL success, NSArray *data) {
            if (completion) {
                completion(success, success ? [data firstObject] : nil);
            }
        }];
    }];
}

- (void) queryClass: (NSString*) class
      withPredicate: (NSDictionary*)predicate
         completion:(void (^)(BOOL success, NSArray *data))completion{
    
    [self queryClass:class withPredicate:predicate include:nil completion:completion];
    
}

- (void) queryClass: (NSString*) class
      withPredicate: (NSDictionary*)predicate
            include: (NSArray*) keys
         completion:(void (^)(BOOL success, NSArray *data))completion{
    
    NSMutableDictionary *params = [@{@"where":[self jsonFromDictionary:predicate]} mutableCopy];
    if (keys.count) {
        params[@"include"] = [keys componentsJoinedByString:@","];
    }
    
    NSURL *url = [NSURL URLWithString:[self url:[self urlForClass:class]
                                     withParams:params]];
    NSLog(@"Querying url: %@", [url.description stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:APP_ID forHTTPHeaderField:@"X-Parse-Application-Id"];
    [request setValue:APP_KEY forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data, NSError *connectionError){
                               if (data.length > 0 && connectionError == nil){
                                   NSArray *jsonResult =
                                   [NSJSONSerialization JSONObjectWithData:data
                                                                   options: 0
                                                                     error: NULL][@"results"];
                                   if (completion) {
                                       completion (YES, jsonResult);
                                   }
                               }else{
                                   NSLog(@"error:\n%@", connectionError);
                               }
                           }];
    
    
}

- (void) createEntity: (NSString*) class
           withFields: (NSDictionary*)fields
           completion:(void (^)(BOOL success, NSString *objectId))completion{
    
    NSURL *url = [NSURL URLWithString:[self urlForClass:class]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:APP_ID forHTTPHeaderField:@"X-Parse-Application-Id"];
    [request setValue:APP_KEY forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod: @"POST"];
    if (fields) {
        [request setHTTPBody: [Requester dataFromDictionary:fields]];
    }
    NSLog(@"Posting url: %@\nwith data:\n%@",url,fields);
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data, NSError *connectionError){
                               if (data.length > 0 && connectionError == nil){
                                   NSLog(@"response:\n%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] );
                                   NSString *objId =
                                   [NSJSONSerialization JSONObjectWithData:data
                                                                   options: 0
                                                                     error: NULL][@"objectId"];
                                   if (completion) {
                                       completion (YES, objId);
                                   }
                               }else{
                                   NSLog(@"error:\n%@", connectionError);
                               }
                           }];
    
    
}

- (NSDictionary*) pointerRelationForClass:(NSString*) class objectId:(NSString*) objectId{
    return @{
             @"__type":@"Pointer",
             @"className":class,
             @"objectId":objectId
             };
}

- (void) loadRelevantRoomsForUser: (User*) user
                       completion:(void(^)(BOOL success, NSArray *data))completion{
    if (!user || !user.objectId) {
        if (completion) {
            completion(false, nil);
        }
        return;
    }
    [self queryClass:ROOM_CLASS
       withPredicate:@{@"$or":@[
                               @{@"owner": [self pointerRelationForClass:USER_CLASS objectId: user.objectId]},
                               @{@"players":[self pointerRelationForClass:USER_CLASS objectId: user.objectId]}
                               ]}
             include:@[@"owner"]
          completion:^(BOOL success, NSArray *data) {
              if (completion) {
                  completion(success, success ? data : nil);
              }
          }];
}

- (void) playersForRoom: (Room*) room
                     completion:(void(^)(BOOL success, NSArray *players))completion{
    if (!room || !room.objectId) {
        if (completion) {
            completion(false, nil);
        }
        return;
    }
    [self queryClass:USER_CLASS
       withPredicate:@{@"$relatedTo":@{
                               @"object":@{
                                       @"__type":@"Pointer",
                                       @"className":ROOM_CLASS,
                                       @"objectId":room.objectId
                                       },
                               @"key":@"players"}
                       }
          completion:^(BOOL success, NSArray *data) {
              if (completion) {
                  completion(success, success ? data : nil);
              }
          }];
}

@end
