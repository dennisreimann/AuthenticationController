#import "AuthenticationViewController.h"


@implementation AuthenticationViewController

@synthesize statusLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)dealloc {
	[statusLabel release];
    [super dealloc];
}

@end