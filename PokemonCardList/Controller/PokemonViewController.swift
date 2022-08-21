//
//  ViewController.swift
//  PokemonCardList
//
//  Created by Roberts Kursitis on 19/08/2022.
//

import UIKit
import AVFoundation

class PokemonViewController: UIViewController {
    
    @IBOutlet weak var favoriteOutlet: UIBarButtonItem!
    
    let defaults = UserDefaults.standard
    static var poki: [Datum] = []
    var favPoki: [Datum] = []
    var urlToggle: Bool = false
    
    static var pokiIDs = [String]()
    
    var indexes = [Int]()
    var allIndexed = [Int]()
    var mute: Bool = false
    var baseURL = "https://api.pokemontcg.io/v2/cards?q=nationalPokedexNumbers:[1+TO+151]+(set.id:base1+OR+set.id:base2+OR+set.id:base3+OR+set.id:basep)&orderBy=nationalPokedexNumbers"
    
    @IBOutlet weak var soundOutlet: UIBarButtonItem!
    @IBOutlet weak var tableViewOutlet: UITableView!
    
    override func viewDidLoad() {
        mute = defaults.bool(forKey: "sound")
        if mute {
            soundOutlet.image = UIImage(systemName: "volume.slash.fill")
        } else {
            soundOutlet.image = UIImage(systemName: "speaker.wave.1.fill")
        }
        PokemonViewController.pokiIDs = defaults.object(forKey: "pokiIDs") as? [String] ?? [""]
        
        super.viewDidLoad()
        self.title = "Pokémon Card List"
        getPokemonData(apiURl: baseURL)
    }
    
    @IBAction func clearDefaultsTapped(_ sender: Any) {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }
    
    @IBAction func addFavTapped(_ sender: Any) {
        PokemonViewController.pokiIDs.removeDuplicates()
        defaults.set(PokemonViewController.pokiIDs, forKey: "pokiIDs")
    }
    
    @IBAction func favTapped(_ sender: Any) {
        urlToggle.toggle()
        favPoki.removeAll(keepingCapacity: true)
        baseURL = "https://api.pokemontcg.io/v2/cards?q=id:base1-2"
        
        if urlToggle {
            if PokemonViewController.pokiIDs.count == 1 {
                baseURL = "https://api.pokemontcg.io/v2/cards?q=id:\(PokemonViewController.pokiIDs[0])&orderBy=nationalPokedexNumbers"
            } else {
                let joinedString = PokemonViewController.pokiIDs.joined(separator: "+OR+id:")
                baseURL += joinedString
            }
        } else {
            baseURL = "https://api.pokemontcg.io/v2/cards?q=nationalPokedexNumbers:[1+TO+151]+(set.id:base1+OR+set.id:base2+OR+set.id:base3+OR+set.id:basep)&orderBy=nationalPokedexNumbers"
        }
        getPokemonData(apiURl: baseURL)
        tableViewOutlet.reloadData()
        
        print("URL used was: " + baseURL)
    }
    
    @IBAction func soundTapped(_ sender: Any) {
        if mute {
            mute = false
            soundOutlet.image = UIImage(systemName: "speaker.wave.1.fill")
            defaults.set(false, forKey: "sound")
        } else {
            mute = true
            soundOutlet.image = UIImage(systemName: "volume.slash.fill")
            defaults.set(true, forKey: "sound")
        }
    }
    
    func getPokemonData(apiURl: String) {
        guard let url = URL(string: apiURl) else {return}

        var request = URLRequest(url: url)
        request.setValue("68f13a36-5697-4424-aee4-89bf17396ad9", forHTTPHeaderField: "X-Api-Key")
        request.httpMethod = "GET"

        let config = URLSessionConfiguration.default
        config.waitsForConnectivity = true

        URLSession(configuration: config).dataTask(with: request) { (data, response, error) in

            if error != nil {
                print((error?.localizedDescription)!)
            }

            guard let data = data else{
                print(error as Any)
                return
            }

            do {
                let jsonData = try JSONDecoder().decode(Pokemon.self, from: data)
                print("jsonData: ", jsonData)
                self.favPoki = jsonData.data
                DispatchQueue.main.async {
                    self.tableViewOutlet.reloadData()
                }
            } catch {
                print("Error: ", error as Any)
            }
        } .resume()
    }
}

extension PokemonViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favPoki.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "pokemonCell", for: indexPath) as? PokiTableViewCell else {return UITableViewCell()}
        
        let poke = favPoki[indexPath.row]
        cell.setupUI(withDataFrom: poke)
        for (index, _) in favPoki.enumerated() {
            allIndexed.append(index)
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !mute {
            DispatchQueue.global(qos: .default).async {
                playSound()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableViewOutlet.indexPathForSelectedRow {
            guard let detailVC = segue.destination as? PokiDetailViewController else { return }
            detailVC.pokemon = favPoki[indexPath.row]
        }
    }
}

extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()

        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }

    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}
