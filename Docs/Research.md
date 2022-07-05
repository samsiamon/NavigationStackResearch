# Research 

## What is NavigationStack?
`NavigationStack` is a new struct announced at WWDC 2022. It is a view that displays a root view and enables one to present additional views over the root view. his feature will be available with the release of iOS 16. Documentation on `NavigationStack` can be found [here](https://developer.apple.com/documentation/SwiftUI/NavigationStack).

## Declaration
`struct NavigationStack<Data, Root> where Root : View`

## Summary
As stated above, the NavigationStack struct displays a root view and allows one to display views on top of the root view by pushing it onto the Navigation Path Stack (will go into more detail of the path stack later on). One can remove views from the path using platform appropriate controls (i.e. a back button/ swiping back/ etc.).

## Implementation
A NavigationStack is implemented as follows: (using carriers as an example in respect to PrePass)
``` swift
NavigationStack {
    // 3.
    List(carriers) { carrier in
        // 2.
        NavigationLink(carrier.name, value: carrier)
    }
    // 1.
    .navigationDestination(for: Carrier.self) { carrier in
        SelectCarrierView(carrier: carrier)
    }
    
}
```
1. We first append `List` with the `.navigationDestination(for:destination:)` to associate a view with a data type. In this example, we associate `Carrier.self` with `SelectCarrier(...)`.
2. We then initialize a `NavigationLink` using its initializer `init<P>(LocalizedStringKey, value: P?)`. This creates a navigation link that presents the view corresponding to a value, with a text label that the link generated from a localized string key. In this example, the localized string key is `carrier.name` and the data value is `carrier`. This data must be the same type as in the `.navigationDestination(for:destination:)`.
3. In this example, the `List` acts as the **root view** and is always present. Selecting a navigation link from the list adds a `SelectCarrierView(...)` view to the stack. Navigating back from that view removes the same `SelectCarrierView(...)` from the stack.

## Navigation Stack State Management
One of the most important features of the new `NavigationStack` struct is its state management. By default, `NavigationStack` manages state to keep track of the views on the stack. However, it also allows code deeper in the navigation stack to read and write to the stack itself.

Using the same example as above, this can be implemented as follows:
``` swift
// 1.
@State private var viewPath: [Carrier] = []

// 2.
NavigationStack(path: $viewPath) {
    List(carriers) { carrier in
        NavigationLink(carrier.name, value: carrier)
    }
    .navigationDestination(for: Carrier.self) { carrier in
        SelectCarrierView(carrier: carrier)
    }
    
}
```
1. We initialize an empty array of carriers to act as our path. Since the array is empty, that means we are at the root view. However, this presents an **issue** when it comes to paths that require many different view types; such is the case with the PrePass app since we will have to navigate from a selection of carriers to a selection of vehicles. More on this issue and its work-around will be discussed below.
2. NavigationStack then takes this element as a binding using `$` so that it can read and write to the path.

## Navigation for different View types
In order to create a stack that can present more than one kind of view, we can add multiple `navigationDestination(for:destination:)` modifiers inside the stack's view heirarchy.

In order to create a path for programattic navigation that contains more than one kind of data, you can use Apple's new type-erasing `NavigationPath` instance as the path.

## NavigationPath
`NavigationPath` is a type-erased list of data representing the content of a navigation stack. This feature will also be available with the release of iOS 16. Documentation for `NavigationPath` can be found [here](https://developer.apple.com/documentation/swiftui/navigationpath).

### Declaration
```swift
struct NavigationPath
```

### Overview
You can manage the state of a `NavigationStack` by initializing the stack with a binding to a collection of data. The stack stores data items in the collection for each view on the stack. You also can read and write the collection to observe and alter the stack’s state.

When a stack displays views that rely on only one kind of data, you can use a standard collection, like an array, to hold the data. If you need to present different kinds of data in a single stack, use a navigation path instead. The path uses type erasure so you can manage a collection of heterogeneous elements. The path also provides the usual collection controls for adding, counting, and removing data elements.

### Serializing the path
When the values you present on the navigation stack conform to the `Codable` protocol, you can use the path’s `codable` property to get a serializable representation of the path. Use that representation to save and restore the contents of the stack. For example, you can define an `ObservableObject` that handles serializing and deserializing the path:
```swift
class MyModelObject: ObservableObject {
    @Published var path: NavigationPath

    static func readSerializedData() -> Data? {
        // Read data representing the path from app's persistent storage.
    }

    static func writeSerializedData(_ data: Data) {
        // Write data representing the path to app's persistent storage.
    }

    init() {
        if let data = Self.readSerializedData() {
            do {
                let representation = try JSONDecoder().decode(
                    NavigationPath.CodableRepresentation.self,
                    from: data)
                self.path = NavigationPath(representation)
            } catch {
                self.path = NavigationPath()
            }
        } else {
            self.path = NavigationPath()
        }
    }

    func save() {
        guard let representation = path.codable else { return }
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(representation)
            Self.writeSerializedData(data)
        } catch {
            // Handle error.
        }
    }
}
```
Then, using that object in your view, you can save the state of the navigation path when the `Scene` enters the `ScenePhase.background` state:
```swift
@StateObject private var pathState = MyModelObject()
@Environment(\.scenePhase) private var scenePhase

var body: some View {
    NavigationStack(path: $pathState.path) {
        // Add a root view here.
    }
    .onChange(of: scenePhase) { phase in
        if phase == .background {
            pathState.save()
        }
    }
}
```

## Important Notes about deprecated swift structs.
With the release of iOS 16, the struct `NavigationView` will be deprecated. It is recommended to to migrate to new navigation types. It is recommended to stop doing this:
```swift
NavigationView { // This is deprecated.
    /* content */
}
.navigationViewStyle(.stack)
```
 and instead do this:
 ```swift
 NavigationStack {
    /* content */
}
 ```
More information on migrating to `NavigationStack` can be found [here](https://developer.apple.com/documentation/swiftui/migrating-to-new-navigation-types).