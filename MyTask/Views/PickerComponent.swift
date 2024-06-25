//
//  PickerComponent.swift
//  MyTask
//
//  Created by Muhammad Sohaib on 25/06/2024.
//

import SwiftUI

struct PickerComponent: View {
    
    @State private var pickerFilters: [String] = ["Active", "Closed"]
    @Binding var defaultPickerSelectedItem: String
//    @ObservedObject var taskViewModel: TaskViewModel
    
    var body: some View {
        Picker("Picker filter", selection: $defaultPickerSelectedItem) {
            ForEach(pickerFilters, id: \.self) {
                Text($0)
            }
        }.pickerStyle(.segmented)
    }
}

#Preview {
    PickerComponent(defaultPickerSelectedItem: .constant("Active"))
}
