//
//  TungTungApp.swift
//  TungTung
//
//  Created by Adithya Firmansyah Putra on 18/03/25.
//

import SwiftUI
import SwiftData

@main
struct TungTungApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Patungan.self, Member.self, PaymentOption.self])
    }
}
