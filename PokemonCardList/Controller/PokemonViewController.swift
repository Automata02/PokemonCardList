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
    var poki: [Datum] = []
    var storedFavorites: [Datum] = []
    var favPoki: [Datum] = []
    var urlToggle: Bool = false
    var isFiltered: Bool = false
    
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
        let ac = UIAlertController(title: "Delete Favorites", message: "Are you sure you want to delete favorites?", preferredStyle: .actionSheet)
        let clear = UIAlertAction(title: "Remove", style: .destructive) { action in
            let defaults = UserDefaults.standard
            let dictionary = defaults.dictionaryRepresentation()
            dictionary.keys.forEach { key in
                defaults.removeObject(forKey: key)
            }
            self.storedFavorites.removeAll()
            PokemonViewController.pokiIDs.removeAll()
            self.tableViewOutlet.reloadData()
        }
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.addAction(clear)
        present(ac, animated: true)
    }
    
    @IBAction func addFavTapped(_ sender: Any) {
        defaults.set(PokemonViewController.pokiIDs, forKey: "pokiIDs")
    }
    
    @IBAction func favTapped(_ sender: Any) {
        isFiltered.toggle()
        if isFiltered {
            favoriteOutlet.image = UIImage(systemName: "arrow.uturn.backward")
            favPoki.removeAll()
            storedFavorites.removeAll()
            let uniqueIDs = Array(Set(PokemonViewController.pokiIDs))
            for id in uniqueIDs {
                for pokemon in poki {
                    if pokemon.id.contains(id) {
                        storedFavorites.append(pokemon)
                    }
                }
            }
            favPoki = storedFavorites
            storedFavorites.removeAll()
        } else {
            favPoki = poki
            favoriteOutlet.image = UIImage(systemName: "star.fill")
        }
//        getPokemonData(apiURl: baseURL)
        tableViewOutlet.reloadData()
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
                self.poki = jsonData.data
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
        
        print("Total number of cells made:" + String(favPoki.count))
        print(PokemonViewController.pokiIDs)
    
        cell.setupUI(withDataFrom: poke)
        for (index, _) in favPoki.enumerated() {
            allIndexed.append(index)
        }
        defaults.set(PokemonViewController.pokiIDs, forKey: "pokiIDs")
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

