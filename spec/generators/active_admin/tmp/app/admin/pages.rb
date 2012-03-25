ActiveAdmin.register Page do

  form :partial => 'admin/cms/pages/form'

  filter :title

  index :as => :table do
    column 'Title' do |page|
      link_to page.title, edit_admin_page_path(page)
    end
    column :description
    column :url
  end

  show do |page|
    attributes_table do
      row :title
      row :description do
        page.description.to_html.html_safe
      end
      row :slug
      row :url
    end
  
    #render 'admin/cms/pages/show'

    active_admin_comments
  end

  controller do
    def update
      super
      @page.set_value params[:content]
    end
  end

end


