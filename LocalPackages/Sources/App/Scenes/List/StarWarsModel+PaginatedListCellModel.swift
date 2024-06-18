import UIKit
import StarWarsAPI
import Translations

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
        return [
            .tr.film.tvcell.title(title),
            .tr.film.tvcell.episode(episodeID),
            .tr.film.tvcell.director(director),
            .tr.film.tvcell.released(releaseDate),
        ]
    }
}

extension Person: PaginatedListCellModel {
    public static func specification() -> CellSpecification {
        return CellSpecification(
            rows: [
                .init(
                    columns: [
                        .headlineLeft.update(\.hugging, .init(priority: .defaultHigh, axis: .horizontal)),
                        .headlineLeft
                    ],
                    spacing: 4),
                .init(columns: [.subheadlineLeft]),
                .init(columns: [.subheadlineLeft, .subheadlineLeft], distribution: .fillEqually),
            ],
            spacing: 2
        )
    }
    
    public func textLabels() -> [String?] {
        return [
            name,
            genderEmoji,
            .tr.person.tvcell.yearOfBirth(birthYear),
            .tr.person.tvcell.height(height),
            .tr.person.tvcell.weight(mass),
        ]
    }
    
    var genderEmoji: String {
        switch gender {
        case "female": return "♀︎"
        case "male": return "♂︎"
        default: return ""
        }
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
