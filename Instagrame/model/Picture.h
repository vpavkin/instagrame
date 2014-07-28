//
//  Picture.h
//  Instagrame
//
//  Created by vpavkin on 28.07.14.
//  Copyright (c) 2014 instagrame. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Room, User;

@interface Picture : NSManagedObject

@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSDate * submitDate;
@property (nonatomic, retain) Room *room;
@property (nonatomic, retain) User *author;
@property (nonatomic, retain) NSSet *voters;
@property (nonatomic, retain) NSSet *subscribers;
@property (nonatomic, retain) NSSet *visitors;
@end

@interface Picture (CoreDataGeneratedAccessors)

- (void)addVotersObject:(User *)value;
- (void)removeVotersObject:(User *)value;
- (void)addVoters:(NSSet *)values;
- (void)removeVoters:(NSSet *)values;

- (void)addSubscribersObject:(User *)value;
- (void)removeSubscribersObject:(User *)value;
- (void)addSubscribers:(NSSet *)values;
- (void)removeSubscribers:(NSSet *)values;

- (void)addVisitorsObject:(User *)value;
- (void)removeVisitorsObject:(User *)value;
- (void)addVisitors:(NSSet *)values;
- (void)removeVisitors:(NSSet *)values;

@end
