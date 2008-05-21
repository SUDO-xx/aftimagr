# require 'ruby-debug'

class AftimagrGenerator < Rails::Generator::NamedBase
  # APPTODO: default_options :with_editable_image => false, :with_attachment_fu_model => false
  
  attr_reader :controller_class_path,
              :controller_class_name,
              :model_class_name,
              :controller_underscore_name
  alias_method :controller_file_name, :controller_underscore_name
  
  def initialize(args, options = {})
    super
    # debugger
    @controller_name = @name.pluralize
    base_name, @controller_class_path = extract_modules(@controller_name)
    @controller_class_name, @controller_underscore_name = inflect_names(base_name)
    @model_class_name = @controller_class_name.singularize
  end
  
  def manifest
    record do |m|
      # APPTODO: Check for class naming collisions.
      
      m.directory(File.join('app/controllers', controller_class_path))
      m.directory(views_dir)
      
      # Controller
      m.template 'controllers/controller.rb',
                 File.join('app/controllers', class_path, "#{table_name}_controller.rb")
                 
      # Views
      m.template 'views/_buttons.html.erb', File.join(views_dir, '_buttons.html.erb')
      m.file 'views/_image.html.erb', File.join(views_dir, '_image.html.erb')
      m.file 'views/_messages.html.erb', File.join(views_dir, '_messages.html.erb')
      m.template 'views/_thumbnails.html.erb', File.join(views_dir, '_thumbnails.html.erb')
      m.template 'views/_upload.html.erb', File.join(views_dir, '_upload.html.erb')
      m.template 'views/index.html.erb', File.join(views_dir, 'index.html.erb')
      m.template 'views/new.html.erb', File.join(views_dir, 'new.html.erb')
      m.template 'views/show.html.erb', File.join(views_dir, 'show.html.erb')
      
      # TinyMCE plugin
      tinymce_plugin_dir = File.join('public/javascripts/tinymce/jscripts/tiny_mce/plugins', name)
      m.directory(tinymce_plugin_dir)
      m.template 'tinymce_plugin/dialog.htm', File.join(tinymce_plugin_dir, 'dialog.htm')
      m.template 'tinymce_plugin/editor_plugin.js', File.join(tinymce_plugin_dir, 'editor_plugin.js')
      m.directory(File.join(tinymce_plugin_dir, 'css'))
      m.file 'tinymce_plugin/css/aftimagr.css', File.join(tinymce_plugin_dir, 'css', "#{name}.css")
      m.directory(File.join(tinymce_plugin_dir, 'img'))
      m.file 'tinymce_plugin/img/aftimagr.gif', File.join(tinymce_plugin_dir, 'img', "#{name}.gif")
      m.directory(File.join(tinymce_plugin_dir, 'js'))
      m.template 'tinymce_plugin/js/dialog.js', File.join(tinymce_plugin_dir, 'js', 'dialog.js')
      m.directory(File.join(tinymce_plugin_dir, 'langs'))
      m.template 'tinymce_plugin/langs/en.js', File.join(tinymce_plugin_dir, 'langs', 'en.js')
      m.template 'tinymce_plugin/langs/en_dlg.js', File.join(tinymce_plugin_dir, 'langs', 'en_dlg.js')
      
      # APPTODO: Just uncomment this before deploying.
      m.route_resources controller_file_name
    end
  end
  
  protected
  
  def banner
    # APPTODO: Get this right.
    "Usage: #{$0} scaffold ModelName"
  end
  
  def views_dir
    File.join('app/views', controller_class_path, controller_file_name)
  end
  
  def window_title
    model_class_name + ' Manager'
  end
  
  def dialog_name
    model_class_name + 'Dialog'
  end

end
