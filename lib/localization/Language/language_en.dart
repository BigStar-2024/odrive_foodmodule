import 'dart:ffi';

import 'languages.dart';

class LanguageEn extends Languages {

  @override String get appName => "TYM'S";

  //signin
  @override String get labelSignin => "Sign in";
  @override String get labelContinueGoogle => "Continue with Google";
  @override String get labelContinueFacebook => "Continue with Facebook";
  @override String get labelContinueApple => "Continue with Apple";
  @override String get labelOr => "or";
  //signup
  @override String get labelSignup => "Sign up";
  @override String get labelPhone => "Phone Number";
  @override String get labelPassword => "Password";
  @override String get labelForgotPassword => "Forgot Passoword?";
  @override String get labelPlaceholderPhoneNumber => "Enter your phone number";
  @override String get labelPlaceholderPassword => "Enter your password";
  @override String get labelPasswordConfirm => "Password Confirm";
  @override String get labelPlaceholderPasswordConfirm => "Confirm your password";
  @override String get labelPhonePasswordError => "Incorrect phone number or password";
  @override String get labelFullName => "Full name";
  @override String get labelPlaceholderFullName => "Enter full name";
  @override String get labelEmail => "Email";
  @override String get labelPlaceholderEmail => "Enter email";
  @override String get labelCheckAllFields => "Check all fields";
  @override String get labelNumberAlreadyExist => "This number already exist.";
  @override String get textAlreadyRegistered => "Already registered?";
  @override String get textToLogin => "To Log in";
  //OTP
  @override String get labelOtp => "Enter OTP";
  @override String get labelContinue => "Continue";
  @override String get labelContinueOnHomepage => "Continue on homepage";
  @override String get labelWrongCode => "wrong code";
  @override String get textConfirmCode => "Enter the confirmation code";
  @override String get textNotReceived => "Haven't received the code yet?";
  @override String get textRegisteredSuccess => "Registered Successfully";
  @override String get textPhoneRegisteredSuccess => "Your phone number has been successfully registered";

  @override String textSendVerificationCode(String phone){
    return "Verification code has been sent to the phone number\nYour $phone";
  }
  @override String textResponseSeconds(int second){
    return "Resend ($second seconds)";
  }

  // static descriptions
  @override String get textSignup => "By clicking Create account, you agree to the system's Terms and policies";
  @override String get textNoAccount => "Don't you have an account";

  //home
  @override String get labelWallet => "Wallet";
  @override String get labelMyAddress => "My Address";
  @override String get labelOffersPromotion => "Offers/Promotion";
  @override String get labelLanguage => "Language";
  @override String get labelOrderHistory => "Order History";
  @override String get labelNotification => "Notification";
  @override String get labelShareInformation => "Share Information";
  @override String get labelPolicy => "Terms and policies";
  @override String get labelSpecialOffer => "Special Offer";
  @override String get labelNearbyRestaurants => "Nearby Restaurants";
  @override String get labelFind => "Find";
  @override String get labelFindNearMe => "Find a restaurant near me";
  @override String get labelGuaranteedDiscount => "Guaranteed discount!";
  @override String get labelDiscover => "Discover";
  @override String get labelWhatLookingFor => "What are you yearning for?";
  @override String get labelFinalize => "Finalize";
  @override String get labelHome => "Home";
  @override String get labelFaourite => "Favourite";
  @override String get labelOrder => "Order";
  @override String get labelReward => "Reward";

  @override String get labelMessage => "Message";
  @override String get labelNoMessage => "No Message";
  @override String get labelEnterMessage => "Enter Message";
  @override String get labelCart => "Cart";
  @override String get labelApply => "Apply";
  @override String get labelCouponCode => "Coupon Code";
  @override String get labelPayment => "Payment";
  @override String get labelCheckout => "Checkout";
  @override String get labelCheckoutDetail => "Checkout detail";
  @override String get labelTotalPayment => "Total Payment";
  @override String get labelExtraDistance => "Extra Distance";
  @override String get labelDiscountCoupon => "Discount coupon";
  @override String get labelShippingCost => "Shipping cost";
  @override String get labelServiceCharge => "Service charge";
  @override String get labelGooglePay => "GooglePay";
  @override String get labelApplePay => "ApplePay";
  @override String get labelAddCreditDebitCard => "Add credit or debit card";
  @override String get labelAddCardDescription => "Your payment details are stored securely.\nBy adding a card, you won’t be charged yet.";
  @override String get labelScan => "SCAN";
  @override String get labelNameOnCard => "Name on card";
  @override String get labelChange => "Change";
  @override String get labelExpireDate => "Expire date";
  @override String get labelCVV => "CVV";
  @override String get labelAdd => "Add";
  @override String get labelFilter => "Filter";
  @override String get labelArrange => "Arrange";
  @override String get labelPromotion => "Promotion";
  @override String get labelPriceScale => "Price Scale";
  @override String get labelSuggestion => "Suggestion";
  @override String get labelDistance => "Distance";
  @override String get labelKM => "KM";
  @override String get labelHighToLow => "Price: High to Low";
  @override String get labelLowToHigh => "Price: Low to High";
  @override String get labelNearest => "Nearest";
  @override String get labelCategories => "Categories";
  @override String get labelQuantity => "Quantity";
  @override String get labelSize => "Size";
  @override String get labelNotes => "Notes";
  @override String get labelToping => "Toping";
  @override String get labelAddToCart => "Add to Cart";
  @override String get labelNoteHint => "Do you have something to say to the restaurant?\nAre not ?";
  @override String get labelOrderDetail => "Order Detail";
  @override String get labelStatus => "Status";
  @override String get labelPreparing => "Preparing";
  @override String get labelCanceled => "Canceled";
  @override String get labelDelivered => "Delivered";
  @override String get labelFollowOrder => "Follow the order";
  @override String get labelShippingFee => "Shipping fee";
  @override String get labelVoucher => "Voucher";
  @override String get labelYummy => "Yummy";
  @override String get labelPaymentMethod => "Payment Method";
  @override String get labelOrderCode => "Order code";
  @override String get labelReceiver => "Receiver";
  @override String get labelAddress => "Address";
  @override String get labelPhoneNumber => "Phone number";
  @override String get labelDownloadRecipt => "Download the Recipt";
  @override String get labelCancelOrder => "Cancel order";
  @override String get labelEstimatedDeliveryTime => "Estimated delivery time";
  @override String get labelOther => "Other";

  @override String get labelExchangeRewards => "Exchange Rewards";
  @override String get labelYourPoints => "Your points";
  @override String get labelPoints => "Points";
  @override String get labelExchangeCategories => "Exchange Categories";
  @override String get labelForNow => "For Now";

  @override String get textScanQR => "Scan QR code to earn more points";
  @override String get textShowQR => "Please scan the QR code to accumulate points";
  @override String get textQRUpdate => "QR code will be updated every 60s";
  @override String get textPointSuccess => "Point accumulated successfully";
  @override String get textPointSuccessDescription => "Congratulations! You had successfully accumulated points. You received 20 Yummy";

  @override String get textNotifyOrder => "Your order is being notified to the restaurant";
  @override String get textOrderCancelReason => "Please select reasons";
  @override String get textReasonLateDelivery => "Late Delivery";
  @override String get textReasonContact => "Can not contact to the driver";
  @override String get textReasonDriverDenied => "Driver denied to come to pick up";
  @override String get textReasonWrongAddress => "Displayed wrong address";
  @override String get textReasonPrice => "Unfavorable price";
  @override String get textReasonWantOther => "I want to order other restaurant";
  @override String get textReasonWantCancel => "I just want to cancel the order";
  @override String get textMessageToRestaurant => "Do yu have any messages to the restaurant?";

  @override String get labelDeliciousAroundHere => "What's delicious around here";


  //settings
  @override String get labelMyAccount => "My Account";
  @override String get labelLogOut => "Log out";
  @override String get labelPersonalInformation => "Personal Information";
  @override String get labelPersonalEditing => "Personal Editing";
  @override String get labelChangePassword => "Change Password";
  @override String get labelHelp => "Help";
  @override String get labelName => "Name";
  @override String get labelDateOfBirth => "Date of birth";
  @override String get labelGender => "Gender";
  @override String get labelGenderMale => "Male";
  @override String get labelGenderFemale => "Female";
  @override String get labelSave => "Save";
  @override String get labelEnterPassword => "Enter Password";
  @override String get labelOldPassword => "Old Password";
  @override String get labelNewPassword => "New Password";
  @override String get labelReenterPassword => "Reenter Password";
  @override String get labelLogIn => "Log in";
  @override String get labelConfirm => "Confirm";
  @override String get labelEnterOtp => "Enter OTP";
  @override String get labelReturn => "Return";
  @override String get labelChangedSuccess => "Changed successfully";
  @override String get labelSetupSuccess => "Set up successfully";

  @override String get labelMyWallet => "My Wallet";
  @override String get labelForYouOwnSafety => "For your own safety";
  @override String get labelSafetyDescription => "For your information safety when setting up Yummy wallet of Yummyfood app, please read and agree to Terms and Policies.";
  @override String get labelSetupYummyWallet => "Setup Yummy Wallet";
  @override String get labelAddPhoneNumber => "Add phone number";
  @override String get labelAssociateBank => "Associate Bank";
  @override String get labelAddAddress => "Add Address";
  @override String get labelNotificationSetting => "Notification setting";
  @override String get labelReceiveAllNotifications => "Receive all notifications";
  @override String get labelPrompts => "Prompts";
  @override String get labelCalls => "Calls";
  @override String get labelOrders => "Orders";
  @override String get labelSecurityPolicy => "Security Policy";
  @override String get labelTerms => "Terms";
  @override String get labelChangeWithServiceTerms => "Change with Service and Terms";
  @override String get labelTC => "T & C";

  @override String get textPasswordChanged => "Your password has successfully changed";
  @override String get textEnterConfirmCode => "Enter the confirmation code";
  @override String get textPasswordResetLink => "Password reset link has been sent to your email";
  @override String get textVerificationCodeSent => "Verification code has been sent to your phone number";
}