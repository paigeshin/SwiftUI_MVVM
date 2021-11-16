//
//  ContentView.swift
//  SwiftUIMVVM
//
//  Created by paige on 2021/11/16.
//

import SwiftUI

// MARK: - MODEL
struct WeatherModel: Codable {
    let timezone: String
    let current: CurrentWeahter
}

struct CurrentWeahter: Codable {
    let temp: Float
    let weather: [WeatherInfo]
}

struct WeatherInfo: Codable {
    let main: String
    let description: String
}

// MARK: - VIEWMODEL
class WeatherViewModel: ObservableObject{
    @Published var title = ""
    @Published var descriptionText = ""
    @Published var temp = ""
    @Published var timezone = ""
    
    init() {
        fetchWeather()
    }
    
    private func fetchWeather() {
        guard let url = URL(string: "") else { return }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }
            // Convert data to Model
            do {
                let model = try JSONDecoder().decode(WeatherModel.self, from: data)
                DispatchQueue.main.async { [weak self] in
                    self?.title = model.current.weather.first?.main ?? ""
                    self?.descriptionText = model.current.weather.first?.description ?? "No Description"
                    self?.temp = "\(model.current.temp)"
                    self?.timezone = model.timezone
                }
            } catch {
                print("failed")
            }
        }
        task.resume()
    }
    
}

// MARK: - VIEW
struct ContentView: View {
    
    @StateObject var viewModel = WeatherViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                Text(viewModel.title)
                    .font(.system(size: 32))
                Text(viewModel.descriptionText)
                    .font(.system(size: 44))
                Text(viewModel.temp)
                    .font(.system(size: 24))
                Text(viewModel.timezone)
                    .font(.system(size: 24))
            }
            .navigationTitle("Weather MVVM")
        }
    }
}
