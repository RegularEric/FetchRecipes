#  README

### Steps to Run the App
1. Clone the repository
2. Open FetchRecipes.xcodeproj in Xcode 16.1+
3. Make sure Package Dependency Flow is fetched
4. Select a simulator (iOS 18.1+)
5. Build and run (⌘R)

### Focus Areas: What specific areas of the project did you prioritize? Why did you choose to focus on these areas?
1. Architecture & Testing
  - MVVM architecture with clear separation of concerns
  - Protocol oriented + Dependency injection for easy unit testing

2. Performance & Caching
  - Image caching with memory and disk storage
  - Efficient recipe filtering and sorting
  - Task cancellation for image loading

### Time Spent: Approximately how long did you spend working on this project? How did you allocate your time?
~ 5 hours

### Trade-offs and Decisions: Did you make any significant trade-offs in your approach?
- I didn't use protocols for EVERY file just to save time. See RecipeListView and RecipeViewModel for the full effect.
- No UI tests to save time. Assignment put more emphasis on unit testing.
- Custom ImageCache will likely be less scalable than a dedicated package - again to save time.

### Weakest Part of the Project: What do you think is the weakest part of your project?
- Dependencies like ImageCache & NetworkClient don't really have a home due to lack of root infrastructure. Sometimes this is ok but if we want to scale, we may need to have a home for them or some architecture pattern like a factory or TCA.
- We can add more layers of abstraction depending on how we want to build on top of this. (e.g.: routing, recipe store if other features will be reading/writing them, etc.)

### External Code and Dependencies: Did you use any external code, libraries, or dependencies?
- I used Flow just for fun. The filters look a lot nicer than SwiftUI LazyVGrid. Eww...

### Additional Information: Is there anything else we should know? Feel free to share any insights or constraints you encountered.
- String and magic numbers should be properly encapsulated.
- No offline support
- No pagination
- All unit tests ideally have a `precondition` but I did not implement to save time. See `RecipeFiltersTests.swift` for example.
