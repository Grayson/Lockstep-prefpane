//
//  LockstepCLI.h
//  Lockstep
//
//  Created by Grayson Hansard on 4/26/11.
//  Copyright 2011 From Concentrate Software. All rights reserved.
//

#import <Foundation/Foundation.h>

#define LALABEL @"com.fromconcentratesoftware.doppelgangerlaunchdaemon"

@interface LockstepCLI : NSObject {
    
}

+(NSString *)localPath;
+(NSDictionary *)fileAssociations;
+(void)removeAssociationsForSource:(NSString *)source;
+(void)removeAssociationForSource:(NSString *)source target:(NSString *)target;
+(void)addAssociationForSource:(NSString *)source target:(NSString *)target;

+(BOOL)launchAgentIsRunning;
+(BOOL)startLaunchAgent;
+(BOOL)stopLaunchAgent;
+(BOOL)writeLaunchAgentWithTimeInterval:(NSUInteger)seconds;
+(BOOL)removeLaunchAgent;

+(NSString *)launchAgentPath;

@end
