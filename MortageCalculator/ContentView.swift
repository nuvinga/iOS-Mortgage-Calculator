//
//  ContentView.swift
//  MortageCalculator
//
//  Created by Nuvin Godakanda Arachchi on 2023-03-23.
//

import SwiftUI

struct ContentView: View {
    
    @AppStorage("monthlyPayment") var monthlyPayment: String = ""
    @AppStorage("loanPeriod") var loanPeriod: String = ""
    @AppStorage("interestRate") var interestRate: String = ""
    @AppStorage("borrowable") var borrowable: String = ""
    
    var body: some View {
        VStack {
            Text("Mortgage Calculator")
                .font(.largeTitle)
                .fontWeight(.bold)
                .background {
                    Image("house")
                        .resizable()
                        .frame(width: 250, height: 400)
                        .opacity(0.3)
                }
            
            VStack {
                VStack {
                    Label("Monthly Payment", systemImage: "sterlingsign.circle.fill")
                    TextField("Monthly Pay", text: $monthlyPayment)
                        .onChange(of: monthlyPayment) { newValue in
                            monthlyPayment = checkText(text: newValue)
                        }
                        .textFieldStyle(.roundedBorder)
                        .padding(.all, 6.0)
                        .border(.teal)
                        .multilineTextAlignment(.center)
                }
                
                VStack {
                    Label("Loan Period - Years", systemImage: "clock.badge.questionmark")
                    TextField("Loan Period in Years", text: $loanPeriod)
                        .padding(.all, 6.0)
                        .textFieldStyle(.roundedBorder)
                        .border(.teal)
                        .multilineTextAlignment(.center)
                }
                
                VStack {
                    Label("Interest Rate", systemImage: "percent")
                    TextField("Interest Rate", text: $interestRate)
                        .onChange(of: interestRate) { newValue in
                            interestRate = checkText(text: newValue)
                        }
                        .padding(.all, 6.0)
                        .textFieldStyle(.roundedBorder)
                        .border(.teal)
                        .multilineTextAlignment(.center)
                }
            }
            
            Button {
                mortgageCalculator()
            } label: {
                Text("Calculate")
                    .padding(.vertical)
            }
            
            Text("Amount that can be borrowed is \(borrowable)")
            
        }
    }
    
    func mortgageCalculator() {
        guard let monthly = Double(monthlyPayment),
                let period = Int(loanPeriod),
                let rate = Double(interestRate)
        else {
            return
        }
        
        let r = rate/100
        let a = Double((r/12)+1)
        let n = Double(period*12)
        
        let apown = (pow(a, n))-1
        let apownegn = pow(a, -n)
        
        let numerator = monthly*(apown*apownegn)
        let p = round(numerator/(r/12))
        
        borrowable = String(format: "%.2f", p)
    }
    
    func checkText(text: String) -> String {
        var updatedString = text
        var dotCount = 0
        for d in text {
            if String(d) == "." {
                dotCount += 1
            }
            
        }
        if dotCount >= 2 {
            // remove the last typed point
            updatedString = String(text.dropLast())
        }
        return updatedString
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
