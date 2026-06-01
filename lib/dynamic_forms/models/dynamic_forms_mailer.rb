module DynamicForms
  module Models
    module DynamicFormsMailer

      def self.included(model)
        model.send(:include, InstanceMethods)

        model.class_eval do
          helper "dynamic_forms::form_submissions"
        end
      end

      module InstanceMethods
        def form_submission(form_submission)
          @form_submission = form_submission

          form_submission.each_field do |field, value|
            if field.is_a?(::FormField::FileField) && !value.blank?
              file_path = File.join(Rails.root, 'public', value)
              if File.exist?(file_path)
                attachments[value.split('/').last.to_s] = {
                  mime_type: 'application/octet-stream',
                  content: File.binread(file_path)
                }
              end
            end
          end

          mail(
            to:      form_submission.form.email,
            from:    DynamicForms.configuration.mailer_sender,
            subject: I18n.t(:form_submission_subject,
                            scope: [:dynamic_forms, :models, :dynamic_forms_mailer],
                            name:  form_submission.form.name)
          )
        end
      end

    end
  end
end
