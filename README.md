# SoftDeleter
soft delete Rails plugin.

## Installation
Add this line to your application's Gemfile:

```ruby
gem "soft_deleter"
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install soft_deleter
```

## Usage
soft delete model User.
```
bundle exec rails g soft_deleter user
```
it create migration file to create user with soft delete attributes.
or if you already have User model, and you want make user model have attributes,
create migration file and add these lines
```
  t.string :deleter_type
  t.integer :deleter_id
  t.timestamp :deleted_at
```
and `bundle exec rails db:migrate`


## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
