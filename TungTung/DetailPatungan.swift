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
    
    /*
    func generatePatunganDetail() -> String {
        
        let paymentOptions = """
        🏦 Opsi Pembayaran:
        1. BCA - 4181011739 (Adithya Firmansyah P.)
        2. Mandiri - 137-00-1234567-8 (Kiki Rahmadani)
        3. BNI - 0641234567 (Zaidan Akbar)
        """
        
        let rules = """
        📌 Aturan Perjanjian:
        - Kirim bukti ke PC kalau sudah bayar
        - Max tanggal 29 Maret
        """
        
        return "\(patunganDetails.title)\n\(patunganDetails.amount)\(remaining)\n👥 Kontribusi Anggota:\n\(patunganDetails.members)\n\n\(paymentOptions)\n\n\(rules)"
    }*/

    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(patunganDetails.title)
                            .font(.headline)
                            .fontWeight(.semibold)
                        Text("Sisa \(remaining, format: .currency(code: "IDR"))")
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundColor(Color("PrimaryColor"))
                        
                        Text("Dari \(patunganDetails.amount, format: .currency(code: "IDR"))")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
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
                            Text(member.name)
                                .frame(width: 100, alignment: .leading)
                            Spacer()
                            Text("\(member.amount, format: .currency(code: "IDR"))")
                                .frame(width: 200, alignment: .trailing)
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
                            .buttonStyle(PlainButtonStyle())
                        }
                        .padding(.vertical, 4)
                    }
                }
                
                Section(header: Text("Opsi Pembayaran").font(.subheadline)) {
                    VStack(alignment: .leading, spacing: 12) {
                        ForEach($patunganDetails.paymentOptions, id: \.paymentOptionId){$paymentOption in
                            VStack(spacing: 12) {
                                BankCardView(bankName: paymentOption.bankName, accountNumber: paymentOption.accountNumber, owner: paymentOption.owner)
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
                    //let detailText = generatePatunganDetail()
                    //UIPasteboard.general.setValue(detailText, forPasteboardType: "public.utf8-plain-text")
                        
                    print("Copied to clipboard: ")
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
            .navigationTitle("Detail Patungan")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
             
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {presentationMode.wrappedValue.dismiss()}) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(Color("PrimaryColor"))
                    }
                }
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: {
                        //let detailText = generatePatunganDetail()
                        //UIPasteboard.general.setValue(detailText, forPasteboardType: "public.utf8-plain-text")
                            
                        print("Copied to clipboard: ")
                    }) {
                        Image(systemName: "document.on.document")
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
    }
    
    struct CheckboxToggleStyle: ToggleStyle {
        func makeBody(configuration: Configuration) -> some View {
            Button(action: {
                configuration.isOn.toggle()
            }) {
                Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(configuration.isOn ? Color("PrimaryColor") : .tintedOrange)
            }
        }
    }
    
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

