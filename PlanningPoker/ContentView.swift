import SwiftUI

struct ContentView: View {
    @State private var selectedValue: String? = nil

    let values = ["0", "1", "2", "3", "5", "8", "13", "20", "40", "100", "?"]

    var body: some View {
        ZStack {
            if let value = selectedValue {
                FullScreenValueView(value: value) {
                    selectedValue = nil
                }
            } else {
                VStack {
                    Spacer()
                    
                    Text("Choose your estimate")
                        .font(.title)
                        .foregroundColor(.black)
                        .padding(.bottom, 40)
                                        
                    ValueGridView(values: values) { value in
                        selectedValue = value
                    }

                    Spacer()
                }
                .padding()
            }
        }
    }
}
