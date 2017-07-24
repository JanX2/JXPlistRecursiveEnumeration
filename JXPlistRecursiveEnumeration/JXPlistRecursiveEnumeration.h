//
//  JXPlistRecursiveEnumeration.h
//  JXPlistRecursiveEnumeration
//
//  Created by Jan on 24.07.17.
//  Based on the idea by Arpad Goretity as used in Plist2ObjC.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, JXPlistNodeType) {
	JXPlistNodeTypeNSString,
	JXPlistNodeTypeNSNumber,
	JXPlistNodeTypeNSArray,
	JXPlistNodeTypeNSDictionary,
	JXPlistNodeTypeNSData,
	JXPlistNodeTypeNSDate,
	JXPlistNodeTypeNSNull,
};

typedef NS_ENUM(NSUInteger, JXPlistPosition) {
	JXPlistPositionCollectionStart,
	JXPlistPositionCollectionEnd,
	JXPlistPositionNodeBefore,
	JXPlistPositionNodeAfter,
	JXPlistPositionNode,
};

typedef void (^JXPlistVisitor)(id node, JXPlistNodeType nodeType, JXPlistPosition position, NSArray *pathComponents);
// NOTE: You can get the level/depth of the `node` from within the block via `pathComponents.count`.

@protocol JXPlistRecursiveEnumeration
- (void)recursiveEnumerationWithPathComponents:(NSMutableArray *)pathComponents
								  visitorBlock:(JXPlistVisitor)visitorBlock;
@end

@interface NSString (JXPlistRecursiveEnumeration) <JXPlistRecursiveEnumeration>
@end

@interface NSNumber (JXPlistRecursiveEnumeration) <JXPlistRecursiveEnumeration>
@end

@interface NSArray (JXPlistRecursiveEnumeration) <JXPlistRecursiveEnumeration>
@end

@interface NSDictionary (JXPlistRecursiveEnumeration) <JXPlistRecursiveEnumeration>
@end

@interface NSData (JXPlistRecursiveEnumeration) <JXPlistRecursiveEnumeration>
@end

@interface NSDate (JXPlistRecursiveEnumeration) <JXPlistRecursiveEnumeration>
@end

@interface NSNull (JXPlistRecursiveEnumeration) <JXPlistRecursiveEnumeration>
@end

/*
 Copyright 2017 Jan Weiß
 
 Some rights reserved: https://opensource.org/licenses/BSD-3-Clause
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions
 are met:

 1. Redistributions of source code must retain the above copyright
    notice, this list of conditions and the following disclaimer.

 2. Redistributions in binary form must reproduce the above copyright
    notice, this list of conditions and the following disclaimer in
    the documentation and/or other materials provided with the
    distribution.
 
 3. Neither the name of the copyright holder nor the names of any
    contributors may be used to endorse or promote products derived
    from this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

