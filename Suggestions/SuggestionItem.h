//
//  SuggestionItem.h
//  Suggestions
//
//  Created by Vova Musiienko on 04.08.15.
//  Copyright (c) 2015 muhaos.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SuggestionItem : NSObject

@property (strong, readonly) NSString* type;
@property (strong, readonly) NSString* localizedCountryName;
@property (strong, readonly) NSString* localizedName;
@property (strong, readonly) NSNumber* offerCount;
@property (strong, readonly) NSArray* searchKeys;

- (instancetype) initWithType:(NSString*)type dictionary:(id)dic;


@end
