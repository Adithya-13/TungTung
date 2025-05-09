import SwiftUI

struct DetailPatungan: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.modelContext) private var modelContext
    
    @Bindable var patunganDetails: Patungan
    //    var onUpdate: () -> Void
    //    var deleteThisPatungan: (UUID) -> Void
    
    //    var onUpdate: () -> Void
    //    var deleteThisPatungan: (UUID) -> Void
    
    private var remaining: Double {
        let amount = patunganDetails.amount
        let accumulatedAmount = patunganDetails.accumulatedAmount
        return Double(amount) - accumulatedAmount
    }
    
    func generatePatunganDetail() -> String {
        let title = patunganDetails.title
        let totalAmount = patunganDetails.amount
        
        let membersText = patunganDetails.members.map { member in
            "- \(member.name): \(formatToRupiah(member.amount)) \(member.isPaid ? "(Lunas ✅)" : "(Belum Lunas ❌)")"
        }.joined(separator: "\n")
        
        let paymentOptionsText = patunganDetails.paymentOptions.map { option in
            "- \(option.bankName): \(option.accountNumber) (\(option.owner))"
        }.joined(separator: "\n")
        
        let agreement = patunganDetails.agreement
        var detailText = """
           📌 Detail Patungan
           \(title)
           
           💰 Total Dana: \(formatToRupiah(totalAmount))
           💵 Sisa Kebutuhan: \(formatToRupiah(remaining))
           
           👥 Kontribusi Anggota:
           \(membersText)
           
           🏦 Opsi Pembayaran:
           \(paymentOptionsText)
           
           """
        
        if !agreement.isEmpty {
            detailText += """
               
               📜 Aturan Perjanjian:
               \(agreement)
               """
        }
        
        detailText += "\n\nBy TungTung Apps!"
        
        return detailText
    }
    
    func formatToRupiah(_ amount: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale(identifier: "id_ID")
        numberFormatter.numberStyle = .currency
        numberFormatter.currencySymbol = "Rp"
        numberFormatter.maximumFractionDigits = 0
        
        return numberFormatter.string(from: NSNumber(value: amount)) ?? "Rp0"
    }
    
    func formatToRupiah(_ amount: Double) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale(identifier: "id_ID")
        numberFormatter.numberStyle = .currency
        numberFormatter.currencySymbol = "Rp"
        numberFormatter.maximumFractionDigits = 0
        
        return numberFormatter.string(from: NSNumber(value: amount)) ?? "Rp0"
    }
    
    @State var showToast = false
    @State var isAlertPresented = false
    
    
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
                                    try? modelContext.save()
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
                    
                    if !patunganDetails.agreement.isEmpty {
                        Section(header: Text("Aturan Perjanjian").font(.subheadline)) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text(patunganDetails.agreement)
                            }
                            .font(.subheadline)
                        }
                    }
                    
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
                ShareLink(item: generatePatunganDetail()){
                    Image(systemName: "square.and.arrow.up")
                        .foregroundStyle(Color("PrimaryColor"))
                }
                //                    Button(action: {
                //                        let detailText = generatePatunganDetail()
                //                        UIPasteboard.general.string = detailText
                //                        //print("Copied to clipboard: \(detailText)")
                //
                //                        withAnimation(.easeInOut(duration: 0.3)) {
                //                            showToast = true
                //                        }
                //
                //                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                //                            withAnimation(.easeInOut(duration: 0.3)) {
                //                                showToast = false
                //                            }
                //                        }
                //                    }) {
                //                        Image(systemName: "doc.on.doc")
                //                            .foregroundColor(Color("PrimaryColor"))
                //                    }
                Button(action: {
                    isAlertPresented = true
                }) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
            }
        }
        .alert("Hapus Patungan?", isPresented: $isAlertPresented, actions: {
            Button("Batal", role: .cancel) {
                isAlertPresented = false
            }
            Button("Hapus", role: .destructive) {
                modelContext.delete(patunganDetails)
                presentationMode.wrappedValue.dismiss()
            }
        }, message: {
            Text("Anda akan menghapus patungan ini secara permanen. Lanjutkan?")
        })
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
            .background(Color(.tertiarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.white.opacity(0.2))
            )
        }
    }
    
    
}

