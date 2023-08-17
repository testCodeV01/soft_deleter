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
and `bundle exec rails db:migrate`<br />
<br />
And add line to model
```ruby
class User < ApplicationRecord
  include SoftDeleter
end
```
This line is added automatically if you use `rails g soft_deleter user` command to make user model.

### Soft delete
```ruby
user = User.first
user.soft_delete           # soft delete
user.soft_delete!          # soft delete and raise if fail soft delete
user.restore               # restore soft deleted user
```
If your app have some models other than user, like `Admin` model,<br />
and you need to record to that Admin account did soft delete.<br />
Then,
```ruby
user = User.first

admin = Admin.first        # admin to delete soft
user.soft_delete(admin)    # soft delete and soft_deleter is admin
user.soft_delete!(admin)   # raise if fail soft delete

user.deleter               # => <Admin:0x00007f37f96a0c88
user.deleter_type          # => Admin(id: integer, ...
user.deleter_id            # => "admin.id" if soft deleter is not set, "user.id"
user.soft_deleted?         # => true
user.alive?                # => false
```

## Associations
If associations some models, User, Book, Section.
```ruby
# User model
class User < ApplicationRecord
  include SoftDeleter
  has_many :books, dependent: :destroy
end

# Book model
class Book < ApplicationRecord
  include SoftDeleter
  belongs_to :user
  has_many :sections, dependent: :destroy
end

# Section model
class Section < ApplicationRecord
  include SoftDeleter
  belongs_to :book
end
```
So, if you excute `user.soft_delete`, then associations books, and sections are delete soft.<br />
And excute `user.restore`, then associations books, and sections are restored.<br />
It works if dependent destroy description. If not, it doesn't work.


## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
