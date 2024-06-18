import Foundation
import StarWarsAPI

extension Film: DetailsModel {
    var modelTitle: String {
        return title
    }
    
    var modelCells: [DetailsModelCell] {
        return [
            .spacing(20),
            .titleDetails(.tr.film.details.director(), director),
            .titleDetails(.tr.film.details.producer(), producer),
            .titleDetails(.tr.film.details.released(), releaseDate),
            .titleDetails(.tr.film.details.episode(), String(episodeID)),
            .spacing(20),
            .separator,
            .spacing(10),
            .title(.tr.film.details.opening_crawl(), .center),
            .spacing(8),
            .title(openingCrawl, .center)
        ]
    }
}

extension Person: DetailsModel {
    var modelTitle: String {
        return name
    }
    
    var modelCells: [DetailsModelCell] {
        return [
            .spacing(20),
            .titleDetails(.tr.person.details.yearOfBirth(), birthYear),
            .titleDetails(.tr.person.details.gender(), gender),
            .titleDetails(.tr.person.details.height(), "\(height) cm"),
            .titleDetails(.tr.person.details.weight(), "\(mass) kg"),
            .separator,
            .titleDetails(.tr.person.details.skin_color(), skinColor),
            .titleDetails(.tr.person.details.hair_color(), hairColor),
            .titleDetails(.tr.person.details.eye_color(), eyeColor),
        ]
    }
}
