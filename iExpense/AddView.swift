//
//  AddView.swift
//  iExpense
//
//  Created by Guadoo on 2021/5/24.
//

import SwiftUI

struct AddView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = ""
    
    @ObservedObject var expenses: Expenses
    
    @State private var showingAlert = false
    
    static let types = ["Business","Personal"]
    
    var body: some View {
        
        NavigationView {
            Form {
                TextField("Name", text: $name)
                Picker("Type", selection: $type) {
                    ForEach(AddView.types, id:\.self){
                        Text($0)
                    }
                }
                TextField("Amount", text: $amount)
                    .keyboardType(.numberPad)
            }
            .navigationBarTitle("Add new expense")
            .navigationBarItems(trailing: Button("Save"){
                if let actualAmount = Int(self.amount) {
                    let item = ExpenseItem(name: self.name, type: self.type, amount: actualAmount)
                    self.expenses.items.append(item)
                    self.presentationMode.wrappedValue.dismiss()
                } else {
                    self.showingAlert = true
                }
            })
            .alert(isPresented: $showingAlert, content: {
                
                let clearButton = Alert.Button.default(Text("Got It")) {
                    self.amount = ""
                }
                
                return Alert(title: Text("Error"), message: Text("Amount shall be the type of Int"), dismissButton: clearButton)
            })
        }
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(expenses: Expenses())
    }
}
