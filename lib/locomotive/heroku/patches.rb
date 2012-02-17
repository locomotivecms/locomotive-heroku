# http://blog.ethanvizitei.com/2010/11/json-pure-ruins-my-morning.html
Fixnum.class_eval do
  def to_json(options = nil)
    to_s
  end
end