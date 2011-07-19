#literal
class Unit < Hash
  def initialize(d,range)
    self[:speed] = {}
    d.times{|time|
      self["x#{time}".to_sym] = rand(range*100)/100.0 - range/2.0
      self[:speed]["x#{time}".to_sym] = 0.0
    }
    self[:fitness] = Float::MAX
    self[:localbest] = self.clone
  end

  def update(vector)
    self[:speed] = vector
    vector.each{|key,value|
      self[key] = self[key] + value
    }
  end

  def update_localbest(unit)
    self[:localbest] = unit.clone
  end
end

#object
class Pso
  def initialize(range,num,d,func)
    @units = []
    @func = func
    @dimension = d
    num.times{@units << Unit.new(@dimension,range)}
    self.update_fitness
  end
  
  def update_fitness
    @units.each{|unit|
      arg = []
      @dimension.times{|time|
        arg << unit["x#{time}".to_sym]
      }
      unit[:fitness] = @func.call(*arg)
    }
  end

  def update_units
    w  = 0.8
    c1 = 0.8
    c2 = 0.8
    @units.each{|unit|
      vector = {}
      @dimension.times{|time|
        #v = wv + c1r1(xl - x) + c2r2(xg - x)
        r1 = rand(100)/100.0
        r2 = rand(100)/100.0
        v = unit[:speed]["x#{time}".to_sym]
        x = unit["x#{time}".to_sym]
        xl = unit[:localbest]["x#{time}".to_sym]
        xg = @best["x#{time}".to_sym]
        vector["x#{time}".to_sym] = w*v + c1*r1*(xl - x) + c2*r2*(xg - x)
      }
      unit.update(vector)
      unit.update_localbest(self.comp(unit[:localbest],unit))
    }
  end

  def step
    self.update_units
    self.update_fitness
  end

  def comp(unit1,unit2)
    if unit1[:fitness] < unit2[:fitness]
      unit1
    else
      unit2
    end
  end

  def find_best
    @best = @units[0]
    @units.each{|unit|
      @best = self.comp(unit,@best)
    }
  end

  def run(time)
    find_best
    time.times{|time|
      print "%d,%5f\n"%[time,@best[:fitness]]
      self.step
      self.find_best
    }
  end

  def to_s
    mess = ""
    @dimension.times{|time|
      x = @best["x#{time}".to_sym]
      mess << "#{x},"
    }
    mess
  end
end




func = lambda{|x1,x2,x3|
  30 + 
  (x1*x1 + 10*Math::cos(2*Math::PI*x1))+
  (x2*x2 + 10*Math::cos(2*Math::PI*x2))
  (x3*x3 + 10*Math::cos(2*Math::PI*x3))
}
func = lambda{|x1,x2,x3|  x1 * x2 * x3}

r = 10
n = 1000
d = 3 
pso = Pso.new(r,n,d,func)
pso.run(1000)
