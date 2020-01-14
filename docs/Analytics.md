# Writing Analytics code

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

# Analytics dashboard (Blazer)

## IMPORTANT

As of right now, all analytics queries are being run **directly against the production database**.
This means that if you run a slow-ass query (think sorts on large amounts of un-indexed data, lots of joins, complex operations against every item in a table), users CAN and WILL see slowdowns.
The worst of this can be mitigated by adding `NOLOCK` to analytics queries, but you will still be causing cache dumps and hogging database resources that may have other priorities.
As such, it is recommended that playing with analytics is kept to local machines and off-hours until such time as there is a dedicated business intelligence database, or some other solution to this problem.

It is also worth noting that adding `NOLOCK` removes ACID guarantees from your queries, so you may run into data inconsistencies and weird problems when doing so.
Said problems can probably be solved by simply retrying whatever the problematic query was.

## Using the dashboard

The blazer dashboard can be accessed at `/analytics/` on the website by users with the admin flag set.
Here, you are shown a searchable list of queries and dashboards.
Queries correspond to individual sql queries against the backing postgreql database, and can be trivially shared and refreshed.
Dashboards are collections of related queries that are designed to be viewed together.

The important thing to note here is that queries and dashboards are stored _in the database_, not in git.
This makes it easy to prototype queries, but also means that they are not trivially placed under source control.
The way to do so would be to place the relevant rows into the database seeds, although we currently do not have "migrate" the current set of queries and dashboards based on the changes made in git.

## Writing queries

Queries are just normal postgres flavored SQL queries.
By default, the results will show up as a table, but can also be shown as a chart if they meet the requirements under the "docs" link in the query builder.
The database schema can be viewed with both the "schema" link and with the "preview table" button, which will pull up a sample query to view a given table.

Existing queries can be modified with "edit" and "fork", with fork creating a copy of an existing query.

It should be noted that the `properties` column of `ahoy_events` is a [JSONB](https://www.postgresql.org/docs/11/functions-json.html) column, which allows for arbitrary, queryable nested json structures.
This is a feature that will probably not be covered by SQL tutorials, but is important for working with our data.
A decent cheat-sheet can be found [here](https://medium.com/hackernoon/how-to-query-jsonb-beginner-sheet-cheat-4da3aa5082a3).
Here is an example that selects all driver actions:

    SELECT * FROM ahoy_events
        WHERE properties->>'controller' LIKE 'driver%';

Note the `->>` operator here, which gives back the text at the `controller` key in the properties column.
If we wanted to get out a value that is nested deeper, we need to use the `->` operator, as it returns a JSONB value, which is different from text. I.e.,

    SELECT * FROM ahoy_events
        WHERE properties->'click'->>'xPos' = '120';

Note that JSONB only stores text, so casting is required to get other data types.
For example, if we wanted to get events with a 'click' x position between 100 and 200, we would do the following:

    SELECT * FROM ahoy_events
        WHERE CAST(properties->'click'->>'xPos' AS INTEGER) >= 100
        AND   CAST(properties->'click'->>'xPos' AS INTEGER) <= 200;
