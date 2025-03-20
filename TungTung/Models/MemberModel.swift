//
//  MemberModel.swift
//  TungTung
//
//  Created by M Zaidaan Nugroho on 21/03/25.
//

import Foundation

struct Member: Codable {
    var memberId: UUID = UUID()
    var name: String
    var amount: Double
    var isPaid: Bool = false
}
