import UIKit

enum DetailsModelCell: Hashable {
    case title(String?, NSTextAlignment)
    case titleDetails(String?, String?)
    case separator
    case spacing(CGFloat)
}

protocol DetailsModel {
    var modelTitle: String { get }
    var modelCells: [DetailsModelCell] { get }
}
