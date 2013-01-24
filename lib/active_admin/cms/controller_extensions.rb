module ActiveAdmin
  module Cms
    module ControllerExtensions
      module ClassMethods
        include ActiveAdmin::Cms::Utility::ClassLevelInheritableAttributes
        cattr_inheritable :current_sheet_class

        def cms_for sheet_class
          @current_sheet_class = sheet_class
        end

        def current_sheet_class
          @current_sheet_class ||= ActiveAdmin::Cms::Sheet
        end
      end

      module InstanceMethods
        def current_sheet
          @current_sheet ||= self.class.current_sheet_class::for_url request.path
        end
      end
    end
  end
end

ActionController::Base.send :extend, ActiveAdmin::Cms::ControllerExtensions::ClassMethods
ActionController::Base.send :include, ActiveAdmin::Cms::ControllerExtensions::InstanceMethods
