//
//  Cards.swift
//  TungTung
//
//  Created by M Zaidaan Nugroho on 18/03/25.
//

import SwiftUI

struct Cards: View {
    let patunganDetails: Patungan

    var formattedAmount: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        formatter.usesGroupingSeparator = true
        return formatter.string(from: NSNumber(value: (patunganDetails.amount/patunganDetails.members.count)*patunganDetails.paidParticipants)) ?? "0"
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text(patunganDetails.title)
                .font(.title)

            Text("Sisa \(patunganDetails.members.count - Int(patunganDetails.paidParticipants)) orang")
                .font(.footnote)
                .foregroundColor(.gray)

            HStack {
                Spacer()
                Text("Rp\(formattedAmount)")
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color("PrimaryColor"))
            }

            ProgressView(value: Double(patunganDetails.paidParticipants) / Double(patunganDetails.members.count))
                .progressViewStyle(LinearProgressViewStyle())
                .frame(height: 8)
                .accentColor(Color("PrimaryColor"))
                .cornerRadius(5)
                .padding(.bottom)
        }
    }
}
