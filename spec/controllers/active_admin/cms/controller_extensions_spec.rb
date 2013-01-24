require 'spec_helper'

describe ActionController::Base do
  before :each do
    class NewSheetType < ActiveAdmin::Cms::Sheet
    end
  end

  describe '.cms_for' do
    it 'should set current_sheet_class to the specified sheet class' do
      controller.class.cms_for NewSheetType
      controller.class.current_sheet_class.should == NewSheetType
    end

  end

  describe '.current_sheet_class' do
    before :each do
      # reset the controller class variables in case they are polluted by previous calls to cms_for
      controller.class.cms_for nil
    end
    it 'should default to the active admin sheet type' do
      controller.class.current_sheet_class.should == ActiveAdmin::Cms::Sheet
    end
  end

  describe '#current_sheet' do

    context 'when there are sheets' do

      before :each do
        @home_sheet = FactoryGirl.create(:sheet, :url => '/')
        @other_sheet = FactoryGirl.create(:sheet, :url => '/other')
      end

      it 'should return @home_sheet when the url = /' do
        controller.request.path = '/'
        controller.current_sheet.should == @home_sheet.becomes(controller.current_sheet.class)
      end

      it 'should assign the current sheet to an instance variable' do
        controller.request.path = '/'
        sheet = controller.current_sheet
        assigns(:current_sheet).should == sheet
      end

      it 'should return @other_sheet when the url = /other' do
        controller.request.path = '/other'
        controller.current_sheet.should == @other_sheet.becomes(controller.current_sheet.class)
      end

      context 'by default' do
        it 'should return an instance of ActiveAdmin::Cms::Sheet' do
          controller.request.path = '/'
          controller.current_sheet.should be_a ActiveAdmin::Cms::Sheet
        end
      end

      context 'when an alternative sheet class has been specified' do
        before :each do
          controller.class.cms_for NewSheetType
        end
        it 'should return an instance of that class' do
          controller.request.path = '/'
          controller.current_sheet.should be_a NewSheetType
        end
      end

    end

  end

end
