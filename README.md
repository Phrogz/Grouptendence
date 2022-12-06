# Installation

```sh
gem install sqlite3 sequel haml sinatra sinatra-contrib thin kramdown

sequel -m models/migrations sqlite://models/db.sqlite3
```