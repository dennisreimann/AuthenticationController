#import <UIKit/UIKit.h>


#define kUsernameDefaultsKey @"username"
#define kPasswordDefaultsKey @"password"

@interface AuthenticationController : UIViewController <UITextFieldDelegate, UIActionSheetDelegate> {
  @private
	id target;
	SEL selector;
	UIViewController *viewController;
	UIActionSheet *authSheet;
	NSString *username;
	NSString *password;
	IBOutlet UITextField *usernameField;
	IBOutlet UITextField *passwordField;
	IBOutlet UIButton *submitButton;
	IBOutlet UIButton *cancelButton;
}

@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *password;

- (id)initWithTarget:(id)theTarget andSelector:(SEL)theSelector andViewController:(UIViewController *)viewController;
- (void)authenticate;
- (IBAction)submit:(id)sender;
- (IBAction)cancel:(id)sender;

@end