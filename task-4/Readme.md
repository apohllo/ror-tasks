# Understanding ActiveRecord #

Prerequisites:
* [Rails API](http://api.rubyonrails.org/)
* [ActiveRecord migrations](http://guides.rubyonrails.org/migrations.html)
* [ActiveRecord validations and callbacks](http://guides.rubyonrails.org/active_record_validations_callbacks.html)
* [ActiveRecord associations](http://guides.rubyonrails.org/association_basics.html)
* [ActiveRecord queries](http://guides.rubyonrails.org/active_record_querying.html)

## Introduction

'ActiveRecord' (AR in short) is the Rails ORM (Object-Relational Mapper). It is
used to simplify the access to the database, by hiding SQL-commands and data
conversion behind an object-oriented interface. There is a lot of references
describing AR (e.g. [Rails API](http://api.rubyonrails.org/), 
[Rails Guides](http://guides.rubyonrails.org) devote much space to AR), so this
introduction will only cover basic aspects of AR as well as some advanced
topics, that are not covered in Rails documentation.

### CRUD 

The first feature of ActiveRecord is CRUD interface for the persistence layer:

Definition

```ruby
# migration
class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string :title
      t.references :author
      # same as
      # t.integer :author_id

      t.timestamps
    end
  end
end

# class definition
class Book < ActiveRecord::Base
end
```


Create

```ruby
book = Book.new(:title => 'Ruby')
book.save
# or
Book.create(:title => 'Ruby')

# In the controller context
if Book.create(params[:book])
  # success
else
  # failure
end

# params[:book] looks like
{ :title => 'Ruby' }
```

Read:

```ruby
# find by id
book = Book.find(1)
book.title          #=> 'Ruby'
# or
book = Book.find_by_id(1)

# find by title
book = Book.find_by_title('Ruby')
# or
book = Book.where(:title => 'Ruby')
```

Update:

```ruby
book = Book.find(1)
book.title = 'Ruby for beginners'
book.save
# or
Book.update(:title => 'Ruby for beginners')

# In the controller context
if Book.update(params[:book])
  # success
else
  # failure
end

# params[:book] looks like
{ :title => 'Ruby for beginners' }
```

Destroy:

```ruby
book = Book.find(1)
book.destroy

book.title = 'Ruby for beginners' #=> error
Book.find(1)                      #=> error
Book.find_by_id(1)                #=> nil
```


* query language
* migrations
* associations
* inheritance
* validations
* callbacks
* pagination
* plugins
* testing + infinite protocol of AR
* security (SQL-injection, `attr_accessible`, etc.)
* nullDB

## Exercises

1. Write migrations that will define tables for the following models:

  * `User` with the following fields:
    * `name` - the name of the user
    * `surname` - the surname of the user
    * `email` - the e-mail address of the user
    * `password` - the encrypted password of the user
  * `TodoList` with the following fields:
    * `title` - the title of the TodoList (e.g. prive, work, etc.)
    * `user_id`  - the id of the owner of the list
  * `TodoItem` with the following fields:
    * `title` - the title of the item
    * `description` - the description of the item
    * `date_due` - the date the item has to be completed
    * `todo_list_id` - the list this item belongs to

  Select the appropriate column types and indices for the tables.


2. Define the classes and their associations:
  * a `User` has many `TodoList`s
  * a `User` has many `TodoItem`s through `TodoList`s
  * a `TodoList` belongs to a `User`
  * a `TodoList` has many `TodoItem`s
  * a `TodoItem` belongs to a `TodoList`

3. Define validations for the following classes:
  * `User`
    * should have a non-empty `name` up to 20 characters long
    * should have a non-empty `surname` up to 30 characters long
    * should have a valid `email` address
    * should accepts the `terms of the service`
    * should have a non-empty `password` that is at leas 10 characters long
    * should have confirmed his/her `password`
  * `TodoList`
    * should have a non-empty `title`
    * should have a non-empty `user` it belongs to
  * `TodoItem`
    * should have a non-empty `title` which is 5 up to 30 characters long
    * should have a non-empty list it belongs to
    * should have a description up to 255 characters long that might be empty
    * should have a due date in dd/mm/yyyy format, that might be empty

4. Write tests that will show the validations are defined correctly.

* extensive list of query language examples
