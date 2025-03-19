import SwiftUI

struct DetailPatungan: View {
    
    @State private var selectedMembers: [String: Bool] = [
        "Adit": false,
        "Kiki": false,
        "Zaidan": false,
        "Jose": false,
        "Syatria": false
    ]
    
    let totalAmount = 500000
    let perPersonAmount = 100000
    
    var paidAmount: Int {
        selectedMembers.filter { $0.value }.count * perPersonAmount
    }
    
    func generatePatunganDetail() -> String {
        let title = "📌 Detail Patungan: Nobar Interstellar\n"
        let total = "💰 Total: Rp\(totalAmount)\n"
        let remaining = "🔻 Sisa: Rp\(totalAmount - paidAmount)\n"
        
        let contributors = selectedMembers.map { name, hasPaid in
            return hasPaid ? "✅ \(name) - Rp\(perPersonAmount)" : "❌ \(name) - Belum bayar"
        }.joined(separator: "\n")
        
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
        
        return "\(title)\n\(total)\(remaining)\n👥 Kontribusi Anggota:\n\(contributors)\n\n\(paymentOptions)\n\n\(rules)"
    }

    
    var body: some View {
        NavigationView {
            List {
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Nobar Interstellar")
                            .font(.headline)
                            .fontWeight(.semibold)
                        Text("Sisa Rp\(totalAmount - paidAmount)")
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundColor(Color("PrimaryColor"))
                        
                        Text("Dari Rp\(totalAmount)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        ProgressView(value: Double(paidAmount), total: Double(totalAmount))
                            .progressViewStyle(LinearProgressViewStyle())
                            .frame(height: 8)
                            .accentColor(Color("PrimaryColor"))
                            .cornerRadius(5)
                            .padding(.top)
                    }
                    .padding(.vertical)
                    
                }
                
                Section(header: Text("Kontribusi Anggota").font(.subheadline)) {
                    ForEach(selectedMembers.keys.sorted(), id: \ .self) { name in
                        HStack {
                            Text(name)
                                .frame(width: 100, alignment: .leading)
                            Spacer()
                            Text("Rp\(perPersonAmount)")
                                .frame(width: 100, alignment: .trailing)
                                .fontWeight(.semibold)
                                .padding(.trailing, 8)
                            Button(action: {
                                selectedMembers[name]?.toggle()
                            }) {
                                Image(systemName: selectedMembers[name] ?? false ? "checkmark.square.fill" : "square")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(selectedMembers[name] ?? false ? Color("PrimaryColor") : .gray)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        .padding(.vertical, 4)
                    }
                }
                
                Section(header: Text("Opsi Pembayaran").font(.subheadline)) {
                    VStack(alignment: .leading, spacing: 12) {
                        
                        VStack(spacing: 12) {
                            BankCardView(bankName: "BCA", accountNumber: "4181011739", accountHolder: "Adithya Firmansyah P.")
                            BankCardView(bankName: "Mandiri", accountNumber: "137-00-1234567-8", accountHolder: "Kiki Rahmadani")
                            BankCardView(bankName: "BNI", accountNumber: "0641234567", accountHolder: "Zaidan Akbar")
                        }
                    }
                    .padding(.vertical)
                }
                
                Section(header: Text("Aturan Perjanjian").font(.subheadline)) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("- Kirim bukti ke pc kalau sudah bayar")
                        Text("- Max tanggal 29 Maret")
                    }
                    .font(.subheadline)
                }
                
                Button(action: {
                    let detailText = generatePatunganDetail()
                    UIPasteboard.general.setValue(detailText, forPasteboardType: "public.utf8-plain-text")
                        
                    print("Copied to clipboard: \n\(detailText)")
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
            .toolbar {
             
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {}) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(Color("PrimaryColor"))
                    }
                }
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: {
                        let detailText = generatePatunganDetail()
                        UIPasteboard.general.setValue(detailText, forPasteboardType: "public.utf8-plain-text")
                            
                        print("Copied to clipboard: \n\(detailText)")
                    }) {
                        Image(systemName: "document.on.document")
                            .foregroundColor(Color("PrimaryColor"))
                    }
                    Button(action: { }) {
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
        var accountHolder: String
        
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
                    Text(accountHolder)
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

struct DetailPatungan_Previews: PreviewProvider {
    static var previews: some View {
        DetailPatungan()
    }
}
