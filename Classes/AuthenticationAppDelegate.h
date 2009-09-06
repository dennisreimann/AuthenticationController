#import <UIKit/UIKit.h>


@class AuthenticationController, AuthenticationViewController;

@interface AuthenticationAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	IBOutlet AuthenticationController *authController;
    IBOutlet AuthenticationViewController *viewController;
}

- (void)authenticate;
- (void)authenticationSucceeded:(BOOL)success;

@end