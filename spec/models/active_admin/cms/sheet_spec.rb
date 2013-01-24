require 'spec_helper'

describe ActiveAdmin::Cms::Sheet do

  describe '::for' do
    context 'given there is a sheet with a url' do
      before :each do
        #debugger
        @sheet_1 = FactoryGirl.create(:sheet, :url => '/athing')
        @sheet_2 = FactoryGirl.create(:sheet, :url => '/something')
      end

      context 'when passed a url' do

        subject{Sheet::for_url('/something')}

        it {should == @sheet_2}

      end
    end
  end

  describe '#content_for' do
    before :each do
      @sheet = FactoryGirl.create(:sheet)
    end

    context 'when the sheet doesn`t have a recipe' do
      subject {@sheet.content_for 'anything'}
      it {should be_nil}
    end

    context 'when the sheet has a recipe' do
      before :each do
        @recipe = FactoryGirl.create(:basic_recipe)
        @sheet.recipe = @recipe
        @sheet.save
      end
      context 'when a content key is passed that is not valid for the specified recipe' do
        subject {@sheet.content_for 'something:stupid'}
        it {should be_nil}
      end
      context 'when a valid content key is passed' do
        before :each do
          ActiveAdmin::Cms::Content.delete_all
        end

        context 'when there isn`t already content with the specified sheet and content key' do

          context 'for a text ingredient' do
            subject {@sheet.content_for('column:text_ingredient_1')}

            it {should_not be_nil}
            it {should be_kind_of ActiveAdmin::Cms::Content}
            its(:sheet) {should == @sheet}
            its(:content_type) {should == ActiveAdmin::Cms::ContentTypes::Text}
            its('text.to_s') {should == ''}
          end

          context 'for a image ingredient' do
            subject {@sheet.content_for('column:image_ingredient_1')}

            it {should_not be_nil}
            it {should be_kind_of ActiveAdmin::Cms::Content}
            its(:sheet) {should == @sheet}
            its(:content_type) {should == ActiveAdmin::Cms::ContentTypes::Image}
            its('text.to_s') {should == ''}
          end
        end

        context 'when there is already content with the specified sheet and content key' do

          before :each do
            @text_content = FactoryGirl.create(:text_content, :key => 'column:text_ingredient_1', :sheet => @sheet, :text => '123')
            #debugger
            @image_content = FactoryGirl.create(:image_content, :key => 'column:image_ingredient_1', :sheet => @sheet)

          end

          context 'when searching for the text ingredient' do
            subject {@sheet.content_for('column:text_ingredient_1')}

            it {should_not be_nil}
            it {should == @text_content}
          end

          context 'when searching for the image ingredient' do
            subject {@sheet.content_for('column:image_ingredient_1')}

            it {should_not be_nil}
            it {should == @image_content}
          end
        end
      end
    end
  end

  describe '#meta_data' do

    subject {@sheet.meta_data}

    before :each do
      @sheet = FactoryGirl.create(:sheet, :recipe => FactoryGirl.create(:basic_recipe))
    end

    it {should be_kind_of Hash}

    describe '[:title]' do

      subject {@sheet.meta_data[:title]}

      context 'when the sheet has a title' do
        before :each do
          @sheet.title = 'A sheet'
          @sheet.save
        end
        context 'when the sheet has a specific meta title set' do
          before :each do
            @sheet.meta_title = 'A title'
            @sheet.save
          end

          it {should == @sheet.meta_title}
        end
        context 'when the sheet doesn`t have a specific meta title' do
          it {should == "#{ActiveAdmin::Cms::SITE_TITLE} | #{@sheet.title}"}
        end
      end

      context 'when the sheet doesn`t have a title' do
        before :each do
          @sheet.title = ''
          @sheet.save
        end
        context 'when the sheet has a specific meta title set' do
          before :each do
            @sheet.meta_title = 'A title'
            @sheet.save
          end

          it {should == @sheet.meta_title}
        end
        context 'when the sheet doesn`t have a specific meta title' do
          it {should == "#{ActiveAdmin::Cms::SITE_TITLE}"}
        end
      end
    end

    describe '[:description]' do
      subject {@sheet.meta_data[:description]}

      context 'when meta description has been set' do
        before :each do
          @sheet.meta_description = 'desc 123'
          @sheet.save
        end
        it {should == @sheet.meta_description}
      end

      context 'when meta keywords have not been set' do
        it {should == ActiveAdmin::Cms::DEFAULT_META_DESCRIPTION}
      end
    end

    describe '[:keywords]' do
      subject {@sheet.meta_data[:keywords]}

      context 'when meta keywords have been set' do
        before :each do
          @sheet.meta_keywords = 'key 123'
          @sheet.save
        end
        it {should == @sheet.meta_keywords}
      end

      context 'when meta keywords have not been set' do
        it {should == ActiveAdmin::Cms::DEFAULT_META_KEYWORDS}
      end
    end
  end

  describe '#set_content' do

    subject{@sheet}

    before :each do
      @sheet = FactoryGirl.create(:sheet, :recipe => FactoryGirl.create(:basic_recipe))
    end

    context 'when the content_key is valid for the sheets recipe' do

      context 'when given an existing content item' do

        before :each do
          @content = FactoryGirl.create(:content)
          @sheet.set_content 'column:text_ingredient_1', @content
        end

        subject{@sheet.content.reload}

        its(:length) {should == 1}

        describe 'the passed content item' do
          subject {@content.reload}

          its(:key) {should == 'column:text_ingredient_1'}
        end

        describe 'the created content item' do
          subject{@sheet.content_for('column:text_ingredient_1')}

          its(:id) {should == @content.id}
          its('text.to_s') {should == @content.text.to_s}
          its(:content_type_class) {should == @content.content_type_class}
        end
      end
    end
    context 'when an invalid content_key is passed' do

      # pending 'it should throw an error'

    end

  end

  describe '#set_value' do
    before :each do
      @sheet = FactoryGirl.create(:sheet, :recipe => FactoryGirl.create(:basic_recipe))
    end

    context 'when passed a content_key => text hash' do
      it 'should set the text for each of the of the content records' do
      @sheet.set_value 'column:text_ingredient_1' => '123', 'footer:address' => '456'

      @sheet.content_for('column:text_ingredient_1').text.to_s.should == "123"
      @sheet.content_for('footer:address').text.to_s.should == '456'
end
    end
  end

end
