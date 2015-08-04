//
//  SearchStore.h
//  Suggestions
//
//  Created by Vova Musiienko on 04.08.15.
//  Copyright (c) 2015 muhaos.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchStore : NSObject

+ (instancetype) sharedStore;

- (void) getSuggestionsForQuery:(NSString*)query completionBlock:(void(^)(NSArray* suggestions, NSError* error)) block;

@end
