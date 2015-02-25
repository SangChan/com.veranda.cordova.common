//
//
//  Created by SangChan on 2015. 2. 24..
//
//
#include <sys/types.h>
#include <sys/sysctl.h>

#import "Common.h"

#define KEY_REGISTRATION_ID @"registration_id"
#define KEY_LOGIN_TOKEN @"login_token"


@implementation UIDevice (ModelVersion)

- (NSString*)modelVersion
{
    size_t size;
    
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char* machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString* platform = [NSString stringWithUTF8String:machine];
    free(machine);
    
    return platform;
}

@end


@implementation Common
- (NSDictionary*)deviceProperties
{
    UIDevice* device = [UIDevice currentDevice];
    return [NSDictionary dictionaryWithObjectsAndKeys:@"Apple",@"manufacturer",[device modelVersion],@"model",@"iOS",@"platform",[device systemVersion],@"version",[self getValueUsingKey:KEY_REGISTRATION_ID],@"registration_id", nil];
}

- (void)getDeviceInfo:(CDVInvokedUrlCommand*)command
{
    [self.commandDelegate runInBackground:^{
        NSDictionary* deviceProperties = [self deviceProperties];
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:deviceProperties];
    
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}

- (void)setLoginToken:(CDVInvokedUrlCommand*)command
{
    [self.commandDelegate runInBackground:^{
        NSString *value = [command.arguments objectAtIndex:0];
        [self setValue:value usingKey:KEY_LOGIN_TOKEN];
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:[command callbackId]];
    }];
}

- (void)getLoginToken:(CDVInvokedUrlCommand*)command
{
    [self.commandDelegate runInBackground:^{
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[self getValueUsingKey:KEY_LOGIN_TOKEN]];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:[command callbackId]];
    }];
}

- (void)getRegistrationID:(CDVInvokedUrlCommand*)command
{
    [self.commandDelegate runInBackground:^{
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[self getValueUsingKey:KEY_REGISTRATION_ID]];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:[command callbackId]];
    }];
}

/*
 Parsing the Root.plist for the key, because there is a bug/feature in Settings.bundle
 So if the user haven't entered the Settings for the app, the default values aren't accessible through NSUserDefaults.
 */


- (NSString*)getSettingFromBundle:(NSString*)settingsName
{
    NSString *pathStr = [[NSBundle mainBundle] bundlePath];
    NSString *settingsBundlePath = [pathStr stringByAppendingPathComponent:@"Settings.bundle"];
    NSString *finalPath = [settingsBundlePath stringByAppendingPathComponent:@"Root.plist"];
    
    NSDictionary *settingsDict = [NSDictionary dictionaryWithContentsOfFile:finalPath];
    NSArray *prefSpecifierArray = [settingsDict objectForKey:@"PreferenceSpecifiers"];
    NSDictionary *prefItem;
    for (prefItem in prefSpecifierArray)
    {
        if ([[prefItem objectForKey:@"Key"] isEqualToString:settingsName])
            return [prefItem objectForKey:@"DefaultValue"];
    }
    return nil;
    
}

- (NSString *)getValueUsingKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:key];
}

- (void)setValue:(NSString *)value usingKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:key];
}



@end
