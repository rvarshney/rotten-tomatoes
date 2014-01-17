//
//  Movie.h
//  RottenTomatoes
//
//  Created by Ruchi Varshney on 1/16/14.
//  Copyright (c) 2014 Ruchi Varshney. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Movie : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *synopsis;
@property (nonatomic, strong) NSString *cast;
@property (nonatomic, strong) NSString *profileImageUrl;
@property (nonatomic, strong) NSString *originalImageUrl;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
