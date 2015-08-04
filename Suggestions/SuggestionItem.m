//
//  SuggestionItem.m
//  Suggestions
//
//  Created by Vova Musiienko on 04.08.15.
//  Copyright (c) 2015 muhaos.com. All rights reserved.
//

#import "SuggestionItem.h"

@implementation SuggestionItem


- (instancetype) initWithType:(NSString*)type dictionary:(id)dic
{
    self = [super init];
    if(self) {
        _type = type;
        _localizedCountryName = [self safeStringFrom:dic[@"localized_country_name"] defaultValue:@"None"];
        _localizedName = [self safeStringFrom:dic[@"localized_name"] defaultValue:@"None"];
        _offerCount = [self safeNumberFrom:dic[@"offer_count"] defaultValue:0];
        _searchKeys = dic[@"search_keys"];
    }
    return self;
}


- (NSString*) safeStringFrom:(NSString*) inStr defaultValue:(NSString*) defStr {
    if (inStr == nil || [inStr isKindOfClass:[NSNull class]] || [inStr isEqualToString:@""]) {
        return defStr;
    }
    return inStr;
}


- (NSNumber*) safeNumberFrom:(NSNumber*) inNum defaultValue:(NSNumber*) defNum {
    if (inNum == nil || [inNum isKindOfClass:[NSNull class]]) {
        return defNum;
    }
    return inNum;
}


@end
