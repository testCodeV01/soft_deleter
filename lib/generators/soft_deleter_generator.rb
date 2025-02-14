class SoftDeleterGenerator < Rails::Generators::NamedBase
  argument :attributes, type: :array, default: []

  def out
    snake_name = name.underscore
    add_attributes = attributes.map do |attr|
      arg = "#{attr.name}:#{attr.type}"
      arg += ":index" if attr.has_index?
      arg += ":uniq" if attr.has_uniq_index?
      arg += "{#{attr.attr_options[:limit]}}" if attr.attr_options.present?
      arg
    end.join(" ")

    system("bundle exec rails g model #{name} #{add_attributes} deleter_type:string deleter_id:integer deleted_at:timestamp")
    system("sed -e '2i \\  include SoftDeleter' app/models/#{snake_name}.rb > app/models/_tmp.rb")
    system("rm app/models/#{snake_name}.rb")
    system("mv app/models/_tmp.rb app/models/#{snake_name}.rb")
  end
end
