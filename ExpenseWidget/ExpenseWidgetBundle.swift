//
//  ExpenseWidgetBundle.swift
//  ExpenseWidget
//
//  Created by Saloni Singh on 14/05/25.
//

import WidgetKit
import SwiftUI

@main
struct ExpenseWidgetBundle: WidgetBundle {
    var body: some Widget {
        ExpenseWidget()
        ExpenseWidgetControl()
        ExpenseWidgetLiveActivity()
    }
}
