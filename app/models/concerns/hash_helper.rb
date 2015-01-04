require 'active_support/concern'
module HashHelper
  extend ActiveSupport::Concern

  included do

  end

  def normalize_keys(hash, type = 'string')
    hash.reduce({}) do |hash, element|
      if type == 'string'
        hash.update(element[0].to_s => element[1])
      else
        hash.update(element[0].to_sym => element[1])
      end
    end
  end

  def find_by_key(node, hash_key, empty_return = nil)
    if node
      if node.is_a?(Hash)
        node.each do |key, value|
          if key == hash_key
            return value
          elsif value.is_a?(Hash)
            result = find_by_key(value, hash_key, empty_return)
            return result if result
          elsif value.is_a?(Array)
            value.each do |elm|
              if elm[hash_key]
                return elm
              else
                result = find_by_key(elm, hash_key, empty_return)
                return result if result
              end
            end
          end
        end
      end
    end
    nil
  end

  def find_all_by_key(node, hash_key, result = [])
    if node.is_a?(Hash)
      node.each do |key, value|
        if key == hash_key
          return result << value
        elsif value.is_a?(Hash)
          find_all_by_key(value, hash_key, result)
        elsif value.is_a?(Array)
          find_all_by_key(value, hash_key, result)
        end
      end
    elsif node.is_a?(Array)
      node.each do |hash|
        find_all_by_key(hash, hash_key, result)
      end
    end
    return result
  end


  module ClassMethods

  end

end
