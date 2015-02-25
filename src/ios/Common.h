//
//
//  Created by SangChan on 2015. 2. 24..
//
//

#import <Cordova/CDV.h>

@interface Common : CDVPlugin

- (void)getDeviceInfo:(CDVInvokedUrlCommand*)command;
- (void)setLoginToken:(CDVInvokedUrlCommand*)command;
- (void)getLoginToken:(CDVInvokedUrlCommand*)command;
- (void)getRegistrationID:(CDVInvokedUrlCommand*)command;

@end
