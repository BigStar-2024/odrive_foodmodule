import UIKit
import Flutter
import GoogleMaps
import Firebase
import FirebaseMessaging

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    // Ajoutez votre clé d'API Google Maps ici
    GMSServices.provideAPIKey("AIzaSyDggn6Hwt1gbuAlfnvJ12OGr8Ygd2ufddQ")
    // Configure Firebase
    //FirebaseApp.configure()
    
    // Configure Firebase Cloud Messaging
    //Messaging.messaging().delegate = self
    
    // Register for remote notifications
    //application.registerForRemoteNotifications()
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
