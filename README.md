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
### Introduce
Soft delete model User.
```
bundle exec rails g soft_deleter user
```
It creates migration file to create user with attributes which is needed to introduce soft delete.<br/>
Add some attributes to migration file, like name, email, age, ...etc.<br />
And excute `bundle exec rails db:migrate`. That's all.<br />
<br />
Or if you already have User model, and you want introduce soft delete in it,
create migration file and add lines like below
```ruby
class AddSoftDeleterAttributesToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :deleter_type, :string
    add_column :users, :deleter_id, :bigint
    add_column :users, :deleted_at, :timestamp
  end
end
```
and excute `bundle exec rails db:migrate`<br />
Here, `deleter_type` and `deleter_id`, these are the infomations who soft delete.<br />
Like `current_admin`, when admin which is "Admin" class does soft delete user record, admin's class name and id can be recorded.
<br /><br />
And add line to model
```ruby
class User < ApplicationRecord
  include SoftDeleter
end
```
This line is added automatically if you use `rails g soft_deleter user` command to make user model.

### scope
When you load users whitout soft deleted records, you need to scope like below.
```ruby
users = User.enabled.all
```
If you don't use enabled scope, you will load users in all records including soft deleted.<br />
Otherwise, if you need to load records with soft deleted, excute like below.
```ruby
deleted_users = User.deleted.all
```

### Soft delete
```ruby
user = User.enabled.first
user.soft_delete                 # soft delete
user.soft_delete!                # soft delete or raise when fail occurs
user.restore                     # restore soft deleted user
user.restore!                    # restore soft deleted user or raise when fail occurs
```
If your app have some models other than user, like `Admin` model,<br />
and you need to record to that Admin user did soft delete.<br />
Then,
```ruby
user = User.enabled.first

admin = Admin.enabled.first     # soft deleted by admin user
user.soft_delete(admin)         # soft delete and set admin to deleter
user.soft_delete!(admin)        # raise if fail to soft delete

user.deleter                    # => <Admin:0x00007f37f96a0c88
user.deleter_type               # => Admin(id: integer, ...
user.deleter_id                 # => "admin.id" if deleter is not set, "user.id"
user.soft_deleted?              # => true
user.alive?                     # => false
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
So, if you excute `user.soft_delete`, then associations books, and sections are soft deleted.<br />
And excute `user.restore`, then associations books, and sections are restored.<br />
It works with dependent destroy descriptions. If not, it doesn't work.


## Exclude Dependent
In the case where Active Storage is used, you will want exclude destroying files.<br />
You can exclude dependents by `exclude_dependent` as below.
```ruby
# has_one_attached
class User < ApplicationRecord
  include SoftDeleter

  has_one_attached :avatar
  exclude_dependent :avatar_attachment # this line
end

# has_many_attached
class Book < ApplicationRecord
  include SoftDeleter
  belongs_to :user
  has_many_attached :images

  exclude_dependent :images_attachments # this line
end
```
`exclude_dependent` accepts array of symbols as arguments.

Otherwise, you can use `suffix` option as below.
```ruby
class User < ApplicationRecord
  include SoftDeleter

  has_one_attached :avatar
  has_one_attached :somefile
  exclude_dependent %i(avatar somefile), suffix: :attachment # this line
end

class Book < ApplicationRecord
  include SoftDeleter
  belongs_to :user
  has_many_attached :images

  exclude_dependent :images, suffix: :attachments # this line
end
```

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
