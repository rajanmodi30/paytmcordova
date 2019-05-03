#import "PaymentsSDK.h"
#import <Cordova/CDV.h>

@interface NXWIonicPaytm : CDVPlugin

-(void)StartTransaction:(CDVInvokedUrlCommand*)command;

@end
