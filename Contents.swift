/**

 * Homework 4
 * Jim Mittler
 * 29 August 2025

 This program loads dog descriptions and images. Shows one image and prints
 the descriptions for the rest.

 _Italic text_
 __Bold text__
 ~~Strikethrough text~~

 */

import PlaygroundSupport
import SwiftUI

/* define a runtime error we can throw if we can't load our stuff */
struct RuntimeError: LocalizedError {
    let description: String

    init(_ description: String) {
        self.description = description
    }

    var errorDescription: String? {
        description
    }
}

/* load the dog names and descriptions. Return a dictionary  */

func loadDogs() throws -> [String: String] {

    /* it would be nice to iterate over the images programatically but swift doesn't seem to want to make that easy. Instead we make an array of dog names.
     */
    let dogs: [String] = [
        "Airedale Terrier",
        "American Foxhound",
        "Dutch Shepherd",
        "Havanese",
        "Leonberger",
        "Mudi",
        "Norwegian Lundehund",
        "Pharaoh Hound",
        "Scottish Terrier",
        "Tosa",
    ]

    /* grab the embedded file with the list of dog descriptions */
    if let fileURL = Bundle.main.url(
        forResource: "dog_data",
        withExtension: "txt"
    ) {
        var fileContents = try String(contentsOf: fileURL, encoding: .utf8)

        /* remove the escaped quotes. I have a feeling the idea was to add a bunch of these strings directly in the program
         but we are just going to load a a file */

        fileContents = fileContents.replacingOccurrences(
            of: "\\\"",
            with: "\""
        )

        /* parse the file into an array of strings, remove empties */
        let separators = CharacterSet(charactersIn: "\r\n")
        let arrayOfStrings = fileContents.components(
            separatedBy: separators
        )
        var filtered = arrayOfStrings.filter { !$0.isEmpty }

        /* there is a leading a trailing quote on each - nuke that */
        for (index, dog) in filtered.enumerated() {
            filtered[index] = String(dog.dropFirst().dropLast())
        }

        /* ok we've got our dictionary now - return it*/
        let dogInfo = Dictionary(uniqueKeysWithValues: zip(dogs, filtered))
        return dogInfo

    } else {
        throw RuntimeError("Could not find 'dog_data.txt' in the main bundle.")
    }

}

do {

    /* fetch our dictionary
     mutable because we will delete one element in a bit
     */
    var dogs = try loadDogs()

    /* grab a random dog */
    let randomDog = dogs.randomElement()!

    /* per instructions print the name and description of the random dog*/
    print("\(randomDog.key): \(randomDog.value)\n")

    /* load the image - not sure why we needed the extension but we seemed to need it */
    if let image = UIImage(named: randomDog.key + ".jpg") {
        // Create an image view to display the image. Use the image size for the frame.
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(
            x: 0,
            y: 0,
            width: image.size.width,
            height: image.size.height
        )  // Adjust size and position as needed
        // Add the image view to the Playground's live view
        PlaygroundPage.current.liveView = imageView

        /* per the instructions loop through dogs and print if not the one with the picture. So remove that dog first
         we add an extra carriage return to space these out */

        dogs.removeValue(forKey: randomDog.key)
        for (name, description) in dogs {
            print("\(name): \(description)\n")
        }

    }

} catch {
    // we bombed out. sad.
    print("An unknown error occurred: \(error)")
}
