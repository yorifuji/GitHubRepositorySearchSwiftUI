//
//  ContentView.swift
//  GitHubRepositorySearchSwiftUI
//
//  Created by yorifuji on 2021/06/07.
//

import SwiftUI
import Combine

struct ContentView: View {
    @State var cancellables = Set<AnyCancellable>()
    var body: some View {
        Button("Test") {
            SearchRepositoryClient.searchRepository("swift").sink { completion in
                switch completion {
                case .finished:
                    print("finished")
                case .failure(let error):
                    switch error {
                    case .createURLError:
                        print("createURL error")
                    case .urlError(let error):
                        print("urlError: \(error.localizedDescription)")
                    case .decodeError(let error):
                        print("decode error: \(error.localizedDescription)")
                    case .responseError:
                        print("responseError")
                    case .statusError(let status):
                        print("statusError: \(status)")
                    }
                }
            } receiveValue: { response in
                print(response)
            }
            .store(in: &cancellables)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
