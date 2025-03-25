import SwiftUI

struct AddPatunganView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var title = ""
    @State private var price: String = ""
    @State private var amount: Int? = nil
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
    
    func isValid() -> Bool {
        return !title.isEmpty && !price.isEmpty && amount != nil && !members.isEmpty && !paymentOptions.isEmpty
    }
    
    
    private func calculateMemberAmount(amount: Int, members: inout [Member]) {
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
    
    private func deleteMember(at offsets: IndexSet) {
        members.remove(atOffsets: offsets)
    }
    
    private func deletePaymentOption(at offsets: IndexSet) {
        paymentOptions.remove(atOffsets: offsets)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Judul Patungan")) {
                    TextField("Contoh: Nobar Interstellar", text: $title)
                        .submitLabel(.next)
                        .background(Color.clear)
                        .accentColor(Color("PrimaryColor"))
                    
                }
                
                Section(header: Text("Jumlah Harga")) {
                    HStack {
                        TextField("500.000", value: $amount, format: .currency(code: "IDR"))
                            .keyboardType(.numberPad)
                            .submitLabel(.done)
                            .onChange(of: amount) {
                                calculateMemberAmount(amount: amount ?? 0, members: &members)
                            }
                            .accentColor(Color("PrimaryColor"))
                            .background(Color.clear)
                        
                    }
                }
                
                Section(header: Text("Orang")) {
                    ForEach(members, id: \.name) { member in
                        HStack {
                            Text(member.name)
                            Spacer()
                            Text("\(member.amount, format: .currency(code: "IDR"))") // Format the amount
                        }
                    }.onDelete(perform: deleteMember)
                    Button("Tambah Orang") {
                        // Show sheet to add a new member
                        showAddMemberSheet.toggle()
                    }
                    .foregroundStyle(Color("PrimaryColor"))
                    .sheet(isPresented: $showAddMemberSheet) {
                        AddMemberSheet(newMemberName: $newMemberName, onSave: {
                            if !newMemberName.isEmpty {
                                members.append(Member(name: newMemberName, amount: memberAmount, isPaid: false))
                                newMemberName = ""
                                calculateMemberAmount(amount: amount ?? 0, members: &members)
                                showAddMemberSheet.toggle()
                            }
                        }, onCancel: {
                            newMemberName = ""
                            showAddMemberSheet.toggle()
                        })
                    }
                }
                
                Section(header: Text("Opsi Pembayaran")) {
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
                    .foregroundStyle(Color("PrimaryColor"))
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
                        .submitLabel(.done)
                        .background(Color.clear)
                        .cornerRadius(8)
                        .padding(.horizontal)
                }
                
                Button {
                    let newPatungan = Patungan(
                        title: title,
                        amount: amount ?? 0,
                        members: members,
                        paymentOptions: paymentOptions,
                        agreement: agreementRule
                        )
<<<<<<< Updated upstream
<<<<<<< Updated upstream
=======
//                    patungans.append(newPatungan)
//                    saveToStorage(patungans: patungans)
>>>>>>> Stashed changes
=======
//                    patungans.append(newPatungan)
//                    saveToStorage(patungans: patungans)
>>>>>>> Stashed changes
                    modelContext.insert(newPatungan)
                    try? modelContext.save()
                    
                    dismiss()
                } label: {
                    Text("Simpan")
                        .fontWeight(.semibold)
                        .padding(.vertical, 20)
                        .frame(maxWidth: .infinity)
                        .background(isValid() ? Color("PrimaryColor") : Color.gray)
                        .foregroundStyle(isValid() ? .black : .white)
                        
                }
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .listRowBackground(Color.clear)
                .disabled(!isValid())
                
                
            }
            .scrollDismissesKeyboard(.immediately)
            .navigationTitle("Tambah Patungan")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(Color("PrimaryColor"))
                    }
                }
            }
        }
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
                .accentColor(Color("PrimaryColor"))
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            HStack {
                Button("Cancel") {
                    onCancel()
                }
                .foregroundColor(Color("PrimaryColor"))
                Spacer()
                Button("Save") {
                    onSave()
                }
                .foregroundColor(Color("PrimaryColor"))
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
                .accentColor(Color("PrimaryColor"))
            
            TextField("Bank Name", text: $newPaymentBank)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .accentColor(Color("PrimaryColor"))
            
            TextField("Owner", text: $newPaymentOwner)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .accentColor(Color("PrimaryColor"))
            
            HStack {
                Button("Cancel") {
                    onCancel()
                }
                .foregroundColor(Color("PrimaryColor"))
                Spacer()
                Button("Save") {
                    onSave()
                }
                .foregroundColor(Color("PrimaryColor"))
            }
            .padding()
        }
        .padding()
    }
}
