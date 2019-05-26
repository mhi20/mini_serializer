# MiniSerializer

Serialize object for export json api


## Installation

Add this line to your application's Gemfile:

```ruby
 gem 'mini_serializer'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mini_serializer

## Usage
### Initialize
 serializer=MiniSerializer::Serializer.new(House.all)
### Initialize with except params
 serializer=MiniSerializer::Serializer.new(House.all,{except:[:id,:title]})
### Associations
   serializer.add_has_many('house_images',['id','house_id','created_at','updated_at'])
   
   serializer.add_has_one('house_type',['id'])
### Parse data with json_serializer    
    render json:serializer.json_serializer


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mhi20/mini_serializer.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
