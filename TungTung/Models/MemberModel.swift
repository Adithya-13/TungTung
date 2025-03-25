//
//  MemberModel.swift
//  TungTung
//
//  Created by M Zaidaan Nugroho on 21/03/25.
//

import Foundation
import SwiftData


@Model
class Member {
    var memberId: UUID = UUID()
    var name: String
    var amount: Double
    var isPaid: Bool
    
    init(name: String, amount: Double, isPaid: Bool){
        self.name = name
        self.amount = amount
        self.isPaid = isPaid
    }
}
