require 'ostruct'

class StoreController < ApplicationController
  include StoreHelper

  def items
    @items = store_items()
  end

  def cart_add
    @cart_form = session[:cart_form] ||= { :items => [], :total => 0 }
    @cart_form.deep_symbolize_keys!
    item = store_items().find { |i| i[:id] == params[:itemId]&.to_i }
    unless item == nil
      # check if already exist in cart_form
      cart_item = @cart_form[:items].find { |i| i[:id] == item[:id] }
      if (cart_item.nil?)
        cart_item = {
          :id => item[:id],
          :name => item[:name],
          :price => item[:price],
          :amount => 1
        }
        @cart_form[:items].push(cart_item)
      else
        cart_item[:amount] += 1
      end
      @item_added_events = []
      event_item = cart_item.dup
      event_item[:amount] = 1
      @item_added_events.push event_item
      @item_added_total ||= 0
      @item_added_total += event_item[:price]
    end

    @cart_form[:total] += cart_item[:price]

    render :cart
  end

  def cart_update
    @cart_form = session[:cart_form] ||= { :items => [], :total => 0 }
    @cart_form.deep_symbolize_keys!

    @cart_form[:items].each_with_index do |item, idx|
      new_amount = params['cartItems'][idx.to_s]&.to_i
      old_amount = item[:amount]
      if(new_amount > old_amount)
        delta = new_amount - old_amount
        event_item = item.dup
        event_item[:amount] = delta
        @item_added_events ||= []
        @item_added_events.push event_item
        @item_added_total ||= 0
        @item_added_total += event_item[:amount] * event_item[:price]
      elsif (old_amount > new_amount)
        delta = old_amount - new_amount
        event_item = item.dup
        event_item[:amount] = delta
        @item_removed_events ||= []
        @item_removed_events.push event_item
        @item_removed_total ||= 0
        @item_removed_total += event_item[:amount] * event_item[:price]
      end
      item[:amount] = new_amount
    end

    # amount==0 means to be removed
    while(to_remove_idx = @cart_form[:items].find_index {|i| i[:amount]==0})
      @cart_form[:items].delete_at(to_remove_idx)
    end

    @cart_form[:total] = 0
    @cart_form[:items]&.each do |i|
      @cart_form[:total] += i[:price] * i[:amount]
    end

    if(params[:btnAction]=="Update")
      render :cart
    else
      render :checkout01
    end
  end

  def cart
    @cart_form = session[:cart_form] ||= { :items => [], :total => 0 }
    @cart_form.deep_symbolize_keys!
    render :cart
  end

  def checkout_shipping
    session[:receiverName] = params[:receiverName]

    @cart_form = session[:cart_form] ||= { :items => [] }
    @cart_form.deep_symbolize_keys!

    render :checkout02
  end

  def checkout_billing
    @cart_form = session[:cart_form] ||= { :items => [] }
    @cart_form.deep_symbolize_keys!

    session[:cart_form] = nil

    if(params[:btnAction]=="Back")
      render :checkout01
    else
      render :checkout_success
    end
  end

  def res_s
    reset_session
    head :ok, content_type: "text/html"
  end

end
