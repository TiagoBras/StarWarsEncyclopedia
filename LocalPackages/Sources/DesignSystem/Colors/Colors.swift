import UIKit

extension UIColor {
    public static let swPrimaryText = color(named: "primaryText")
    public static let swSecondaryText = color(named: "secondaryText")
    public static let swLightText = color(named: "lightText")
    public static let swDarkText = color(named: "darkText")
    public static let swBackground = color(named: "background")
    public static let swSeparator = color(named: "separator")
    
    private static func color(named name: String) -> UIColor {
        return UIColor(named: name, in: .module, compatibleWith: nil)!
    }
}
