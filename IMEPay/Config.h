//
//  Config.h
//  IMEPay
//
//  Created by Manoj Karki on 7/12/17.
//  Copyright © 2017 Manoj Karki. All rights reserved.
//

#ifndef Config_h
#define Config_h

#define URL_BASE_TEST @"https://stg.imepay.com.np:7979/api/Web" // Staging
#define URL_BASE_LIVE @"https://payment.imepay.com.np:7979/api/Web" // Live

#define EP_GET_TOKEN @"/GetToken"

#define EP_PAYMENT @"/Payment"
#define EP_CONFIRM @"/Confirm"
#define EP_VALIDATE_USER @"/V2/ValidateUser"
#define EP_VALIDATE_OTP @"/V2/ValidateOTP"

#define NOTIF_SHOULD_QUIT @"NOTIF_SHOULD_QUIT"
#define NOTIF_TRANSACTION_CANCELLED @"NOTIF_TRANSACTION_CANCELLED"

#endif /* Config_h */
