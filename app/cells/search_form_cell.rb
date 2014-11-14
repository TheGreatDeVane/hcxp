class SearchFormCell < Cell::ViewModel

  def show
    render
  end

  def form_action
    case model[:action]
      when 'bands' then bands_search_index_path
      when 'users' then users_search_index_path
      else search_index_path
    end
  end

  def input_value
    if model[:controller] == 'search'
      params[:q]
    end
  end

end
