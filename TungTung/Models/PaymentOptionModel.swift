//
//  PaymentOptionModel.swift
//  TungTung
//
//  Created by M Zaidaan Nugroho on 21/03/25.
//

import Foundation
import SwiftData

@Model
class PaymentOption{
    var paymentOptionId: UUID = UUID()
    var accountNumber: String
    var bankName: String
    var owner: String
    
    init(accountNumber: String, bankName: String, owner: String){
        self.accountNumber = accountNumber
        self.bankName = bankName
        self.owner = owner
    }
}
