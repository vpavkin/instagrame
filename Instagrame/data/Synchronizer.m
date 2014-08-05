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
#import "Picture+Addon.h"


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

- (NSArray*) syncPlayers:(NSArray*) users forRoom:(Room*) room{
    NSMutableArray *coreUsers = [NSMutableArray array];
    for (NSDictionary* user in users) {
        User* coreUser = [self syncUser:user];
        [coreUsers addObject:coreUser];
    }
    [room addPlayers:[NSSet setWithArray:coreUsers]];
    return coreUsers;
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

- (NSArray*) syncRooms:(NSArray*) rooms{
    NSMutableArray *coreRooms = [NSMutableArray array];
    for (NSDictionary* room in rooms) {
        Room* coreRoom = [self syncRoom:room];
        [coreRooms addObject:coreRoom];
    }
    return coreRooms;
}

- (Picture*) syncPicture:(NSDictionary*) picture{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:PICTURE_CLASS];
    request.predicate = [NSPredicate predicateWithFormat:@"objectId = %@", picture[@"objectId"]];
    
    NSError* error;
    Picture* corePicture = [[self.document.managedObjectContext executeFetchRequest:request error:&error] firstObject];
    if (!corePicture)
        corePicture = [NSEntityDescription insertNewObjectForEntityForName:PICTURE_CLASS inManagedObjectContext:self.document.managedObjectContext];
    if (!corePicture.updatedAt || ([corePicture.updatedAt compare:picture[UPDATED_AT]] == NSOrderedAscending)){
        corePicture = [corePicture updateWithActualData:picture];
        corePicture.author = [self syncUser:picture[@"author"]];
        corePicture.room = [self syncRoom:picture[@"room"]];
    }
    NSLog(@"Syncronized core picture:\n %@", corePicture);
    return corePicture;

}

- (NSArray*) syncPictures:(NSArray*) pictures forRoom: (Room*) room{
    NSMutableArray *corePictures = [NSMutableArray array];
    for (NSDictionary* picture in pictures) {
        Picture* corePicture = [self syncPicture:picture];
        [corePictures addObject:corePicture];
    }
    [room addPictures:[NSSet setWithArray:corePictures]];
    return corePictures;

}


@end
