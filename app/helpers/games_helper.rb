module GamesHelper
  def comma_separated_links_for(list)
    return if list.count == 0

    list.collect do |item|
      link_to(item.name, url_for(item)) 
     end.join(", ").html_safe
  end
end
