require 'active_support/concern'
module McSearch
  extend ActiveSupport::Concern

  included do

  end

  module ClassMethods

    def focus(attributes = {})
      attributes = attributes.delete_if { |key, value| [:action, :controller].include?(key.to_sym)}
      attributes = self.normalize_keys(attributes)

      focus_record  = self.where(attributes[:id]).first
      finder        = self.all
      finder        = finder.where(parent_id: attributes[:parent_id]) if attributes[:parent_id].present?
      total_items   = finder.count
      position      = finder.map(&:id).index(focus_record.id)
      before        = position
      after         = total_items - (position + 1 )

      # Logic to determine which data to output should go before this statement
      finder        = finder.order('created_at desc').offset(position)

    end

    def search(attributes = {})
    # set defaults and merge with user input
    attributes = attributes.delete_if { |key, value| [:action, :controller].include?(key.to_sym)}
    attributes = self.normalize_keys(attributes)
    options = { limit:      self.default_set_amount,
                direction:  self.default_sort_order,
                by:         self.default_sort_column,
                per_page:   self.default_set_amount,
                page_no:    self.default_page_no
    }.merge(attributes)

    # initialize finder to all records lazily
    finder = self.all

    # search conditions for audreycms page
    finder = self.build_query(finder, options)

    # order -- if ordering on multiple conditions becomes a requirement
    # split into its own method
    finder = finder.order("#{options[:by]} #{options[:direction]}")

    # total count
    count = finder.count

    # offset
    finder = finder.offset(self.return_offset(options))

    # per_page limit
    finder = finder.limit(self.return_limit(options))

    # convenience for API users to discern
    unless finder.empty?
      last_id = finder.last.id
      first_id = finder.first.id
      items_left = self.remaining_items(options, count)
      prev_page_url = self.prev_url(options)
      next_page_url = self.next_url(options)
    end

    if options[:results_only] == true
      finder
    else
      api_result = {
        result_set: finder,
        prev_page_url: prev_page_url,
        next_page_url: next_page_url,
        last_id: last_id,
        first_id: first_id,
        total_items: count,
        items_left: items_left,
      }
    end

    end

    def search_url(attributes)
      query = '?'
      attributes.each do |name, value|
        query << "#{name}=#{value}&"
      end
      "#{self.search_path}#{query.chomp('&') }"
    end

    def prev_url(params)
      if params[:page_no].to_i > 1
        prev_page_no = params[:page_no].to_i - 1
        search_url(params).gsub("page_no=#{params[:page_no]}", "page_no=#{prev_page_no}")
      end
    end

    def next_url(params)
      next_page_no = params[:page_no].to_i + 1
      search_url(params).gsub("page_no=#{params[:page_no]}", "page_no=#{next_page_no}")
    end

    def build_query(finder, options)
      options.each do |name, value|
        q = self.return_comparison_type(name, value)
        if q.nil?
        elsif q.is_a?(Array)
          finder = finder.where(q[0], q[1])
        else
          finder = finder.where(q)
        end
      end
      finder
    end

    def return_comparison_type(name, value)
      if self.attr_map[name]
        case
        when self.attr_map[name][:match] == 'like'
          ["#{name.to_s} ILIKE ?", "#{value}%"]
        when self.attr_map[name][:match] == 'exact'
          { name.to_sym=> value }
        when self.attr_map[name][:match] == 'gt'
          ["#{name.to_s} > ?", "#{value}"]
        when self.attr_map[name][:match] == 'gteq'
          ["#{name.to_s} >= ?", "#{value}"]
        when self.attr_map[name][:match] == 'lt'
          ["#{name.to_s} < ?", "#{value}"]
        when self.attr_map[name][:match] == 'lteq'
          ["#{name.to_s} <= ?", "#{value}"]
        else
          { name.to_sym=> value }
        end
      else
        return
      end
    end

    def return_offset(options)
      options[:page_no].to_i <= 1 ? 0 : ( (options[:page_no].to_i - 1) * options[:per_page].to_i )
    end

    def return_limit(options)
      if options[:limit].to_i == 1000
        1000
      else
        options[:per_page].to_i > self.result_limit ? self.result_limit : options[:per_page].to_i
      end
    end

    def remaining_items(options, total_items)
      if total_items > (return_offset(options) + self.return_limit(options))
        total_items - (return_offset(options) + self.return_limit(options))
      else
        0
      end
    end

    def normalize_keys(hash, to_type = 'symbol')
      unless hash.nil?
        tmp = {}
        hash.keys.each do |val|
          to_type == 'string' ? tmp[val.to_s] = hash[val] : tmp[val.to_sym] = hash[val]
        end
        tmp
      end
    end
  end
end
