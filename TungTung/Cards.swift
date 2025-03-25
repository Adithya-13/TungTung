//
//  Cards.swift
//  TungTung
//
//  Created by M Zaidaan Nugroho on 18/03/25.
//

import SwiftUI

struct Cards: View {
    @Bindable var patunganDetails: Patungan
//    var updatePatungan: () -> Void
//    var requestDelete: (UUID) -> Void
    
    private func formattedAmount(amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        formatter.usesGroupingSeparator = true
        return formatter.string(from: NSNumber(value: amount)) ?? "0"
    }

    var body: some View {
        
<<<<<<< Updated upstream
        NavigationLink(destination: DetailPatungan(patunganDetails: patunganDetails)) {
=======
        NavigationLink(destination: DetailPatungan(patunganDetails: patunganDetails/*, onUpdate: updatePatungan, deleteThisPatungan: requestDelete*/)) {
>>>>>>> Stashed changes
            VStack(alignment: .leading) {
                Text(patunganDetails.title)
                    .font(.title)

                Text("Sisa \(patunganDetails.members.count - Int(patunganDetails.paidParticipants)) orang")
                    .font(.footnote)
                    .foregroundColor(.gray)

                VStack(alignment: .leading){
                    HStack {
                        Spacer()
                        Text("\(patunganDetails.accumulatedAmount, format: .currency(code: "IDR"))")
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color("PrimaryColor"))
                    }
                    HStack {
                        Spacer()
                        Text("/ \(patunganDetails.amount, format: .currency(code: "IDR"))")
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
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
