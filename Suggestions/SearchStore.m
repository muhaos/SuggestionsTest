//
//  SearchStore.m
//  Suggestions
//
//  Created by Vova Musiienko on 04.08.15.
//  Copyright (c) 2015 muhaos.com. All rights reserved.
//

#import "SearchStore.h"
#import "SuggestionItem.h"

@interface SearchStore ()

// stores latest valid request signature
@property (nonatomic) id validToken;

@end


@implementation SearchStore


+ (instancetype) sharedStore {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}


- (void) getSuggestionsForQuery:(NSString*)query completionBlock:(void(^)(NSArray* suggestions, NSError* error)) block
{
    
    NSURL *URL = [NSURL URLWithString:@"http://private-anon-8fe87b844-andresbrun.apiary-mock.com/api/v3/search_suggestions"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [request setHTTPMethod:@"GET"];

    // DON'T know why but with paramenters and/or content-type specified I get "Cant parse responce"

    
    //[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    
//    query = @"Ber";
//    NSString* paramsString = [NSString stringWithFormat:@"{\"q\" = \"%@\"}", query];
//    NSData* paramsData = [paramsString dataUsingEncoding:NSUTF8StringEncoding];
//    [request setHTTPBody:paramsData];

    self.validToken = request; //used request object as valid token
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      
                                      if (!data) {
                                          block(nil, [NSError errorWithDomain:@"search" code:1 userInfo:nil]);
                                          return;
                                      } else if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                                          NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
//                                          if (statusCode != 200) {
//                                              block(nil, [NSError errorWithDomain:@"search" code:2 userInfo:nil]);
//                                              return;
//                                          }
                                      }
                                      
                                      NSError *parseError = nil;
                                      NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
                                      if (parseError != nil) {
                                          block(nil, [NSError errorWithDomain:@"search" code:3 userInfo:nil]);
                                          return;
                                      }
                                      
                                      NSArray* suggestionsJsonArr = dictionary[@"search_suggestions"];
                                      
                                      NSArray* suggestions = [self parseSuggestions:suggestionsJsonArr];
                                      
                                      if (self.validToken == request) { // we are latest valid request
                                          block(suggestions, nil);
                                      }
                                  
                                  
                                  }];
    [task resume];
    
}


- (NSArray*) parseSuggestions:(NSArray*)suggestionsJsonArr
{
    NSMutableArray* result = [NSMutableArray new];
    
    for (NSDictionary* suggestionGroup in suggestionsJsonArr) {
        for (NSDictionary* suggestionDic in suggestionGroup[@"suggestions"])
        {
            SuggestionItem* si = [[SuggestionItem alloc] initWithType:suggestionGroup[@"type"] dictionary:suggestionDic];
            [result addObject:si];
        }
    }
    
    return result;
}


@end
