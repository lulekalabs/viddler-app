module ClientSideValidations
  module SimpleForm
    module FormBuilder

      def self.included(base)
        base.class_eval do
          def self.client_side_form_settings(options, form_helper)
            {
              :type => self.to_s,
              :form_class => nil,
              :wrapper_class => 'clearfix',
              :wrapper_error_class => "error",
              :error_class => "help-block",
              :error_tag => "span",
              :wrapper_tag => "div"
            }
          end
        end
      end

    end
  end
end

SimpleForm::FormBuilder.send(:include, ClientSideValidations::SimpleForm::FormBuilder)

