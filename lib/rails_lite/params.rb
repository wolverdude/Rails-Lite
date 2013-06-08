require 'uri'

module Params
  def self.parse(req, route_params)
    params = route_params
    if req.query_string
      query_params = parse_www_encoded_form(req.query_string)
      params.merge!(query_params)
    end
    params
  end

  def self.parse_www_encoded_form(www_encoded_form)
    params = {}
    array = URI.decode_www_form(www_encoded_form)

    array.each do |kv_pair|
      key, value = kv_pair
      key_list = parse_key(key)

      store_key(params, key_list, value)
    end

    params
  end

  def self.store_key(hash, key_list, value)
    key = key_list.first
    if key_list.size == 1
      hash[key] = value
    else
      hash[key].is_a?(Hash) || hash[key] = {}
      store_key(hash[key], key_list[1..-1], value)
    end
  end

  def self.parse_key(key)
    # matches first word plus every word inside brackets thereafter.
    key_list = key.match(/^\w+/).to_a
    key_list + key.scan(/\[(\w+)\]/).to_a.map(&:first)
  end
end
