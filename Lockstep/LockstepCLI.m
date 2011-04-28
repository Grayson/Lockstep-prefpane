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

@end

@implementation LockstepCLI

+(NSString *)localPath {
    
	NSBundle *b = [NSBundle bundleWithIdentifier:@"com.fromconcentratesoftware.Lockstep"];
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
	NSTask *t = [[NSTask new] autorelease];
	NSPipe *pipe = [NSPipe pipe];
	NSFileHandle *fh = [pipe fileHandleForReading];
	t.launchPath = [LockstepCLI localPath];
	t.arguments = args;
	t.standardOutput = pipe;
	t.standardInput = [NSPipe pipe];
	
	[t launch];
	[t waitUntilExit];
	
	NSData *d = [fh readDataToEndOfFile];
	return [[[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding] autorelease];
}

@end
