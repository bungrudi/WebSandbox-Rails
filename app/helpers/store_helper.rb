module StoreHelper
  def store_items
    items = []
    100.times do |n|
      n += 1
      items.push({:id=> n, :name=> "Playstation #{n}", :price=> 1000*n})
    end
    items
  end
end
