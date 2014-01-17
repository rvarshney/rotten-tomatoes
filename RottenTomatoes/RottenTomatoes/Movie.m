//
//  Movie.m
//  RottenTomatoes
//
//  Created by Ruchi Varshney on 1/16/14.
//  Copyright (c) 2014 Ruchi Varshney. All rights reserved.
//

#import "Movie.h"

@interface Movie()

@property (nonatomic, strong) NSArray *castList;
@property (nonatomic, strong) NSDictionary *posters;

@end

@implementation Movie

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.title = [dictionary objectForKey:@"title"];
        self.synopsis = [dictionary objectForKey:@"synopsis"];
        self.castList = [dictionary objectForKey:@"abridged_cast"];
        self.posters = [dictionary objectForKey:@"posters"];
    }
    return self;
}

- (NSString *)cast
{
    NSMutableArray *castNameList = [[NSMutableArray alloc] init];
    [self.castList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [castNameList addObject:[obj objectForKey:@"name"]];
    }];
    return [castNameList componentsJoinedByString:@", "];
}

- (NSString *)profileImageUrl
{
    return [self.posters objectForKey:@"profile"];
}

- (NSString *)originalImageUrl
{
    return [self.posters objectForKey:@"original"];
}

@end
