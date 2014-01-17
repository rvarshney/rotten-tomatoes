//
//  MoviesViewController.m
//  RottenTomatoes
//
//  Created by Ruchi Varshney on 1/16/14.
//  Copyright (c) 2014 Ruchi Varshney. All rights reserved.
//

#import "UIImageView+AFNetworking.h"
#import "SVProgressHUD.h"

#import "MoviesViewController.h"
#import "MovieViewController.h"
#import "MovieCell.h"
#import "Movie.h"

@interface MoviesViewController ()

@property (nonatomic, strong) NSMutableArray *movies;
@property (nonatomic, strong) UIView *errorView;
@property (nonatomic, strong) UILabel *errorLabel;

- (void)reload;

@end

@implementation MoviesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setupErrorView
{
    self.errorView = [[UIView alloc] init];
    self.errorView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, 30);
    self.errorView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];

    self.errorLabel = [[UILabel alloc] initWithFrame:self.errorView.frame];
    [self.errorLabel setTextColor:[UIColor whiteColor]];
    [self.errorLabel setFont:[UIFont boldSystemFontOfSize:12]];
    [self.errorLabel setTextAlignment:NSTextAlignmentCenter];
    [self.errorView addSubview:self.errorLabel];

    [self.view addSubview:self.errorView];
}

- (void)setupRefreshControl
{
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self setRefreshControl:refreshControl];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupErrorView];
    [self setupRefreshControl];
    [self reload];
}

- (void)refresh:(id)sender
{
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing Movies..."];
    [self reload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.movies.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MovieCell *cell = (MovieCell *)[tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    
    Movie *movie = self.movies[indexPath.row];
    cell.movieTitleLabel.text = movie.title;
    cell.movieSynopsisLabel.text = movie.synopsis;
    cell.movieCastLabel.text = movie.cast;
    [cell.movieThumbnail setImageWithURL:[NSURL URLWithString:movie.profileImageUrl]];
    
    return cell;
}

#pragma mark - Segue

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UITableViewCell *selectedCell = (UITableViewCell *)sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:selectedCell];
    Movie *movie = self.movies[indexPath.row];

    MovieViewController *movieViewController = (MovieViewController *)segue.destinationViewController;
    movieViewController.movie = movie;
}

#pragma mark - Private method definitions

- (void)setup
{
    self.movies = [[NSMutableArray alloc] init];
    self.title = @"Movies";
}

- (void)showError:(NSString *)message
{
    self.errorLabel.text = message;
    [self.errorView setHidden:NO];
}

- (void)hideError
{
    [self.errorView setHidden:YES];
}

- (void)reload
{
    [self hideError];

    // Set loading indicators
    [SVProgressHUD showWithStatus:@"Loading Movies..."];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    // Start network request
    NSString *url = @"http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apikey=g9au4hv6khv6wzvzgt55gpqs";
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLCacheStorageAllowed timeoutInterval:20];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        // Handle network error
        if (connectionError) {
            [self showError:@"Network Error"];
        } else if (data == nil) {
            [self showError:@"No Data Available"];
        } else {
            // Extract data
            NSDictionary *object = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSArray *movies = [object objectForKey:@"movies"];
            [self.movies removeAllObjects];
            for (NSDictionary *movie in movies) {
                [self.movies addObject: [[Movie alloc] initWithDictionary:movie]];
            }
            [self.tableView reloadData];
        }

        // Update indicators
        [self.refreshControl endRefreshing];
        [SVProgressHUD dismiss];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
}

@end
