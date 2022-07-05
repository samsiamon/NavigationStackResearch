////
////  PathModelObject.swift
////  NavStackTestApp
////
////  Created by Sam.Siamon on 7/5/22.
////
//
//import Foundation
//import SwiftUI
//
//class PathModelObject: ObservableObject {
//    @Published var path: NavigationPath
//
//    static func readSerializedData() -> Data? {
//        // Read data representing the path from app's persistent storage.
//    }
//
//    static func writeSerializedData(_ data: Data) {
//        // Write data representing the path to app's persistent storage.
//    }
//
//    init() {
//        if let data = Self.readSerializedData() {
//            do {
//                let representation = try JSONDecoder().decode(
//                    NavigationPath.CodableRepresentation.self,
//                    from: data)
//                self.path = NavigationPath(representation)
//            } catch {
//                self.path = NavigationPath()
//            }
//        } else {
//            self.path = NavigationPath()
//        }
//    }
//
//    func save() {
//        guard let representation = path.codable else { return }
//        do {
//            let encoder = JSONEncoder()
//            let data = try encoder.encode(representation)
//            Self.writeSerializedData(data)
//        } catch {
//            fatalError("could not save path")
//        }
//    }
//}
