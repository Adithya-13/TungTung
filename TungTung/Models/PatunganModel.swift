//
//  PatunganModel.swift
//  TungTung
//
//  Created by M Zaidaan Nugroho on 21/03/25.
//

import Foundation
import SwiftData

@Model
class Patungan{
    var id: UUID = UUID()
    var title: String = ""
    var amount: Int
    @Relationship(deleteRule: .cascade) var members: [Member]
    @Relationship(deleteRule: .cascade) var paymentOptions: [PaymentOption]
    var agreement: String = ""
    var accumulatedAmount: Double {
        members.filter(\.isPaid).map { Double($0.amount) }.reduce(0, +)
    }
    var paidParticipants: Int {
        members.filter { $0.isPaid }.count
    }
    
    init(title: String, amount: Int, members: [Member], paymentOptions: [PaymentOption], agreement: String){
        self.title = title
        self.amount = amount
        self.members = members
        self.paymentOptions = paymentOptions
        self.agreement = agreement
    }
}
