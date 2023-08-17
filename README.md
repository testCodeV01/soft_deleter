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
### Introdue
soft delete model User.
```
bundle exec rails g soft_deleter user
```
It create migration file to create user with soft delete attributes.<br/>
Or if you already have User model, and you want make user model have attributes,
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

### Soft delete
```ruby
user = User.first
user.soft_delete           # soft delete
user.soft_delete!          # soft delete and raise if fail soft delete
user.restore               # restore soft deleted user
```
If your App have some models other than user, like `Admin` model,<br />
and you need to record to that Admin account did soft delete.<br />
Then,
```ruby
admin = Admin.first        # admin to delete soft
user.soft_delete(admin)    # soft delete and soft_deleter is admin
user.soft_delete!(admin)   # raise if fail soft delete

user.deleter               # => <Admin:0x00007f37f96a0c88
user.deleter_type          # => Admin(id: integer, ...
user.soft_deleted?         # => true
usr.alive?                 # => false
```


## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
