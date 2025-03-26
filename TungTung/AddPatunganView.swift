import SwiftUI

struct AddPatunganView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var title = ""
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
    
    @State private var showErrorMessage = false
    
    func isValid() -> Bool {
        return !title.isEmpty && amount != 0 && !members.isEmpty && members.count > 1 && !paymentOptions.isEmpty
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
                
                Section(header: Text("Aturan Perjanjian")) {
                    ZStack(alignment: .topLeading) {
                        if agreementRule.isEmpty {
                            Text("Contoh: Max tanggal 20 Mei")
                                .foregroundColor(Color("Placeholder"))
                                .padding(.vertical, 12)
                        }
                        
                        TextEditor(text: $agreementRule)
                            .submitLabel(.done)
                            .background(Color.clear)
                            .cornerRadius(8)
                            .padding(.horizontal, -4)
                            .accentColor(Color("PrimaryColor"))
                        
                    }
                    .frame(minHeight: 150)
                }
                
                Button {
                    if isValid() {
                        let newPatungan = Patungan(
                            title: title,
                            amount: amount ?? 0,
                            members: members,
                            paymentOptions: paymentOptions,
                            agreement: agreementRule
                        )
                        //                    patungans.append(newPatungan)
                        //                    saveToStorage(patungans: patungans)
                        modelContext.insert(newPatungan)
                        try? modelContext.save()
                        dismiss()
                    }
                    else{
                        showErrorMessage.toggle()
                    }
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
                .alert("Error", isPresented: $showErrorMessage, actions: {
                    Button("Ok", role: .cancel) {
                        showErrorMessage.toggle()
                    }
                }, message: {
                    Text("Lengkapi data, semua form harus diisi")
                })
                
                
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
            Text("Member baru")
                .font(.headline)
                .padding()
            
            TextField("Masukkan nama anggota", text: $newMemberName)
                .padding()
                .accentColor(Color("PrimaryColor"))
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            HStack {
                Button("Batal") {
                    onCancel()
                }
                .foregroundColor(Color("PrimaryColor"))
                Spacer()
                Button("Simpan") {
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
            Text("Opsi Pembayaran Baru")
                .font(.headline)
                .padding()
            
            TextField("Nomor Rekening", text: $newPaymentAccount)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .accentColor(Color("PrimaryColor"))
                .keyboardType(.numberPad)
            
            TextField("Nama Bank/E-Wallet", text: $newPaymentBank)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .accentColor(Color("PrimaryColor"))
            
            TextField("Pemilik Rekening", text: $newPaymentOwner)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .accentColor(Color("PrimaryColor"))
            
            HStack {
                Button("Batal") {
                    onCancel()
                }
                .foregroundColor(Color("PrimaryColor"))
                Spacer()
                Button("Simpan") {
                    onSave()
                }
                .foregroundColor(Color("PrimaryColor"))
            }
            .padding()
        }
        .padding()
    }
}
