module HashFmap
  refine Hash do
    def fmap &block
      self.reduce({}) do |memo, (k,v)|
        memo[k] = block.call(v) ; memo
      end
    end
    def fmap_keys! &block
      keys_count = self.keys.count
      new_hash = self.reduce({}) do |memo, (k,v)|
        memo[block.call(k)] = v ; memo
      end
      new_keys_count = new_hash.keys.count
      raise "transformation block lost keys (#{keys_count - new_keys_count} too few)" if keys_count != new_keys_count
      new_hash
    end
    def fmap_keys &block
      self.reduce({}) do |memo, (k,v)|
        transformed_key = block.call(k)
        if memo.keys.include?(transformed_key)
          if transformed_key.is_a? Symbol
            transformed_key = "#{transformed_key}2".to_sym
          else
            transformed_key = "#{transformed_key}2"
          end
        end
        memo[transformed_key] = v ; memo
      end
    end
  end
end

using HashFmap
hash = {foo: "bar", "foo" => :bar}
other_hash = {foo: "bar", crunchy: "bacon"}
p "starting with: hash"
p hash
p "and: other_hash"
p other_hash

p "Hash#fmap"
p hash.fmap {|v| v.upcase }

begin
  p "Hash#fmap_keys! (with duplicate post-processed keys)"
  p hash.fmap_keys! {|k| k.to_s.upcase.to_sym }
rescue => e
  p "#{e}"
end
p "Hash#fmap_keys! (with unique post-processed keys)"
p other_hash.fmap_keys! {|k| k.to_s.upcase.to_sym }

p "Hash#fmap_keys"
p hash.fmap_keys {|k| k.to_s.upcase.to_sym }

