//
//  ContentView.swift
//  Stocks
//
//  Created by Matthew Geimer on 2/4/20.
//  Copyright © 2020 SIGMobile. All rights reserved.
//

//Intraday prices link: https://cloud.iexapis.com/stable/stock/AAPL/intraday-prices?token=pk_243b38b37f924b15b0eaaf0ab9a57d5f

import SwiftUI

class ViewModel: ObservableObject {
	
	private let API_TOKEN: String = "pk_243b38b37f924b15b0eaaf0ab9a57d5f"
	
	var currentCompanyTicker: String
	@Published var companyLoaded: Bool
	@Published var companyName: String
	@Published var iexRealtimePrice: Double
	@Published var volume: Int
	
	init() {
		companyLoaded = false
		companyName = ""
		iexRealtimePrice = 0
		volume = 0
		currentCompanyTicker = ""
	}
	
	func getDataFromAPI() {
		if let url = URL(string: "https://cloud.iexapis.com/stable/stock/\(self.currentCompanyTicker)/quote?token=\(self.API_TOKEN)") {
		   URLSession.shared.dataTask(with: url) { data, response, error in
			  if let data = data {
				  do {
					 let res = try JSONDecoder().decode(Response.self, from: data)
					DispatchQueue.main.async {
						self.companyName = res.companyName
						self.iexRealtimePrice = res.iexRealtimePrice
						self.volume = res.iexVolume
						self.companyLoaded = true
					}
				  } catch let error {
					 print(error)
				  }
			   }
		   }.resume()
		}
	}
}

struct ContentView: View {
	
	@ObservedObject var viewModel: ViewModel
	
	init(viewModel: ViewModel) {
		self.viewModel = viewModel
		viewModel.currentCompanyTicker = ""
	}
	
    var body: some View {
		VStack {
			TextField("Stock Ticker", text: $viewModel.currentCompanyTicker)
				.padding()
				.background(Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0))
				.clipShape(RoundedRectangle(cornerRadius: 10))
				.padding(12)
				.shadow(radius: 10)
			if viewModel.companyLoaded {
				Group {
					Text("Company Name: \(viewModel.companyName)")
					Text("Latest Price: $\(viewModel.iexRealtimePrice)")
					Text("Volume: \(viewModel.volume)")
				}
					.padding(.top, 30)
			}
			Button(action: {
				self.viewModel.getDataFromAPI()
			}) {
				Text("Make request")
					.padding()
					.foregroundColor(Color.white)
					.background(Color.blue)
					.clipShape(RoundedRectangle(cornerRadius: 10))
					.padding(12)
					.shadow(radius: 10)
			}
		}
    }
}

struct Response: Codable {
	let companyName: String
	let iexRealtimePrice: Double
	let iexVolume: Int
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: ViewModel())
    }
}
