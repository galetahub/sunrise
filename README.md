# Sunrise CMS

Open source mini content management system for programmers.

## Setup

For rails 5.x.x:

```ruby
  gem 'sunrise-cms', '~> 1.1.0', require: 'sunrise'
```

For rails 4.x.x:

```ruby
  gem "sunrise-cms", :require => "sunrise"
```

For rails 3.x.x:

```ruby
  gem "sunrise-cms", "~> 0.7.x" :require => "sunrise"
```

## Instructions

### ActiveRecord

```bash
$> rails g devise:install
$> rails g sunrise:install --orm=active_record
```

Copy db migrations files:

```bash
$> rake sunrise:install:migrations
$> rake page_parts_engine:install:migrations
$> rake meta_manager_engine:install:migrations
$> rails g public_activity:migration
```

### Mongoid

```bash
$> rails g sunrise:install --orm=mongoid
```

## Usage

Just create class:

```ruby
class SunriseProduct < Sunrise::AbstractModel
  self.resource_name = "Product"

  association :structure

  after_sort :clear_cache
  
  index :thumbs do
    scope { Product.includes(:picture) }
    preview lambda { |product| product.picture.try(:url, :thumb) }

    field :title
    field :price
    field :total_stock
  end

  export do
    scope { Product.includes(:picture).recently.with_state(:finished) }

    field :id
    field :product_title
    field :size
    field :started_at
    field :finished_at
    field :unique_accounts_count
    field :total_points
  end
  
  show do
    field :title
    field :price
    field :total_stock
    field :sort_order
    field :is_visible
  end
  
  form do
    field :title
    field :price
    field :total_stock
    
    field do |form, record|
      form.input :notes, :as => :text, :id => record.id
    end

    group :sidebar, :holder => :sidebar do
      field :sale_limit_id, :collection => lambda { SaleLimit.all }, :include_blank => false
      field :sort_order
      field :is_visible, :boolean => true
    end

    group :bottom, :holder => :bottom do
      nested_attributes :variants, :multiply => true do
        field :size
        field :total_stock, :html => { :style => 'width:100%;clear:both;' }
        field :item_model_id, :collection => lambda { ItemModel.all }, :include_blank => false
      end

      nested_attributes :project_fields, multiply: true, sort: true do
        field :name
        field :value
      end
    
      field :picture, :as => :uploader
    end
  end

  protected

    def clear_cache
      Rails.cache.clear
    end
end
```

Assets uploading detect ccurrent user by request.env['warden'].user. To overwrite it use:

```ruby
class Asset
  def uploader_user(request)
    request.env['warden'].user(:account) || request.env['warden'].user(:user)
  end
end
```

### Export data

#### XML, JSON, CSV

```
  GET /manage/users/export.xml
  GET /manage/users/export.csv
```

#### JSON

```
  GET /manage/users/export.json
```

For more info look at jbuilder https://rubygems.org/gems/jbuilder.

#### Excel

```
  gem "ruby2xlsx", "~> 0.0.1"

  GET /manage/users/export.xlsx
```

### Strong parameters

Now in sunrise file you can perform attributes check. 
By default permited_attributes allow edit all attributes.

```ruby
class SunrisePost < Sunrise::AbstractModel
  self.resource_name = "Post"
  edit do
    # Default value
    # permited_attributes :all 

    # Pre user check
    permited_attributes lambda { |user| 
      user.admin? ? :all : [:title, :content] 
    }
  end
end
```

### Include additional js codes

For example your want to include ckeditor editor.
In "Gemfile" include gem:

```ruby
gem "ckeditor"
```

Create file "app/assets/javascripts/sunrise/plugins.js":

```
//= require ckeditor/init
```

### Layout for devise login page

``` ruby
# config/application.rb
config.to_prepare do
  Devise::SessionsController.layout "sunrise/devise"
  Devise::PasswordsController.layout "sunrise/devise"
  Devise::ConfirmationsController.layout "sunrise/devise"
end
```

Copyright (c) 2014 Fodojo, released under the MIT license
