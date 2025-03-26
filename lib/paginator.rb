class Paginator
  def self.paginate(scope, params)
    collection = scope.page(params[:page]).per(params[:per_page])
    [{
      meta: {
        current_page: collection.current_page,
        total_pages: collection.total_pages,
        total_count: collection.total_count,
        per_page: collection.limit_value
      }
    }, collection]
  end
end
