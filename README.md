# Craze
## Description
Craze allows users to create their own closet and provides automatic outfit recommendations based on multiple factors.<br>
The app aims at making it for its users to chose an outfit whenever they need: in the morning to go work, in the evening to go out for dinner or a party, during the weekend for sports activities, etc...<br>

## Differentiation
Craze is not just another virtual closet application and its value lays in its ability to provide relevant recommendations for its users by simply opening the app (or via a refresh click if necessary).

## Overview
Here is an exhaustive list of existing features of Craze app:
- Craze requires user to add their clothes into the app, using gallery pictures or taking new ones. Each clothe is then stored as a Core Data object.
- Once clothes have been added to the app, a recommendation "engine" fetches Core Data objects (clothes) based on several attributes including weather (useing NSPredicates to narrow down the fetches)
- Craze uses the OpenWeather API to return the weather information based on the user's location (location access by the app should be granted by the users). If location is not granted or the weather response is not available, the recommendation will still work and simply ignore the weather attributes in its algorithm.
- The home screen displays the recommended clothes to the user with the option to refresh or validate them
- When the recommendation is validated, an Outfit Core Date object is created with the data of the three Clothes composing it. Outfits and Clothes objects have a many-to-many relationship.
- All clothes are displayed in a collection view (Closet) where the user can easily edit or delete its clothes
- The validated Outfits are stored in a table view (Outfit History) where the users can see and delete their previously validated outfits.
