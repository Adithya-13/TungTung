//
//  ContentView.swift
//  TungTung
//
//  Created by Adithya Firmansyah Putra on 18/03/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack {
                NavigationLink(destination: AddPatunganView()) {
                    Text("Go to Destination")
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
