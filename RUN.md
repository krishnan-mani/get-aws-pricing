
- Setup ruby and gems (use RVM)

```
$ rvm current
ruby-2.2.1@get-aws-pricing
$ bundle install --binstubs
```

- Use mongodb. Copy the configuration file example to create a real one.
- Run rake task to populate pricing information

```
$ cp api/config/config.yml.example api/config/config.yml
$ RUN_LOCAL=true rake clear_data
$ RUN_LOCAL=true rake save_all
```

- Run the tests

```
$ rspec
```

- Run the API

```
$ rackup -p 4500
```
