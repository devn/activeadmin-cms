module ActiveAdmin
  module Cms
    class SheetGenerator < Rails::Generators::NamedBase
      desc 'Creates a new type of sheet'

      include Rails::Generators::Migration

      def self.next_migration_number(dirname)
        Time.now.strftime("%Y%m%d%H%M%S")
      end

      def self.source_root
        @_active_admin_cms_source_root ||= File.expand_path("../templates", __FILE__)
      end

      def create_admin
        template 'admin/sheets.rb.erb', "app/admin/#{plural_table_name}.rb"
      end

      def create_model
        template 'sheet.rb.erb', "app/models/#{file_path}.rb"
      end

      def create_admin_views
        template 'views/admin/cms/sheets/_form.html.haml', "app/views/admin/cms/#{plural_table_name}/_form.html.haml"
        template 'views/admin/cms/sheets/_ingredient.html.haml', "app/views/admin/cms/#{plural_table_name}/_ingredient.html.haml"
        template 'views/admin/cms/sheets/_section.html.haml', "app/views/admin/cms/#{plural_table_name}/_section.html.haml"
        template 'views/admin/cms/sheets/_show.html.haml', "app/views/admin/cms/#{plural_table_name}/_show.html.haml"
      end

      def create_migrations
        Dir["#{self.class.source_root}/migrations/*.rb"].sort.each do |filepath|
          name = File.basename(filepath)
          migration_template "migrations/#{name}", "db/migrate/#{name.gsub(/^\d+_/,'')}"
          sleep 1
        end
      end

    end
  end
end
