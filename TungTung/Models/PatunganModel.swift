//
//  PatunganModel.swift
//  TungTung
//
//  Created by M Zaidaan Nugroho on 21/03/25.
//

import Foundation

struct Patungan: Codable{
    var id: UUID = UUID()
    var title: String = ""
    var amount: Int
    var members: [Member]
    var paymentOptions: [PaymentOption]
    var agreement: String = ""
    var accumulatedAmount: Double {
        members.filter(\.isPaid).map { Double($0.amount) }.reduce(0, +)
    }
    var paidParticipants: Int {
        members.filter { $0.isPaid }.count
    }
}
