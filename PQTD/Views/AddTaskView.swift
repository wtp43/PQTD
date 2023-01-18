//
//  AddView.swift
//  PQTD
//
//  Created by William Tang on 2023-01-14.
//

import SwiftUI

struct AddTaskView: View {
    
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var listViewModel: IPQViewModel
    @EnvironmentObject var categoryViewModel: CategoryViewModel

    
    @State var textFieldTitle: String = ""
    @State var textFieldPriority: Int = 0
    @State var alertTitle: String = ""
    @State var showAlert: Bool = false
    @State private var category: CategoryModel = .emptySelection
    
    
    var body: some View {
        Form {
            Section(header: Text("Task")) {
                TextField("Title", text: $textFieldTitle)
                    .padding(.horizontal)
                    .frame(height: 55)
                    .cornerRadius(10)
                    .disableAutocorrection(true)
                TextField("Title", value: $textFieldPriority, formatter: NumberFormatter())
                    .keyboardType(.numberPad)
                    .padding(.horizontal)
                    .frame(height: 55)
                    .cornerRadius(10)
            }
 
            Section(header: Text("Category")) {
                Picker("", selection: $category) {
                    ForEach(categoryViewModel.categories, id: \.self) { category in
                        HStack{
                            Image(systemName: category.icon)
                            Text(category.title)
                                .tag(category as CategoryModel?)
                        }
                        .foregroundColor(category.categoryColor)
                    }
                }
                .padding(.horizontal)
                .pickerStyle(.wheel)
            }
        }
        .navigationBarTitle(Text("New Task"))
        .navigationBarTitleDisplayMode(.inline)
        .alert(isPresented: $showAlert, content: getAlert)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Add") {
                    saveButtonPressed()
                    dismiss()
                }
            }
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel", role: .cancel) {
                    dismiss()
                }
            }
        }
    }
    
    func saveButtonPressed(){
        if textIsAppropriate() {
            listViewModel.addItem(title: textFieldTitle, categoryID: category.id)
            dismiss()
        }
    }
    
    func textIsAppropriate() -> Bool {
        if textFieldTitle.count < 1 {
            alertTitle = "Your new todo item must be at least 1 character long"
            showAlert.toggle()
            return false
        }
        return true
    }
    
    func getAlert() -> Alert {
        return Alert(title: Text(alertTitle))
    }
    
}


struct AddTaskView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            AddTaskView()
        }
        .environmentObject(IPQViewModel())
        .environmentObject(CategoryViewModel())
    }
}
