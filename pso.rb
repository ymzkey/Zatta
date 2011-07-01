# -*- coding: utf-8 -*-
class Particle
  attr_accessor :x,:fitness,:localbest
  def initialize(x,v)
    @x = x #place
    @v = v #speed
    @w = 0.5
    @c1 = 0.7
    @c2 = 0.7
    @fitness = Float::MAX
    @localbest = self.x
  end

  def update(best,localbest,minx,maxx)
    @x = @x + @v
    @x = minx if @x < minx
    @x = maxx if @x > maxx
    #p "#{@x}:#{@v}"
    @localbest = localbest
    @v = @w*@v + @c1*rand()*(best.x - @x) + @c2*rand()*(@localbest - @x)
  end
end

class Optimus
  def initialize(minx,maxx,limit)
    #解空間設定
    @minx = minx
    @maxx = maxx
    @limit = limit
    @threashold = 0.00000000001
    @range = (maxx - minx)/10000.0
    #粒子初期化
    @particles = gene_particles(50)
    @particles.each{|particle|
      particle.fitness = self.get_fittines(particle.x)
    }
  end

  def gene_particles(time)
    reslut = []
    time.times{
      x = @minx + (@maxx - @minx)*rand()
      v = (@maxx - @minx)*rand()
      reslut << Particle.new(x,v)
    }
    return reslut
  end

  def process()
    best = self.best_particle()
    @particles.each{|particle|
      localbest = particle.localbest
      localbest = particle.x if self.get_fittines(particle.x) < self.get_fittines(particle.localbest)
      particle.update(best,localbest,
                      @minx,@maxx)
      particle.fitness = self.get_fittines(particle.x)
    }
    best
  end

  def main
    @limit.times{|time|
      best = self.process
      puts sprintf("%.50f",best.x)
      break if best.fitness < @threashold
    }
    best = self.best_particle
    puts sprintf("%.50f",best.x)
    return best.x
  end

  def local_best_particle(x)
    localbest = @particles[0]
    @particles.each {|particle|
      if (x - particle.x).abs < @range
        if localbest.fitness > particle.fitness
          localbest = particle
        end
      end
    }
    return localbest
  end

  def best_particle
    best = @particles[0]
    @particles.each{|particle|
      if best.fitness > particle.fitness
        best = particle
      end
    }
    return best
  end

  def get_fittines(x)
    #最小値0の最小化問題を取り扱う
    #x.abs
    #(x*x - 2).abs #2の平方根がでる
    10 + x*x - 10*(Math.cos(2*Math::PI*x))#rastrigin
  end
end


opt = Optimus.new(-100.0,100.0,1000)
opt.main
