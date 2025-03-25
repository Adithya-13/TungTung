//
//  ContentView.swift
//  TungTung
//
//  Created by Adithya Firmansyah Putra on 18/03/25.
//

import SwiftUI
import SwiftData
import Lottie

//func saveToStorage(patungans: [Patungan]) {
//    if let encoded = try? JSONEncoder().encode(patungans) {
//        UserDefaults.standard.set(encoded, forKey: "savedPatungans")
//    }
//}

struct ContentView: View {
    @Query var patungans: [Patungan] = []
    
    private var animation: String = "frankensteinAnm.json"
    
    /*
    func deleteAllPatungans() {
        patungans.removeAll()
        UserDefaults.standard.removeObject(forKey: "savedPatungans")
    }*/
    
//    private func deletePatungan(id: UUID) {
//        patungans.removeAll { $0.id == id } // Remove by ID
//        saveToStorage(patungans: patungans)
//    }
//    
//    private func loadFromStorage() {
//        if let savedData = UserDefaults.standard.data(forKey: "savedPatungans"),
//            let decoded = try? JSONDecoder().decode([Patungan].self, from: savedData) {
//            patungans = decoded
//        }
//    }
    
    var body: some View {
        NavigationStack {
            AppBar(title: "TungTung!")
            VStack {
                if patungans.isEmpty {
                    VStack {
                        LottieView(animation: .named(animation))
                            .playbackMode(.playing(.toProgress(1, loopMode: .loop)))
                            .resizable()
                            .frame(width: 350, height: 350)
                            .scaledToFit()
                        Text("Belum ada patungan nih      ")
                            .font(.footnote)
                            .padding(.bottom)
                        
                        NavigationLink(destination: AddPatunganView()){
                            Label("Tambahkan Patungan", systemImage: "plus")
                                .font(.subheadline)
                                .foregroundStyle(Color.black)
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
                        ForEach(patungans) { patunganDetails in
                            Section() {
                                Cards(patunganDetails: patunganDetails/*, updatePatungan: {saveToStorage(patungans: patungans)}, requestDelete: deletePatungan*/)
                            }
                            .listSectionSpacing(15)
                        }
                    }
                    NavigationLink(destination: AddPatunganView()){
                        Label("Tambahkan Patungan", systemImage: "plus")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.top)
                            .foregroundStyle(Color.black)
                            .background(Color("PrimaryColor"))
                    }
                }
                
            }
            //.onAppear(perform: loadFromStorage)
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
}
