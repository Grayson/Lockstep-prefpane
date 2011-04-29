//
//  LockstepCLI.m
//  Lockstep
//
//  Created by Grayson Hansard on 4/26/11.
//  Copyright 2011 From Concentrate Software. All rights reserved.
//

#import "LockstepCLI.h"

@interface LockstepCLI (PrivateMethods)

+(NSString *)_runWithArguments:(NSArray *)args;
+(NSString *)_runTask:(NSString *)taskPath withArguments:(NSArray *)args;

@end

@implementation LockstepCLI

+(NSString *)localPath {
    
	NSBundle *b = [NSBundle bundleWithIdentifier:@"com.fromconcentratesoftware.Doppelganger"];
	return [b pathForResource:@"lockstep" ofType:@""];
}

+(NSDictionary *)fileAssociations {
	NSString *txt = [LockstepCLI _runWithArguments:[NSArray arrayWithObject:@"--showfiles"]];
	NSArray *lines = [txt componentsSeparatedByString:@"\n"];
	NSMutableDictionary *associations = [NSMutableDictionary dictionary];
	NSString *lastMaster = nil;
	NSCharacterSet *whitespaceSet = [NSCharacterSet characterSetWithCharactersInString:@"\t\n\r "];
	NSCharacterSet *colonSet = [NSCharacterSet characterSetWithCharactersInString:@":"];
	for (NSString *line in lines) {
		if ([line hasSuffix:@":"]) // Master line
			lastMaster = [line stringByTrimmingCharactersInSet:colonSet];
		else if ([line length]) {
			NSMutableArray *array = [associations objectForKey:lastMaster];
			if (!array) array = [NSMutableArray array];
			[array addObject:[line stringByTrimmingCharactersInSet:whitespaceSet]];
            [associations setObject:array forKey:lastMaster];
		}
	}
	return associations;
}

+(void)removeAssociationsForSource:(NSString *)source {
	[LockstepCLI _runWithArguments:[NSArray arrayWithObjects:@"--delete", @"--source", source, nil]];
}

+(void)removeAssociationForSource:(NSString *)source target:(NSString *)target {
	[LockstepCLI _runWithArguments:[NSArray arrayWithObjects:@"--delete", @"--source", source, @"--target", target, nil]];
}

+(void)addAssociationForSource:(NSString *)source target:(NSString *)target {
	[LockstepCLI _runWithArguments:[NSArray arrayWithObjects:@"--source", source, @"--target", target, nil]];
}

+(NSString *)_runWithArguments:(NSArray *)args {
	return [self _runTask:[LockstepCLI localPath] withArguments:args];
}

+(NSString *)_runTask:(NSString *)taskPath withArguments:(NSArray *)args {
	NSTask *t = [[NSTask new] autorelease];
	NSPipe *pipe = [NSPipe pipe];
	NSFileHandle *fh = [pipe fileHandleForReading];
	t.launchPath = taskPath;
	t.arguments = args;
	t.standardOutput = pipe;
	t.standardInput = [NSPipe pipe];
	
	[t launch];
	[t waitUntilExit];
	
	NSData *d = [fh readDataToEndOfFile];
	return [[[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding] autorelease];
}

+(BOOL)launchAgentIsRunning {
	NSString *tmp = [self _runTask:@"/bin/launchctl" withArguments:[NSArray arrayWithObject:@"list"]];
	return [tmp rangeOfString:LALABEL].location != NSNotFound;
}

+(BOOL)startLaunchAgent {
	[self _runTask:@"/bin/launchctl" withArguments:[NSArray arrayWithObjects:
		@"load", [LockstepCLI launchAgentPath], nil]];
	return [self launchAgentIsRunning];
}

+(BOOL)stopLaunchAgent {
	[self _runTask:@"/bin/launchctl" withArguments:[NSArray arrayWithObjects:
		@"unload", [LockstepCLI launchAgentPath], nil]];
		return [LockstepCLI launchAgentIsRunning];
}

+(BOOL)writeLaunchAgentWithTimeInterval:(NSUInteger)seconds {
	NSDictionary *launchAgent = [NSDictionary dictionaryWithObjectsAndKeys:
		LALABEL, @"label",
		[NSArray arrayWithObject:[LockstepCLI localPath]], @"ProgramArguments",
		[NSNumber numberWithUnsignedLong:seconds], @"StartInterval",
		nil];
	return [launchAgent writeToFile:[LockstepCLI launchAgentPath] atomically:YES];
}

+ (BOOL)removeLaunchAgent
{
	if ([LockstepCLI launchAgentIsRunning]) return NO;
	return [[NSFileManager defaultManager] removeItemAtPath:[LockstepCLI launchAgentPath] error:nil];
}

+(NSString *)launchAgentPath {
	NSString *launchAgentDirectoryPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Library"] stringByAppendingPathComponent:@"LaunchAgents"];
	if (![[NSFileManager defaultManager] createDirectoryAtPath:launchAgentDirectoryPath withIntermediateDirectories:YES attributes:nil error:nil]) return nil;
	return [[launchAgentDirectoryPath stringByAppendingPathComponent:LALABEL] stringByAppendingPathExtension:@"plist"];
}

@end
