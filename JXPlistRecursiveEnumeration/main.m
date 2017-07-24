//
//  main.m
//  JXPlistRecursiveEnumeration
//
//  Created by Jan on 23.07.17.
//  Copyright © 2017 Jan. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JXPlistRecursiveEnumeration.h"


typedef NS_OPTIONS(NSUInteger, JXPlistDumpOptions) {
	JXPlistDumpExcludeFirstPathSegment				= 1 << 0,
};


static NSString * const kFileNameKey = @"JXPlistRecursiveEnumerationFileName";
static NSString * const kFilePathKey = @"JXPlistRecursiveEnumerationFilePath";
static NSString * const kFileDateKey = @"JXPlistRecursiveEnumerationFileModificationDate";


void printUsage() {
	printf("Usage: JXPlistRecursiveEnumeration <file.plist> [<file2.plist>]\n\n");
}

void dumpPlistRootedIn(id rootObj, JXPlistDumpOptions options) {
	NSMutableArray *pathComponents = [NSMutableArray array];
	
	NSMutableString *string = [NSMutableString string];
	
	NSMutableOrderedSet *pathSet = [NSMutableOrderedSet orderedSet];
	
	[rootObj recursiveEnumerationWithPathComponents:pathComponents
									   visitorBlock:
	 ^(id node, JXPlistNodeType nodeType, JXPlistPosition position, NSArray *pathComponents) {
		 const NSUInteger pathComponentsCount = pathComponents.count;
		 
		 if ((nodeType != JXPlistNodeTypeNSArray) &&
			 (nodeType != JXPlistNodeTypeNSDictionary) &&
			 (position == JXPlistPositionNode)) {
			 
			 NSString *path = nil;
			 
			 NSArray *pathComponentsUsed = nil;
			 
			 if ((options & JXPlistDumpExcludeFirstPathSegment)) {
				 const NSUInteger offset = 1;
				 NSRange tailRange = NSMakeRange(offset, pathComponentsCount - offset);
				 NSArray *pathComponentsTail = [pathComponents subarrayWithRange:tailRange];
				 pathComponentsUsed = pathComponentsTail;
			 }
			 else {
				 pathComponentsUsed = pathComponents;
			 }
			 
			 path = [pathComponentsUsed componentsJoinedByString:@"/"];
			 
			 [pathSet addObject:path];
			 
			 NSString *description = [node description];
			 [string appendFormat:@"%@" "\t" "%@" "\n", path, description];
		 }
		 else {
			 if ((pathComponentsCount == 1) &&
				 (position == JXPlistPositionCollectionEnd)) {
				 [string appendString:@"\n"];
			 }
		 }
	 }];
	
	printf("%s", [string UTF8String]);
	
	printf("\n");
	printf("%s", [[pathSet description] UTF8String]);
}

int main(int argc, const char * argv[]) {
	@autoreleasepool {
		NSError *error;
		
		JXPlistDumpOptions dumpOptions =
		JXPlistDumpExcludeFirstPathSegment;
		
		NSArray *processArguments = [[NSProcessInfo processInfo] arguments];
		NSUInteger argumentCount = processArguments.count;
		
		if (argumentCount < 2) {
			printUsage();
			printf("Error: There is an insufficient number of arguments.\n");
			return EXIT_FAILURE;
		}
		
		const NSUInteger firstPathArgumentIndex = 1;
		
		NSUInteger pathCount = argumentCount - firstPathArgumentIndex;
		NSArray *plistFilePaths = [processArguments subarrayWithRange:NSMakeRange(firstPathArgumentIndex, pathCount)];
		
		for (NSString *plistFilePath in plistFilePaths) {
			NSString *plistFileName = plistFilePath.lastPathComponent;
			//NSString *plistFileBaseName = plistFileName.stringByDeletingPathExtension;
			NSString *plistFilePathExtension = plistFileName.pathExtension;
			
			NSData *plistData = [NSData dataWithContentsOfFile:plistFilePath
													   options:0
														 error:&error];
			
			if (plistData == nil) {
				printf("%s\n", [[error description] UTF8String]);
				continue;
			}
			
			id <JXPlistRecursiveEnumeration, NSObject> rootObject = nil;
			
			if ([plistFilePathExtension isEqualToString:@"json"]) {
				NSJSONReadingOptions options =
				kNilOptions;
				
				rootObject =
				[NSJSONSerialization JSONObjectWithData:plistData
												options:options
												  error:&error];
			}
			else {
				NSPropertyListReadOptions options =
				NSPropertyListImmutable;
				
				rootObject =
				[NSPropertyListSerialization propertyListWithData:plistData
														  options:options
														   format:NULL
															error:&error];
			}
			
			BOOL rootIsDictionary = NO;
			BOOL rootIsArray = NO;
			
			if (rootObject &&
				((rootIsDictionary = [rootObject isKindOfClass:[NSDictionary class]]) ||
				 (rootIsArray = [rootObject isKindOfClass:[NSArray class]]))
				) {
				
				dumpPlistRootedIn(rootObject, dumpOptions);
				printf("\n\n");
			}
			else {
				// This must be an invalid file.
				if (!rootObject) {
					printf("%s\n", [[error description] UTF8String]);
				}
				
				printUsage();
				printf("Error: Invalid file supplied.\n");
				return EXIT_FAILURE;
			}
		}
	}
	
	return EXIT_SUCCESS;
}

