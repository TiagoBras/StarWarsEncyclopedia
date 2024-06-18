import UIKit
import StarWarsAPI

extension Film: PaginatedListCellModel {
    public static func specification() -> CellSpecification {
        return CellSpecification(
            rows: [
                .init(
                    columns: [
                        .headlineLeft,
                        .headlineRight.update(\.lineBreakMode, .byTruncatingHead)
                    ],
                    spacing: 2),
                .init(columns: [.subheadlineLeft]),
                .init(columns: [.subheadlineLeft])
            ],
            spacing: 2
        )
    }
    
    public func textLabels() -> [String?] {
        return [title, "Episode \(episodeID)", "Directed by \(director)", "Released on \(releaseDate)"]
    }
}

// MARK: - Helper Extensions

fileprivate extension NSTextAlignment {
    @MainActor
    static var naturalInverse: NSTextAlignment {
        return UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft ? .left : .right
    }
}

fileprivate extension CellSpecificationRowLabel {
    static let headlineLeft = Self(font: .preferredFont(forTextStyle: .headline))
    @MainActor
    static let headlineRight = Self(font: .preferredFont(forTextStyle: .headline), alignment: .naturalInverse)
    
    static let subheadlineLeft = Self(font: .preferredFont(forTextStyle: .subheadline))
    @MainActor
    static let subheadlineRight = Self(font: .preferredFont(forTextStyle: .subheadline), alignment: .naturalInverse)
}
