//
//  ContentView.swift
//  Stocks
//
//  Created by Matthew Geimer on 2/4/20.
//  Copyright © 2020 SIGMobile. All rights reserved.
//

import SwiftUI

struct ContentView: View {
	
	private let API_TOKEN: String = "pk_243b38b37f924b15b0eaaf0ab9a57d5f"
	
	@State private var currentCompanyTicker: String = "AAPL"
	@State private var companyLoaded = false
	
	@State private var companyName:String = ""
	@State private var iexRealtimePrice: Double = 0
	@State private var volume: Int = 0
	
    var body: some View {
		VStack {
			TextField("Stock Ticker", text: $currentCompanyTicker)
				.foregroundColor(Color.white)
				.padding()
				.background(Color.blue)
				.clipShape(RoundedRectangle(cornerRadius: 10))
				.padding(12)
				.shadow(radius: 10)
			if companyLoaded {
				Group {
					Text("Company Name: \(companyName)")
					Text("Latest Price: $\(iexRealtimePrice)")
					Text("Volume: \(volume)")
				}
					.padding(.top, 30)
			}
			Button(action: {
				if let url = URL(string: "https://cloud.iexapis.com/stable/stock/\(self.currentCompanyTicker)/quote?token=\(self.API_TOKEN)") {
				   URLSession.shared.dataTask(with: url) { data, response, error in
					  if let data = data {
						  do {
							 let res = try JSONDecoder().decode(Response.self, from: data)
							self.companyName = res.companyName
							self.iexRealtimePrice = res.iexRealtimePrice
							self.volume = res.iexVolume
							self.companyLoaded = true
						  } catch let error {
							 print(error)
						  }
					   }
				   }.resume()
				}
			}) {
				Text("Make request")
					.padding()
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
        ContentView()
    }
}
