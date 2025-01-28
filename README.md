# Uala Challenge

This project implements a simple yet powerful app to manage and explore a list of cities. The app focuses on performance, usability, and clean architecture. Below, you'll find a detailed explanation of the approach, structure, and decisions taken during the development process.

---

## **Features**

1. **City Listing:**
   - Displays a scrollable list of cities retrieved from an external JSON API.
   - Optimized filtering based on user input (prefix search).
   - Case-insensitive search functionality.

2. **Favorites Management:**
   - Mark/unmark cities as favorites.
   - Toggle to view only favorite cities.
   - Favorites persist across app launches using `UserDefaults`.

3. **City Details with Map Integration:**
   - Navigate to a detailed view displaying the city's location on a map.
   - Annotation with the city name and coordinates.

4. **Responsive UI:**
   - Seamless layout changes for portrait and landscape modes.
   - In portrait, navigation stack separates the city list and map views.
   - In landscape, both the list and map are visible side-by-side.

5. **Testing:**
   - **Unit Tests** for ViewModel logic (e.g., filtering, toggling favorites, fetching cities).
   - **UI Tests** for end-to-end interaction, including search, toggles, and navigation.

---

## **Architecture**

The project follows the MVVM (Model-View-ViewModel) architecture to ensure clean separation of concerns and scalability.

### **Folder Structure:**

- **Models:** Defines the `City` structure and its properties.
- **ViewModels:** Contains business logic (e.g., `CityViewModel` and `CityDetailViewModel`).
- **Views:** SwiftUI views for displaying city lists, rows, and details.
- **Services:** Handles API requests and abstracts data fetching (`CityService`).
- **Tests:**
  - Unit tests: Validate `CityViewModel` functionality.
  - UI tests: Test app interactions.

### **CityViewModel Responsibilities:**
- Fetch cities using `CityService`.
- Filter cities based on user input and toggle states.
- Manage favorites with `UserDefaults` for persistence.
- Notify the view about changes using `@Published` properties.

---

## **Performance Optimizations**

1. **Efficient Filtering:**
   - Uses prefix-based filtering optimized for real-time search.
   - Debounced input to reduce unnecessary computations while typing.

2. **Problem:**
     - Rendering all cities in a single `List` or `ForEach` caused high memory usage and decreased UI responsiveness.
   **Solution:**
     - Switched to using `LazyVStack` within a `ScrollView` to ensure that only visible items are rendered in memory, improving responsiveness.

3. **State Binding:**
   - Leverages SwiftUI's `@Published` and `Combine` to minimize manual state management.

4. **Reduced API Load:**
   - City data is loaded once and reused, avoiding redundant network calls.

---

## **Testing**

### **Unit Tests:**
- **`CityViewModelTests`:**
  - Verifies city fetching, filtering, and favorite toggling.
  - Uses `MockCityService` to simulate API responses.

### **UI Tests:**
- Ensures end-to-end functionality, including:
  - Toggling favorites.

### **How to Run Tests:**
1. Open the project in Xcode.
2. Select the `UalaChallengeTests` or `UalaChallengeUITests` target.
3. Press `Cmd + U` to execute all tests.

---

## **Setup and Requirements**

- **iOS Version:** Compatible with iOS 18.2+.
- **Swift Version:** Swift 5.
- **Tools:** Built and tested using Xcode 16.2.

### **How to Run the App:**
1. Clone the repository.
2. Open the project in Xcode.
3. Select a simulator or connected device.
4. Press `Cmd + R` to build and run the app.

---

## **Decisions and Assumptions**

1. **Data Source:**
   - The cities are fetched from a static JSON API provided in the challenge.

2. **Persistence:**
   - `UserDefaults` is used for simplicity in storing favorite cities.
   - This is sufficient for small-scale data.

3. **Filtering Logic:**
   - Filters are case-insensitive and based on prefix matching.
   - Optimized to handle large datasets with minimal delay.

4. **Limitations:**
   - No error handling for API failures is currently implemented (can be expanded).
   - The map view currently supports a single city at a time.

---

## **Future Improvements**

1. **Error Handling:**
   - Display user-friendly error messages for API/network failures.

2. **Offline Mode:**
   - Cache city data locally to enable offline functionality.

3. **Scalability:**
   - Migrate favorites to a database like Core Data for better performance with larger datasets.

4. **UI Enhancements:**
   - Add animations for transitions between views.
   - Improve map interaction with pinch-to-zoom or clustering for nearby cities.

---

## **Author**
Liz Fabiola Isasi Cardozo

