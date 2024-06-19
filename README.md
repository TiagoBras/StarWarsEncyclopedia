# Welcome to Star Wars Encyclopedia (lite)

In this simple app you can check details about Star Wars movies and characters. 

It uses [SWAPI](https://swapi.dev) for the data.

# How to run the app

1. Clone this repository
2. Open `StarWarsWorld.xcworkspace`
3. Go to target `StarWarsWorld`
4. Open `Signing & Capabilities` and change the Team to yours
5. Run the app on your phone or simulator

# Ways to extend this app

It's easy to extend this app with more data from the API.

Imagine you want to add a tab with the list of `vehicles` or `species`.

## Step 1 - Conform to `PaginatedListCellModel`
First you need to conform `Vehicle` to `PaginatedListCellModel`.

Go to `LocalPackages/Sources/App/Scenes/List/StarWarsModel+PaginatedListCellModel.swift` and add this:

```swift
extension Vehicle: PaginatedListCellModel {
    public static func specification() -> CellSpecification {
        CellSpecification(
            rows: [
                .init(columns: [.headlineLeft]),
                .init(columns: [.subheadlineLeft])
            ])
    }
    
    // The number of text labels must match the number of 
    // columns defined in the specification
    public func textLabels() -> [String?] {
        [name, model]
    }
}
```

## Step 2 - Conform to `DetailsModel`

Go to `LocalPackages/Sources/App/Scenes/Details/StarWarsModel+DetailsModel.swift` and add this:

```swift
extension Vehicle: DetailsModel {
    var modelTitle: String {
        name
    }
    
    var modelCells: [DetailsModelCell] {
        [
            .spacing(20),
            .titleDetails("Model", model),
            .titleDetails("Manufacturer", manufacturer),
            .titleDetails("Cost in Credits", costInCredits),
            .separator,
            .titleDetails("Length", length),
            .titleDetails("Max Atmosphering Speed", maxAtmospheringSpeed),
            .titleDetails("Crew", crew),
            .titleDetails("Passengers", passengers),
            .titleDetails("Cargo Capacity", cargoCapacity),
        ]
    }
}
```

## Step 3 - Conform to `HasViewControllerTitle`

Go to `LocalPackages/Sources/App/Coordinators/AppCoordinator.swift` and add this to the end of the file:

```swift
extension Vehicle: HasViewControllerTitle {
    static var viewControllerTitle: String { "Vehicles" }
}
```

## Step 4 - Add view controller to HomeVC's viewControllers

In the same, file change:

```swift
func homeScene() -> UIViewController {
    let homeVC = HomeVC()
    homeVC.viewControllers = [
        paginatedListScene(starWarsClient.getFilms),
        paginatedListScene(starWarsClient.getPeople),
    ]
    return homeVC
}
```

to this:

```swift
func homeScene() -> UIViewController {
    let homeVC = HomeVC()
    homeVC.viewControllers = [
        paginatedListScene(starWarsClient.getFilms),
        paginatedListScene(starWarsClient.getPeople),
        paginatedListScene(starWarsClient.getVehicles),
    ]
    return homeVC
}
```

And there you go, a new tab with a list of vehicles and their details.

# What else could I do? 

1. Use **translations** instead of hardcoded strings. Just go to `Translations` package, add the translations to the `strings` files. Optionally (although, highly recommended), create a static field in `Translations.swift`.
2. Add one more tab for the `planets`, `starships` or `species`.
