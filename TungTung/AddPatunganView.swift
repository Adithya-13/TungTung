import SwiftUI

struct Member: Codable {
    var name: String
    var amount: Double
}

struct PaymentOption: Codable {
    var accountNumber: String
    var bankName: String
    var owner: String
}

struct AddPatunganView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var patungans: [Patungan]
    
    @State private var title = ""
    @State private var price: String = ""
    @State private var amount: Int = 0
    @State private var members: [Member] = []
    @State private var paymentOptions: [PaymentOption] = []
    @State private var agreementRule = ""
    
    @State private var newMemberName = ""
    @State private var newPaymentAccount = ""
    @State private var newPaymentBank = ""
    @State private var newPaymentOwner = ""
    
    @State private var showAddMemberSheet = false
    @State private var showAddPaymentSheet = false
    @State private var memberAmount: Double = 0.0
    
    func saveToStorage() {
        if let encoded = try? JSONEncoder().encode(patungans) {
            UserDefaults.standard.set(encoded, forKey: "savedPatungans")
        }
    }
        
        
    func calculateMemberAmount(amount: Int, members: inout [Member]) {
        guard amount > 0 else {
            for index in members.indices {
                members[index].amount = 0.0
            }
            return
        }

        let numberOfMembers = Double(members.count)
        if numberOfMembers > 0 {
            let memberAmount = Double(amount) / numberOfMembers
            for index in members.indices {
                members[index].amount = memberAmount
            }
        }
    }
        
    func deleteMember(at offsets: IndexSet) {
        members.remove(atOffsets: offsets)
    }
        
    func deletePaymentOption(at offsets: IndexSet) {
            paymentOptions.remove(atOffsets: offsets)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Judul Patungan")) {
                    TextField("Contoh: Nobar Interstellar", text: $title)
                        .background(Color.clear)
                        .cornerRadius(8)
                }
                
                Section(header: Text("Jumlah Harga")) {
                    HStack {
                        Text("Rp")
                        TextField("500.000", text: $price)
                            .keyboardType(.numberPad)
                            .onChange(of: price) { newValue in
                                let filtered = newValue.filter { "0123456789".contains($0) }
                                if filtered != newValue {
                                    price = filtered // Remove invalid characters
                                }
                                amount = Int(price) ?? 0
                                calculateMemberAmount(amount: amount, members: &members)
                            }
                            .background(Color.clear)
                            .cornerRadius(8)
                    }
                }

                Section(header: Text("Tambah Orang")) {
                    ForEach(members, id: \.name) { member in
                        HStack {
                            Text(member.name)
                            Spacer()
                            Text("Rp \(member.amount, specifier: "%.2f")") // Format the amount
                        }
                    }.onDelete(perform: deleteMember)
                    Button("Tambah Orang") {
                        // Show sheet to add a new member
                        showAddMemberSheet.toggle()
                    }
                    .sheet(isPresented: $showAddMemberSheet) {
                        AddMemberSheet(newMemberName: $newMemberName, onSave: {
                            if !newMemberName.isEmpty {
                                members.append(Member(name: newMemberName, amount: memberAmount))
                                newMemberName = "" // ✅ Clear input field
                                calculateMemberAmount(amount: amount, members: &members)
                                showAddMemberSheet.toggle()
                            }
                        }, onCancel: {
                            newMemberName = "" // ✅ Also clear on cancel
                            showAddMemberSheet.toggle()
                        })
                    }
                }

                Section(header: Text("Tambah Opsi Pembayaran")) {
                    ForEach(paymentOptions, id: \.accountNumber) { option in
                        HStack {
                            Text(option.accountNumber)
                            Spacer()
                            Text(option.bankName)
                            Spacer()
                            Text(option.owner)
                        }
                    }.onDelete(perform: deletePaymentOption)
                    Button("Tambah Opsi Pembayaran") {
                        // Show sheet to add a new payment option
                        showAddPaymentSheet.toggle()
                    }
                    .sheet(isPresented: $showAddPaymentSheet) {
                        AddPaymentSheet(newPaymentAccount: $newPaymentAccount, newPaymentBank: $newPaymentBank, newPaymentOwner: $newPaymentOwner, onSave: {
                            if !newPaymentAccount.isEmpty && !newPaymentBank.isEmpty && !newPaymentOwner.isEmpty {
                                // Add new payment option to the list
                                paymentOptions.append(PaymentOption(accountNumber: newPaymentAccount, bankName: newPaymentBank, owner: newPaymentOwner))
                                newPaymentAccount = "" // Clear the input fields
                                newPaymentBank = ""
                                newPaymentOwner = ""
                                showAddPaymentSheet.toggle()
                            }
                        }, onCancel: {
                            
                            newPaymentAccount = ""
                            newPaymentBank = ""
                            newPaymentOwner = ""
                            showAddPaymentSheet.toggle()
                        })
                    }
                }

                Section(header: Text("Agreement Rule")) {
                    TextEditor(text: $agreementRule)
                        .background(Color.clear)
                        .cornerRadius(8)
                        .padding(.horizontal)
                }
                
                Button("Simpan") {
                    let newPatungan = Patungan(
                        title: title,
                        members: members,
                        paymentOptions: paymentOptions,
                        amount: amount)
                    patungans.append(newPatungan)
                    saveToStorage()
                    
                    dismiss()
                };
                }
                
                
            }
            .navigationTitle("Tambah Patungan")
            .navigationBarBackButtonHidden(false)
        }
    }


struct AddMemberSheet: View {
    @Binding var newMemberName: String
    var onSave: () -> Void
    var onCancel: () -> Void
    
    var body: some View {
        VStack {
            Text("New Member")
                .font(.headline)
                .padding()
            
            TextField("Enter member name", text: $newMemberName)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            HStack {
                Button("Cancel") {
                    onCancel()
                }
                .foregroundColor(.blue)
                Spacer()
                Button("Save") {
                    onSave()
                }
                .foregroundColor(.blue)
            }
            .padding()
        }
        .padding()
    }
}

struct AddPaymentSheet: View {
    @Binding var newPaymentAccount: String
    @Binding var newPaymentBank: String
    @Binding var newPaymentOwner: String
    var onSave: () -> Void
    var onCancel: () -> Void
    
    var body: some View {
        VStack {
            Text("New Payment Option")
                .font(.headline)
                .padding()
            
            TextField("Account Number", text: $newPaymentAccount)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("Bank Name", text: $newPaymentBank)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("Owner", text: $newPaymentOwner)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            HStack {
                Button("Cancel") {
                    onCancel()
                }
                .foregroundColor(.blue)
                Spacer()
                Button("Save") {
                    onSave()
                }
                .foregroundColor(.blue)
            }
            .padding()
        }
        .padding()
    }
}

