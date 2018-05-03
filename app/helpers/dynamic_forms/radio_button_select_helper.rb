# Adds the FormBuilder#radio_button_select method
module DynamicForms
  module RadioButtonSelectHelper

    def self.included(base)
      ActionView::Helpers::FormBuilder.send :include, InstanceMethods
    end

    module InstanceMethods

      # FormBuilder helper method that gives the user a group of checkboxes.
      #
      # Arguments:
      #   name: attribute name, as with most FormBuilder helpers
      #   full_collection: an array of all the possible values (one checkbox displayed for each)
      #
      # By default, this method will output a radiobuttons with labels. If custom behavior
      # is needed, a block can be passed that takes two block parameters (the input markup and
      # the object represented by the checkbox).
      #
      # Examples:
      #
      #   # Examples assume
      #   # f.object.favorite_colors #=> 'blue'
      #   # COLORS = ['red', 'orange', 'yellow', 'green', 'blue']
      #
      #   # This will output five raiobuttons, with 'blue' selected
      #   <%= f.radio_button_select(:favorite_colors, COLORS) %>
      #
      #   # Use a block for custom formatting
      #   <p id="special_radio_button_select">
      #     <% f.radio_button_select(:favorite_colors, COLORS) do |input, color| %>
      #       <span><label><%= color %></label> <%= input %></span>
      #     <% end %>
      #   </p>
      #

      def radio_button_select(name, full_collection, options={}, &block)
        # iterate through all possible choices
        radios = []

        full_collection.each_with_index do |item, index|
          n = options[:name] || radio_name_for(name)
          id = radio_id_for(name, item)
          if options[:value]
            checked = options[:value] == item
          elsif @object.send(name.to_sym) == item
            checked = true
          elsif options[:required] && index == 0 && @object.send(name.to_sym).blank?
            checked = true
          else
            checked = false
          end
          markup = %Q{<input type="radio" id="#{id}" name="#{n}" value="#{item}" #{'checked="checked"' if checked} />}
          radios << [markup, item]
        end

        if block_given?
          # iterate over custom markup block
          radios.each do |markup, item|
            yield markup, item
          end
        else
          # output list of checkboxes
          out = ""
          radios.each do |markup, item|
            out += "<span class='radio-option'>#{markup}<label for='#{radio_id_for(name, item)}' style='display:inline-block;'>#{item}</label></span>"
          end
          out.html_safe
        end
      end

      private

      # returns the name attribute for a field by following form_for naming conventions
      def radio_name_for(_name)
        "#{@object_name}[#{_name}]"
      end

      # returns the id attribute for a field by following form_for naming conventions
      def radio_id_for(_name, _item)
        "#{@object_name}_#{_name}_#{_item}".gsub(/\W/, '')
      end

    end

  end
end
