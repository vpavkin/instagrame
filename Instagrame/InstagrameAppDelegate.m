//
//  InstagrameAppDelegate.m
//  Instagrame
//
//  Created by vpavkin on 22.07.14.
//  Copyright (c) 2014 instagrame. All rights reserved.
//

#import "InstagrameAppDelegate.h"
#import "InstagrameContext.h"

@implementation InstagrameAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self setBarItemsStyle];
    [self createDocument];
    return YES;
}

- (void) setBarItemsStyle{
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil]
     setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor],
       NSFontAttributeName:[UIFont fontWithName:@"Avenir Light" size:18]
       }
     forState:UIControlStateNormal];
}

- (void) createDocument{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *documentsDirectory =[[fileManager URLsForDirectory:NSDocumentDirectory
                                                    inDomains:NSUserDomainMask] firstObject];
    NSString *documentName = @"InstagrameStorage";
    NSURL *url = [documentsDirectory URLByAppendingPathComponent:documentName];
    UIManagedDocument *document = [[UIManagedDocument alloc] initWithFileURL:url];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[url path]]) {
        [document openWithCompletionHandler:^(BOOL success) {
            if (success) [self documentIsReady : document];
            if (!success) NSLog(@"couldn’t open document at %@", url);
        }];
    } else {
        [document saveToURL:url forSaveOperation:UIDocumentSaveForCreating
          completionHandler:^(BOOL success) {
              if (success) [self documentIsReady : document];
              if (!success) NSLog(@"couldn’t create document at %@", url);
          }];
    }

}

- (void) documentIsReady:(UIManagedDocument*) document{
    instagrameContext.document = document;
}

@end

