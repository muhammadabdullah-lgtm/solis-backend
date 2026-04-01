module Products
  class FilterQuery
    def initialize(scope = Product.all, params = {})
      @scope = scope
      @params = params
    end

    def call
      products = scope
      products = filter_by_category(products)
      products = filter_by_brand(products)
      products = filter_by_price_range(products)
      products = filter_by_search(products)
      products = apply_sort(products)
      products
    end

    private

    attr_reader :scope, :params

    def filter_by_category(products)
      return products if params[:category_id].blank?

      products.where(category_id: params[:category_id])
    end

    def filter_by_brand(products)
      return products if params[:brand_id].blank?

      products.where(brand_id: params[:brand_id])
    end

    def filter_by_price_range(products)
      if params[:min_price].present?
        products = products.where('price >= ?', params[:min_price])
      end

      if params[:max_price].present?
        products = products.where('price <= ?', params[:max_price])
      end

      products
    end

    def filter_by_search(products)
      return products if params[:q].blank?

      products.where('name ILIKE ?', "%#{params[:q].strip}%")
    end

    def apply_sort(products)
      case params[:sort]
      when 'price_asc'
        products.order(price: :asc)
      when 'price_desc'
        products.order(price: :desc)
      when 'newest'
        products.order(created_at: :desc)
      else
        products.order(created_at: :desc)
      end
    end
  end
end