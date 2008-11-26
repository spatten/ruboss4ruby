# Merb specific handling
# make sure we're running inside Merb
if defined?(Merb::Plugins)
  Merb::BootLoader.before_app_loads do
    if defined?(ActiveRecord::Base)
      Merb.add_mime_type(:fxml,  :to_fxml,  %w[application/xml text/xml application/x-xml], :charset => "utf-8")
      require File.join(File.dirname(__FILE__),'ruboss4ruby', 'active_foo')
    else
      Merb.add_mime_type(:fxml,  :to_xml,  %w[application/xml text/xml application/x-xml], :charset => "utf-8")
      if defined?(Merb::Orms::DataMapper)
        require File.join(File.dirname(__FILE__), 'ruboss4ruby', 'datamapper_foo')
      end
    end
  end
  
  # TODO: can we find out if use_orm :activerecord is on and only then load active record specific tasks?
  Merb::Plugins.add_rakefiles "ruboss4ruby/tasks", "ruboss4ruby/active_record_tasks"  
elsif defined?(ActionController::Base)
  # if we are not running in Merb, we've got to be running in Rails
  Mime::Type.register_alias "application/xml", :fxml

  require File.join(File.dirname(__FILE__),'ruboss4ruby', 'version')
  require File.join(File.dirname(__FILE__),'ruboss4ruby', 'configuration')
  require File.join(File.dirname(__FILE__),'ruboss4ruby', 'active_foo')
  require File.join(File.dirname(__FILE__), 'ruboss4ruby', 'ruboss_helper')
  require File.join(File.dirname(__FILE__), 'ruboss4ruby', 'xml_defaults')
  ActionView::Base.send :include, RubossHelper unless ActionView::Base.included_modules.include?(RubossHelper)
  require File.join(File.dirname(__FILE__), 'ruboss4ruby', 'ruboss_test_helpers')  
  Test::Unit::TestCase.send :include, RubossTestHelpers unless Test::Unit::TestCase.included_modules.include?(RubossTestHelpers)

  module ActionController
    class Base
      alias_method :old_render, :render unless method_defined?(:old_render)

      # so that we can have handling for :fxml option and write code like
      # format.fxml  { render :fxml => @projects }
      def render(options = nil, extra_options = {}, &block)
        if options && options[:fxml]
          xml = options[:fxml]
          response.content_type ||= Mime::XML
          render_for_text(xml.respond_to?(:to_fxml) ? xml.to_fxml : xml, options[:status])
        else
          old_render(options, extra_options, &block)
        end
      end
    end
  end

  module RubossController
    private

    # Extract any keys named _metadata from the models in the params hash
    # and put them in the root of the params hash.
    def extract_metadata_from_params
      metadata = {}
      metadata.merge!(params.delete('_metadata')) if params.has_key?('_metadata')
      params.each do |k, v|
        next unless v.respond_to?(:has_key?) and v.has_key?('_metadata')
        metadata.merge!(v.delete('_metadata'))
      end
      params.merge!(metadata) unless metadata.empty?
    end  
  end

  ActionController::Base.send :include, RubossController  
  ActionController::Base.send :prepend_before_filter, :extract_metadata_from_params  

  # temporarily disable forgery protection site-wise
  ActionController::Base.allow_forgery_protection = false
end