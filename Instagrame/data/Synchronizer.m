//
//  Synchronizer.m
//  Instagrame
//
//  Created by vpavkin on 30.07.14.
//  Copyright (c) 2014 instagrame. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "Synchronizer.h"
#import "InstagrameContext.h"
#import "User.h"
#import "User+Addon.h"
#import "Room.h"
#import "Room+Addon.h"
#import "Picture.h"


@interface Synchronizer ()

@property (strong, readonly) UIManagedDocument* document;

@end

@implementation Synchronizer

- (UIManagedDocument*) document{
    return instagrameContext.document;
}

- (User*) syncUser:(NSDictionary*) user{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:USER_CLASS];
    request.predicate = [NSPredicate predicateWithFormat:@"objectId = %@", user[@"objectId"]];
    
    NSError* error;
    User* coreUser = [[self.document.managedObjectContext executeFetchRequest:request error:&error] firstObject];
    if (!coreUser)
        coreUser = [NSEntityDescription insertNewObjectForEntityForName:USER_CLASS inManagedObjectContext:self.document.managedObjectContext];
    if (!coreUser.updatedAt || ([coreUser.updatedAt compare:user[UPDATED_AT]] == NSOrderedAscending)){
        coreUser = [coreUser updateWithActualData:user];
    }
    NSLog(@"Syncronized core user:\n %@", coreUser);
    return coreUser;
}

- (Room*) syncRoom:(NSDictionary*) room{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:ROOM_CLASS];
    request.predicate = [NSPredicate predicateWithFormat:@"objectId = %@", room[@"objectId"]];
    
    NSError* error;
    Room* coreRoom = [[self.document.managedObjectContext executeFetchRequest:request error:&error] firstObject];
    if (!coreRoom)
        coreRoom = [NSEntityDescription insertNewObjectForEntityForName:ROOM_CLASS inManagedObjectContext:self.document.managedObjectContext];
    if (!coreRoom.updatedAt || ([coreRoom.updatedAt compare:room[UPDATED_AT]] == NSOrderedAscending)){
        coreRoom = [coreRoom updateWithActualData:room];
        coreRoom.owner = [self syncUser:room[@"owner"]];
    }
    NSLog(@"Syncronized core room:\n %@", coreRoom);
    return coreRoom;
}

@end