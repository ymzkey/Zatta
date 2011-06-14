module BenchMark
  def rastrigin(jigen)
    lambda{|args|
      warn("rastrigin: x is not in  -5.12 < x < 5.12") unless args.each{|ele|
        return false unless -5.12 < ele and ele < 5.12
        true
      }
      
      pi = Math::PI
      abort("miss mutch, #{jigen} and #{args.size}.") unless jigen == args.size
      10*jigen +
      args.inject(0){|result,ele|
        result + lambda{|x| x*x - 10*Math::cos(2*pi*x)}.call(ele)
      }
    }
  end
end


if __FILE__ == $0
  include BenchMark
  ras2 = BenchMark.rastrigin(2)

  resolusion = 100
  resolusion.times{|i|
    x1 = (i.to_f/resolusion.to_f)*10.0 - 5.0
    resolusion.times{|j|
      x2 = (j.to_f/resolusion.to_f)*10.0 - 5.0
      puts "#{x1} #{x2} #{1000*ras2.call([x1,x2])}"
    }
  }
end
