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

    var body: some View {
        NavigationStack {
            AppBar(patungans: $patungans, title: "TungTung!")
            Divider()
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
                                .background(Color("Orange"))
                                .cornerRadius(15)
                                .shadow(color: Color.black.opacity(0.2), radius: 5, x:0, y:5)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView{
                        VStack(spacing: 15){
                            ForEach(patungans, id: \.id){patunganDetails in
                                NavigationView {
                                    NavigationLink(destination: DetailPatungan()) {
                                        Cards(patunganDetails:patunganDetails)
                                    }
                                }
                            }
                        }
                    }
                }
                
            }
            .background(Color.gray.opacity(0.1))
        }
    }
}

#Preview {
    ContentView()
}
