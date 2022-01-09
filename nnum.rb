class Nnum
  MANLEN = 500
  Val = Struct.new( :man, :exp ) do
    def int(base_exp, method)
      (man * 10**(exp-base_exp)).round
    end

    def head
      man.to_s[0,2]
    end

    def size
      return 1 if man==0
      MANLEN + exp + 1
    end

    def add(x, method)
      return x.dup if self.man==0
      return self.dup if x.man==0

      min_exp = [x.exp, self.exp].min
      delta = {floor:0, ceil:1}[method]
      return Val.create( man: self.man + delta, add_exp:self.exp, method:method ) if min_exp < self.exp-MANLEN*2
      return Val.create( man: x.man + delta, add_exp:x.exp, method:method ) if min_exp < x.exp-MANLEN*2

      m = self.int(min_exp, method) + x.int(min_exp, method)
      return Val.create( man: m, add_exp:min_exp, method:method )
    end

    def mul(x, method)
      return Val.new(0,0) if self.man==0 || x.man==0
      base_exp = x.exp + exp
      m = x.man * man
      return Val.create( man: m, add_exp:base_exp, method:method )
    end
  end

  def Val.create(man:, add_exp:, method:)
    case man
    when 0
      return Val.new( 0, 0 )
    else
      exp = Math.log10(man).floor - MANLEN
      m = (man.to_r / (10r**exp).to_r).send(method)
      return Val.new( m, exp+add_exp)
    end
  end

  def initialize(num, add_exp:0, lsd:nil)
    case num
    when 0
      @vals = Array.new(2){ Val.new(0,0) }
      @lsd = 0
    else
      @vals = [
        Val.create(man:num, add_exp:0, method: :floor),
        Val.create(man:num, add_exp:0, method: :ceil),
      ]
      @lsd = (lsd || num.abs) % 100
    end
  end

  attr_accessor :vals, :lsd

  def to_i
    i = [
      vals[0].int(0, :floor),
      vals[1].int(0, :ceil)
    ].uniq
    return i.first if i.size==1
    raise "no accurate value: #{@vals}"
  end

  def head
    h = @vals.map{ |e| e.head }.uniq
    return h.first if h.size==1
    raise "no accurate value: #{@vals}"
  end

  def tail
    return "%02d" % [@lsd % 100]
  end

  def size
    s = @vals.map{ |e| e.size }.uniq
    return s.first if s.size==1
    raise "no accurate value: #{@vals}"
  end
  
  def +(x)
    r=Nnum.new(0)
    r.vals = [
      vals[0].add( x.vals[0], :floor ),
      vals[1].add( x.vals[1], :ceil )
    ]
    r.lsd = (lsd+x.lsd) % 100
    r
  end

  def *(x)
    r=Nnum.new(0)
    r.vals = [
      vals[0].mul( x.vals[0], :floor ),
      vals[1].mul( x.vals[1], :ceil )
    ]
    r.lsd = (lsd * x.lsd) % 100
    r
  end

  def inspect
    "[#{@vals.map{ |e| e.inspect }.join(", ")}]"
  end
end

if __FILE__==$0
  def test0
    c=[0, 1, 1234, 4567, 11**10, 22**20]
    c.each do |na|
      a=Nnum.new(na)
      c.each do |nb|
        b=Nnum.new(nb)
        r = a+b
        nr = na+nb
        ehead = (nr*10**10).to_s[0,2]
        etail = "%02d" % (nr % 100)
        esize = nr.to_s.size
        unless r.head == ehead
          p( { a:a, b:b, r:r, na:na, nb:nb, nr:nr } )
          puts "r.head is #{r.head}, expects #{ehead}"
        end
        unless r.tail == etail
          p( { a:a, b:b, r:r, na:na, nb:nb, nr:nr } )
          puts "r.tail is #{r.tail}, expects #{etail}"
        end
        unless r.size == esize
          p( { a:a, b:b, r:r, na:na, nb:nb, nr:nr } )
          puts "r.size is #{r.size}, expects #{esize}"
        end
      end
    end
  end
  test0
  def test1
    c=[0, 1, 1234, 4567, 11**10, 22**20]
    c.each do |na|
      a=Nnum.new(na)
      c.each do |nb|
        b=Nnum.new(nb)
        r = a*b
        nr = na*nb
        ehead = (nr*10**10).to_s[0,2]
        etail = "%02d" % (nr % 100)
        esize = nr.to_s.size
        unless r.head == ehead
          p( { a:a, b:b, r:r, na:na, nb:nb, nr:nr } )
          puts "r.head is #{r.head}, expects #{ehead}"
        end
        unless r.tail == etail
          p( { a:a, b:b, r:r, na:na, nb:nb, nr:nr } )
          puts "r.tail is #{r.tail}, expects #{etail}"
        end
        unless r.size == esize
          p( { a:a, b:b, r:r, na:na, nb:nb, nr:nr } )
          puts "r.size is #{r.size}, expects #{esize}"
        end
      end
    end
  end
  test1
end