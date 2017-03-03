module Loud
  refine String do
    def louder
      upcase + " said the cat"
    end
  end
end

class Cat
  def meow
    "meow"
  end
end

using Loud
c = Cat.new
p c.meow.louder
