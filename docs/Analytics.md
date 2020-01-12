# Analytics

This project uses the [Ahoy](https://github.com/ankane/ahoy) gem to capture information about app usage without relying on external services.
This page is an attempt to consolidate documentation on how our analytics work, but for complete documentation please refer to the ahoy docs proper.

## Ahoy model

Ahoy uses the same database as the rest of the application, and has two models that it uses: Events and Visits.
These models can be accessed just like any other ActiveRecord model through the Ahoy::Event and Ahoy::Visit classes respectively.

Visits are about what they sound like, and (try) to represent a single visit to the website, i.e. one browser continuously looking at the page.
The timeout for visits is set to 4 hours of inactivity by default, so they are not on a per-browser basis.
If possible, visits are tied to users.

Events are things that are explicitly logged by the application, both from server-side (ruby) code and client-side (javascript) code.
Every event is tied to a visit, and has two fields: a name, and "properties". The name should more or less be unique per call site, while the properties can be any arbitrary dict (json blob).
For example, we may want to have "signed up for ride" as the name, and "{ride_id: 1, added_initial_message: true}" as the properties.

## Calling ahoy

Events can be created in controller code with `ahoy.track "signed up for ride", ride_id: 1,added_initial_message: true`.

In javascript, you need to make sure you import ahoy in the file you want to track from (`import Ahoy from 'ahoy.js'`) and then call `Ahoy.track("signed up for ride", {"ride_id": 1, "added_initial_message": false})`.
