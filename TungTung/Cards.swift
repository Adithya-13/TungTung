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
        return formatter.string(from: NSNumber(value: patunganDetails.amount)) ?? "0"
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text(patunganDetails.title)
                .font(.title)

            Text("Sisa \(patunganDetails.members.count - Int(patunganDetails.paidParticipants)) orang")
                .font(.footnote)
                .foregroundColor(.gray)
                .padding(.bottom, 20)

            HStack {
                Spacer()
                Text("Rp\(formattedAmount)")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
            }

            ProgressView(value: Double(patunganDetails.paidParticipants) / Double(patunganDetails.members.count))
                .tint(.black)
        }
    }
}
