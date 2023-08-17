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
```
$ gem install soft_deleter
```

## Usage
soft delete model User.
```
bundle exec rails g soft_deleter user
```
it create migration file to create user with soft delete attributes.<br/>
or if you already have User model, and you want make user model have attributes,
create migration file and add lines like bellow
```ruby
class AddSoftDeleterAttributesToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :deleter_type, :string
    add_column :users, :deleter_id, :integer
    add_column :users, :deleted_at, :timestamp
  end
end
```
and `bundle exec rails db:migrate`




## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
