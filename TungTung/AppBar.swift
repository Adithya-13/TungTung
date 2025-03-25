//
//  AppBar.swift
//  TungTung
//
//  Created by M Zaidaan Nugroho on 18/03/25.
//

import SwiftUI

struct AppBar: View{
    var title: String
    
    var body: some View{
        HStack {
            Text(title)
                .font(.largeTitle).fontWeight(.bold)
                .padding(.leading)
                .foregroundStyle(Color("PrimaryColor"))
            Spacer()
            NavigationLink(destination: AddPatunganView()){
                Image(systemName: "plus")
                    .padding(.trailing, 20)
                    .foregroundStyle(Color("PrimaryColor"))
                    .font(.title)
            }
        }
        .padding(.bottom)
    }
}
