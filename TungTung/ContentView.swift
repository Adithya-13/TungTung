//
//  ContentView.swift
//  TungTung
//
//  Created by Adithya Firmansyah Putra on 18/03/25.
//

import SwiftUI

struct Patungan: Codable{
    var id: UUID = UUID()
    var title: String
    var members: [Member]
    var paymentOptions: [PaymentOption]
    var paidParticipants = 0
    var amount: Int
}

struct ContentView: View {
    @State private var patungans: [Patungan] = []
    func loadFromStorage() {
        if let savedData = UserDefaults.standard.data(forKey: "savedPatungans"),
            let decoded = try? JSONDecoder().decode([Patungan].self, from: savedData) {
            patungans = decoded
        }
    }
    
    func saveToStorage() {
        if let encoded = try? JSONEncoder().encode(patungans) {
            UserDefaults.standard.set(encoded, forKey: "savedPatungans")
        }
    }
    
    func deletePatungan(at offsets: IndexSet) {
        patungans.remove(atOffsets: offsets)
        saveToStorage()
    }

    var body: some View {
        NavigationStack {
            VStack {
                if patungans.isEmpty {
                    VStack {
                        Text("Belum ada patungan")
                            .font(.footnote)
                            .padding(.bottom)
                        
                        NavigationLink(destination: AddPatunganView(patungans: $patungans)){
                            Label("Tambahkan Patungan", systemImage: "plus")
                                .foregroundStyle(Color.white)
                                .padding()
                                .frame(width: 250, height: 50)
                                .background(Color("HueOrange"))
                                .cornerRadius(15)
                                .shadow(color: Color.black.opacity(0.2), radius: 5, x:0, y:5)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        ForEach(patungans, id: \.id) { patunganDetails in
                            Cards(patunganDetails: patunganDetails)
                        }
                        .onDelete(perform: deletePatungan)
                    }
                    NavigationLink(destination: AddPatunganView(patungans: $patungans)){
                        Image(systemName: "plus")
                            .frame(maxWidth: .infinity)
                            .padding(.top)
                            .foregroundStyle(Color("TintedOrange"))
                            .background(Color("ShadedOrange"))
                    }
                }
            }
            .onAppear(perform: loadFromStorage)
            .navigationTitle(Text("TungTung!"))
        }
    }
}

#Preview {
    ContentView()
}
