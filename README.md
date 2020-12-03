# NFL Rushing
It's recommended that you have Docker and docker-compose install as the instruction is geared toward Docker runtime.

## Setup
1. Build a docker image and install project dependencies
    ```
    docker-compose up elixir
    ```
2. Setup the database, as well as load the JSON data from file (see `priv/repo/seeds.exs` for data loading)
    ```
    docker-compose run --rm web mix ecto.setup
    ```

## Test
You can run test suites by calling `test` service.
```
docker-compose up test
```

You can also see static code analysis by calling `credo` as well.
```
docker-compose up credo
```
Although if you want coloring on `credo` output, consider running this instead.
```
docker-compose run --rm test mix credo
```


## Running
1. Install client-side dependencies by running
```
docker-compose run --rm web npm install --prefix ./assets
```
2. Start the `web` service by running `up` command. This will start Elixir/Phoenix application as well as compile the front-end application.
```
docker-compose up web
```
3. Navigate to [localhost:4000/stats](localhost:4000/stats)


## Features
1. The player search is implemented as `LIKE NAME%` so the matching starts from beginning of first name.
2. Currently the sorting allows one-column-one-direction-at-a-time sort only.
3. Everything is done through server-side for simplicity.
4. JSON file import and CSV file download is implemented through Stream in Elixir which should handle large dataset somewhat.
