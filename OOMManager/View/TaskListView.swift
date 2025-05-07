//
//  TaskListView.swift
//  OOMManager
//
//  Created by João Martins on 07/05/2025.
//

import SwiftUI
import SwiftData


struct TaskListView: View {
    @Query(sort: \TaskModel.title) var tasks: [TaskModel]
    
    var body: some View {
        Text("Task list").font(.headline)
        List(tasks) { task in
            VStack(alignment: .leading) {
                Text(task.title).font(.headline)
            }
        }
    }
}


#Preview {
    TaskListView()
}
