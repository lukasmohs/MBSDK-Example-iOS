// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(OSX)
  import AppKit.NSImage
  internal typealias AssetColorTypeAlias = NSColor
  internal typealias AssetImageTypeAlias = NSImage
#elseif os(iOS) || os(tvOS) || os(watchOS)
  import UIKit.UIImage
  internal typealias AssetColorTypeAlias = UIColor
  internal typealias AssetImageTypeAlias = UIImage
#endif

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum Asset {
  internal static let dblc = ImageAsset(name: "dblc")
  internal static let dblcg = ImageAsset(name: "dblcg")
  internal static let dblcr = ImageAsset(name: "dblcr")
  internal static let dblo = ImageAsset(name: "dblo")
  internal static let dblog = ImageAsset(name: "dblog")
  internal static let dblor = ImageAsset(name: "dblor")
  internal static let dbrc = ImageAsset(name: "dbrc")
  internal static let dbrcg = ImageAsset(name: "dbrcg")
  internal static let dbrcr = ImageAsset(name: "dbrcr")
  internal static let dbro = ImageAsset(name: "dbro")
  internal static let dbrog = ImageAsset(name: "dbrog")
  internal static let dbror = ImageAsset(name: "dbror")
  internal static let dflc = ImageAsset(name: "dflc")
  internal static let dflcg = ImageAsset(name: "dflcg")
  internal static let dflcr = ImageAsset(name: "dflcr")
  internal static let dflo = ImageAsset(name: "dflo")
  internal static let dflog = ImageAsset(name: "dflog")
  internal static let dflor = ImageAsset(name: "dflor")
  internal static let dfrc = ImageAsset(name: "dfrc")
  internal static let dfrcg = ImageAsset(name: "dfrcg")
  internal static let dfrcr = ImageAsset(name: "dfrcr")
  internal static let dfro = ImageAsset(name: "dfro")
  internal static let dfrog = ImageAsset(name: "dfrog")
  internal static let dfror = ImageAsset(name: "dfror")
  internal static let car = ImageAsset(name: "car")
  internal static let carLock = ImageAsset(name: "car_lock")
  internal static let carOutline = ImageAsset(name: "car_outline")
  internal static let carWithoutDoors = ImageAsset(name: "car_without_doors")
  internal static let mainBg = ImageAsset(name: "main-bg")
  internal static let zetsche = ImageAsset(name: "zetsche")
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

internal struct ColorAsset {
  internal fileprivate(set) var name: String

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, OSX 10.13, *)
  internal var color: AssetColorTypeAlias {
    return AssetColorTypeAlias(asset: self)
  }
}

internal extension AssetColorTypeAlias {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, OSX 10.13, *)
  convenience init!(asset: ColorAsset) {
    let bundle = Bundle(for: BundleToken.self)
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(OSX)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

internal struct DataAsset {
  internal fileprivate(set) var name: String

  #if os(iOS) || os(tvOS) || os(OSX)
  @available(iOS 9.0, tvOS 9.0, OSX 10.11, *)
  internal var data: NSDataAsset {
    return NSDataAsset(asset: self)
  }
  #endif
}

#if os(iOS) || os(tvOS) || os(OSX)
@available(iOS 9.0, tvOS 9.0, OSX 10.11, *)
internal extension NSDataAsset {
  convenience init!(asset: DataAsset) {
    let bundle = Bundle(for: BundleToken.self)
    #if os(iOS) || os(tvOS)
    self.init(name: asset.name, bundle: bundle)
    #elseif os(OSX)
    self.init(name: NSDataAsset.Name(asset.name), bundle: bundle)
    #endif
  }
}
#endif

internal struct ImageAsset {
  internal fileprivate(set) var name: String

  internal var image: AssetImageTypeAlias {
    let bundle = Bundle(for: BundleToken.self)
    #if os(iOS) || os(tvOS)
    let image = AssetImageTypeAlias(named: name, in: bundle, compatibleWith: nil)
    #elseif os(OSX)
    let image = bundle.image(forResource: NSImage.Name(name))
    #elseif os(watchOS)
    let image = AssetImageTypeAlias(named: name)
    #endif
    guard let result = image else { fatalError("Unable to load image named \(name).") }
    return result
  }
}

internal extension AssetImageTypeAlias {
  @available(iOS 1.0, tvOS 1.0, watchOS 1.0, *)
  @available(OSX, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init!(asset: ImageAsset) {
    #if os(iOS) || os(tvOS)
    let bundle = Bundle(for: BundleToken.self)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(OSX)
    self.init(named: NSImage.Name(asset.name))
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

private final class BundleToken {}
