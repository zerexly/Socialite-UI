import UIKit
import Flutter
import GoogleMobileAds
import PushKit
import flutter_callkit_incoming
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate,PKPushRegistryDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GMSServices.provideAPIKey("AIzaSyBOSn0omCgR27SLAZcXxFgWFOFl4k4jnj0")

        GADMobileAds.sharedInstance().start(completionHandler: nil)
        GeneratedPluginRegistrant.register(with: self)

//        ImageGallery.shared.createImagePickerChanel(window: window!)
        //Setup VOIP
        let mainQueue = DispatchQueue.main
        let voipRegistry: PKPushRegistry = PKPushRegistry(queue: mainQueue)
        voipRegistry.delegate = self
        voipRegistry.desiredPushTypes = [PKPushType.voIP]
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    
    // Handle updated push credentials
    func pushRegistry(_ registry: PKPushRegistry, didUpdate credentials: PKPushCredentials, for type: PKPushType) {
        print(credentials.token)
        let deviceToken = credentials.token.map { String(format: "%02x", $0) }.joined()
        print(deviceToken)
        //Save deviceToken to your server
        SwiftFlutterCallkitIncomingPlugin.sharedInstance?.setDevicePushTokenVoIP(deviceToken)
    }
        
    func pushRegistry(_ registry: PKPushRegistry, didInvalidatePushTokenFor type: PKPushType) {
        print("didInvalidatePushTokenFor")
        SwiftFlutterCallkitIncomingPlugin.sharedInstance?.setDevicePushTokenVoIP("")
    }
        
    // Handle incoming pushes
    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType, completion: @escaping () -> Void) {
        print( payload.dictionaryPayload)
        print("from notification");

        guard type == .voIP else {
            print("type != .voIP")
            return
        }
        print("type == .voIP")

        let id = payload.dictionaryPayload["id"]
        let uuid = payload.dictionaryPayload["uuid"]

        let nameCaller = payload.dictionaryPayload["username"]
        let callerImage =  payload.dictionaryPayload["userImage"]
        let callerId =  payload.dictionaryPayload["callerId"]

        let handle =  payload.dictionaryPayload["channelName"]
        let token =  payload.dictionaryPayload["token"]

        let data = flutter_callkit_incoming.Data(id: uuid as! String, nameCaller: nameCaller as! String, handle: handle as! String, type: payload.dictionaryPayload["callType"] as! Int == 1 ? 0 : 1)
        //set more data
        data.extra = ["id": id!, "platform": "ios","callerId":callerId! ,"callerImage":callerImage!, "channelName":handle!,"token":token!]

        SwiftFlutterCallkitIncomingPlugin.sharedInstance?.showCallkitIncoming(data, fromPushKit: true)
    }
}
