import 'package:flutter/material.dart';

/*
Title:Languages
Purpose:Languages
Created By:Kalpesh Khandla
*/

abstract class Languages {
  static Languages? of(BuildContext context) {
    return Localizations.of<Languages>(context, Languages);
  }

  String get appName;

  //signin
  String get labelSignin;
  String get labelContinueGoogle;
  String get labelContinueFacebook;
  String get labelContinueApple;
  String get labelOr;
  //signup
  String get labelSignup;
  String get labelPhone;
  String get labelPassword;
  String get labelForgotPassword;
  String get labelPlaceholderPhoneNumber;
  String get labelPlaceholderPassword;
  String get labelPasswordConfirm;
  String get labelPlaceholderPasswordConfirm;
  String get labelPhonePasswordError;
  String get labelFullName;
  String get labelPlaceholderFullName;
  String get labelEmail;
  String get labelPlaceholderEmail;
  String get labelCheckAllFields;
  String get labelNumberAlreadyExist;
  String get textAlreadyRegistered;
  String get textToLogin;
  //OTP
  String get labelOtp;
  String get labelContinue;
  String get labelContinueOnHomepage;
  String get labelWrongCode;
  String get textConfirmCode;
  String get textNotReceived;
  String get textRegisteredSuccess;
  String get textPhoneRegisteredSuccess;

  String textSendVerificationCode(String phone);
  String textResponseSeconds(int second);

  // static descriptions
  String get textSignup;
  String get textNoAccount;

  String get labelWallet;
  String get labelMyAddress;
  String get labelOffersPromotion;
  String get labelLanguage;
  String get labelOrderHistory;
  String get labelNotification;
  String get labelShareInformation;
  String get labelPolicy;
  String get labelSpecialOffer;
  String get labelNearbyRestaurants;
  String get labelFind;
  String get labelFindNearMe;
  String get labelGuaranteedDiscount;
  String get labelDiscover;
  String get labelWhatLookingFor;
  String get labelFinalize;
  String get labelHome;
  String get labelFaourite;
  String get labelOrder;
  String get labelReward;

  String get labelMessage;
  String get labelNoMessage;
  String get labelEnterMessage;
  String get labelCart;
  String get labelApply;
  String get labelCouponCode;
  String get labelPayment;
  String get labelCheckout;
  String get labelCheckoutDetail;
  String get labelTotalPayment;
  String get labelExtraDistance;
  String get labelDiscountCoupon;
  String get labelShippingCost;
  String get labelServiceCharge;
  String get labelGooglePay;
  String get labelApplePay;
  String get labelAddCreditDebitCard;
  String get labelAddCardDescription;
  String get labelScan;
  String get labelNameOnCard;
  String get labelChange;
  String get labelExpireDate;
  String get labelCVV;
  String get labelAdd;
  String get labelFilter;
  String get labelArrange;
  String get labelPromotion;
  String get labelPriceScale;
  String get labelSuggestion;
  String get labelDistance;
  String get labelKM;
  String get labelHighToLow;
  String get labelLowToHigh;
  String get labelNearest;
  String get labelCategories;
  String get labelQuantity;
  String get labelSize;
  String get labelNotes;
  String get labelToping;
  String get labelAddToCart;
  String get labelNoteHint;
  String get labelOrderDetail;
  String get labelStatus;
  String get labelPreparing;
  String get labelCanceled;
  String get labelDelivered;
  String get labelFollowOrder;
  String get labelShippingFee;
  String get labelVoucher;
  String get labelYummy;
  String get labelPaymentMethod;
  String get labelOrderCode;
  String get labelReceiver;
  String get labelAddress;
  String get labelPhoneNumber;
  String get labelDownloadRecipt;
  String get labelCancelOrder;
  String get labelEstimatedDeliveryTime;
  String get labelOther;

  String get labelExchangeRewards;
  String get labelYourPoints;
  String get labelPoints;
  String get labelExchangeCategories;
  String get labelForNow;

  String get textScanQR;
  String get textShowQR;
  String get textQRUpdate;
  String get textPointSuccess;
  String get textPointSuccessDescription;

  String get textNotifyOrder;
  String get textOrderCancelReason;
  String get textReasonLateDelivery;
  String get textReasonContact;
  String get textReasonDriverDenied;
  String get textReasonWrongAddress;
  String get textReasonPrice;
  String get textReasonWantOther;
  String get textReasonWantCancel;
  String get textMessageToRestaurant;

  String get labelDeliciousAroundHere;


  //settings
  String get labelMyAccount;
  String get labelLogOut;
  String get labelPersonalInformation;
  String get labelPersonalEditing;
  String get labelChangePassword;
  String get labelHelp;
  String get labelName;
  String get labelDateOfBirth;
  String get labelGender;
  String get labelGenderMale;
  String get labelGenderFemale;
  String get labelSave;
  String get labelEnterPassword;
  String get labelOldPassword;
  String get labelNewPassword;
  String get labelReenterPassword;
  String get labelLogIn;
  String get labelConfirm;
  String get labelEnterOtp;
  String get labelReturn;
  String get labelChangedSuccess;
  String get labelSetupSuccess;

  String get labelMyWallet;
  String get labelForYouOwnSafety;
  String get labelSafetyDescription;
  String get labelSetupYummyWallet;
  String get labelAddPhoneNumber;
  String get labelAssociateBank;
  String get labelAddAddress;
  String get labelNotificationSetting;
  String get labelReceiveAllNotifications;
  String get labelPrompts;
  String get labelCalls;
  String get labelOrders;
  String get labelSecurityPolicy;
  String get labelTerms;
  String get labelChangeWithServiceTerms;
  String get labelTC;

  String get textPasswordChanged;
  String get textEnterConfirmCode;
  String get textPasswordResetLink;
  String get textVerificationCodeSent;
}