require rcga.rb
class Pso < Rcga
  def fittness
  end

  def better?(vector1,vector2)
    
  end
end

p = Pso.new(min,max)
p.fittness = rastrigin(3)
p.optimus
