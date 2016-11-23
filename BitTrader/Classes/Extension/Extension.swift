//
//  Extension.swift
//  BitTrader
//
//  Created by chako on 2016/10/09.
//  Copyright © 2016年 Bit Trader. All rights reserved.
//

import Foundation
import UIKit

import APIKit
import RxCocoa
import RxSwift

// MARK: String Extension
enum CryptoAlgorithm {
    case MD5, SHA1, SHA224, SHA256, SHA384, SHA512
    
    var HMACAlgorithm: CCHmacAlgorithm {
        var result: Int = 0
        switch self {
        case .MD5:      result = kCCHmacAlgMD5
        case .SHA1:     result = kCCHmacAlgSHA1
        case .SHA224:   result = kCCHmacAlgSHA224
        case .SHA256:   result = kCCHmacAlgSHA256
        case .SHA384:   result = kCCHmacAlgSHA384
        case .SHA512:   result = kCCHmacAlgSHA512
        }
        return CCHmacAlgorithm(result)
    }
    
    var digestLength: Int {
        var result: Int32 = 0
        switch self {
        case .MD5:      result = CC_MD5_DIGEST_LENGTH
        case .SHA1:     result = CC_SHA1_DIGEST_LENGTH
        case .SHA224:   result = CC_SHA224_DIGEST_LENGTH
        case .SHA256:   result = CC_SHA256_DIGEST_LENGTH
        case .SHA384:   result = CC_SHA384_DIGEST_LENGTH
        case .SHA512:   result = CC_SHA512_DIGEST_LENGTH
        }
        return Int(result)
    }
}

extension String {
    
    func hmac(algorithm: CryptoAlgorithm, key: String) -> String {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = Int(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = algorithm.digestLength
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        let keyStr = key.cString(using: String.Encoding.utf8)
        let keyLen = Int(key.lengthOfBytes(using: String.Encoding.utf8))
        
        CCHmac(algorithm.HMACAlgorithm, keyStr!, keyLen, str!, strLen, result)
        
        let digest = stringFromResult(result: result, length: digestLen)
        
        result.deallocate(capacity: digestLen)
        
        return digest
    }
    
    private func stringFromResult(result: UnsafeMutablePointer<CUnsignedChar>, length: Int) -> String {
        let hash = NSMutableString()
        for i in 0..<length {
            hash.appendFormat("%02x", result[i])
        }
        return String(hash)
    }
    
    enum DateFormat: String {
        case iso8601 = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        case cell = "MM/dd HH:mm:ss"
    }

    func formatDate(fromFormat: DateFormat, toFormat: DateFormat) -> String {
        
        let fromDateFormatter = DateFormatter()
        fromDateFormatter.timeZone = NSTimeZone.local
        fromDateFormatter.dateFormat = fromFormat.rawValue
        
        if let date = fromDateFormatter.date(from: self) {
            let toDateFormatter = DateFormatter()
            toDateFormatter.timeZone = NSTimeZone.local
            toDateFormatter.dateFormat = toFormat.rawValue
            
            return toDateFormatter.string(from: date)
        } else {
            return self
        }
    }
}

extension Date {
    
    public static func iso8601Date(from string: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.local
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        return dateFormatter.date(from: string)
    }

}

extension NSNumber {
    
    func formatComma() -> String {
        
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.decimal
        formatter.groupingSeparator = ","
        formatter.groupingSize = 3
        
        return formatter.string(from: self) ?? self.stringValue
    }
}

extension Array {

    public mutating func appendNotNil(element: Element?) {
        guard element != nil else {
            return
        }
        self.append(element!)
    }
}

// MARK: UIView
extension UIView {
    func addFittingConstraintsFor(childView: UIView) {
        let constraints = [.top, .leading, .bottom, .trailing].map {
            NSLayoutConstraint(
                item: childView,
                attribute: $0,
                relatedBy: .equal,
                toItem: self,
                attribute: $0,
                multiplier: 1.0,
                constant: 0.0)
        }
        childView.translatesAutoresizingMaskIntoConstraints = false
        addConstraints(constraints)
    }
}

// MARK: Font
extension UIFont {
    
    var monospacedDigitFont: UIFont {
        let oldFontDescriptor = fontDescriptor
        let newFontDescriptor = oldFontDescriptor.monospacedDigitFontDescriptor
        return UIFont(descriptor: newFontDescriptor, size: 0)
    }
    
}

extension UIColor {
    func toImage() -> UIImage {
        let size = CGSize(width: 1, height: 1)
        UIGraphicsBeginImageContext(size)
        let rect = CGRect(origin: CGPoint.zero, size: size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(self.cgColor)
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

private extension UIFontDescriptor {
    
    var monospacedDigitFontDescriptor: UIFontDescriptor {
        let fontDescriptorFeatureSettings = [[UIFontFeatureTypeIdentifierKey: kNumberSpacingType, UIFontFeatureSelectorIdentifierKey: kMonospacedNumbersSelector]]
        let fontDescriptorAttributes = [UIFontDescriptorFeatureSettingsAttribute: fontDescriptorFeatureSettings]
        let fontDescriptor = self.addingAttributes(fontDescriptorAttributes)
        return fontDescriptor
    }
}

// MARK: Session
extension Session {
    func rx_sendRequest<T: Request>(request: T) -> Observable<T.Response> {
        return Observable.create { observer in
            let task = self.send(request) { result in
                switch result {
                case .success(let res):
                    observer.on(.next(res))
                    observer.on(.completed)
                case .failure(let err):
                    observer.onError(err)
                }
            }
            return Disposables.create { [weak task] in
                task?.cancel()
            }
        }
    }
    
    class func rx_sendRequest<T: Request>(request: T) -> Observable<T.Response> {
        return shared.rx_sendRequest(request: request)
    }
}
