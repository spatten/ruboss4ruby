module ActiveRecord
  
  class Base
    class << self
            
      def default_xml_methods(*args)
        methods = *args.dup
        module_eval <<-END 
            def self.default_xml_methods_array
              return [#{methods.inspect}].flatten
            end
          END
      end
      
      def default_xml_includes(*args)
        includes = *args.dup
        module_eval <<-END
          def self.default_xml_include_params
            return [#{includes.inspect}].flatten
          end
        END
      end
            
      def default_xml_hash(already_included = [])
        # return {} unless self.class.respond_to?(:default_xml_include_params) || self.class.respond_to?(:default_xml_methods_array)
        default_hash = {:include => {}}
        default_hash[:methods] = self.default_xml_methods_array if self.respond_to?(:default_xml_methods_array)
        if self.respond_to?(:default_xml_include_params)
          default_includes = self.default_xml_include_params
          default_hash[:include] = default_includes.inject({}) do |include_hash, included|
            next if already_included.include?(included) # We only want to include things once, to avoid infinite loops
            included_class = included.to_s.singularize.camelize.constantize
            include_hash[included] = included_class.default_xml_hash(already_included + default_includes) 
            include_hash
          end
        end
        default_hash
      end 
      
      # options[:include] can be a Hash, Array, Symbol or nil.
      # We always want it as a Hash.  This translates includes to a Hash like this:
      # If it's a nil, return an empty Hash ({})
      # If it's a Hash, then it is just returned
      # If it's an array, then it returns a Hash with each array element as a key, and values of empty Hashes.
      # If it's a symbol, then it returns a Hash with a single key/value pair, with the symbol as the key and an empty Hash as the value.
      def includes_as_hash(includes = nil)      
        res = case
          when includes.is_a?(Hash)
            includes      
          when includes.nil?
           {}  
          else #Deal with arrays and symbols
            res = [includes].flatten.inject({}) {|include_hash, included| include_hash[included] = {} ; include_hash}
        end
        res
      end  

    end
  
  end    
  
  module Serialization
    
    alias_method :xml_defaults_old_to_xml, :to_xml unless method_defined?(:xml_defaults_old_to_xml)
    
    def to_xml(options = {}, &block)
      options[:methods] = [options[:methods] || []].flatten + (self.class.default_xml_hash[:methods] || [])
      options[:include] = self.class.default_xml_hash[:include].merge(self.class.includes_as_hash(options[:include]))
      xml_defaults_old_to_xml(options, &block)
    end      
    
  end
    

end