import Foundation

struct theLinphone {
    static var lc: COpaquePointer?
    static var lct: LinphoneCoreVTable?
    static var manager: LinphoneManager?
}

var sipRegistrationStatus: SipRegistrationStatus = SipRegistrationStatus.UNKNOWN

var registrationStateChanged: LinphoneCoreRegistrationStateChangedCb = {
    (lc: COpaquePointer, proxyConfig: COpaquePointer, state: LinphoneRegistrationState, message: UnsafePointer<Int8>) in
    
    switch state{
    case LinphoneRegistrationNone: /**<Initial state for registrations */
        NSLog("LinphoneRegistrationNone")
        sipRegistrationStatus = .UNKNOWN
        
    case LinphoneRegistrationProgress:
        NSLog("LinphoneRegistrationProgress")
        sipRegistrationStatus = .UNKNOWN
                
    case LinphoneRegistrationOk:
        NSLog("LinphoneRegistrationOk")
        sipRegistrationStatus = .OK
        
    case LinphoneRegistrationCleared:
        NSLog("LinphoneRegistrationCleared")
        sipRegistrationStatus = .UNKNOWN
        
    case LinphoneRegistrationFailed:
        NSLog("LinphoneRegistrationFailed")
        sipRegistrationStatus = .FAIL
        
    default:
        NSLog("Unkown registration state")
    }
}

var callStateChanged: LinphoneCoreCallStateChangedCb = {
    (lc: COpaquePointer, call: COpaquePointer, callSate: LinphoneCallState,  message) in
    
    switch callSate{
    case LinphoneCallIncomingReceived: /**<This is a new incoming call */
        NSLog("callStateChanged: LinphoneCallIncomingReceived")
        
        
//        let currentCall = linphone_core_get_current_call(theLinphone.lc!)
//        if currentCall != nil{
//            linphone_core_decline_call(theLinphone.lc!, call, LinphoneReasonDeclined)
//            return
//        }
        
        if var controller = UIApplication.sharedApplication().keyWindow?.rootViewController{
            while let presentedViewController = controller.presentedViewController {
                controller = presentedViewController
            }
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("receiveCall")
            controller.presentViewController(vc, animated: true, completion: nil)
        }
        
    case LinphoneCallStreamsRunning: /**<The media streams are established and running*/
        NSLog("callStateChanged: LinphoneCallStreamsRunning")
        
    case LinphoneCallError: /**<The call encountered an error*/
        NSLog("callStateChanged: LinphoneCallError")
        
    default:
        NSLog("Default call state: \(callSate)")
    }
}




class LinphoneManager {
    
    static var iterateTimer: NSTimer?
    static var isInit: Bool = false
    
    func startLinphone() {
        if LinphoneManager.isInit {
            NSLog("Linphone already init")
        }else{
            NSLog("Linphone init")
            initLinphone()
            let proxyConfig = setIdentify()
            register(proxyConfig)
            setTimer()
        }
    }
    
    func initLinphone(){
        // Enable debug log to stdout
        linphone_core_set_log_file(nil)
        linphone_core_set_log_level(ORTP_DEBUG)
        
        // Load config
        let configFilename = documentFile("linphonerc")
        let factoryConfigFilename = bundleFile("linphonerc-factory")
        
        let configFilenamePtr: UnsafePointer<Int8> = configFilename.cStringUsingEncoding(NSUTF8StringEncoding)
        let factoryConfigFilenamePtr: UnsafePointer<Int8> = factoryConfigFilename.cStringUsingEncoding(NSUTF8StringEncoding)
        let lpConfig = lp_config_new_with_factory(configFilenamePtr, factoryConfigFilenamePtr)
        
        // Set Callback
        theLinphone.lct = LinphoneCoreVTable()
        theLinphone.lct!.registration_state_changed = registrationStateChanged
        theLinphone.lct!.call_state_changed = callStateChanged
        
        theLinphone.lc = linphone_core_new_with_config(&theLinphone.lct!, lpConfig, nil)
        LinphoneManager.isInit = true
        
        // Set ringtone

        let ringbackPath = NSBundle.mainBundle().pathForResource("ringback", ofType: "wav")
        linphone_core_set_ringback(theLinphone.lc!, ringbackPath!)
        
        let localRingPath = NSBundle.mainBundle().pathForResource("toy-mono", ofType: "wav")
        linphone_core_set_ring(theLinphone.lc!, localRingPath!)
        
    }
    
    @objc func iterate(){
        if let lc = theLinphone.lc{
            linphone_core_iterate(lc); /* first iterate initiates registration */
        }
    }
    
    private func bundleFile(file: NSString) -> NSString{
        return NSBundle.mainBundle().pathForResource(file.stringByDeletingPathExtension, ofType: file.pathExtension)!
    }
    
    private func documentFile(file: NSString) -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        
        let documentsPath: NSString = paths[0] as NSString
        return documentsPath.stringByAppendingPathComponent(file as String)
    }
    
    private func setIdentify() -> COpaquePointer {
        
        // Reference: http://www.linphone.org/docs/liblinphone/group__registration__tutorials.html
        
        let account = UserData.getSipAccount()!
        let password = UserData.getSipPassword()!
        let domain = UserData.getProxyAddress()!
        let port = UserData.getProxyPort()!
        
        let identity = "sip:" + account + "@" + domain + ":" + port;
        
        
        /*create proxy config*/
        let proxy_cfg = linphone_proxy_config_new();
        
        /*parse identity*/
        let from = linphone_address_new(identity);
        
        if (from == nil){
            NSLog("\(identity) not a valid sip uri, must be like sip:toto@sip.linphone.org");
            return nil
        }
        
        let info=linphone_auth_info_new(linphone_address_get_username(from), nil, password, nil, nil, nil); /*create authentication structure from identity*/
        linphone_core_add_auth_info(theLinphone.lc!, info); /*add authentication info to LinphoneCore*/
        
        // configure proxy entries
        linphone_proxy_config_set_identity(proxy_cfg, identity); /*set identity with user name and domain*/
        let server_addr = String.fromCString(linphone_address_get_domain(from)); /*extract domain address from identity*/
        
        linphone_address_destroy(from); /*release resource*/
        
        linphone_proxy_config_set_server_addr(proxy_cfg, server_addr!); /* we assume domain = proxy server address*/
        //        linphone_proxy_config_enable_register(proxy_cfg, 0); /* activate registration for this proxy config*/
        linphone_proxy_config_set_expires(proxy_cfg, 60)
        linphone_core_add_proxy_config(theLinphone.lc!, proxy_cfg); /*add proxy config to linphone core*/
        linphone_core_set_default_proxy_config(theLinphone.lc!, proxy_cfg); /*set to default proxy*/
        
        return proxy_cfg
    }
    
    private func register(proxy_cfg: COpaquePointer){
        linphone_proxy_config_enable_register(proxy_cfg, 1); /* activate registration for this proxy config*/
    }
    
    
    func unregister(){
        NSLog("Linphone unregister()..")
        
        if let timer = LinphoneManager.iterateTimer{
            timer.invalidate()
        }
        
        let proxy_cfg = linphone_core_get_default_proxy_config(theLinphone.lc!); /* get default proxy config*/
        
        if linphone_proxy_config_get_state(proxy_cfg) !=  LinphoneRegistrationFailed {
            linphone_proxy_config_edit(proxy_cfg); /*start editing proxy configuration*/
            linphone_proxy_config_enable_register(proxy_cfg, 0); /*de-activate registration for this proxy config*/
            linphone_proxy_config_done(proxy_cfg); /*initiate REGISTER with expire = 0*/
            
            while(linphone_proxy_config_get_state(proxy_cfg) !=  LinphoneRegistrationCleared){
                    linphone_core_iterate(theLinphone.lc!); /*to make sure we receive call backs before shutting down*/
                    ms_usleep(50000);
            }
        }
        
        
        linphone_core_remove_listener(theLinphone.lc!, &theLinphone.lct!)
        linphone_core_destroy(theLinphone.lc!);
        
        LinphoneManager.isInit = false
    }
    
    private func setTimer(){
        LinphoneManager.iterateTimer = NSTimer.scheduledTimerWithTimeInterval(
            0.02, target: self, selector: #selector(iterate), userInfo: nil, repeats: true)
    }
}