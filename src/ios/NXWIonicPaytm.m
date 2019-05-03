#import "NXWIonicPaytm.h"
#import <SystemConfiguration/CaptiveNetwork.h>

@implementation NXWIonicPaytm{
  NSString* callbackId;
  PGTransactionViewController *txnController;
}

-(void)StartTransaction:(CDVInvokedUrlCommand*)command {
  CDVPluginResult* pluginResult = nil;
  callbackId = command.callbackId;

     NSString* arguments_data = [command.arguments objectAtIndex:0];//getting the data of js from array
     NSArray *m_id = [arguments_data valueForKey:@"m_id"];//passing mid to array
     NSArray *oid = [arguments_data valueForKey:@"oid"];//passing order id to array
     NSArray *Customer_id = [arguments_data valueForKey:@"Customer_id"];//passing customer id to array
     NSArray *mobile_no = [arguments_data valueForKey:@"mobile_no"];//passing mobile no to array
     NSArray *email = [arguments_data valueForKey:@"email"];//passing email to array
     NSArray *channel_id = [arguments_data valueForKey:@"channel_id"];//passing channel id to array
     NSArray *web_staging = [arguments_data valueForKey:@"web_staging"];//passing web staging value to array
     NSArray *tnx_amount = [arguments_data valueForKey:@"tnx_amount"];//passing transaction amount to array
     NSArray *industry_type_id = [arguments_data valueForKey:@"industry_type_id"];//passing mid to array
     NSArray *callback_url = [arguments_data valueForKey:@"callback_url"];//passing callback url to array
     NSArray *checksumhash = [arguments_data valueForKey:@"checksumhash"];//passing checksumhash to array
     NSNumber *StagingOrProduction=[arguments_data valueForKey:@"staging_value"];//getting the staging value




    PGOrder *order = [PGOrder orderForOrderID:@""
    		customerID:@""
    		amount:@""
    		customerMail:@""
    		customerMobile:@""];
          order.params =
          @{@"MID" : m_id,
    		@"ORDER_ID": oid,
    		@"CUST_ID" : Customer_id,
    		@"MOBILE_NO" : mobile_no,
    		@"EMAIL" : email,
    		@"CHANNEL_ID": channel_id,
    		@"WEBSITE": web_staging,
    		@"TXN_AMOUNT": tnx_amount,
    		@"INDUSTRY_TYPE_ID": industry_type_id,
    		@"CHECKSUMHASH":checksumhash,
    		@"CALLBACK_URL":callback_url
      };//creating the paytm function and passing data to it

        NSLog(@"data =%@", order.params);//logging the params of it

      txnController = [[PGTransactionViewController alloc] initTransactionForOrder:order];//generating the order and intializing the order
    	txnController.loggingEnabled = YES;//no idead what this is obective c is  shit
      if ([StagingOrProduction intValue]==1){//if the staging or prooduction is 1 then passing staging parameters
        txnController.serverType = eServerTypeStaging;
      }else{//else passing the production value
        txnController.serverType = eServerTypeProduction;
      }

    	txnController.merchant = [PGMerchantConfiguration defaultConfiguration];
    	txnController.delegate = self;
    	// [self.navigationController pushViewController:txnController animated:YES];

        UIViewController *rootVC = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
        [rootVC presentViewController:txnController animated:YES completion:nil];
        //starting the paytm transaction
}

- (void)didFinishedResponse:(PGTransactionViewController *)controller
                     response:(NSDictionary *)response{
                       //ehwn the view is finished loading with either transaction done or error
                       NSLog(@" Transaction process done ");
                       NSLog(@"%@",response);
                      //  [[[UIAlertView alloc] initWithTitle:@"Transaction Cancel" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];

                      //  [txnController dismissViewControllerAnimated:YES completion:nil];
    //

      NSLog(@"%@",response);//dumping reponse
      CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:response];
      //sending reponse in strigified format
      [self.commandDelegate sendPluginResult:result callbackId:callbackId];
      [txnController dismissViewControllerAnimated:YES completion:nil];
      //going back to the main app

}

//Called when a transaction is failed with any reason. response dictionary will be having details about failed Transaction.
- (void)didCancelTrasaction:(PGTransactionViewController *)controller
                     error:(NSError *)error
                  response:(NSDictionary *)response{

                    // [txnController dismissViewControllerAnimated:YES completion:nil];
      NSLog(@"Response %@",response);
      NSLog(@"Error %@",error);


       CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:response];
      [self.commandDelegate sendPluginResult:result callbackId:callbackId];
      [txnController dismissViewControllerAnimated:YES completion:nil];
      //going back to the main app


}


//Called when a transaction is Canceled by User. response dictionary will be having details about Canceled Transaction.
- (void)errorMisssingParameter:(PGTransactionViewController *)controller
                       error:(NSError *)error
                    response:(NSDictionary *)response{

     NSLog(@"Response %@",response);
     NSLog(@"Error %@",error);


    CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:response];
    [self.commandDelegate sendPluginResult:result callbackId:callbackId];
    [txnController dismissViewControllerAnimated:YES completion:nil];
    //going back to the main app

}



@end
