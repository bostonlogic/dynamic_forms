require 'twelve_hour_time_helper'

require 'dynamic_forms/configuration'
require 'dynamic_forms/dynamic_validations'
require 'dynamic_forms/relationships'

require 'dynamic_forms/models/form'
require 'dynamic_forms/models/form_field'
require 'dynamic_forms/models/form_field_option'
require 'dynamic_forms/models/form_submission'
require 'dynamic_forms/models/field_types/check_box'
require 'dynamic_forms/models/field_types/date_select'
require 'dynamic_forms/models/field_types/datetime_select'
require 'dynamic_forms/models/field_types/check_box_group'
require 'dynamic_forms/models/field_types/select'
require 'dynamic_forms/models/field_types/text_area'
require 'dynamic_forms/models/field_types/text_field'
require 'dynamic_forms/models/field_types/file_field'
require 'dynamic_forms/models/field_types/radio_button_select'
require 'dynamic_forms/models/field_types/time_select'
require 'dynamic_forms/models/field_types/item_quantity'
require 'dynamic_forms/models/dynamic_forms_mailer'


module DynamicForms
  class Engine < ::Rails::Engine
    config.to_prepare do
      ApplicationController.helper(DynamicForms::CheckBoxGroupHelper)
      ApplicationController.helper(DynamicForms::RadioButtonSelectHelper)
      ApplicationController.helper(DynamicForms::FormsHelper)
      ApplicationController.helper(DynamicForms::FormSubmissionsHelper)
    end

    ActiveRecord::Base.send(:include, DynamicForms::Relationships)
  end
end
