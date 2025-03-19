//
//  Cards.swift
//  TungTung
//
//  Created by M Zaidaan Nugroho on 18/03/25.
//

import SwiftUI

struct Cards: View {
    @Binding var patunganDetails: Patungan
    var updatePatungan: () -> Void
    var requestDelete: (UUID) -> Void

    var formattedAmount: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        formatter.usesGroupingSeparator = true
        return formatter.string(from: NSNumber(value: patunganDetails.accumulatedAmount)) ?? "0"
    }

    var body: some View {
        
        NavigationLink(destination: DetailPatungan(patunganDetails: $patunganDetails, onUpdate: updatePatungan, deleteThisPatungan: requestDelete)) {
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
}
