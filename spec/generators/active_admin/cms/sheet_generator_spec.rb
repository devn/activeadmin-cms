require "generator_spec/test_case"
require 'generators/active_admin/cms/sheet/sheet_generator'

describe ActiveAdmin::Cms::SheetGenerator do
  include GeneratorSpec::TestCase
  destination File.expand_path("../../tmp", __FILE__)
  arguments %w(Sheet)

  before(:all) do
    prepare_destination
    run_generator
  end

  it 'should create the correct files' do
    destination_root.should have_structure {
      no_file "test.rb"
      directory "app" do
        directory "admin" do
          file "sheets.rb" do
            contains 'ActiveAdmin.register Sheet'
           end
        end
        directory "models" do
          file "sheet.rb" do
            contains "class Sheet < ActiveAdmin::Cms::Sheet"
          end
        end
        directory "views" do
          directory "admin" do
            directory "cms" do
              directory "sheets" do
                file "_form.html.haml" do
                  contains "form_for"
                end
                file "_ingredient.html.haml"
                file "_section.html.haml"
                file "_show.html.haml"
              end
            end
          end
        end
      end
      directory "db" do
        directory "migrate" do
          migration "create_sheets" do
            contains "class CreateSheets < ActiveRecord::Migration"
          end
        end
      end
    }
  end

end

