# Navigation Architechture

## AppTabBar changes
It will probably be best if each tab item in `AppTabBar` is it's own `NavigationStack` since each tab item and their succeeding views use fairly different data.
A nice thing about this implementation is that in theory, since each NavigationStack will keep track of it's own path, one could navigate to another tab and then back and should still be on the view they were previously on.
```swift
struct AppTabBar: View {
	@State private var selectedTab: Tab = .drive

    // currently only SelectCarrierView and MoreView really have data and paths thar require keeping track of.
    // however, more paths can be implemented via a similar fashion as below.
    @StateObject private var carrierPath = CarrierPathManager()
    @StateObject private var morePath = MorePathManager()
    @Environment(\.scenePhase) private var scenePhase

	var body: some View {

		TabView(selection: $selectedTab) {

			NavigationStack($carrierPath) {
                SelectCarrierView()
			}
			.tabItem {
				Image("WheelIcon")
				Text("drive")
			}
			.tag(Tab.drive)

			NavigationStack {
                PreviousDecisionsView()
			}
			.tabItem {
				Image("DecisionsIcon")
				Text("decisions")
			}
			.tag(Tab.decisions)

			NavigationStack {
				ProfileView()
			}
			.tabItem {
				Image("ProfileIcon")
				Text("profile")
			}
			.tag(Tab.profile)

			NavigationStack {
				SettingsView()
			}
			.tabItem {
				Image("SettingsIcon")
				Text("settings")
			}
			.tag(Tab.settings)

			NavigationStack($morePath) {
				MoreView()
                    .onCarriersTap {
                        UserStoredSettings.defaultCarrier = nil
                        UserStoredSettings.defaultVehicle = nil
                        selectedTab = .drive
                    }
			}
			.tabItem {
				Image("MoreTabIcon")
				Text("more")
			}
			.tag(Tab.more)
		}
		.accentColor(Color.blueVariant5)
		.onChange(of: selectedTab) { newValue in
			guard newValue != .more else {
				return
			}
		}
	}
}
```
This implementation will use an observable object to write and read the stack paths. This will look something like the following:
```swift
class CarrierPathManager: ObservableObject {
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

### Inside SelectCarrierView
Inside `SelectCarrierView` and it's succeeding views, we will use `NavigationLink` and the new `.navigationDestination`
The following code snippet does not contain all of the code used in `SelectCarrierView` and is for demo purposes only.
```swift
struct SelectCarrierView: View {
    // this is not how the data for carriers is actually implemented and is only for demo purposes
    let carriers = [Carriers]

	var body: some View {
		List(carriers) { carrier in
            // This Navigation link uses the init<P>(value: P?, label: () -> Label)
            // where Label is a view
            NavigationLink(value: carrier) {
                SelectCarrierRow()
            }
        }
        .navigationDestination(Carrier.self) { carrier in
            SelectVehicleView(carrier: carrier)
        }
    }
}	
```
### Inside SelectVehicleView
The following code snippet does not contain all of the code used in `SelectVehicleView` and is for demo purposes only.
```swift
struct SelectVehicleView: View {
    // this is not how the data for vehicles is actually implemented and is only for demo purposes
    let vehicles = [Vehicle]

	var body: some View {
		List(vehicles) { vehicle in
            NavigationLink(value: vehicle) {
                SelectVehicleRow()
            }
        }
        .navigationDestination(Vehicle.self) { vehicle in
            // I think it would probably be a good idea to nav to CurrentVehicle before
            // starting drvie mode, and drive mode should be started inside of 
            // CurrentVehicle instead of SelectVehicleView
            CurrentVehicle(vehicle: vehicle)
        }
    }
}	
```
### Inside CurrentVehicle
Since `CurrentVehicle` does not require us to nav to a different view at the moment, then it unnessary to use any `NavigationLink`(s) in said view. This may change if we decide to use a map instead of the current implementation of drive mode.

### Inside MoreView
The following code snippet does not contain all of the code used in `MoreView` and is for demo purposes only.
```swift
struct MoreView: View {

    var body: some View {
        List {
            // the NavigationLink(s) in this view will use
            // init(label: () -> Label, destination: () -> Destination)
            // where Destination is a View
            // Label is using init(localizedStringKey, image: String)
            NavigationLink(destination: { SelectCarrierView() }) {
                Label("Carriers", image: "CarriersIcon")
            }
            NavigationLink(destination: { FAQsView() }) {
                Label("FAQs", image: "FAQIcon")
            }
            NavigationLink(destination: { PoliciesView() }) {
                Label("Policies", image: "PolicyIcon")
            }
            NavigationLink(destination: { SummonPage() }) {
                Label("Summon Elements", image: "SummonIcon")
            }
        }
    }
}
```