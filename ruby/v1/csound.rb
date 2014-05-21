require './ruby_csound'

cs = Csound.new
result = cs.compile()
if result == 0
  cs.perform()
  input = gets
  while input != 'quit' do
    input = gets
  end
end
cs.destroy()
