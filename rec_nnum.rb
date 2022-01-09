b = (ARGV[0] || 2 ).to_i
c = (ARGV[1] || 1 ).to_i
t0 = Time.now

child=fork do
  require "./nnum.rb"

  def omi(x)
    return x.to_i.to_s if x.size<6
    x.head + "(omit #{x.size-4} digits)" + x.tail
  end
  
  class Fibo
    def initialize
      @c={}
    end
    TWO = Nnum.new(2)
    def impl(n)
      # see https://qiita.com/yassu/items/dab30eb2f2070c913451
      h=(n/2).floor
      fc = calc(h)
      fp = calc(h-1)
      if n.even?
        fc  *(fc + TWO * fp)
      else
        fc * TWO * (fc + fp) + fp * fp
      end
    end
    def calc(n)
      return Nnum.new(n) if n<2
      @c[n] ||= impl(n)
    end
  end
  f = Fibo.new
  (0...).each do |x|
    i = b**x+c
    v = omi(f.calc(i))
    puts "f(#{i})=#{v}"
  end
end
sleep(0.85)
Process.kill 15, child
