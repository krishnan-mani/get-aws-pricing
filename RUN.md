
- Setup ruby and gems (use RVM)

```
$ rvm current
ruby-2.2.1@get-aws-pricing
$ bundle install
```

- Use mongodb
- Run rake task to populate S3 pricing information

```
$ rake save_S3_pricing
```

- Run the API

```
$ ruby api/app.rb
```