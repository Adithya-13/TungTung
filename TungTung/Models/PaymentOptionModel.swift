//
//  PaymentOptionModel.swift
//  TungTung
//
//  Created by M Zaidaan Nugroho on 21/03/25.
//

import Foundation

struct PaymentOption: Codable {
    var paymentOptionId: UUID = UUID()
    var accountNumber: String
    var bankName: String
    var owner: String
}
