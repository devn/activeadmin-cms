class Sheet < ActiveAdmin::Cms::Sheet
  attr_accessible :title, :description, :recipe_id, :url, :meta_title, :meta_keywords, :meta_description
end
