
#import <Cordova/CDVPlugin.h>

#import <MessageUI/MFMailComposeViewController.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>
#import <FacebookSDK/FBDialogs.h>


@interface SocialShare : CDVPlugin

@property(nonatomic,retain) NSString* callbackId;

- (void) showEmailComposer:(CDVInvokedUrlCommand*)command;
- (void) mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error;

- (void) showSMSComposer:(CDVInvokedUrlCommand*)command;
- (void) messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result;

- (void) showTwitter:(CDVInvokedUrlCommand*)command;
- (void) showFacebook:(CDVInvokedUrlCommand*)command;

@end
