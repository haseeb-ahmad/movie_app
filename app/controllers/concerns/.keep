# app/controllers/concerns/paginate.rb
module Paginate
  extend ActiveSupport::Concern

  # Paginate the collection using Kaminari
  def paginate(collection)
    collection.page(params[:page]).per(params[:per_page] || 10)
  end
end
