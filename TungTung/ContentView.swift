//
//  ContentView.swift
//  TungTung
//
//  Created by Adithya Firmansyah Putra on 18/03/25.
//

import SwiftUI
import Lottie

struct Patungan: Codable{
    var id: UUID = UUID()
    var title: String = ""
    var amount: Int
    var members: [Member]
    var paymentOptions: [PaymentOption]
    var agreement: String = ""
    var paidParticipants: Int = 0
}

func saveToStorage(patungans: [Patungan]) {
    if let encoded = try? JSONEncoder().encode(patungans) {
        UserDefaults.standard.set(encoded, forKey: "savedPatungans")
    }
}

struct ContentView: View {
    
    @State private var patungans: [Patungan] = []
    
    private var animation: String = "frankensteinAnm.json"
    
    func loadFromStorage() {
        if let savedData = UserDefaults.standard.data(forKey: "savedPatungans"),
            let decoded = try? JSONDecoder().decode([Patungan].self, from: savedData) {
            patungans = decoded
        }
    }
    
    private func deletePatungan(at offsets: IndexSet) {
        patungans.remove(atOffsets: offsets)
        saveToStorage(patungans: patungans)
    }
    
    var body: some View {
        NavigationStack {
            AppBar(patungans: $patungans, title: "TungTung!")
            VStack {
                if patungans.isEmpty {
                    VStack {
                        LottieView(animation: .named(animation))
                            .playbackMode(.playing(.toProgress(1, loopMode: .loop)))
                            .resizable()
                            .frame(width: 350, height: 350)
                            .scaledToFit()
                        Text("Belum ada patungan")
                            .font(.footnote)
                            .padding(.bottom)
                        
                        NavigationLink(destination: AddPatunganView(patungans: $patungans)){
                            Label("Tambahkan Patungan", systemImage: "plus")
                                .foregroundStyle(Color.white)
                                .padding()
                                .frame(width: 250, height: 50)
                                .background(Color("PrimaryColor"))
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
                            .font(.title)
                            .frame(maxWidth: .infinity)
                            .padding(.top)
                            .foregroundStyle(Color("TintedOrange"))
                            .background(Color("PrimaryColor"))
                    }
                }
                
            }
            .onAppear(perform: loadFromStorage)
        }
    }
}

#Preview {
    ContentView()
}
