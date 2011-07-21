class Vector < Array
  def initialize(demension,range)
    demension.times{
      self << (rand()*range - range/2.0)
    }
  end
end

class Unit < Hash
  def initialize(demension,range)
    self[:speed] = Vector.new(demension,range)
    self[:place] = Vector.new(demension,range)
    self[:fitness] = Float::MAX
    self[:localbest] = self.clone
  end
end

class Pso
  def initialize(demension,range,number,func)
    @demension =  demension
    @range = range
    @number = number
    @func = func
  end

  def gene_units()
    units = []
    @number.times{
      units << Unit.new(@demension,@range)
    }
    return units
  end

  def compare(unit1,unit2)
    if unit1[:fitness] < unit2[:fitness]
      return unit1.clone
    else
      return unit2.clone
    end
  end
  
  def find_best(units)
    best = units[0]
    units.each{|unit|
      best = compare(unit,best)
    }
    return best
  end

  def get_speed(unit,best)
    w  = 0.9
    c1 = 0.3
    c2 = 0.9
    speed = Vector.new(@demension,@range)
    @demension.times{|xi|
      r1 = rand()
      r2 = rand()
      speed_xi = 
      w * unit[:speed][xi] + 
      c1 * r1 * (best[:place][xi]             - unit[:place][xi]) +
      c2 * r2 * (unit[:localbest][:place][xi] - unit[:place][xi])

      if speed_xi > @range/2.0
        speed_xi = 0.0 # @range/2.0
      elsif speed_xi < -1*@range/2.0
        speed_xi = 0.0 #-1*@range/2.0
      end
      speed[xi] = speed_xi
    }
    return speed
  end

  def get_place(unit)
    place = Vector.new(@demension,@range)
    @demension.times{|xi|
      place_xi = unit[:speed][xi] + unit[:place][xi]
      if place_xi > @range/2.0
        place_xi = @range/2.0
      elsif place_xi < -1*@range/2.0
        place_xi = -1*@range/2.0
      end
      place[xi] = place_xi
    }
    return place
  end


  def get_fitness(unit)
    @func.call(*(unit[:place]))
  end

  def put_out(g,best)
    print "%d, %f\n"%[g,best[:fitness]]
  end

  def run(time)
    units = gene_units()
    time.times{|g|
      best = find_best(units)
      
      units.each{|unit|
        unit[:speed] = get_speed(unit,best)
        unit[:place] = get_place(unit)
        unit[:fitness] = get_fitness(unit)
        unit[:localbest] = compare(unit,unit[:localbest])
      }
      put_out(g,best) if g%10 == 1 or g == time - 1
    }
  end
end

func = {}
func[:sqx_1] = lambda{|x1| x1*x1 + 1}
func[:sqx_3] = lambda{|x1,x2,x3| x1*x1+x2*x2+x3*x3}

func[:rosen3]= lambda{|x1,x2,x3|
  f = lambda{|a,b|
    100*(b-a*a)*(b-a*a)+(1-a*a)*(1-a*a)
  }
  f.call(x1,x2) + f.call(x2,x3)
}

func[:rast4]= lambda{|x1,x2,x3,x4|
  f = lambda{|x|
    (x*x - 10*Math::cos(2*Math::PI*x))
  }
  10*3 + 
  f.call(x1) +
  f.call(x2) +
  f.call(x3) + 
  f.call(x4)
}

func[:rast3] = lambda{|x1,x2,x3|
  f = lambda{|x|
    (x*x - 10*Math::cos(2*Math::PI*x))
  }
  10*3 + 
  f.call(x1) +
  f.call(x2) +
  f.call(x3)
}


demension = 3
range = 5.12*2
number = 50
pso = Pso.new(demension,range,number,func[:rast3])
pso.run(1000)
