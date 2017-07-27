//
//  VIPHelpers.swift
//  VostVIP
//
//  Created by Pavel Volobuev on 02/12/2016.
//  Copyright © 2016 LTech. All rights reserved.
//

import UIKit

struct K {
    
    // MARK: Device
    
    enum UIUserInterfaceIdiom : Int {
        case Unspecified
        case Phone
        case Pad
    }
    
    struct ScreenSize {
        static let WIDTH         = UIScreen.main.bounds.size.width
        static let HEIGHT        = UIScreen.main.bounds.size.height
        static let MAX_LENGTH    = max(ScreenSize.WIDTH, ScreenSize.HEIGHT)
        static let MIN_LENGTH    = min(ScreenSize.WIDTH, ScreenSize.HEIGHT)
    }
    
    struct DeviceType {
        static let IS_IPHONE_4_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.MAX_LENGTH < 568.0
        static let IS_IPHONE_5_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.MAX_LENGTH <= 568.0
        static let IS_IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.MAX_LENGTH == 568.0
        static let IS_IPHONE_6          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.MAX_LENGTH == 667.0
        static let IS_IPHONE_6P         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.MAX_LENGTH == 736.0
        static let IS_IPAD              = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.MAX_LENGTH == 1024.0
        static let IS_IPAD_PRO          = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.MAX_LENGTH == 1366.0
    }
    
    struct Platform {
        static var isSimulator: Bool {
            return TARGET_OS_SIMULATOR != 0
        }
    }
    
    static let Identifier = (UIDevice.current.identifierForVendor?.uuidString)!
    
    // MARK: Keys
    // FIXME: Check it before Production
    
    struct Keys {
//        static let yandexMapKitApiKey = "JvNnR4AXqRZe~6eTuDPAigB5b8~-cdCH24x6eUnpTz5AIMP3OUJYga8IBKuNegTx0YBfrQYshM737nRoNAlY7tAj-OfUVgf2SeDsV7OjUaQ="
////        static let oneSignalAppId = "82d346e1-50b0-4be0-92d9-098f4686b367" // Test
//        static let oneSignalAppId = "3db998cf-db54-4a43-a59a-851fd5594cda" // Production
//        static let dadataToken = "e00543380b17a06bc9479b0525f398a0c35f32b6"
//        static let ltechAuthHeader = "Bearer XZme5bvfyL6SYwY9gLffaXeN9tfwNJ46LKBMwH2BM8Kwt2K8qWkAgXaYe06A"
    }
    
    struct KeychainKeys {
        static let phoneNumber = "phoneNumber"
        static let accessToken = "access_token"
        static let isAuthorized = "is_authorized"
        // Orders
        static let orderId = "orderId"
        static let orderSignature = "orderSignature"
    }
    
    // MARK: Notifications
    
    struct NotificationName {
        static let clearAllFields = "clearAllFields"
//        static let stopMonitoringLocation = "stopMonitoringLocation"
//        static let fetchingLocation = "fetchingLocation"
    }
}

// MARK: Font

extension UIFont {
    class func sanFrancisco(_ size: CGFloat, bold: Bool = false) -> UIFont {
        return bold ? UIFont(name:"SFUIText-Bold", size: size)! : UIFont(name:"SFUIText-Regular", size: size)!
    }
    
    class func arial(_ size: CGFloat, bold: Bool = false) -> UIFont {
        return bold ? UIFont(name:"Arial-BoldMT", size: size)! : UIFont(name:"ArialMT", size: size)!
    }
}

// MARK: UserDefaults

//extension DefaultsKeys {
//    static let failurePhoneCount = DefaultsKey<Int>("failurePhoneCount")
//    static let unlockDate = DefaultsKey<Date?>("unlockDate")
//    static let showBannerCount = DefaultsKey<Int>("showBannerCount")
//    static let showMessages = DefaultsKey<Bool>("showMessages")
//    static let touchDate = DefaultsKey<Date?>("touchDate")
//    static let showHistory = DefaultsKey<Bool>("showHistory")
//}

// MARK: Color

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
    
    @nonobjc static let backgroundGradientLeftTop = UIColor(netHex: 0xfa9a5a)
    @nonobjc static let backgroundGradientRightBottom = UIColor(netHex: 0xf279ac)
    @nonobjc static let infoRed = UIColor(netHex: 0xff6666)
    @nonobjc static let infoBlack = UIColor(netHex: 0x333333)
    
}

// MARK: UIView

extension UIView {
    class func loadFrom(nibNamed: String, bundle : Bundle? = nil) -> UIView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[0] as? UIView
    }
}

extension UIView {
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.duration = 0.6
        animation.values = [-16, 16, -16, 16, -8, 8, -4, 4, 0]
        layer.add(animation, forKey: "shake")
    }
}

// MARK: - Storyboard

extension UIStoryboard {
    func instantiateVC<T: UIViewController>() -> T? {
        if let name = NSStringFromClass(T.self).components(separatedBy: ".").last {
            return instantiateViewController(withIdentifier: name) as? T
        }
        return nil
    }
    
    func instantiateVC<T: UIViewController>(with identifier: String) -> T? {
        return instantiateViewController(withIdentifier: identifier) as? T
    }
}

// MARK: - Dispatch

func delay(_ delay: Double, _ closure: @escaping () -> ()) {
    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
        closure()
    }
}

// MARK: - String

extension String {
    static func replace(_ string: String, by mask: String) -> String {
        var newString = mask
        for char in string.characters {
            for (index, patternChar) in newString.characters.enumerated() {
                if patternChar == "_" {
                    let start = newString.index(newString.startIndex, offsetBy: index)
                    let end = newString.index(newString.startIndex, offsetBy: index + 1)
                    let range = start..<end
                    newString = newString.replacingCharacters(in: range, with: String(char))
                    
                    break
                }
            }
        }
        return newString.replacingOccurrences(of: "_", with: "").trimmingCharacters(in: .whitespaces)
    }
}

extension String {
    func condenseWhitespace() -> String {
        return self.components(separatedBy: CharacterSet.whitespacesAndNewlines)
            .filter { !$0.isEmpty }
            .joined(separator: " ")
    }
}

extension String {
    func numberOnly() -> String {
        return self.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression, range: nil)
    }
}

extension String {
    var length: Int {
        return self.characters.count
    }
    
    subscript (i: Int) -> String {
        return self[Range(i ..< i + 1)]
    }
    
    func substring(from: Int) -> String {
        return self[Range(min(from, length) ..< length)]
    }
    
    func substring(to: Int) -> String {
        return self[Range(0 ..< max(0, to))]
    }
    
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return self[Range(start ..< end)]
    }
}

extension String {
    func toBool() -> Bool? {
        switch self {
        case "True", "true", "yes", "1":
            return true
        case "False", "false", "no", "0":
            return false
        default:
            return nil
        }
    }
}

extension String {
    static func seconds(for number: Int) -> String {
        let unitsStringArray = ["секунду", "секунды", "секунд"]
        return unitsStringArray[suffixKey(for: number)]
    }
    
    static func suffixKey(for number: Int) -> Int {
        let keys = [2, 0, 1, 1, 1, 2]
        let mod = number % 100
        let modSuff = mod % 10
        let keyAgrument = min(modSuff, 5)
        return (mod > 7 && mod < 20) ? 2 : keys[keyAgrument]
    }
}

// MARK: - Alamofire

//extension Request {
//    public func debugLog() -> Self {
//        #if DEBUG
//            debugPrint(self)
//        #endif
//        return self
//    }
//}

// MARK: - Methods

func formattedAmount(from string: String) -> String? {
    var currencyString = string
    
    if let range: Range<String.Index> = string.range(of: ".") {
        let substr = string[string.startIndex..<range.lowerBound]
        currencyString = substr
    }
    
    if let myInteger = Int(currencyString) {
        let myNumber = NSNumber(value:myInteger)
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.usesGroupingSeparator = true
        formatter.groupingSeparator = " ";
        formatter.groupingSize = 3;
        
        if let formattedString = formatter.string(from: myNumber) {
            currencyString = formattedString
            if let range: Range<String.Index> = string.range(of: ".") {
                let substr = string[range.upperBound..<string.endIndex]
                if substr == "0" {
                    currencyString = "\(formattedString)"
                } else {
                    currencyString = "\(formattedString).\(substr)"
                }
            }
        }
        
        return currencyString
    }
    
    return nil
}

extension Date {
    var age: Int {
        return Calendar.current.dateComponents([.year], from: self, to: Date()).year!
    }
}

