### Red models

Translating the SQL tables into **Red** models should represent
a person with all the attributes in the SQL tables, including
the implied relationships among the tables by the common
**person_key** found in all the tables.
The load script, described next, accomplishes that goal.

#### Part 1 - Creating the database

We created a Perl 6 script to (1) create **Red** models of our desired
database models (2), read the CSV data file, and (3) load an SQLite
database file with the results.  The script is
[load-db.p6](./load-db.p6).  Note we use a unique, generated secondary
key in addition to the primary key (id) for each entry, and that key
has been validated with all the data prior to loading the database. In
the rare instance of a duplicate key, we would add another field to
the key and so document it (and migrate the database to a version with
the new seconday key but preserving the primary key.

#### Part 2 - Querying the database

After we created the dabatase, we will then start to use it with
various queries as we prepare for the next event.

We created a separate script to query the SQLite database. The script
is [query-db.p6](./query-db.p6) **[a WIP]**. It will be updated as we
determine new reports are needed.

Some example CSV files containing typical reports needed are shown:
(1) current contact list [contacts-2019-04-01.csv](./data/contacts-2019-04-01.csv),
and
(2) [attendance-2020.csv](./data/update-2020.csv) and

#### Part 3 - Updating the database

(1) updates between events [update-2019-04-01.csv](./data/update-2019-04-01.csv),
and
(2) [attendance-2020.csv](./data/update-2020.csv) and

We also created a script to update the database:
[update-db.p6](./update-db.p6) **[a WIP]**.


#### Part 4 - Preparation for the next event (2020)
There are two reports needed in preparation for the next event
