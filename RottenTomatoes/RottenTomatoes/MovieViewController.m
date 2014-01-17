//
//  MovieViewController.m
//  RottenTomatoes
//
//  Created by Ruchi Varshney on 1/19/14.
//  Copyright (c) 2014 Ruchi Varshney. All rights reserved.
//

#import "UIImageView+AFNetworking.h"

#import "MovieViewController.h"

@interface MovieViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *movieImageView;
@property (weak, nonatomic) IBOutlet UILabel *movieSynopsisLabel;
@property (weak, nonatomic) IBOutlet UILabel *movieCastLabel;
@end

@implementation MovieViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
   [self update];
}

- (void)update
{
    self.title = self.movie.title;
    [self.movieImageView setImageWithURL:[NSURL URLWithString:self.movie.originalImageUrl]];
    self.movieSynopsisLabel.text = self.movie.synopsis;
    [self.movieSynopsisLabel sizeToFit];
    self.movieCastLabel.text = self.movie.cast;
    [self.movieCastLabel sizeToFit];
}

@end
