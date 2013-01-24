module ActiveAdmin
  module Cms
    module CmsHelper
      def cms_content sheet, content_key, options = {}
        raise Exceptions::MissingSheet if !sheet
        #debugger
        sheet.content_for(content_key).to_html(options).html_safe if sheet.content_for(content_key)
      end
    end
  end
end

ActionView::Base.send :include, ActiveAdmin::Cms::CmsHelper
