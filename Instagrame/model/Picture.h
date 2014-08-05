//
//  Picture.h
//  Instagrame
//
//  Created by vpavkin on 05.08.14.
//  Copyright (c) 2014 instagrame. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Room, User;

@interface Picture : NSManagedObject

@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSString * photoURL;
@property (nonatomic, retain) NSString * objectId;
@property (nonatomic, retain) NSDate * submitDate;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) User *author;
@property (nonatomic, retain) Room *room;
@property (nonatomic, retain) NSSet *subscribers;
@property (nonatomic, retain) NSSet *visitors;
@property (nonatomic, retain) NSSet *voters;
@end

@interface Picture (CoreDataGeneratedAccessors)

- (void)addSubscribersObject:(User *)value;
- (void)removeSubscribersObject:(User *)value;
- (void)addSubscribers:(NSSet *)values;
- (void)removeSubscribers:(NSSet *)values;

- (void)addVisitorsObject:(User *)value;
- (void)removeVisitorsObject:(User *)value;
- (void)addVisitors:(NSSet *)values;
- (void)removeVisitors:(NSSet *)values;

- (void)addVotersObject:(User *)value;
- (void)removeVotersObject:(User *)value;
- (void)addVoters:(NSSet *)values;
- (void)removeVoters:(NSSet *)values;

@end
