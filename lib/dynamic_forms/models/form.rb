# Developed by Chris Powers, Killswitch Collective on 09/10/2008
#
# The Form holds information about a dynamic form that the
# client can build and users can fill out and submit.
module DynamicForms
  module Models
    module Form

      def self.included(model)
        model.send(:include, InstanceMethods)
        model.send(:include, Validations)
        model.send(:include, NamedScopes)
        model.send(:include, Relationships)

        model.class_eval do
          accepts_nested_attributes_for :form_fields, :reject_if => lambda { |a| a[:label].blank? }, :allow_destroy => true

          DynamicForms.configuration.field_types.each do |field_type|
            # create has_many for each field type
            has_many field_type.pluralize.to_sym, :class_name => "::FormField::#{field_type.camelize}"
          end
        end
      end

      module Validations
        def self.included(model)
          model.class_eval do
            validates_presence_of :name
          end
        end
      end

      module NamedScopes
        def self.included(model)
          model.class_eval do
            scope :active, -> { where(:active => true) }
          end
        end
      end

      module Relationships
        def self.included(model)
          model.class_eval do
            belongs_to :creator, :polymorphic => true

            has_many :form_fields,
                     -> { order('position ASC')} ,
                     :dependent => :destroy,
                     :class_name => "::FormField"
          end
        end
      end

      module InstanceMethods
        def field_keys
          self.form_fields.map(&:name)
        end

        def is_multipart?
          !self.form_fields.detect{|ff| ff.is_a?(::FormField::FileField)}.blank?
        end
      end

    end
  end
end
