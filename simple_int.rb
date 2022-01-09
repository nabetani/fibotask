b = (ARGV[0] || 2 ).to_i
c = (ARGV[1] || 1 ).to_i
t0 = Time.now

child=fork do
  def omi(x)
    s = x.to_s
    return s if s.size<6
    s[0,2] + "(omit #{s.size-4} digits)" + s[-2,2]
  end

  r=[0,1]
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
