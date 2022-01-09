b = (ARGV[0] || 2 ).to_i
c = (ARGV[1] || 1 ).to_i
t0 = Time.now

child=fork do
  require "./nnum.rb"

  def omi(x)
    return x.to_i.to_s if x.size<6
    x.head + "(omit #{x.size-4} digits)" + x.tail
  end

  r=[0,1].map{ |e| Nnum.new(e) }
  n=0
  (0...).each do |ix|
    if ix==b**n+c
      n+=1
      puts( "f(#{ix})=#{omi(r[0])}" )
    end
    r = [r[1], r[0]+r[1]]
  end
end
sleep(0.85)
Process.kill 15, child
