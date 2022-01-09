b = (ARGV[0] || 2 ).to_i
c = (ARGV[1] || 1 ).to_i
t0 = Time.now

child=fork do
  def omi(x)
    s = x.to_s
    return s if s.size<6
    s[0,2] + "(omit #{s.size-4} digits)" + s[-2,2]
  end
  
  class Fibo
    def initialize
      @c={}
    end
    def impl(n)
      # see https://qiita.com/yassu/items/dab30eb2f2070c913451
      h=(n/2).floor
      fc = calc(h)
      fp = calc(h-1)
      if n.even?
        fc**2 + 2 * fc * fp
      else
        2 * fc**2 + 2 * fc * fp + fp**2
      end
    end
    def calc(n)
      return n if n<2
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
