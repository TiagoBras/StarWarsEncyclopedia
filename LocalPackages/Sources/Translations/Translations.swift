import Foundation

extension String {
    /// Translations
    public enum tr {}
}

fileprivate func s(_ key: String, _ comment: String, args: CVarArg...) -> String {
    let format = NSLocalizedString(key, bundle: .module, comment: comment)
    
    return withVaList(args) {
        NSString(format: format, locale: NSLocale.current, arguments: $0) as String
    }
}

extension String.tr {
    public enum common {
        public static let download = s("common.download-button", "Download Button CTA")
        public static let films = s("common.films", "Word for films")
        public static let people = s("common.people", "Word for people")
    }
    
    public enum film {
        public enum tvcell {
            public static func title(_ filmTitle: String) -> String {
                return s("film.tvcell.title", "Film's title", args: filmTitle)
            }
            
            public static func episode(_ episode: Int) -> String {
                return s("film.tvcell.episode", "Film's episode number", args: episode)
            }
            
            public static func director(_ directorName: String) -> String {
                return s("film.tvcell.director", "Film's director", args: directorName)
            }
            
            public static func released(_ date: String) -> String {
                return s("film.tvcell.released", "Film's release date", args: date)
            }
        }
        
        public enum details {
            public static func director() -> String {
                return s("film.details.director", "Director")
            }
            
            public static func producer() -> String {
                return s("film.details.producer", "Producer")
            }
            
            public static func released() -> String {
                return s("film.details.released", "Released date")
            }
            
            public static func episode() -> String {
                return s("film.details.episode", "Episode number")
            }
            
            public static func opening_crawl() -> String {
                return s("film.details.opening_crawl", "Opening Crawl")
            }
        }
    }
    
    public enum person {
        public enum tvcell {
            public static func yearOfBirth(_ yearOfBirth: String) -> String {
                return s("person.tvcell.year_of_birth", "Person's year of birth", args: yearOfBirth)
            }
            
            public static func height(_ height: String) -> String {
                return s("person.tvcell.height", "Person's height", args: height)
            }
            
            public static func weight(_ weight: String) -> String {
                return s("person.tvcell.weight", "Person's weight", args: weight)
            }
        }
        
        public enum details {
            public static func height() -> String {
                return s("person.details.height", "Height")
            }
            
            public static func weight() -> String {
                return s("person.details.weight", "Weight")
            }
            
            public static func hair_color() -> String {
                return s("person.details.hair_color", "Hair Color")
            }
            
            public static func skin_color() -> String {
                return s("person.details.skin_color", "Skin Color")
            }
            
            public static func eye_color() -> String {
                return s("person.details.eye_color", "Eye Color")
            }
            
            public static func gender() -> String {
                return s("person.details.gender", "Gender")
            }
            
            public static func yearOfBirth() -> String {
                return s("person.details.year_of_birth", "Year of Birth")
            }
        }
    }
}

