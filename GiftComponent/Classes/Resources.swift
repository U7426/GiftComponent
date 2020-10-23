//
//  Resources.swift
//  KDGiftComponent
//
//  Created by 冯龙飞 on 2020/10/10.
//

import Foundation
fileprivate class ThisClass {}

public struct Resources {
    public static var bundle: Bundle {
        let path = Bundle(for: ThisClass.self).resourcePath! + "/GiftComponent.bundle"
        return Bundle(path: path)!
    }
}
internal struct WrappedBundleImage: _ExpressibleByImageLiteral {
    let image: UIImage?

    init(imageLiteralResourceName name: String) {
        image = UIImage(named: name, in: Resources.bundle, compatibleWith: nil)
    }
}

extension UIImage {
    static func fromWrappedBundleImage(_ wrappedImage: WrappedBundleImage) -> UIImage? {
        return wrappedImage.image
    }
}
