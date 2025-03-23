import SwiftUI

struct DetailPatungan: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var patunganDetails: Patungan
    var onUpdate: () -> Void
    var deleteThisPatungan: (UUID) -> Void
    
    private var remaining: Double {
        let amount = patunganDetails.amount
        let accumulatedAmount = patunganDetails.accumulatedAmount
        return Double(amount) - accumulatedAmount
    }
    
    func generatePatunganDetail() -> String {
        let title = patunganDetails.title
        let totalAmount = patunganDetails.amount

        let membersText = patunganDetails.members.map { member in
            "- \(member.name): Rp\(String(format: "%.2f", member.amount)) \(member.isPaid ? "(Lunas ✅)" : "(Belum Lunas ❌)")"
        }.joined(separator: "\n")
        
        let paymentOptionsText = patunganDetails.paymentOptions.map { option in
            "- \(option.bankName): \(option.accountNumber) (\(option.owner))"
        }.joined(separator: "\n")
        
        let agreement = patunganDetails.agreement
        
        return """
        📌 **Detail Patungan**
        \(title)
        
        💰 **Total Dana:** Rp\(totalAmount)
        💵 **Sisa Kebutuhan:** Rp\(String(format: "%.2f", remaining))
        
        👥 **Kontribusi Anggota:**
        \(membersText)
        
        🏦 **Opsi Pembayaran:**
        \(paymentOptionsText)
        
        📜 **Aturan Perjanjian:**
        \(agreement)
        """
    }
    
    @State private var showToast = false
    
    
    var body: some View {
        ZStack {
            NavigationStack {
                List {
                    Section {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(patunganDetails.title)
                                .font(.headline)
                                .fontWeight(.semibold)
                            
                            Text("\(patunganDetails.accumulatedAmount, format: .currency(code: "IDR"))")
                                .font(.title)
                                .fontWeight(.semibold)
                                .foregroundColor(Color("PrimaryColor"))
                            
                            HStack(spacing: 5) {
                                
                                Text("Terkumpul dari")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                
                                Text("\(patunganDetails.amount, format: .currency(code: "IDR"))")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                            }
                            
                            ProgressView(
                                value: Double(patunganDetails.paidParticipants),
                                total: Double(patunganDetails.members.count))
                            .progressViewStyle(LinearProgressViewStyle())
                            .frame(height: 8)
                            .accentColor(Color("PrimaryColor"))
                            .cornerRadius(5)
                            .padding(.top)
                        }
                        .padding(.vertical)
                        
                    }
                    
                    Section(header: Text("Kontribusi Anggota (\(patunganDetails.paidParticipants)/\(patunganDetails.members.count))").font(.subheadline)) {
                        ForEach($patunganDetails.members, id: \.memberId) { $member in
                            HStack {
                                Image(systemName: "person.fill")
                                    .foregroundColor(Color("PrimaryColor"))
                                Text(member.name)
                                    .frame(width: 100, alignment: .leading)
                                Spacer()
                                Text("\(member.amount, format: .currency(code: "IDR"))")
                                    .frame(alignment: .trailing)
                                    .fontWeight(.semibold)
                                    .padding(.trailing, 8)
                                
                                Button(action: {
                                    member.isPaid.toggle()
                                    onUpdate()
                                }) {
                                    Image(systemName: member.isPaid ? "checkmark.square.fill" : "square")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(member.isPaid ? Color("PrimaryColor") : .gray)
                                }
                                .padding(.vertical, 4)
                            }
                        }
                    }
                    
                    Section(header: Text("Opsi Pembayaran").font(.subheadline)) {
                        VStack(alignment: .leading, spacing: 12) {
                            ForEach($patunganDetails.paymentOptions, id: \.paymentOptionId) { $paymentOption in
                                BankCardView(bankName: paymentOption.bankName, accountNumber: paymentOption.accountNumber, owner: paymentOption.owner)
                                    .onLongPressGesture {
                                        let bankAccount = "\(paymentOption.owner) - \(paymentOption.bankName)\n\(paymentOption.accountNumber)"
                                        UIPasteboard.general.string = bankAccount
                                        //print(bankAccount)
                                        withAnimation(.easeInOut(duration: 0.3)) {
                                            showToast = true
                                        }
                                        
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                            withAnimation(.easeInOut(duration: 0.3)) {
                                                showToast = false
                                            }
                                        }
                                    }
                            }
                        }
                        .padding(.vertical)
                    }
                    
                    Section(header: Text("Aturan Perjanjian").font(.subheadline)) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(patunganDetails.agreement)
                        }
                        .font(.subheadline)
                    }
                    
                    Button(action: {
                        let detailText = generatePatunganDetail()
                        UIPasteboard.general.string = detailText
                        //print("Copied to clipboard: \(detailText)")
                        
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showToast = true
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                showToast = false
                            }
                        }
                    }) {
                        Text("Salin Detail Patungan")
                            .fontWeight(.semibold)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color("PrimaryColor"))
                            .foregroundStyle(.black)
                            .cornerRadius(8)
                    }
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets())
                    }
                }
                
                // **TOAST View**
                if showToast {
                    VStack {
                        Spacer()
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                            Text("Berhasil disalin!")
                                .font(.subheadline)
                                .foregroundColor(.black)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white)
                                .shadow(radius: 4)
                        )
                        .padding(.bottom, 50)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
            }
            .navigationTitle("Detail Patungan")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(Color("PrimaryColor"))
                    }
                }
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: {
                        let detailText = generatePatunganDetail()
                        UIPasteboard.general.string = detailText
                        //print("Copied to clipboard: \(detailText)")
                        
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showToast = true
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                showToast = false
                            }
                        }
                    }) {
                        Image(systemName: "doc.on.doc")
                            .foregroundColor(Color("PrimaryColor"))
                    }
                    Button(action: {
                        deleteThisPatungan(patunganDetails.id)
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                }
        }
    }
    
//    struct CheckboxToggleStyle: ToggleStyle {
//        func makeBody(configuration: Configuration) -> some View {
//            Button(action: {
//                configuration.isOn.toggle()
//            }) {
//                Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
//                    .resizable()
//                    .frame(width: 24, height: 24)
//                    .foregroundColor(configuration.isOn ? Color("PrimaryColor") : .tintedOrange)
//            }
//        }
//    }
    
    struct BankCardView: View {
        var bankName: String
        var accountNumber: String
        var owner: String
        
        @Environment(\.colorScheme) var colorScheme
        
        var body: some View {
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(accountNumber)
                        .font(.headline)
                        .bold()
                    Text(bankName)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text(owner)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .lineLimit(1)
                }
                Spacer()
                
                Image(systemName: "creditcard.fill")
                    .resizable()
                    .frame(width: 30, height: 20)
                    .foregroundColor(Color("PrimaryColor"))
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color(.tertiarySystemBackground)) // Background adaptif
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(colorScheme == .dark ? Color.white.opacity(0.2) : Color.black.opacity(0.1), lineWidth: 1) // Border adaptif
            )
        }
    }
    
    
}

