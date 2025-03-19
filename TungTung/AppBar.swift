//
//  AppBar.swift
//  TungTung
//
//  Created by M Zaidaan Nugroho on 18/03/25.
//

import SwiftUI

struct AppBar: View{
    @Binding var patungans : [Patungan]
    var title: String
    
    var body: some View{
        HStack {
                    Text(title)
                        .font(.largeTitle)
                        .padding(.leading)
                    Spacer()
            NavigationLink(destination: AddPatunganView(patungans: $patungans)){
                Image(systemName: "plus")
                    .padding(.trailing)
                    .foregroundColor(.black)
                    .font(.title)
            }
                }
                .frame(height: 50)
                .background(Color.white)
    }
}
